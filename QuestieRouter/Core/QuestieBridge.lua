-- QuestieRouter: puente con Questie.
-- Todo el acceso a internos de Questie pasa por aqui, para que si Questie cambia solo haya que tocar este archivo.
--
-- Internos que usamos (comprobados en Questie 12.6.x):
--   Questie.db.char.TrackerFocus            -> questId enfocado con el boton de foco del tracker
--   QuestieCompat.GetSuperTrackedQuestID()  -> mision supertrackeada de Blizzard (Forever la tiene)
--   QuestieDB.GetQuest(questId)             -> objeto Quest con .Objectives[i].spawnList, .Finisher, :IsComplete()
--   DistanceUtils.GetNearestSpawnForQuest() -> spawn mas cercano (objetivo pendiente o quien la entrega)
--   ZoneDB:GetUiMapIdByAreaId(areaId)       -> convierte la zona de Questie (AreaId) a uiMapID
--   LibStub("HereBeDragonsQuestie-2.0")     -> posiciones de mundo, vectores y distancias
--   LibStub("HereBeDragonsQuestie-Pins-2.0")-> pines de mapa y minimapa

local _, QR = ...

local Bridge = {}
QR.Bridge = Bridge

function Bridge:Init()
    local L = QuestieLoader
    self.QuestieDB = L:ImportModule("QuestieDB")
    self.ZoneDB = L:ImportModule("ZoneDB")
    self.DistanceUtils = L:ImportModule("DistanceUtils")
    self.QuestieCompat = QuestieCompat or L:ImportModule("QuestieCompat")
    self:FindMapLibs()
end

--- Librerias de mapa (HereBeDragons). LibStub(nombre) da error si no la encuentra y eso dejaba el puente a
--- medias (HBD = nil -> "attempt to index field 'HBD'" en cada refresco). Se buscan sin error, con la copia
--- de Questie primero y la independiente despues; si aun no estan, se reintenta unos segundos.
local function FindLib(...)
    if not LibStub then return nil end
    for i = 1, select("#", ...) do
        local lib = LibStub(select(i, ...), true)
        if lib then return lib end
    end
end

--- Las versiones nuevas de Questie ya no registran su HereBeDragons en LibStub: es un modulo suyo ("HBD" y
--- "HBDPins"). Sin esto se cogia la copia de otro addon (la de Spy es antigua: sin
--- GetZoneCoordinatesFromWorldInstance -> error continuo al despegar). Se mira la tabla de modulos directamente,
--- porque ImportModule crearia un modulo vacio si no existe.
local function QuestieModule(name, probe)
    local mods = QuestieLoader and QuestieLoader._modules
    local m = mods and mods[name]
    if type(m) == "table" and type(m[probe]) == "function" then return m end
end

--- Coordenadas de zona (0-1) de un punto del mundo. Con instancia si la libreria lo permite; las copias
--- antiguas de HereBeDragons no tienen GetZoneCoordinatesFromWorldInstance y se usa la conversion clasica.
function QR:ZoneCoordsFromWorld(x, y, inst, zone, allowOutOfBounds)
    local HBD = self.HBD
    if not HBD then return nil end
    if inst and HBD.GetZoneCoordinatesFromWorldInstance then
        return HBD:GetZoneCoordinatesFromWorldInstance(x, y, inst, zone, allowOutOfBounds)
    end
    return HBD:GetZoneCoordinatesFromWorld(x, y, zone, allowOutOfBounds)
end

function Bridge:FindMapLibs(tries)
    self.HBD = self.HBD or QuestieModule("HBD", "GetPlayerWorldPosition")
        or FindLib("HereBeDragonsQuestie-2.0", "HereBeDragons-2.0")
    self.HBDPins = self.HBDPins or QuestieModule("HBDPins", "AddMinimapIconWorld")
        or FindLib("HereBeDragonsQuestie-Pins-2.0", "HereBeDragons-Pins-2.0")
    QR.HBD, QR.HBDPins = self.HBD, self.HBDPins
    if self.HBD and self.HBDPins then
        if tries then QR:Fire("SETTINGS_CHANGED") end   -- llegaron tarde: recalcular todo
        return true
    end
    tries = (tries or 0) + 1
    if tries <= 10 then
        C_Timer.After(1, function() Bridge:FindMapLibs(tries) end)
    elseif not self.libsWarned then
        self.libsWarned = true
        QR:Print(QR.L["HereBeDragons (Questie) not found: the route and the map lines are paused. Update or reinstall Questie."])
    end
    return false
end

--- Mision activa: la enfocada en el tracker de Questie, o en su defecto la supertrackeada de Blizzard.
---@return number|nil questId
function Bridge:GetActiveQuestId()
    local focus = Questie and Questie.db and Questie.db.char and Questie.db.char.TrackerFocus
    -- TrackerFocus puede ser un questId o (en versiones antiguas) "questId objectiveIndex".
    if type(focus) == "string" then
        focus = tonumber(focus:match("^(%d+)"))
    end
    if type(focus) == "number" and focus > 0 then
        return focus
    end
    if QR.db.followSuperTrack and self.QuestieCompat and self.QuestieCompat.GetSuperTrackedQuestID then
        return self.QuestieCompat.GetSuperTrackedQuestID()
    end
    return nil
end

---@param questId number
---@return table|nil quest
function Bridge:GetQuest(questId)
    if not questId then return nil end
    local ok, quest = pcall(self.QuestieDB.GetQuest, questId)
    if ok then return quest end
    return nil
end

---@return boolean
function Bridge:IsQuestComplete(quest)
    local ok, complete = pcall(quest.IsComplete, quest)
    return ok and (complete == 1 or (complete ~= -1 and quest.isComplete)) or false
end

--- Calcula el destino mas cercano para una mision.
---@return table|nil target { questId, questName, name, areaId, uiMapId, x, y (0-1), wx, wy, instance, isTurnIn }
function Bridge:ComputeTarget(quest)
    if not quest then return nil end
    if not self:IsQuestComplete(quest) then
        local px, py, pinst = self.HBD:GetPlayerWorldPosition()
        local maps = self:CandidateMaps()
        local best
        for _, o in pairs(quest.Objectives or {}) do
            local done = o.Completed == true or (o.Needed and o.Collected and o.Needed == o.Collected)
            if not done then
                local p = self:ObjectiveArea(quest, o, maps, px, py, pinst)
                if p and (not best or p.dist < best.dist) then best = p end
            end
        end
        if best then
            best.questId, best.questName, best.isTurnIn = quest.Id, quest.name, false
            return best
        end
    end
    local ok, spawn, areaId, name = pcall(self.DistanceUtils.GetNearestSpawnForQuest, quest)
    if not ok or not spawn or not areaId then
        return nil
    end
    local x, y = spawn[1], spawn[2]
    if not x or not y or x < 0 or y < 0 then
        return nil
    end
    local uiMapId = self.ZoneDB:GetUiMapIdByAreaId(areaId)
    if not uiMapId then return nil end

    x, y = x / 100, y / 100
    if not self.HBD then return nil end   -- librerias de mapa aun no disponibles (ver FindMapLibs)
    local wx, wy, instance = self.HBD:GetWorldCoordinatesFromZone(x, y, uiMapId)
    if not wx then return nil end

    return {
        questId = quest.Id,
        questName = quest.name,
        name = name,
        areaId = areaId,
        uiMapId = uiMapId,
        x = x, y = y,
        wx = wx, wy = wy, instance = instance,
        isTurnIn = self:IsQuestComplete(quest),
    }
end

---------------------------------------------------------------------------
-- Ayudas para el planificador de zona
---------------------------------------------------------------------------

function Bridge:UiMapOf(areaId)
    return areaId and self.ZoneDB:GetUiMapIdByAreaId(areaId)
end

--- ¿Mision de elite? 1) la etiqueta "Elite" de la mision (QuestieDB.GetQuestTagInfo, la fiable); 2) si alguno de
--- los bichos a matar del objetivo es elite / elite raro / jefe (rango 1, 2 o 3). Se guarda en cache cuando es seguro
--- (la etiqueta puede tardar en llegar del juego: mientras no llega no se guarda el "no").
local eliteCache = {}
local ELITE_RANK = { [1] = true, [2] = true, [3] = true }
function Bridge:IsEliteQuest(questId)
    if not questId then return false end
    local c = eliteCache[questId]
    if c ~= nil then return c end
    local DB = self.QuestieDB
    local tagKnown = false
    if DB.GetQuestTagInfo and DB.questTagIds then
        local ok, tag, tagName = pcall(DB.GetQuestTagInfo, questId)
        if ok and tag == DB.questTagIds.ELITE then eliteCache[questId] = true return true end
        tagKnown = ok and (tag ~= nil or tagName ~= nil)
    end
    local quest = self:GetQuest(questId)
    for _, od in pairs(quest and quest.ObjectiveData or {}) do
        if od.Type == "monster" and od.Id and DB.QueryNPCSingle then
            local ok, rank = pcall(DB.QueryNPCSingle, od.Id, "rank")
            if ok and ELITE_RANK[rank] then eliteCache[questId] = true return true end
        end
    end
    if tagKnown then eliteCache[questId] = false end
    return false
end

--- ¿Mision de mazmorra? 1) etiqueta "Mazmorra" (QuestieDB.GetQuestTagInfo); 2) su zona es una mazmorra
--- (ZoneDB.IsDungeonZone de Questie). Cache igual que la de elite.
local dungeonCache = {}
function Bridge:IsDungeonQuest(questId)
    if not questId then return false end
    local c = dungeonCache[questId]
    if c ~= nil then return c end
    local DB = self.QuestieDB
    local tagKnown = false
    if DB.GetQuestTagInfo and DB.questTagIds then
        local ok, tag, tagName = pcall(DB.GetQuestTagInfo, questId)
        if ok and tag == DB.questTagIds.DUNGEON then dungeonCache[questId] = true return true end
        tagKnown = ok and (tag ~= nil or tagName ~= nil)
    end
    local okZ, zos = pcall(DB.QueryQuestSingle, questId, "zoneOrSort")
    if okZ and type(zos) == "number" and zos > 0 and self.ZoneDB and self.ZoneDB.IsDungeonZone then
        local ok, isDungeon = pcall(self.ZoneDB.IsDungeonZone, zos)
        if not ok then ok, isDungeon = pcall(self.ZoneDB.IsDungeonZone, self.ZoneDB, zos) end
        if ok and isDungeon then dungeonCache[questId] = true return true end
    end
    if tagKnown then dungeonCache[questId] = false end
    return false
end

--- Estado de una mision para el jugador actual.
---@return string "done" | "active" | "available" | "lowlevel" | "locked"
local function ComputeStatus(self, questId)
    if Questie.db.char.complete[questId] then return "done" end
    if self.ActiveQuests.Get(questId) then return "active" end
    local ok, doable = pcall(self.QuestieDB.IsDoable, questId)
    if not (ok and doable) then return "locked" end
    local req = self.QuestieDB.QueryQuestSingle(questId, "requiredLevel") or 1
    if req > UnitLevel("player") then return "lowlevel" end
    return "available"
end

-- Durante una actualizacion del planificador (Planner:Update, todo seguido en el mismo fotograma: nada cambia en
-- medio) el estado de cada mision se calcula una sola vez; antes se pedia varias veces por mision.
local statusMemo, statusMemoOn, statusMemoTime = {}, false, nil
function Bridge:BeginStatusMemo()
    wipe(statusMemo)
    statusMemoOn, statusMemoTime = true, GetTime()
end
function Bridge:EndStatusMemo()
    statusMemoOn = false
    wipe(statusMemo)
end

function Bridge:QuestStatus(questId)
    -- (la memoria solo vale en el fotograma en que se abrio: si algo fallo y no se cerro, no se usa despues)
    if statusMemoOn and statusMemoTime == GetTime() and questId ~= nil then
        local s = statusMemo[questId]
        if not s then
            s = ComputeStatus(self, questId)
            statusMemo[questId] = s
        end
        return s
    end
    return ComputeStatus(self, questId)
end

-- Motivos por los que este personaje no podra coger nunca la mision (no es cuestion de esperar o de hacer otra antes)
local NEVER = { "WRONG_RACE", "WRONG_CLASS", "EXCLUSIVE_COMPLETED", "DISABLING_QUEST_COMPLETED", "BREADCRUMB_FOLLOWUP",
                "BLACKLISTED", "LEVEL_TOO_HIGH", "EXCEED_REPUTATION", "PROFESSION_SPECIALIZATION" }

--- Por que no se puede coger una mision, segun Questie (QuestieDB.IsDoableVerbose, texto breve ya traducido por
--- Questie): devuelve el motivo sin el "No disponible: " del principio, y true si no se podra coger nunca.
function Bridge:LockReason(questId)
    local DB = self.QuestieDB
    if not DB.IsDoableVerbose then return nil, false end
    local ok, text, _, state = pcall(DB.IsDoableVerbose, questId, false, true, true)
    if not ok or type(text) ~= "string" then return nil, false end
    local never = false
    local states = DB.DoableStates or {}
    for _, k in ipairs(NEVER) do if states[k] ~= nil and state == states[k] then never = true end end
    return text:match("^[^:]+:%s*(.+)$") or text, never
end

function Bridge:IterateActive()
    return self.ActiveQuests.Iterate()
end

function Bridge:NumQuestsInLog()
    local n = 0
    for _ in self.ActiveQuests.Iterate() do n = n + 1 end
    return n
end

-- Coordenadas de mundo cacheadas por tabla de coordenada {x, y} (las tablas de Questie no cambian).
local worldCache = setmetatable({}, { __mode = "k" })

local function WorldOf(self, areaId, spawn)
    local c = worldCache[spawn]
    if c == nil then
        c = false
        local ui = self:UiMapOf(areaId)
        if ui and spawn[1] and spawn[1] >= 0 then
            local wx, wy, inst = self.HBD:GetWorldCoordinatesFromZone(spawn[1] / 100, spawn[2] / 100, ui)
            if wx then c = { wx, wy, inst, ui } end
        end
        worldCache[spawn] = c
    end
    return c or nil
end

local FAR = 1e7 -- distancia ficticia para puntos en otro continente

--- Punto mas cercano al jugador de una tabla de spawns de Questie { [areaId] = { {x,y}, ... } }.
---@return table|nil point { areaId, uiMapId, x, y (0-1), wx, wy, instance, dist }
function Bridge:NearestSpawn(spawns, px, py, pinst)
    -- (la tabla del resultado se crea una sola vez, al final: antes, una por cada spawn que mejoraba al anterior)
    local bestD, bestArea, bestSpawn, bestW
    if not spawns then return nil end
    for areaId, list in pairs(spawns) do
        for _, spawn in pairs(list) do
            local w = WorldOf(self, areaId, spawn)
            if w then
                local d
                if w[3] == pinst and px then
                    d = self.HBD:GetWorldDistance(pinst, px, py, w[1], w[2]) or FAR
                else
                    d = FAR
                end
                if not bestD or d < bestD then
                    bestD, bestArea, bestSpawn, bestW = d, areaId, spawn, w
                end
            end
        end
    end
    if not bestD then return nil end
    return { areaId = bestArea, uiMapId = bestW[4], x = bestSpawn[1] / 100, y = bestSpawn[2] / 100,
             wx = bestW[1], wy = bestW[2], instance = bestW[3], dist = bestD }
end

-- Objetos de Questie: QuestieDB:GetObject no los guarda (crea la tabla y sus spawns en cada llamada, y entonces la
-- cache de coordenadas de WorldOf tampoco servia). Son datos fijos: se guardan aqui.
local objectCache = {}
function Bridge:GetObject(objId)
    if not objId then return nil end
    local o = objectCache[objId]
    if not o then
        o = self.QuestieDB:GetObject(objId)
        if o then objectCache[objId] = o end
    end
    return o
end

--- Guias de evento: NPCs y objetos que la base de datos tiene en varias zonas pero que ahora solo estan en una
--- (la Feria de la Luna Negra: Elwynn o Mulgore segun el mes). [id] = areaId; lo rellena Guide/Events.lua.
Bridge.npcArea, Bridge.objectArea = {}, {}

local function OnlyArea(spawns, areaId)
    if areaId and spawns and spawns[areaId] then return { [areaId] = spawns[areaId] } end
    return spawns
end

---------------------------------------------------------------------------
-- Dentro de una mazmorra o banda no hay coordenadas del mundo: el punto pasa a ser su entrada (como hacen las guias
-- de mazmorra). Sin esto, una mision de clase que se coge o entrega dentro (el corcel del paladin en Scholomance, el
-- terrorecus del brujo en La Masacre, las del Templo de Ahn'Qiraj...) dejaba la guia parada o la flecha en "Otro
-- continente".
---------------------------------------------------------------------------
-- areaId de Questie de cada instancia -> instanceID (el de Data/Dungeons.lua), por si su mapa no da coordenadas
local AREA_INSTANCE = {
    [1581] = 36, [717] = 34, [209] = 33, [718] = 43, [491] = 47, [719] = 48, [1337] = 70, [721] = 90, [1477] = 109,
    [722] = 129, [796] = 189, [1176] = 209, [2100] = 349, [2437] = 389, [1583] = 229, [1585] = 230, [2017] = 329,
    [2057] = 289, [2557] = 429, [10022] = 429, [10023] = 429, [10024] = 429, [10025] = 429, [2717] = 409,
    [2677] = 469, [2159] = 249, [1977] = 309, [3429] = 509, [3428] = 531, [3456] = 533,
    -- Montaña Roca Negra (Questie la tiene como zona propia, sin coordenadas del mundo): la entrada de la Cumbre de
    -- Roca Negra, que esta en la misma montaña (Bodley: Regreso al principio, conjunto de mazmorra 2)
    [10074] = 229,
}
local entranceByInst = {}

--- Entrada de una instancia (por instanceID): { wx, wy, instance (0 o 1), uiMapId, x, y, name } o nil
function Bridge:InstanceEntrance(instId)
    if not instId then return nil end
    local e = entranceByInst[instId]
    if e ~= nil then return e or nil end
    e = false
    for _, row in ipairs(QR.DungeonData or {}) do
        for _, d in ipairs(row[5]) do
            if d[1] == instId and not e then
                local wx, wy, inst
                if row[1] then
                    -- (yardas en el orden de las tablas del juego: el mismo cambio de ejes que Router)
                    if QR.db and QR.db.travel and QR.db.travel.axisSwap == false then wx, wy = row[2], row[3]
                    else wx, wy = row[3], row[2] end
                    inst = row[1]
                else
                    wx, wy, inst = self.HBD:GetWorldCoordinatesFromZone(row[2], row[3], row[4])
                end
                if wx then
                    local cont = ({ [0] = 1415, [1] = 1414 })[inst]
                    local x, y
                    if cont then x, y = self.HBD:GetZoneCoordinatesFromWorld(wx, wy, cont, true) end
                    local name = GetRealZoneText and d[1] > 0 and GetRealZoneText(d[1])
                    e = { wx = wx, wy = wy, instance = inst, uiMapId = cont, x = x, y = y,
                          name = (type(name) == "string" and name ~= "") and name or d[2] }
                end
            end
        end
    end
    entranceByInst[instId] = e
    return e or nil
end

--- Si el punto esta dentro de una instancia, lo cambia por su entrada (conservando el nombre de quien era y
--- diciendo en que mazmorra esta: p.inDungeon). Sin entrada conocida, nil.
function Bridge:OutsidePoint(p, px, py, pinst)
    if not p or p.instance == 0 or p.instance == 1 then return p end
    local e = self:InstanceEntrance(p.instance or AREA_INSTANCE[p.areaId])
    if not e then return nil end
    local d = (px and pinst == e.instance) and (self.HBD:GetWorldDistance(pinst, px, py, e.wx, e.wy) or FAR) or FAR
    return { wx = e.wx, wy = e.wy, instance = e.instance, uiMapId = e.uiMapId, x = e.x, y = e.y, dist = d,
             areaId = p.areaId, name = p.name, npcId = p.npcId, inDungeon = e.name }
end

--- Spawns de una instancia cuyo mapa no da coordenadas: su entrada (o nil)
local function InstanceOnly(self, spawns, px, py, pinst)
    for areaId in pairs(spawns or {}) do
        local inst = AREA_INSTANCE[areaId]
        if inst then return self:OutsidePoint({ instance = inst, areaId = areaId }, px, py, pinst) end
    end
end

--- Punto mas cercano de quien da / recibe una mision (quest.Starts o quest.Finisher). Dentro de una mazmorra, su
--- entrada (p.inDungeon dice cual).
local function Consider(self, best, p, name, npcId, px, py, pinst)
    if not p then return best end
    p.name, p.npcId = name, npcId
    p = self:OutsidePoint(p, px, py, pinst)
    if p and (not best or p.dist < best.dist) then return p end
    return best
end

function Bridge:NearestNpcOrObject(holder, px, py, pinst)
    local best
    if not holder then return nil end
    if holder.NPC then
        for _, npcId in pairs(holder.NPC) do
            local npc = self.QuestieDB:GetNPC(npcId)
            if npc and npc.spawns and npc.friendly ~= false then
                local spawns = OnlyArea(npc.spawns, self.npcArea[npcId])
                best = Consider(self, best, self:NearestSpawn(spawns, px, py, pinst) or InstanceOnly(self, spawns, px, py, pinst),
                                npc.name, npcId, px, py, pinst)
            end
        end
    end
    if holder.GameObject then
        for _, objId in pairs(holder.GameObject) do
            local obj = self:GetObject(objId)
            if obj and obj.spawns then
                local spawns = OnlyArea(obj.spawns, self.objectArea[objId])
                best = Consider(self, best, self:NearestSpawn(spawns, px, py, pinst) or InstanceOnly(self, spawns, px, py, pinst),
                                obj.name, nil, px, py, pinst)
            end
        end
    end
    return best
end

--- Coordenadas de mundo de un spawn de Questie: { wx, wy, instancia, uiMapId } (cacheadas)
function Bridge:WorldPoint(areaId, spawn)
    return WorldOf(self, areaId, spawn)
end

---------------------------------------------------------------------------
-- Donde hacer los objetivos: 1) la zona de spawns en la que estas o la mejor cercana (tamaño / distancia),
-- 2) el area que marca el propio juego solo si el objetivo no tiene spawns conocidos
---------------------------------------------------------------------------
local MAX_POINTS = 220        -- tope de spawns a analizar por objetivo (los mas cercanos)

local poiCache, poiCacheTime = {}, 0

--- Areas de mision del juego (las zonas azules): { [questId] = { x, y, uiMapId } } para un mapa
local function QuestsOnMap(uiMapId)
    if not (C_QuestLog and C_QuestLog.GetQuestsOnMap and uiMapId) then return nil end
    local now = GetTime()
    if now - poiCacheTime > 1 then poiCache, poiCacheTime = {}, now end
    local cached = poiCache[uiMapId]
    if cached == nil then
        cached = {}
        local ok, list = pcall(C_QuestLog.GetQuestsOnMap, uiMapId)
        for _, q in ipairs(ok and list or {}) do
            if q.questID and q.x and q.y and not q.isMapIndicatorQuest then
                cached[q.questID] = { x = q.x, y = q.y, uiMapId = uiMapId }
            end
        end
        poiCache[uiMapId] = cached
    end
    return cached
end

--- Punto del area de mision del juego para esa mision, buscando en los mapas dados (o nil)
function Bridge:GamePOI(questId, maps, px, py, pinst)
    for _, uiMapId in ipairs(maps) do
        local list = QuestsOnMap(uiMapId)
        local poi = list and list[questId]
        if poi then
            local wx, wy, inst = self.HBD:GetWorldCoordinatesFromZone(poi.x, poi.y, uiMapId)
            if wx then
                local d = (inst == pinst and px) and (self.HBD:GetWorldDistance(pinst, px, py, wx, wy) or 1e7) or 1e7
                return { uiMapId = uiMapId, x = poi.x, y = poi.y, wx = wx, wy = wy, instance = inst, dist = d, fromGame = true }
            end
        end
    end
end

--- Zonas de un objetivo a partir de sus spawns: grupos conectados (spawns a menos de LINK_YARDS se unen), que
--- equivalen a las zonas azules del juego aunque la mision tenga varias. Cada zona: { members, near, nearD }.
local LINK_YARDS = 80         -- yardas: spawns a menos de esto forman parte de la misma zona
local IN_ZONE_YARDS = 60      -- si estas a menos de esto de un spawn de una zona, estas "en" esa zona
local ZONE_FALLOFF = 300      -- yardas: cuanto pesa la distancia frente al tamaño de la zona
local CORE_YARDS = 60         -- para elegir un punto "de verdad" dentro de la zona (no un spawn suelto)

-- Spawns de cada objetivo, guardados: lo que no depende de tu posicion (coordenadas y, si caben todos, las zonas)
-- se calcula una vez; en cada actualizacion solo se pone la distancia. Antes se creaba una tabla por spawn y se
-- rehacian las zonas (comparando cada spawn con todos) cada 1,5 s. Firma: las tablas de Questie en el mismo orden;
-- si cambian, se rehace.
local spawnCache = setmetatable({}, { __mode = "k" })

local function SameSpawnLists(c, spawnLists)
    local sig, k = c.sig, 0
    for _, sd in pairs(spawnLists) do
        if sig[k + 1] ~= sd or sig[k + 2] ~= sd.Spawns or sig[k + 3] ~= sd.Name then return false end
        k = k + 3
    end
    return k == #sig
end

local function SpawnRecords(self, spawnLists)
    local c = spawnCache[spawnLists]
    if c and SameSpawnLists(c, spawnLists) then return c end
    c = { sig = {}, recs = {}, sorted = {}, near = {} }
    for _, sd in pairs(spawnLists) do
        local sig = c.sig
        sig[#sig + 1], sig[#sig + 2], sig[#sig + 3] = sd, sd.Spawns, sd.Name
        for areaId, list in pairs(sd.Spawns or {}) do
            for _, spawn in pairs(list) do
                local w = spawn[1] and spawn[1] >= 0 and self:WorldPoint(areaId, spawn)
                if w then
                    c.recs[#c.recs + 1] = { wx = w[1], wy = w[2], instance = w[3], uiMapId = w[4], areaId = areaId,
                                            x = spawn[1] / 100, y = spawn[2] / 100, dist = 1e7, name = sd.Name,
                                            idx = #c.recs + 1 }
                end
            end
        end
    end
    spawnCache[spawnLists] = c
    return c
end

-- Orden total (a igual distancia, el orden de la base de datos): da siempre el mismo resultado, se ordene como se
-- ordene. Antes, con table.sort solo por distancia, dos spawns en el mismo sitio podian salir en cualquier orden.
local function DistLess(a, b)
    local da, db = a.dist, b.dist
    return da < db or (da == db and a.idx < b.idx)
end

--- Ordena c.sorted. Al moverte el orden casi no cambia de una vez a otra: se parte del de la vez anterior y se
--- recoloca solo lo que se ha movido (casi lineal). Si cambia mucho (p. ej. al volar o teletransportarte), table.sort.
local function SortByDist(c, recs)
    local sorted = c.sorted
    if #sorted ~= #recs then
        for i = 1, #recs do sorted[i] = recs[i] end
        for i = #recs + 1, #sorted do sorted[i] = nil end
        table.sort(sorted, DistLess)
        return sorted
    end
    local n, budget = #sorted, #sorted * 8
    for i = 2, n do
        local v = sorted[i]
        local j = i - 1
        while j >= 1 and DistLess(v, sorted[j]) do
            sorted[j + 1] = sorted[j]
            j = j - 1
            budget = budget - 1
        end
        sorted[j + 1] = v
        if budget < 0 then
            table.sort(sorted, DistLess)
            return sorted
        end
    end
    return sorted
end

--- Vecinos fijos de cada spawn (a menos de LINK_YARDS, misma instancia), con una rejilla: se calcula una vez por
--- objetivo. p.nb: los que unen zonas; p.nbCore: los que cuentan para ZoneTarget (a menos de CORE_YARDS).
local EMPTY = {}
local function BuildNeighbors(c, recs)
    if c.neighbors then return end
    local L2, C2 = LINK_YARDS * LINK_YARDS, CORE_YARDS * CORE_YARDS
    local grid = {}
    local function cell(inst, gx, gy)
        local a = grid[inst]; if not a then return nil end
        local b = a[gx]; return b and b[gy]
    end
    for _, p in ipairs(recs) do
        local gx, gy = math.floor(p.wx / LINK_YARDS), math.floor(p.wy / LINK_YARDS)
        p.gx, p.gy = gx, gy
        local a = grid[p.instance] or {}; grid[p.instance] = a
        local b = a[gx] or {}; a[gx] = b
        local list = b[gy] or {}; b[gy] = list
        list[#list + 1] = p
    end
    for _, p in ipairs(recs) do
        local nb, nbCore = {}, {}
        for dx = -1, 1 do
            for dy = -1, 1 do
                for _, q in ipairs(cell(p.instance, p.gx + dx, p.gy + dy) or EMPTY) do
                    if q ~= p then
                        local ex, ey = q.wx - p.wx, q.wy - p.wy
                        local d2 = ex * ex + ey * ey
                        if d2 <= L2 then nb[#nb + 1] = q end
                        if d2 <= C2 then nbCore[#nbCore + 1] = q end
                    end
                end
            end
        end
        p.nb, p.nbCore = nb, nbCore
    end
    c.neighbors = true
end

--- -> lista de puntos (con .dist puesta), la cache y si la lista es solo una parte (los MAX_POINTS mas cercanos).
--- Con todos, las zonas no cambian al moverte. Los puntos son de la cache: no se devuelven tal cual.
local function SpawnPoints(self, spawnLists, px, py, pinst)
    local c = SpawnRecords(self, spawnLists)
    local recs, HBD = c.recs, self.HBD
    for i = 1, #recs do
        local r = recs[i]
        r.dist = (r.instance == pinst and px) and (HBD:GetWorldDistance(pinst, px, py, r.wx, r.wy) or 1e7) or 1e7
    end
    if #recs <= MAX_POINTS then return recs, c, false end
    local sorted, near = SortByDist(c, recs), c.near
    for i = 1, MAX_POINTS do near[i] = sorted[i] end
    BuildNeighbors(c, recs)
    return near, c, true
end

local function BuildZones(pts)
    local L2 = LINK_YARDS * LINK_YARDS
    local zoneOf, zones = {}, {}
    for i = 1, #pts do
        if not zoneOf[i] then
            local z = { members = {} }
            zones[#zones + 1] = z
            zoneOf[i] = z
            local queue, head = { i }, 1
            while queue[head] do
                local p = pts[queue[head]]
                head = head + 1
                z.members[#z.members + 1] = p
                if not z.nearD or p.dist < z.nearD then z.near, z.nearD = p, p.dist end
                for j = 1, #pts do
                    if not zoneOf[j] then
                        local q = pts[j]
                        if q.instance == p.instance then
                            local dx, dy = q.wx - p.wx, q.wy - p.wy
                            if dx * dx + dy * dy <= L2 then zoneOf[j] = z; queue[#queue + 1] = j end
                        end
                    end
                end
            end
        end
    end
    return zones
end

--- Punto al que ir dentro de una zona: el spawn mas cercano al jugador que tenga vecinos (parte "llena"
--- de la zona, no un spawn suelto en el borde); si no hay ninguno, el mas cercano.
local function ZoneTarget(z)
    local C2 = CORE_YARDS * CORE_YARDS
    local need = math.min(3, #z.members)
    local best
    for _, p in ipairs(z.members) do
        if not best or p.dist < best.dist then
            local n = 0
            for _, q in ipairs(z.members) do
                local dx, dy = q.wx - p.wx, q.wy - p.wy
                if dx * dx + dy * dy <= C2 then n = n + 1 end
            end
            if n >= need then best = p end
        end
    end
    return best or z.near
end

--- Igual que BuildZones, para los MAX_POINTS mas cercanos de un objetivo con mas spawns: con los vecinos ya
--- calculados (p.nb) en vez de comparar cada spawn con todos. Mismo recorrido: los vecinos de cada uno se añaden en
--- el orden de la lista, como al recorrerla entera.
local subsetPos, scratch = {}, {}
local function SubsetZones(pts)
    wipe(subsetPos)
    for i = 1, #pts do subsetPos[pts[i]] = i end
    local zoneOf, zones = {}, {}
    for i = 1, #pts do
        if not zoneOf[i] then
            local z = { members = {} }
            zones[#zones + 1] = z
            zoneOf[i] = z
            local queue, head = { i }, 1
            while queue[head] do
                local p = pts[queue[head]]
                head = head + 1
                z.members[#z.members + 1] = p
                if not z.nearD or p.dist < z.nearD then z.near, z.nearD = p, p.dist end
                local n = 0
                for _, q in ipairs(p.nb) do
                    local j = subsetPos[q]
                    if j and not zoneOf[j] then n = n + 1; scratch[n] = j end
                end
                for k = n + 1, #scratch do scratch[k] = nil end
                if n > 1 then table.sort(scratch) end
                for k = 1, n do
                    zoneOf[scratch[k]] = z
                    queue[#queue + 1] = scratch[k]
                end
            end
        end
    end
    return zones
end

--- Igual que ZoneTarget, con los vecinos ya calculados: los de p.nbCore que estan en la lista (estan a menos de
--- LINK_YARDS, asi que son de su misma zona) mas el propio p.
local function SubsetZoneTarget(z)
    local need = math.min(3, #z.members)
    local best
    for _, p in ipairs(z.members) do
        if not best or p.dist < best.dist then
            local n = 1
            for _, q in ipairs(p.nbCore) do if subsetPos[q] then n = n + 1 end end
            if n >= need then best = p end
        end
    end
    return best or z.near
end

--- Igual que ZoneTarget, para zonas guardadas: cuantos vecinos tiene cada spawn no cambia al moverte, asi que se
--- cuenta una vez (z.core[i]: tiene suficientes vecinos).
local function CachedZoneTarget(z)
    local members, core = z.members, z.core
    if not core then
        core = {}
        local C2 = CORE_YARDS * CORE_YARDS
        local need = math.min(3, #members)
        for i, p in ipairs(members) do
            local n = 0
            for _, q in ipairs(members) do
                local dx, dy = q.wx - p.wx, q.wy - p.wy
                if dx * dx + dy * dy <= C2 then n = n + 1 end
            end
            core[i] = n >= need
        end
        z.core = core
    end
    local best
    for i, p in ipairs(members) do
        if (not best or p.dist < best.dist) and core[i] then best = p end
    end
    return best or z.near
end

--- Mejor sitio para hacer un objetivo a partir de sus spawns:
---   1) si ya estas dentro de una zona del objetivo, esa (no te manda a otra con los mismos bichos);
---   2) si no, la zona con mejor relacion tamaño / distancia (la grande gana si esta relativamente cerca).
--- poi (opcional): area que marca el juego; la zona que la contiene recibe un pequeño extra.
function Bridge:BestSpawnArea(spawnLists, px, py, pinst, poi)
    if not spawnLists then return nil end
    local pts, cache, subset = SpawnPoints(self, spawnLists, px, py, pinst)
    if #pts == 0 then return nil end
    local zones
    if subset then
        zones = SubsetZones(pts)
    else
        -- todos los spawns: las zonas son siempre las mismas; solo cambia cual es el mas cercano de cada una
        zones = cache.zones
        if not zones then
            zones = BuildZones(pts)
            cache.zones = zones
        end
        for _, z in ipairs(zones) do
            local near, nearD
            for _, p in ipairs(z.members) do
                if not nearD or p.dist < nearD then near, nearD = p, p.dist end
            end
            z.near, z.nearD = near, nearD
        end
    end
    local chosen, inZone
    for _, z in ipairs(zones) do
        if z.nearD <= IN_ZONE_YARDS and (not chosen or #z.members > #chosen.members) then chosen, inZone = z, true end
    end
    if not chosen then
        local bestScore
        local P2 = (LINK_YARDS * 1.5) ^ 2
        for _, z in ipairs(zones) do
            local score = #z.members / (1 + z.nearD / ZONE_FALLOFF)
            if poi and poi.wx then
                for _, q in ipairs(z.members) do
                    local dx, dy = q.wx - poi.wx, q.wy - poi.wy
                    if q.instance == poi.instance and dx * dx + dy * dy <= P2 then score = score * 1.25 break end
                end
            end
            if not bestScore or score > bestScore then chosen, bestScore = z, score end
        end
    end
    local src = inZone and chosen.near or (subset and SubsetZoneTarget(chosen) or CachedZoneTarget(chosen))
    -- (copia: los puntos son de la cache y quien recibe el destino lo modifica)
    return { wx = src.wx, wy = src.wy, instance = src.instance, uiMapId = src.uiMapId, areaId = src.areaId,
             x = src.x, y = src.y, dist = src.dist, name = src.name,
             clusterSize = #chosen.members, inZone = inZone }
end

--- Donde ir para los objetivos de una mision: la zona de spawns (en la que estas, o la mejor cercana); el area
--- que marca el juego solo desempata o sirve de respaldo si el objetivo no tiene spawns conocidos. El juego da
--- UN punto por mision aunque tenga varias zonas azules, asi que no puede mandar por si solo.
function Bridge:ObjectiveArea(quest, objective, maps, px, py, pinst)
    local poi = self:GamePOI(quest.Id, maps, px, py, pinst)
    local best = self:BestSpawnArea(objective and objective.spawnList, px, py, pinst, poi)
    -- objetivo dentro de una mazmorra o banda: a su entrada
    if best and best.instance and best.instance ~= 0 and best.instance ~= 1 then
        local name = best.name
        best = self:OutsidePoint(best, px, py, pinst)
        if best then best.name = name or best.name end
    end
    if best then return best end
    if poi then
        local name
        for _, sd in pairs(objective and objective.spawnList or {}) do name = sd.Name break end
        poi.name = name
        return poi
    end
end

--- Mapas candidatos para buscar el area del juego: donde esta el jugador y el de la guia
function Bridge:CandidateMaps(extraMap)
    local maps, seen = {}, {}
    local function add(m) if m and not seen[m] then seen[m] = true; maps[#maps + 1] = m end end
    add(C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player"))
    local guide = QR.Planner and QR.Planner:GetGuide()
    if guide then add(self:UiMapOf(guide.areaId)) end
    add(extraMap)
    return maps
end

QR:RegisterModule("Bridge", function()
    Bridge:Init()
    Bridge.ActiveQuests = QuestieLoader:ImportModule("ActiveQuests")
end, true)   -- al entrar: solo importa modulos (la tabla de zonas de Questie ya esta lista al cargarlo)

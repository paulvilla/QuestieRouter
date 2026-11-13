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

function Bridge:FindMapLibs(tries)
    self.HBD = self.HBD or FindLib("HereBeDragonsQuestie-2.0", "HereBeDragons-2.0")
    self.HBDPins = self.HBDPins or FindLib("HereBeDragonsQuestie-Pins-2.0", "HereBeDragons-Pins-2.0")
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
function Bridge:QuestStatus(questId)
    if Questie.db.char.complete[questId] then return "done" end
    if self.ActiveQuests.Get(questId) then return "active" end
    local ok, doable = pcall(self.QuestieDB.IsDoable, questId)
    if not (ok and doable) then return "locked" end
    local req = self.QuestieDB.QueryQuestSingle(questId, "requiredLevel") or 1
    if req > UnitLevel("player") then return "lowlevel" end
    return "available"
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
    local best, bestD
    for areaId, list in pairs(spawns or {}) do
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
                    bestD = d
                    best = { areaId = areaId, uiMapId = w[4], x = spawn[1] / 100, y = spawn[2] / 100,
                             wx = w[1], wy = w[2], instance = w[3], dist = d }
                end
            end
        end
    end
    return best
end

--- Punto mas cercano de quien da / recibe una mision (quest.Starts o quest.Finisher).
function Bridge:NearestNpcOrObject(holder, px, py, pinst)
    local best
    for _, npcId in pairs(holder and holder.NPC or {}) do
        local npc = self.QuestieDB:GetNPC(npcId)
        if npc and npc.spawns and npc.friendly ~= false then
            local p = self:NearestSpawn(npc.spawns, px, py, pinst)
            if p and (not best or p.dist < best.dist) then p.name = npc.name; p.npcId = npcId; best = p end
        end
    end
    for _, objId in pairs(holder and holder.GameObject or {}) do
        local obj = self.QuestieDB:GetObject(objId)
        if obj and obj.spawns then
            local p = self:NearestSpawn(obj.spawns, px, py, pinst)
            if p and (not best or p.dist < best.dist) then p.name = obj.name; best = p end
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

local function SpawnPoints(self, spawnLists, px, py, pinst)
    local pts = {}
    for _, sd in pairs(spawnLists or {}) do
        for areaId, list in pairs(sd.Spawns or {}) do
            for _, spawn in pairs(list) do
                local w = spawn[1] and spawn[1] >= 0 and self:WorldPoint(areaId, spawn)
                if w then
                    local d = (w[3] == pinst and px) and (self.HBD:GetWorldDistance(pinst, px, py, w[1], w[2]) or 1e7) or 1e7
                    pts[#pts + 1] = { wx = w[1], wy = w[2], instance = w[3], uiMapId = w[4], areaId = areaId,
                                      x = spawn[1] / 100, y = spawn[2] / 100, dist = d, name = sd.Name }
                end
            end
        end
    end
    if #pts > MAX_POINTS then
        table.sort(pts, function(a, b) return a.dist < b.dist end)
        for i = #pts, MAX_POINTS + 1, -1 do pts[i] = nil end
    end
    return pts
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

--- Mejor sitio para hacer un objetivo a partir de sus spawns:
---   1) si ya estas dentro de una zona del objetivo, esa (no te manda a otra con los mismos bichos);
---   2) si no, la zona con mejor relacion tamaño / distancia (la grande gana si esta relativamente cerca).
--- poi (opcional): area que marca el juego; la zona que la contiene recibe un pequeño extra.
function Bridge:BestSpawnArea(spawnLists, px, py, pinst, poi)
    local pts = SpawnPoints(self, spawnLists, px, py, pinst)
    if #pts == 0 then return nil end
    local zones = BuildZones(pts)
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
    local target = inZone and chosen.near or ZoneTarget(chosen)
    target.clusterSize = #chosen.members
    target.inZone = inZone
    return target
end

--- Donde ir para los objetivos de una mision: la zona de spawns (en la que estas, o la mejor cercana); el area
--- que marca el juego solo desempata o sirve de respaldo si el objetivo no tiene spawns conocidos. El juego da
--- UN punto por mision aunque tenga varias zonas azules, asi que no puede mandar por si solo.
function Bridge:ObjectiveArea(quest, objective, maps, px, py, pinst)
    local poi = self:GamePOI(quest.Id, maps, px, py, pinst)
    local best = self:BestSpawnArea(objective and objective.spawnList, px, py, pinst, poi)
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
end)

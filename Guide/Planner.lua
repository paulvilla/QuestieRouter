-- QuestieRouter: planificador de zona.
--
-- Problema: no queremos ir mision a mision (coger A, hacer A, entregar A, coger B...). Lo que hace
-- un jugador es ir a un "hub", coger TODO lo que hay, hacer los objetivos que tiene cerca, volver
-- a entregar (lo que suele desbloquear la siguiente tanda) y repetir. El planificador imita eso.
--
-- Cada vez que se recalcula (cada ~1.5 s y en cada cambio del log) construye tres listas de tareas:
--   PICKUP    misiones de la guia disponibles (requisitos y nivel OK)   -> posicion de quien la da
--   OBJECTIVE objetivos sin terminar de misiones del log en esta zona   -> spawn mas cercano
--   TURNIN    misiones del log completas                                -> posicion de quien la recibe
-- y elige la siguiente con estas reglas, en orden:
--   1. Hub:     cualquier recoger/entregar a menos de HUB_RADIUS yardas -> la mas cercana
--               (asi se vacia el hub entero antes de salir, y se encadenan las que se desbloquean)
--   2. Campo:   el objetivo mas cercano; pero si de camino hay un recoger/entregar mucho mas cerca
--               (DETOUR_FACTOR de la distancia al objetivo) se hace primero
--   3. Entregar lo que quede, la mas cercana
--   4. Siguiente hub: la mision disponible con MENOR posicion en la guia (nivel bajo -> alto)
--   5. Nada que hacer: o falta nivel (dice cual) o la zona esta terminada
--
-- Ademas no propone objetivos de misiones demasiado altas (nivel > jugador + MAX_LEVEL_ABOVE)
-- ni recoger si el registro de misiones esta lleno.

local _, QR = ...
local L = QR.L

local Planner = {}
QR.Planner = Planner

local HUB_RADIUS = 120       -- yardas
local DETOUR_FACTOR = 0.35
local MAX_LEVEL_ABOVE = 3
-- Tamaño del registro de misiones: lo dice el juego (WoW Forever: 40; Classic original: 20)
local function MaxQuestsInLog()
    local n = C_QuestLog and C_QuestLog.GetMaxNumQuestsCanAccept and C_QuestLog.GetMaxNumQuestsCanAccept()
    return (type(n) == "number" and n > 0) and n or 20
end

local KIND_COLOR = { pickup = "|cffffd100", objective = "|cffff8040", turnin = "|cff33ff33", corpse = "|cffbbbbbb", travel = "|cff62d2e0" }
local KIND_LABEL = { pickup = "Pick up", objective = "Do", turnin = "Turn in", corpse = "Corpse", travel = "Travel" }
-- Planner.KIND_TEXT[kind] -> nombre del tipo de paso con su color, en el idioma activo
Planner.KIND_TEXT = setmetatable({}, { __index = function(_, kind)
    return KIND_COLOR[kind] and (KIND_COLOR[kind] .. L[KIND_LABEL[kind]] .. "|r") or nil
end })

function Planner:GetGuide()
    local key = QR.charDB and QR.charDB.activeGuide
    return key and QR.zoneGuideByKey[key] or nil
end

function Planner:IsActive()
    return QR.db.enabled and self:GetGuide() ~= nil
end

function Planner:SetGuide(key)
    QR.charDB.activeGuide = key
    self.plan = nil
    self.committed, self.focus = nil, nil
    QR:Fire("GUIDE_CHANGED", self:GetGuide())
    if QR.Target then QR.Target:Refresh(true) end
end

---------------------------------------------------------------------------
-- Construccion de tareas
---------------------------------------------------------------------------

local function ObjectiveDone(o)
    return o.Completed == true or (o.Needed and o.Collected and o.Needed == o.Collected)
end

local function MakeTask(kind, quest, point, label)
    point.kind = kind
    point.questId = quest.Id
    point.questName = quest.name
    point.label = label or point.name
    point.name = point.label
    point.isTurnIn = kind == "turnin"
    return point
end

local FAR = 1e7
local CONT_MAP = { [0] = 1415, [1] = 1414 }

-- Capitales (uiMapId). Dentro de una, primero se entregan TODAS las misiones completas que se entregan en
-- esa ciudad (sean o no de la guia) y despues se sigue con la guia.
local CITY_MAPS = { [1453] = true, [1454] = true, [1455] = true, [1456] = true, [1457] = true, [1458] = true }

--- uiMapId de la capital en la que esta el jugador, o nil
function Planner:PlayerCity()
    local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    -- (un submapa dentro de la ciudad, si lo hubiera, cuenta como la ciudad)
    local guard = 0
    while map and not CITY_MAPS[map] and guard < 4 do
        local info = C_Map.GetMapInfo(map)
        map = info and info.parentMapID
        guard = guard + 1
        if info and info.mapType and Enum and Enum.UIMapType and info.mapType <= Enum.UIMapType.Zone then break end
    end
    return map and CITY_MAPS[map] and map or nil
end

--- Guia de mazmorra: lo que esta dentro de la mazmorra (otra instancia, o sin punto en el mundo) se cambia por
--- su entrada. Dentro de la instancia no hay coordenadas del mundo: la flecha lleva hasta la puerta.
local function ToEntrance(guide, p, px, py, pinst)
    if not guide.dungeon or (p and (p.instance == 0 or p.instance == 1)) then return p end
    local e = QR.Router and QR.Router.DungeonEntrance and QR.Router:DungeonEntrance(guide.dungeon)
    if not e then return p end
    local d = (px and pinst == e.inst) and (QR.HBD:GetWorldDistance(pinst, px, py, e.wx, e.wy) or FAR) or FAR
    local cont = CONT_MAP[e.inst]
    local x, y
    if cont and QR.HBD.GetZoneCoordinatesFromWorld then x, y = QR.HBD:GetZoneCoordinatesFromWorld(e.wx, e.wy, cont, true) end
    return { wx = e.wx, wy = e.wy, instance = e.inst, dist = d, uiMapId = cont, x = x, y = y,
             name = (p and p.name) or e.name, npcId = p and p.npcId, inDungeon = e.name }
end

function Planner:BuildTasks(guide)
    local B = QR.Bridge
    local px, py, pinst = QR.HBD:GetPlayerWorldPosition()
    local level = UnitLevel("player")
    local guideMap = B:UiMapOf(guide.areaId)
    local maps = B:CandidateMaps(guideMap) -- donde buscar las areas de mision del juego
    local tasks = { pickup = {}, objective = {}, turnin = {}, notes = {} }
    local skipped = QR.charDB.skipped or {}
    local city = self:PlayerCity()

    -- Misiones del log
    for questId in B:IterateActive() do
        local quest = (not skipped[questId]) and B:GetQuest(questId)
        if quest then
            local inGuide = guide.info[questId] ~= nil
            if B:IsQuestComplete(quest) then
                local p = B:NearestNpcOrObject(quest.Finisher, px, py, pinst)
                -- en una capital: se entrega aqui aunque no sea de la guia (tiene prioridad, ver Choose)
                local inCity = city and p and p.uiMapId == city
                if inGuide and not inCity then p = ToEntrance(guide, p, px, py, pinst) end
                if p and (inGuide or inCity or p.uiMapId == guideMap) then
                    local t = MakeTask("turnin", quest, p)
                    t.city = inCity or nil
                    table.insert(tasks.turnin, t)
                end
            else
                local tooHigh = (quest.level or 0) > level + MAX_LEVEL_ABOVE
                for idx, o in pairs(quest.Objectives or {}) do
                    if not ObjectiveDone(o) then
                        -- zona de spawns en la que estas o la mejor cercana; el area del juego solo como respaldo
                        local best = B:ObjectiveArea(quest, o, maps, px, py, pinst)
                        if inGuide then best = ToEntrance(guide, best, px, py, pinst) end
                        if best and (inGuide or best.uiMapId == guideMap) then
                            if tooHigh then
                                tasks.notes[questId] = L["level too high"]
                            else
                                local text = o.Description or best.name
                                if best.inDungeon then text = string.format(L["%s (inside %s)"], text or "", best.inDungeon) end
                                local t = MakeTask("objective", quest, best, text)
                                t.objectiveIndex = idx
                                t.objType = o.Type            -- monster / item / object (aviso de "recoger cerca")
                                t.objText, t.have, t.need = o.Description, o.Collected, o.Needed
                                table.insert(tasks.objective, t)
                            end
                        elseif not best and inGuide then
                            tasks.notes[questId] = L["objective without a location"]
                        end
                    end
                end
            end
        end
    end

    -- Misiones de la guia por coger
    local logFull = B:NumQuestsInLog() >= MaxQuestsInLog()
    local nextLevel
    for _, row in ipairs(guide.quests) do
        local questId = row[1]
        local status = B:QuestStatus(questId)
        if skipped[questId] then
            -- saltada por el jugador (Mayus+clic en la ventana)
        elseif status == "available" and Planner:NotOffered(questId) then
            -- el NPC no la ofrecio al hablar con el (falta algo de la cadena que Questie no sabe): no llevar alli
            tasks.notes[questId] = L["The NPC doesn't offer it yet (earlier quest of the chain missing)"]
        elseif status == "available" and not logFull then
            local quest = B:GetQuest(questId)
            local p = quest and B:NearestNpcOrObject(quest.Starts, px, py, pinst)
            if quest then p = ToEntrance(guide, p, px, py, pinst) end
            if p then
                local t = MakeTask("pickup", quest, p)
                t.order = guide.order[questId]
                table.insert(tasks.pickup, t)
            end
        elseif status == "lowlevel" then
            if not nextLevel or row[3] < nextLevel then nextLevel = row[3] end
        end
    end
    tasks.logFull = logFull
    tasks.nextLevel = nextLevel
    return tasks
end

---------------------------------------------------------------------------
-- Eleccion de la siguiente tarea
---------------------------------------------------------------------------

local function Nearest(...)
    local best
    for i = 1, select("#", ...) do
        for _, t in ipairs(select(i, ...)) do
            if not best or t.dist < best.dist then best = t end
        end
    end
    return best
end

local function IsCityTurnin(t)
    return t.city or (t.point and t.point.city) or false
end

--- Entrega en la capital en la que estas mas cercana (tareas o pasos), o nil
local function NearestCityTurnin(list)
    local best
    for _, t in ipairs(list) do
        if IsCityTurnin(t) and (not best or t.dist < best.dist) then best = t end
    end
    return best
end

function Planner:Choose(tasks)
    -- 0. En una capital: primero todas las entregas de la ciudad, de la mas cercana a la mas lejana
    local cityTurn = NearestCityTurnin(tasks.turnin)
    if cityTurn then return cityTurn, "ciudad" end

    -- 1. Hub: recoger / entregar cerca
    local hub = Nearest(tasks.turnin, tasks.pickup)
    if hub and hub.dist <= HUB_RADIUS then return hub, "hub" end

    -- 2. Campo: objetivo mas cercano (con desvio si compensa)
    local obj = Nearest(tasks.objective)
    if obj then
        if hub and hub.dist < obj.dist * DETOUR_FACTOR then return hub, "desvio" end
        return obj, "campo"
    end

    -- 3. Entregar lo que quede
    local turn = Nearest(tasks.turnin)
    if turn then return turn, "entregar" end

    -- 4. Siguiente hub: la disponible mas baja en la guia
    local nextHub
    for _, t in ipairs(tasks.pickup) do
        if not nextHub or t.order < nextHub.order then nextHub = t end
    end
    if nextHub then return nextHub, "siguiente hub" end

    return nil, nil
end

function Planner:Update()
    if not QR.HBD then return end   -- librerias de mapa aun no disponibles (Bridge:FindMapLibs)
    local guide = self:GetGuide()
    if not guide then
        self.plan = nil
        return nil
    end
    local tasks = self:BuildTasks(guide)
    QR.Steps:CheckCompletions(guide)
    -- Pasos agrupados (coger por NPC, hacer por mision, entregar por NPC) y orden simulado
    local live = QR.Steps:FromTasks(tasks)
    local pinned = self:MatchPinned(guide, live)
    -- en una capital las entregas de la ciudad van antes que el paso en curso (luego se vuelve a la guia)
    local committed = not pinned and (self:MatchCityTurnin(live) or self:MatchCommitted(live))
    if committed and committed.reason ~= "hub" and committed.reason ~= "ciudad" then committed.reason = "en curso" end
    local steps = QR.Steps:Simulate(live, pinned or committed or nil)
    local step = steps[1]
    if step and not pinned then self:RememberStep(step) end
    local task
    if step then
        -- la flecha va al punto del paso actual, con el texto del paso
        task = step.point
        task.kind = step.kind
        task.questId = step.questIds[1]
        task.questName = step.kind == "objective" and step.questName
            or (#step.questIds == 1 and step.lines[1].text) or string.format(L["%d quests"], #step.questIds)
        task.label = step.npc or task.label
        task.name = task.label
        task.isTurnIn = step.kind == "turnin"
    end
    self.plan = { guide = guide, tasks = tasks, steps = steps, current = task, currentStep = step,
                  reason = step and step.reason, nearby = self:NearbyCollect(step, tasks) }

    if not task then
        if tasks.logFull then
            self.plan.message = L["Quest log full: abandon or turn in some quests."]
        elseif tasks.nextLevel then
            self.plan.message = string.format(L["Nothing else at your level. Next quest at level %d."], tasks.nextLevel)
        else
            self.plan.message = L["Zone complete. Choose the next guide."]
        end
    end
    QR:Fire("PLAN_UPDATED", self.plan)
    return task
end

---------------------------------------------------------------------------
-- Compromiso con el paso actual: que no "baile" entre dos misiones cercanas
---------------------------------------------------------------------------
-- El paso que estas haciendo se mantiene mientras siga vivo. Solo se cambia si:
--   * hay un coger / entregar cerca (NEAR_HUB, el mismo radio de "hub" de siempre): tiene prioridad, se hace y
--     luego se vuelve al paso. Una vez elegido se mantiene hasta HUB_KEEP (no salta en el borde del radio);
--   * otro objetivo es claramente mejor: tras MIN_DWELL s, a menos de SWITCH_RATIO de la distancia y ahorrando
--     mas de SWITCH_YARDS (nunca si ya estas dentro del area del objetivo, AREA_YARDS);
--   * lo que haces apunta a otra mision: seleccionas un bicho suyo o avanza su contador.
local NEAR_HUB, HUB_KEEP = HUB_RADIUS, 170
local MIN_DWELL, SWITCH_RATIO, SWITCH_YARDS, AREA_YARDS = 25, 0.5, 150, 50
local NEARBY_YARDS = 60      -- aviso "Atento: recoger X" si esta a menos de esto
local FOCUS_SECONDS = 60     -- cuanto dura la preferencia por la mision que acabas de tocar

local function StepKey(s)
    local ids = {}
    for i, q in ipairs(s.questIds or {}) do ids[i] = q end
    table.sort(ids)
    return s.kind .. ":" .. table.concat(ids, ",") .. ":" .. tostring(s.npcId or s.npc or "")
end
Planner.StepKey = StepKey

local function StepDist(s) return s and s.point and s.point.dist or 1e9 end

function Planner:Commit(step)
    self.committed = step and { key = StepKey(step), kind = step.kind, questId = step.questIds[1], since = GetTime() } or nil
end

--- Paso comprometido entre los pasos vivos (o nil para que se elija por proximidad)
function Planner:MatchCommitted(live)
    -- lo que estas haciendo manda: mision cuyo bicho seleccionaste o cuyo contador acaba de avanzar
    local f = self.focus
    if f and GetTime() - f.at < FOCUS_SECONDS then
        local c = self.committed
        if not (c and c.kind == "objective" and c.questId == f.questId) then
            for _, s in ipairs(live) do
                if s.kind == "objective" and s.questIds[1] == f.questId then self:Commit(s) break end
            end
        end
    end
    local c = self.committed
    local cur
    if c then
        for _, s in ipairs(live) do if StepKey(s) == c.key then cur = s break end end
        if not cur then self.committed, c = nil, nil end      -- terminado: se elige el siguiente
    end
    local dCur = StepDist(cur)
    -- coger / entregar cerca: tiene prioridad (el compromiso se conserva para volver despues). El que ya se
    -- eligio se mantiene hasta HUB_KEEP para que no salte en el borde del radio; si no, el mas cercano <= NEAR_HUB.
    -- entre varios coger / entregar gana el MAS CERCANO; el ya elegido solo se mantiene si esta casi igual de cerca
    -- (no mas de un 25 % + 15 yd mas lejos), para no saltar entre dos NPC a distancias parecidas
    -- (el paso en curso tambien cuenta si es un coger / entregar: antes se excluia y, tras elegir el mas cercano,
    --  en la siguiente vuelta solo quedaba el otro y saltaba a el)
    if cur and (cur.kind == "pickup" or cur.kind == "turnin") and not self.hubKey then self.hubKey = StepKey(cur) end
    local hub, hubD, kept, keptD
    for _, s in ipairs(live) do
        if s.kind == "pickup" or s.kind == "turnin" then
            local d = StepDist(s)
            if self.hubKey == StepKey(s) and d <= HUB_KEEP then kept, keptD = s, d end
            if d <= NEAR_HUB and (not hubD or d < hubD) then hub, hubD = s, d end
        end
    end
    if kept and (not hubD or keptD <= hubD * 1.25 + 15) then hub, hubD = kept, keptD end
    if hub then
        self.hubKey = StepKey(hub)
        hub.reason = "hub"
        return hub
    end
    self.hubKey = nil
    if not cur then return nil end
    -- otro objetivo claramente mejor (y no estas ya dentro del area del tuyo)
    if cur.kind == "objective" and dCur > AREA_YARDS and GetTime() - c.since >= MIN_DWELL then
        for _, s in ipairs(live) do
            local d = StepDist(s)
            if s ~= cur and s.kind == "objective" and d < dCur * SWITCH_RATIO and dCur - d > SWITCH_YARDS then
                self.committed = nil
                return nil
            end
        end
    end
    return cur
end

--- En una capital: la entrega de la ciudad mas cercana. La ya elegida se mantiene si sigue casi igual de cerca
--- (como en los hubs: no mas de un 25 % + 15 yd mas lejos), para no saltar entre dos NPC a distancias parecidas.
function Planner:MatchCityTurnin(live)
    local best, kept
    for _, s in ipairs(live) do
        if s.kind == "turnin" and IsCityTurnin(s) then
            if not best or StepDist(s) < StepDist(best) then best = s end
            if self.cityKey == StepKey(s) then kept = s end
        end
    end
    if kept and StepDist(kept) <= StepDist(best) * 1.25 + 15 then best = kept end
    self.cityKey = best and StepKey(best) or nil
    if best then best.reason = "ciudad" end
    return best
end

--- Tras elegir el paso actual: pasa a ser el comprometido, salvo que sea un coger / entregar de paso (desvio
--- corto con otro compromiso todavia vivo: al terminarlo se vuelve a lo que estabas haciendo)
function Planner:RememberStep(step)
    local c = self.committed
    if c and c.key == StepKey(step) then return end
    if c and (step.kind == "pickup" or step.kind == "turnin") and StepDist(step) <= HUB_KEEP then return end
    self:Commit(step)
end

--- Aviso sin cambiar de paso: si estas matando y otra mision tiene algo que recoger / usar muy cerca
function Planner:NearbyCollect(step, tasks)
    if not step or step.kind ~= "objective" then return nil end
    local best
    for _, t in ipairs(tasks.objective) do
        if t.questId ~= step.questIds[1] and (t.objType == "item" or t.objType == "object")
            and t.dist and t.dist <= NEARBY_YARDS and (not best or t.dist < best.dist) then
            best = t
        end
    end
    if not best then return nil end
    local text = best.objText or best.label or "?"
    if best.need and best.need > 1 then text = string.format("%s (%d/%d)", text, best.have or 0, best.need) end
    return { questId = best.questId, text = text, dist = best.dist }
end

-- Preferencia por lo que haces: bicho seleccionado de una mision del log, o contador que avanza
do
    local lastCounts = {}
    local function MonsterQuestOf(name)
        local B = QR.Bridge
        for qid in B:IterateActive() do
            local quest = B:GetQuest(qid)
            for _, od in pairs(quest and quest.ObjectiveData or {}) do
                if od.Type == "monster" and od.Id then
                    local npc = B.QuestieDB:GetNPC(od.Id)
                    if npc and npc.name == name then return qid end
                end
            end
        end
    end
    local f = CreateFrame("Frame")
    pcall(f.RegisterEvent, f, "PLAYER_TARGET_CHANGED")
    pcall(f.RegisterEvent, f, "QUEST_LOG_UPDATE")
    f:SetScript("OnEvent", function(_, event)
        if not (QR.Bridge and QR.Bridge.ActiveQuests and Planner:GetGuide()) then return end
        local B = QR.Bridge
        if event == "PLAYER_TARGET_CHANGED" then
            if UnitExists("target") and not UnitIsDead("target") and UnitCanAttack and UnitCanAttack("player", "target") then
                local qid = MonsterQuestOf(UnitName("target"))
                if qid then Planner.focus = { questId = qid, at = GetTime() } end
            end
            return
        end
        -- QUEST_LOG_UPDATE: la mision cuyo contador sube es la que estas haciendo
        local seen = {}
        for qid in B:IterateActive() do
            local quest = B:GetQuest(qid)
            local sum = 0
            for _, o in pairs(quest and quest.Objectives or {}) do sum = sum + (o.Collected or 0) end
            seen[qid] = sum
            if lastCounts[qid] and sum > lastCounts[qid] then Planner.focus = { questId = qid, at = GetTime() } end
        end
        lastCounts = seen
    end)
end

---------------------------------------------------------------------------
-- Paso elegido por el jugador ("Ir a este paso")
---------------------------------------------------------------------------
--- Fija un paso: queda como actual hasta que se termina; luego se sigue desde ahi
function Planner:PinStep(step)
    local guide = self:GetGuide()
    if not guide or not step then return end
    local ids = {}
    for i, q in ipairs(step.questIds) do ids[i] = q end
    QR.charDB.pinnedStep = { guide = guide.key, kind = step.kind, questIds = ids }
    if QR.Target then QR.Target:Refresh(true) end
end

function Planner:UnpinStep()
    QR.charDB.pinnedStep = nil
    if QR.Target then QR.Target:Refresh(true) end
end

function Planner:IsPinned(step)
    local pin = QR.charDB.pinnedStep
    if not pin or not step or pin.kind ~= step.kind then return false end
    for _, a in ipairs(pin.questIds) do
        for _, b in ipairs(step.questIds) do if a == b then return true end end
    end
    return false
end

--- El paso fijado entre los pasos vivos; si ya no esta (se termino), se suelta y se sigue normal
function Planner:MatchPinned(guide, live)
    local pin = QR.charDB.pinnedStep
    if not pin then return nil end
    if pin.guide ~= guide.key then QR.charDB.pinnedStep = nil return nil end
    for _, s in ipairs(live) do
        if self:IsPinned(s) then return s end
    end
    QR.charDB.pinnedStep = nil
    return nil
end

--- Destino para la flecha y las lineas (mismo formato que Bridge:ComputeTarget).
function Planner:GetTarget()
    return self:Update()
end

---------------------------------------------------------------------------
-- Cadenas de misiones
---------------------------------------------------------------------------
--- Misiones anteriores de la cadena que faltan: { { id, name, zone (nombre del mapa o nil), inGuide }, ... }
--- preQuestGroup = hacen falta todas; preQuestSingle = basta con una (si no hay ninguna hecha, se listan).
function Planner:MissingPrereqs(questId, guide)
    local B = QR.Bridge
    local done = Questie.db.char.complete
    local q = B.QuestieDB.QueryQuestSingle
    local out = {}
    -- single = true: es una de varias alternativas (preQuestSingle: basta con hacer una)
    local function add(p, single)
        local pq = B:GetQuest(p)
        local zos = q(p, "zoneOrSort")
        local map = type(zos) == "number" and zos > 0 and B:UiMapOf(zos)
        local info = map and C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
        out[#out + 1] = { id = p, name = pq and pq.name or ("#" .. p), zone = info and info.name or nil,
                          inGuide = guide and guide.info[p] ~= nil, single = single or nil }
    end
    local okG, group = pcall(q, questId, "preQuestGroup")
    for _, p in ipairs((okG and type(group) == "table") and group or {}) do if not done[p] then add(p) end end
    local okS, single = pcall(q, questId, "preQuestSingle")
    if okS and type(single) == "table" and #single > 0 then
        local any = false
        for _, p in ipairs(single) do if done[p] then any = true end end
        if not any then for _, p in ipairs(single) do add(p, true) end end
    end
    return out
end

--- Misiones anteriores de la cadena, TAMBIEN las ya hechas (para ver la cadena entera en el menu):
--- { { id, single }, ... }. preQuestGroup: todas. preQuestSingle: la que ya hiciste o, si ninguna, todas las
--- alternativas (single = true: basta con una).
function Planner:ChainPrereqs(questId)
    local B = QR.Bridge
    local done = Questie.db.char.complete
    local q = B.QuestieDB.QueryQuestSingle
    local out = {}
    local okG, group = pcall(q, questId, "preQuestGroup")
    for _, p in ipairs((okG and type(group) == "table") and group or {}) do out[#out + 1] = { id = p } end
    local okS, single = pcall(q, questId, "preQuestSingle")
    if okS and type(single) == "table" and #single > 0 then
        local chosen
        for _, p in ipairs(single) do if done[p] then chosen = p break end end
        if chosen then
            out[#out + 1] = { id = chosen }
        else
            for _, p in ipairs(single) do out[#out + 1] = { id = p, single = true } end
        end
    end
    return out
end

--- Misiones que el NPC no ofrecio al hablar con el (se olvidan al entregar una mision o subir de nivel)
function Planner:NotOffered(questId)
    return QR.charDB.notOffered and QR.charDB.notOffered[questId] or false
end

--- Resumen del estado de cada mision de la guia, para la lista de la ventana.
function Planner:GetQuestRows()
    local guide = self:GetGuide()
    if not guide then return {} end
    local rows = {}
    local notes = self.plan and self.plan.tasks and self.plan.tasks.notes or {}
    for _, row in ipairs(guide.quests) do
        local questId = row[1]
        local quest = QR.Bridge:GetQuest(questId)
        local status = QR.Bridge:QuestStatus(questId)
        if status == "active" and quest and QR.Bridge:IsQuestComplete(quest) then status = "complete" end
        local note = notes[questId]
        if status == "available" and self:NotOffered(questId) then
            status = "locked"
            note = L["The NPC doesn't offer it yet (earlier quest of the chain missing)"]
        end
        -- cadena: que mision anterior falta y, si es de otra zona, de cual
        local chain, chainZone
        if status == "locked" or status == "lowlevel" then
            local missing = self:MissingPrereqs(questId, guide)
            if #missing > 0 then
                local parts = {}
                for _, m in ipairs(missing) do
                    parts[#parts + 1] = m.name .. ((not m.inGuide and m.zone) and (" (" .. m.zone .. ")") or "")
                    if not m.inGuide and not chainZone then chainZone = m.zone or "?" end
                end
                chain = table.concat(parts, ", ")
            end
        end
        table.insert(rows, {
            questId = questId,
            name = quest and quest.name or ("#" .. questId),
            level = row[2],
            reqLevel = row[3],
            status = status,
            note = note,
            chain = chain,
            chainZone = chainZone,
            elite = QR.Bridge:IsEliteQuest(questId),
            dungeon = QR.Bridge:IsDungeonQuest(questId),
        })
    end
    return rows
end

-- Al hablar con un NPC: que misiones ofrece de verdad. Las de la guia que deberian estar disponibles con el
-- (segun Questie) y no salen, se apartan hasta entregar alguna mision o subir de nivel.
do
    local listShownAt = 0
    local function NpcId()
        local guid = UnitGUID and UnitGUID("npc")
        if not guid then return nil end
        local kind, _, _, _, _, id = strsplit("-", guid)
        return tonumber(id), kind
    end
    local function Check(offeredIds, offeredTitles)
        local guide = Planner:GetGuide()
        local npcId, kind = NpcId()
        if not guide or not npcId then return end
        local B = QR.Bridge
        local changed = false
        for _, row in ipairs(guide.quests) do
            local qid = row[1]
            if B:QuestStatus(qid) == "available" then
                local quest = B:GetQuest(qid)
                local starts = quest and quest.Starts or {}
                local fromHere = false
                for _, n in pairs((kind == "GameObject" and starts.GameObject or starts.NPC) or {}) do
                    if n == npcId then fromHere = true end
                end
                if fromHere and not offeredIds[qid] and not (quest.name and offeredTitles[quest.name]) then
                    QR.charDB.notOffered = QR.charDB.notOffered or {}
                    if not QR.charDB.notOffered[qid] then QR.charDB.notOffered[qid] = true; changed = true end
                end
            end
        end
        if changed and QR.Target then QR.Target:Refresh(true) end
    end
    local f = CreateFrame("Frame")
    for _, e in ipairs({ "GOSSIP_SHOW", "QUEST_GREETING", "QUEST_DETAIL", "QUEST_TURNED_IN", "PLAYER_LEVEL_UP" }) do
        pcall(f.RegisterEvent, f, e)
    end
    f:SetScript("OnEvent", function(_, event)
        if event == "QUEST_TURNED_IN" or event == "PLAYER_LEVEL_UP" then
            -- algo de la cadena pudo desbloquearse: se vuelve a intentar
            if QR.charDB and QR.charDB.notOffered and next(QR.charDB.notOffered) then
                QR.charDB.notOffered = nil
                if QR.Target then QR.Target:Refresh(true) end
            end
            return
        end
        local ids, titles = {}, {}
        if event == "GOSSIP_SHOW" then
            listShownAt = GetTime()
            if C_GossipInfo and C_GossipInfo.GetAvailableQuests then
                for _, info in ipairs(C_GossipInfo.GetAvailableQuests() or {}) do
                    if info.questID then ids[info.questID] = true end
                    if info.title then titles[info.title] = true end
                end
            elseif GetGossipAvailableQuests then
                for _, v in ipairs({ GetGossipAvailableQuests() }) do
                    if type(v) == "string" then titles[v] = true end
                end
            end
        elseif event == "QUEST_GREETING" then
            listShownAt = GetTime()
            for i = 1, (GetNumAvailableQuests and GetNumAvailableQuests() or 0) do
                local t = GetAvailableTitle(i)
                if t then titles[t] = true end
            end
        elseif event == "QUEST_DETAIL" then
            -- solo cuenta si el NPC abrio la mision directamente (sin lista antes): entonces es la unica que da
            if GetTime() - listShownAt < 3 then return end
            local id = GetQuestID and GetQuestID()
            if id then ids[id] = true end
            local t = GetTitleText and GetTitleText()
            if t then titles[t] = true end
        end
        Check(ids, titles)
    end)
end

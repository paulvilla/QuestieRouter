-- QuestieRouter: pasos de la guia (lo que se ve en la ventana: hechos, actual y proximos).
--
-- 1. Agrupa las tareas del planificador en pasos:
--      Coger    todas las misiones de un mismo NPC en un paso
--      Hacer    todos los objetivos de una mision en un paso, con sus contadores
--      Entregar todas las entregas a un mismo NPC en un paso
-- 2. Simula el futuro con las mismas reglas del planificador (hub -> campo -> entregar -> siguiente hub)
--    moviendo un "jugador virtual" de paso en paso. Al coger una mision en la simulacion se añaden
--    sus pasos futuros (hacer, con posicion estimada desde la base de datos, y entregar).
-- 3. Guarda el historial de lo hecho (aceptar, completar objetivos, entregar) por guia.

local _, QR = ...

local Steps = {}
QR.Steps = Steps

local MAX_UPCOMING = 14
local MERGE_YARDS = 40
local FAR = 1e7
local HISTORY_MAX = 60

---------------------------------------------------------------------------
-- Utilidades
---------------------------------------------------------------------------
local function Dist(ax, ay, ainst, p)
    if not p or not ax or p.instance ~= ainst then return FAR end
    return QR.HBD:GetWorldDistance(ainst, ax, ay, p.wx, p.wy) or FAR
end

local function SamePlace(a, b)
    return a and b and a.instance == b.instance and Dist(a.wx, a.wy, a.instance, b) <= MERGE_YARDS
end

local function ObjectiveDone(o)
    return o.Completed == true or (o.Needed and o.Collected and o.Needed == o.Collected)
end

local function C(kind) return QR.Skin.TEXT[kind] or "|cffffffff" end

local OBJ_ICON = { monster = "combat", killcredit = "combat", item = "collect", object = "gossip", event = "marker" }

--- Pinta en color los nombres de mobs / objetos que aparecen en el texto de la mision.
local function Colorize(text, quest)
    if not text or text == "" then return text end
    for _, o in pairs(quest.Objectives or {}) do
        for _, sd in pairs(o.spawnList or {}) do
            local name = sd.Name
            if name and #name > 2 then
                local color = (o.Type == "item") and C("loot") or C("enemy")
                local s, e = text:find(name, 1, true)
                if s then text = text:sub(1, s - 1) .. color .. name .. "|r" .. text:sub(e + 1) end
            end
        end
    end
    return text
end

---------------------------------------------------------------------------
-- Pasos vivos a partir de las tareas
---------------------------------------------------------------------------
local function NewStep(kind, point)
    return { kind = kind, point = point, questIds = {}, lines = {}, order = 1e9 }
end

local function ObjectiveLines(quest)
    local lines, remaining, total = {}, 0, 0
    for _, o in pairs(quest.Objectives or {}) do
        local done = ObjectiveDone(o)
        local needed = o.Needed or 1
        local have = o.Collected or (done and needed or 0)
        total = total + needed
        remaining = remaining + math.max(0, needed - have)
        local desc = o.Description or "?"
        local text
        if needed > 1 or (o.Type == "item" or o.Type == "monster") then
            text = string.format("%s: %d/%d", desc, have, needed)
        else
            text = desc
        end
        table.insert(lines, { icon = done and "complete" or (OBJ_ICON[o.Type] or "marker"), text = text, done = done })
    end
    return lines, remaining, total
end

function Steps:FromTasks(tasks)
    local B = QR.Bridge
    local steps = {}

    -- Coger: agrupado por NPC
    for _, t in ipairs(tasks.pickup) do
        local s
        for _, other in ipairs(steps) do
            if other.kind == "pickup" and other.npc == t.label and SamePlace(other.point, t) then s = other break end
        end
        if not s then
            s = NewStep("pickup", t)
            s.npc = t.label
            s.npcId = t.npcId
            table.insert(steps, s)
        end
        table.insert(s.questIds, t.questId)
        s.order = math.min(s.order, t.order or 1e9)
        table.insert(s.lines, { icon = t.icon or "accept", text = t.questName or ("#" .. t.questId) })
    end

    -- Hacer: un paso por mision; posicion = objetivo pendiente mas cercano
    local byQuest = {}
    for _, t in ipairs(tasks.objective) do
        local s = byQuest[t.questId]
        if not s then
            s = NewStep("objective", t)
            s.questIds[1] = t.questId
            byQuest[t.questId] = s
            table.insert(steps, s)
            local quest = B:GetQuest(t.questId)
            s.questName = t.questName
            s.lines, s.remaining, s.total = ObjectiveLines(quest)
            local d = quest.Description
            s.description = Colorize(type(d) == "table" and d[1] or d, quest)
        elseif t.dist < s.point.dist then
            s.point = t
        end
    end

    -- Entregar: agrupado por NPC
    for _, t in ipairs(tasks.turnin) do
        local s
        for _, other in ipairs(steps) do
            if other.kind == "turnin" and other.npc == t.label and SamePlace(other.point, t) then s = other break end
        end
        if not s then
            s = NewStep("turnin", t)
            s.npc = t.label
            s.npcId = t.npcId
            table.insert(steps, s)
        end
        table.insert(s.questIds, t.questId)
        table.insert(s.lines, { icon = t.icon or "turnin", text = t.questName or ("#" .. t.questId) })
    end
    return steps
end

---------------------------------------------------------------------------
-- Pasos futuros (simulacion)
---------------------------------------------------------------------------
local estimateCache = {}

--- Punto estimado de los objetivos de una mision aun no aceptada (desde la base de datos).
local function EstimateObjectivePoint(quest, from)
    if estimateCache[quest.Id] ~= nil then return estimateCache[quest.Id] or nil end
    local B, DB = QR.Bridge, QR.Bridge.QuestieDB
    local best
    local function consider(spawns, name)
        local p = spawns and B:NearestSpawn(spawns, from.wx, from.wy, from.instance)
        if p and (not best or p.dist < best.dist) then p.name = name; best = p end
    end
    for _, od in pairs(quest.ObjectiveData or {}) do
        if od.Type == "monster" or od.Type == "killcredit" then
            local npc = DB:GetNPC(od.Id)
            if npc then consider(npc.spawns, npc.name) end
        elseif od.Type == "object" then
            local obj = DB:GetObject(od.Id)
            if obj then consider(obj.spawns, obj.name) end
        elseif od.Type == "item" then
            local ok, drops = pcall(DB.QueryItemSingle, od.Id, "npcDrops")
            for _, npcId in pairs(ok and drops or {}) do
                local npc = DB:GetNPC(npcId)
                if npc then consider(npc.spawns, npc.name) end
            end
        end
    end
    estimateCache[quest.Id] = best or false
    return best
end

local function FutureObjective(quest, from)
    local p = EstimateObjectivePoint(quest, from) or from
    local s = NewStep("objective", p)
    s.future = true
    s.questIds[1] = quest.Id
    s.questName = quest.name
    local d = quest.Description
    s.description = type(d) == "table" and d[1] or d
    for _, od in pairs(quest.ObjectiveData or {}) do
        if od.Text then table.insert(s.lines, { icon = OBJ_ICON[od.Type] or "marker", text = od.Text }) end
    end
    return s
end

local function FutureTurnin(quest, pool, from)
    local B = QR.Bridge
    local p = B:NearestNpcOrObject(quest.Finisher, from.wx, from.wy, from.instance)
    if not p then return nil end
    for _, s in ipairs(pool) do
        if s.kind == "turnin" and s.npc == p.name and SamePlace(s.point, p) then
            table.insert(s.questIds, quest.Id)
            table.insert(s.lines, { icon = "turnin", text = quest.name })
            return nil
        end
    end
    local s = NewStep("turnin", p)
    s.future = true
    s.npc = p.name
    s.npcId = p.npcId
    s.questIds[1] = quest.Id
    s.lines[1] = { icon = "turnin", text = quest.name }
    return s
end

--- first (opcional): paso elegido por el jugador; va primero y el resto se ordena desde ahi
function Steps:Simulate(liveSteps, first)
    local B = QR.Bridge
    local px, py, pinst = QR.HBD:GetPlayerWorldPosition()
    local pool = {}
    for _, s in ipairs(liveSteps) do pool[#pool + 1] = s end
    local out = {}
    local vx, vy, vinst = px, py, pinst

    for _ = 1, MAX_UPCOMING do
        local lists = { pickup = {}, objective = {}, turnin = {} }
        for _, s in ipairs(pool) do
            s.dist = Dist(vx, vy, vinst, s.point)
            table.insert(lists[s.kind], s)
        end
        local chosen, reason
        if first and #out == 0 then
            chosen, reason = first, "elegido"
        else
            chosen, reason = QR.Planner:Choose(lists)
        end
        if not chosen then break end
        for i, s in ipairs(pool) do if s == chosen then table.remove(pool, i) break end end
        chosen.reason = chosen.reason or reason
        table.insert(out, chosen)
        vx, vy, vinst = chosen.point.wx, chosen.point.wy, chosen.point.instance

        if chosen.kind == "pickup" then
            for _, qid in ipairs(chosen.questIds) do
                local quest = B:GetQuest(qid)
                if quest then
                    if next(quest.ObjectiveData or {}) then
                        pool[#pool + 1] = FutureObjective(quest, chosen.point)
                    else
                        local t = FutureTurnin(quest, pool, chosen.point)
                        if t then pool[#pool + 1] = t end
                    end
                end
            end
        elseif chosen.kind == "objective" then
            local quest = B:GetQuest(chosen.questIds[1])
            if quest then
                local t = FutureTurnin(quest, pool, chosen.point)
                if t then pool[#pool + 1] = t end
            end
        end
    end
    return out
end

---------------------------------------------------------------------------
-- Historial
---------------------------------------------------------------------------
local function History(create)
    local guide = QR.Planner:GetGuide()
    if not guide then return nil end
    QR.charDB.history = QR.charDB.history or {}
    local h = QR.charDB.history[guide.key]
    if not h and create then
        h = { count = 0, entries = {} }
        QR.charDB.history[guide.key] = h
    end
    return h
end
Steps.History = History

function Steps:Record(kind, questId, text)
    local h = History(true)
    if not h then return end
    local last = h.entries[#h.entries]
    -- mismas acciones seguidas en menos de 90 s se juntan en una tarjeta (como un paso de coger varias)
    if last and last.kind == kind and (time() - last.time) < 90 and kind ~= "objective" then
        table.insert(last.lines, text)
        last.time = time()
    else
        h.count = h.count + 1
        table.insert(h.entries, { kind = kind, questId = questId, lines = { text }, time = time(), number = h.count })
        while #h.entries > HISTORY_MAX do table.remove(h.entries, 1) end
    end
    QR:Fire("HISTORY_CHANGED")
end

local function QuestName(questId)
    local q = QR.Bridge:GetQuest(questId)
    return q and q.name or ("#" .. tostring(questId))
end

function Steps:Init()
    local f = CreateFrame("Frame")
    f:RegisterEvent("QUEST_ACCEPTED")
    f:RegisterEvent("QUEST_TURNED_IN")
    f:SetScript("OnEvent", function(_, event, a1, a2)
        if not QR.Planner:IsActive() then return end
        if event == "QUEST_ACCEPTED" then
            -- Classic: (indiceLog, questId); clientes modernos: (questId)
            local questId = (type(a2) == "number" and a2 > 0) and a2 or a1
            Steps:Record("pickup", questId, QuestName(questId))
        else
            Steps:Record("turnin", a1, QuestName(a1))
        end
    end)
end

--- Llamado por el planificador: detecta misiones que acaban de completarse para el historial.
function Steps:CheckCompletions(guide)
    QR.charDB.completedSeen = QR.charDB.completedSeen or {}
    local seen = QR.charDB.completedSeen
    for questId in QR.Bridge:IterateActive() do
        local quest = QR.Bridge:GetQuest(questId)
        if quest and guide.info[questId] and QR.Bridge:IsQuestComplete(quest) then
            if not seen[questId] and next(quest.Objectives or {}) then
                seen[questId] = true
                Steps:Record("objective", questId, quest.name)
            end
        end
    end
end

QR:RegisterModule("Steps", function() Steps:Init() end)

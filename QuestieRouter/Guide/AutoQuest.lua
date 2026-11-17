-- QuestieRouter: coger y entregar misiones automaticamente al hablar con un NPC (dos activables: menu / Ajustes).
--   Coger:    solo las misiones de la guia activa que el planificador propondria (disponibles, de tu nivel, no
--             "para mas tarde", no saltadas). Nada de misiones de mucho mas nivel ni de fuera de la guia.
--   Entregar: las misiones completas del registro. Si la recompensa hay que elegirla, se deja al jugador.
-- Con Mayus pulsada al hablar no se hace nada automatico.

local _, QR = ...
local L = QR.L

local Auto = {}
QR.AutoQuest = Auto

local function Paused() return IsShiftKeyDown and IsShiftKeyDown() end

--- ¿Es una mision de la guia que toca coger ahora?
function Auto:Wanted(questId)
    local P, B = QR.Planner, QR.Bridge
    local guide = P and P:GetGuide()
    if not (guide and questId) then return false end
    local info = guide.info[questId]
    if not info or info.later then return false end
    if QR.charDB.skipped and QR.charDB.skipped[questId] then return false end
    return B:QuestStatus(questId) == "available"
end

--- Misiones de la guia que tocan, por nombre (las listas de los NPC antiguos solo dan el titulo)
local function WantedByTitle()
    local P, B = QR.Planner, QR.Bridge
    local guide = P and P:GetGuide()
    local out = {}
    for _, row in ipairs(guide and guide.quests or {}) do
        if Auto:Wanted(row[1]) then
            local q = B:GetQuest(row[1])
            if q and q.name then out[q.name] = row[1] end
        end
    end
    return out
end

--- Misiones completas del registro, por nombre y por ID
local function CompleteInLog()
    local B = QR.Bridge
    local byName, byId = {}, {}
    for qid in B:IterateActive() do
        local q = B:GetQuest(qid)
        if q and B:IsQuestComplete(q) then
            byId[qid] = true
            if q.name then byName[q.name] = true end
        end
    end
    return byName, byId
end

local function OnGossip()
    local db = QR.db
    if Paused() then return end
    -- 1) entregar (primero: puede desbloquear la siguiente de la cadena)
    if db.autoTurnIn then
        local byName, byId = CompleteInLog()
        if C_GossipInfo and C_GossipInfo.GetActiveQuests then
            for _, info in ipairs(C_GossipInfo.GetActiveQuests() or {}) do
                if info.isComplete or byId[info.questID] or byName[info.title] then
                    C_GossipInfo.SelectActiveQuest(info.questID)
                    return
                end
            end
        elseif GetGossipActiveQuests and SelectGossipActiveQuest then
            local list = { GetGossipActiveQuests() }
            local stride = (GetNumGossipActiveQuests and GetNumGossipActiveQuests() > 0) and (#list / GetNumGossipActiveQuests()) or 6
            for i = 1, #list / stride do
                local title, complete = list[(i - 1) * stride + 1], list[(i - 1) * stride + 4]
                if complete or byName[title] then SelectGossipActiveQuest(i) return end
            end
        end
    end
    -- 2) coger las de la guia
    if db.autoAccept then
        local titles = WantedByTitle()
        if C_GossipInfo and C_GossipInfo.GetAvailableQuests then
            for _, info in ipairs(C_GossipInfo.GetAvailableQuests() or {}) do
                if Auto:Wanted(info.questID) or titles[info.title] then
                    C_GossipInfo.SelectAvailableQuest(info.questID)
                    return
                end
            end
        elseif GetGossipAvailableQuests and SelectGossipAvailableQuest then
            local list = { GetGossipAvailableQuests() }
            local stride = (GetNumGossipAvailableQuests and GetNumGossipAvailableQuests() > 0) and (#list / GetNumGossipAvailableQuests()) or 7
            for i = 1, #list / stride do
                if titles[list[(i - 1) * stride + 1]] then SelectGossipAvailableQuest(i) return end
            end
        end
    end
end

local function OnGreeting()
    local db = QR.db
    if Paused() then return end
    if db.autoTurnIn and GetNumActiveQuests then
        local byName = CompleteInLog()
        for i = 1, GetNumActiveQuests() do
            if byName[GetActiveTitle(i)] then SelectActiveQuest(i) return end
        end
    end
    if db.autoAccept and GetNumAvailableQuests then
        local titles = WantedByTitle()
        for i = 1, GetNumAvailableQuests() do
            if titles[GetAvailableTitle(i)] then SelectAvailableQuest(i) return end
        end
    end
end

local f = CreateFrame("Frame")
for _, e in ipairs({ "GOSSIP_SHOW", "QUEST_GREETING", "QUEST_DETAIL", "QUEST_PROGRESS", "QUEST_COMPLETE" }) do
    pcall(f.RegisterEvent, f, e)
end
f:SetScript("OnEvent", function(_, event)
    if not QR.db or not QR.ready then return end
    if event == "GOSSIP_SHOW" then
        OnGossip()
    elseif event == "QUEST_GREETING" then
        OnGreeting()
    elseif event == "QUEST_DETAIL" then
        if QR.db.autoAccept and not Paused() then
            local id = GetQuestID and GetQuestID()
            local title = GetTitleText and GetTitleText()
            if Auto:Wanted(id) or (title and WantedByTitle()[title]) then AcceptQuest() end
        end
    elseif event == "QUEST_PROGRESS" then
        if QR.db.autoTurnIn and not Paused() and IsQuestCompletable and IsQuestCompletable() then CompleteQuest() end
    elseif event == "QUEST_COMPLETE" then
        if QR.db.autoTurnIn and not Paused() then
            local n = GetNumQuestChoices and GetNumQuestChoices() or 0
            if n <= 1 then
                GetQuestReward(n == 1 and 1 or nil)
            else
                QR:Print(L["Choose your reward to turn in the quest."])
            end
        end
    end
end)

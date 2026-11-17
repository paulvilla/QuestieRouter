-- QuestieRouter: seleccion del destino.
-- Decide cada pocos segundos a que punto hay que ir y avisa con el mensaje "TARGET_CHANGED".
-- La flecha y las lineas solo leen QR.target; no calculan nada de Questie.

local _, QR = ...
local L = QR.L

local Target = {}
QR.Target = Target

QR.target = nil

--- Misma posicion: por coordenadas de zona si las hay; si no (destinos de viaje: maestro de vuelo,
--- muelle; o el cadaver), por coordenadas de mundo. Antes se restaba x/y sin comprobar y fallaba
--- con los destinos de viaje, que solo tienen coordenadas de mundo.
local function SamePlace(a, b)
    if a.x and b.x and a.y and b.y then
        return a.uiMapId == b.uiMapId and math.abs(a.x - b.x) < 0.0005 and math.abs(a.y - b.y) < 0.0005
    end
    if a.wx and b.wx and a.wy and b.wy then
        return a.instance == b.instance and math.abs(a.wx - b.wx) < 1 and math.abs(a.wy - b.wy) < 1
    end
    return false
end

local function SameTarget(a, b)
    if a == b then return true end
    if not a or not b then return false end
    return a.questId == b.questId and a.kind == b.kind and a.isTurnIn == b.isTurnIn
        and a.travelKind == b.travelKind and SamePlace(a, b)
        -- viajes: misma ruta (p. ej. al activar / desactivar los vuelos puede empezar igual y cambiar despues)
        and (a.route and a.route.key) == (b.route and b.route.key)
end

local function DistanceTo(t)
    if not t then return nil end
    local px, py, pinst = QR.HBD:GetPlayerWorldPosition()
    if not px or pinst ~= t.instance then return nil end
    local _, dist = QR.HBD:GetWorldVector(pinst, px, py, t.wx, t.wy)
    return dist
end
Target.DistanceTo = DistanceTo

function Target:Set(newTarget)
    if SameTarget(QR.target, newTarget) then return end
    QR.target = newTarget
    QR:Fire("TARGET_CHANGED", newTarget)
end

--- Fantasma: destino = tu cadaver (prioridad sobre todo lo demas). Busca en el mapa de la zona
--- y, si no esta ahi, en los mapas padre (continente).
function Target:CorpseTarget()
    if not (UnitIsGhost and UnitIsGhost("player")) then return nil end
    if not (C_DeathInfo and C_DeathInfo.GetCorpseMapPosition) then return nil end
    local map = QR.HBD.GetPlayerZone and QR.HBD:GetPlayerZone()
        or (C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player"))
    for _ = 1, 4 do
        if not map then break end
        local ok, pos = pcall(C_DeathInfo.GetCorpseMapPosition, map)
        if ok and pos and pos.x then
            local x, y = pos.x, pos.y
            local wx, wy, inst = QR.HBD:GetWorldCoordinatesFromZone(x, y, map)
            if wx then
                return { kind = "corpse", questName = L["Your corpse"], name = L["Go back to your corpse"],
                         uiMapId = map, x = x, y = y, wx = wx, wy = wy, instance = inst }
            end
        end
        local info = C_Map.GetMapInfo and C_Map.GetMapInfo(map)
        local parent = info and info.parentMapID
        if not parent or parent == map then break end
        map = parent
    end
    return nil
end

function Target:Refresh(force)
    -- sin las librerias de mapa de Questie no se puede calcular nada (se reintenta solo: Bridge:FindMapLibs)
    if not QR.HBD then return end
    if not QR.db.enabled then
        self:Set(nil)
        return
    end
    local corpse = self:CorpseTarget()
    if corpse then
        self:Set(corpse)
        return
    end
    local candidate
    local m = self.manual
    if m then
        -- destino elegido a mano (/qr dungeon): se quita solo al llegar
        local px, py, pinst = QR.HBD:GetPlayerWorldPosition()
        if px and pinst == m.instance and QR.HBD:GetWorldDistance(pinst, px, py, m.wx, m.wy) < 40 then
            QR:Print(string.format(QR.L["You have arrived: %s."], m.questName))
            self.manual = nil
            m = nil
        end
    end
    if m then
        candidate = {}
        for k, v in pairs(m) do candidate[k] = v end
    elseif QR.Planner and QR.Planner:IsActive() then
        -- Modo guia de zona: el planificador decide (coger / hacer / entregar).
        candidate = QR.Planner:GetTarget()
    else
        -- Modo foco: la mision enfocada en el tracker de Questie.
        local quest = QR.Bridge:GetQuest(QR.Bridge:GetActiveQuestId())
        candidate = QR.Bridge:ComputeTarget(quest)
    end

    -- viajes: si compensa, primero al maestro de vuelo o al muelle
    if candidate and QR.Router then candidate = QR.Router:Wrap(candidate) end

    local current = QR.target
    -- Histeresis: si seguimos con la misma mision y fase, solo saltar a otro spawn si es claramente mas cercano.
    -- (no se aplica a los viajes: una ruta nueva siempre sustituye a la anterior)
    if not force and candidate and current and current.kind ~= "travel" and candidate.kind ~= "travel"
        and current.questId == candidate.questId
        and current.kind == candidate.kind and current.isTurnIn == candidate.isTurnIn
        and not SameTarget(current, candidate) then
        local dCur, dNew = DistanceTo(current), DistanceTo(candidate)
        if dCur and dNew and dNew > dCur * (1 - QR.db.retargetHysteresis) then
            return
        end
    end
    self:Set(candidate)
end

--- Destino elegido a mano (p. ej. la entrada de una mazmorra). nil lo quita.
function Target:SetManual(dest)
    self.manual = dest
    self:Refresh(true)
end

function Target:Init()
    local f = CreateFrame("Frame")
    -- Cambios que pueden mover el destino: foco, progreso de objetivos, zona.
    f:RegisterEvent("QUEST_LOG_UPDATE")
    f:RegisterEvent("QUEST_WATCH_UPDATE")
    f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    pcall(f.RegisterEvent, f, "SUPER_TRACKING_CHANGED")
    -- morir / liberar espiritu / revivir: cambiar el destino al momento
    for _, e in ipairs({ "PLAYER_DEAD", "PLAYER_ALIVE", "PLAYER_UNGHOST" }) do pcall(f.RegisterEvent, f, e) end

    local pending = false
    f:SetScript("OnEvent", function()
        -- Agrupar rafagas de QUEST_LOG_UPDATE y dejar que Questie procese primero.
        if pending then return end
        pending = true
        C_Timer.After(0.3, function()
            pending = false
            Target:Refresh(true)
        end)
    end)

    -- El foco de Questie es una variable, no un evento: comprobarla periodicamente es barato.
    local lastQuestId
    C_Timer.NewTicker(QR.db.retargetInterval, function()
        local q = QR.Bridge:GetActiveQuestId()
        Target:Refresh(q ~= lastQuestId)
        lastQuestId = q
    end)

    -- cualquier cambio de ajustes (vuelos, barcos, rutas de viaje...) recalcula la ruta; agrupado, por si se
    -- mueve un deslizador de Opciones
    local settingsPending = false
    QR:On("SETTINGS_CHANGED", function()
        if settingsPending then return end
        settingsPending = true
        C_Timer.After(0.3, function()
            settingsPending = false
            Target:Refresh(true)
        end)
    end)

    Target:Refresh(true)
end

QR:RegisterModule("Target", function() Target:Init() end)

-- QuestieRouter: puntos añadidos a mano en el mapa del mundo. Dos maneras:
--   * Mayus + clic izquierdo (punto "solo"): la flecha y las lineas llevan solo al punto; la ruta de la guia se oculta
--     hasta llegar.
--   * Alt + clic izquierdo (punto "de paso", p.via = true): la flecha lleva al punto y en el mapa sigue la ruta de la
--     guia, que se calcula como si ya estuvieras en el ultimo punto (ver Waypoints:PlanOrigin).
-- Solo hay uno de cada tipo: uno nuevo sustituye al anterior del mismo tipo. Mayus / Alt + clic encima de un punto
-- (con algo de margen) lo quita. El ultimo que se añade va primero. Al llegar (a menos de ARRIVE yardas) desaparece y se sigue con lo de antes. En la ventana de la guia salen delante de los pasos
-- como "Punto añadido a mano" (clic derecho: quitarlo). Se guardan por personaje (QR.charDB.waypoints).

local _, QR = ...
local L = QR.L

local Waypoints = {}
QR.Waypoints = Waypoints

local ARRIVE = 10          -- yardas
local CHECK = 0.5          -- segundos entre comprobaciones de llegada

local function List()
    QR.charDB.waypoints = QR.charDB.waypoints or {}
    return QR.charDB.waypoints
end

function Waypoints:All() return QR.charDB and List() or {} end
function Waypoints:First() return QR.charDB and List()[1] or nil end

--- Destino para la flecha / el router a partir de un punto
function Waypoints:Target(p)
    if not p then return nil end
    local info = p.map and C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(p.map)
    return {
        kind = "manualpoint", manualPoint = p,
        questName = L["Manual waypoint"],
        name = string.format("%s (%.1f, %.1f)", info and info.name or "?", (p.x or 0) * 100, (p.y or 0) * 100),
        wx = p.wx, wy = p.wy, instance = p.inst, uiMapId = p.map, x = p.x, y = p.y,
    }
end

local function Changed()
    if QR.Target then QR.Target:Refresh(true) end
    QR:Fire("WAYPOINTS_CHANGED")
end

--- ¿Todos los puntos son "de paso" (Alt + clic)? Entonces la guia sigue calculandose y viendose desde ellos.
--- Con un punto "solo" (Mayus + clic) en la lista, lo de siempre: solo los puntos.
function Waypoints:ViaMode()
    local list = self:All()
    if #list == 0 then return false end
    for _, p in ipairs(list) do
        if not p.via then return false end
    end
    return true
end

--- Desde donde se calcula la ruta de la guia: el ultimo punto de paso (el que se visita justo antes de seguir con la
--- guia) o, si no, tu posicion. -> wx, wy, instancia (como HBD:GetPlayerWorldPosition)
function Waypoints:PlanOrigin()
    if QR.charDB and self:ViaMode() then
        local list = List()
        local p = list[#list]
        if p and p.wx then return p.wx, p.wy, p.inst end
    end
    return QR.HBD:GetPlayerWorldPosition()
end

--- Añade un punto (mapa uiMapID y x, y en 0..1); va el primero. via: punto de paso (la guia sigue desde el)
function Waypoints:Add(map, x, y, via)
    local wx, wy, inst = QR.HBD:GetWorldCoordinatesFromZone(x, y, map)
    if not wx then
        QR:Print(L["That spot can't be used as a waypoint (no world position)."])
        return
    end
    local list = List()
    -- el punto nuevo sustituye al que pusiste antes del mismo tipo (Mayus + clic o Alt + clic): no se acumulan
    for i = #list, 1, -1 do
        if (list[i].via and true or false) == (via and true or false) then table.remove(list, i) end
    end
    table.insert(list, 1, { map = map, x = x, y = y, wx = wx, wy = wy, inst = inst, via = via or nil,
                              t = (GetServerTime and GetServerTime()) or time() })
    local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
    local msg = via and L["Waypoint added: %s (%.1f, %.1f). The guide route continues from it."]
        or L["Waypoint added: %s (%.1f, %.1f). It goes first."]
    QR:Print(string.format(msg, info and info.name or "?", x * 100, y * 100))
    Changed()
end

function Waypoints:Remove(p)
    local list = List()
    for i, q in ipairs(list) do
        if q == p then table.remove(list, i) break end
    end
    Changed()
end

function Waypoints:Clear()
    if QR.charDB then QR.charDB.waypoints = nil end
    Changed()
end

--- ¿Has llegado al primero? Se quita y se sigue con lo siguiente
function Waypoints:CheckArrival()
    local p = self:First()
    if not p then return end
    local px, py, pinst = QR.HBD:GetPlayerWorldPosition()
    if not px or pinst ~= p.inst then return end
    local d = QR.HBD:GetWorldDistance(pinst, px, py, p.wx, p.wy)
    if d and d <= ARRIVE then
        table.remove(List(), 1)
        QR:Print(L["You reached the manual waypoint."])
        Changed()
    end
end

---------------------------------------------------------------------------
-- Mayus / Alt + clic izquierdo en el mapa del mundo
---------------------------------------------------------------------------
-- Como Polestar (Nav/Journey.lua), que funciona en este cliente:
--   * el clic se lee con el evento global GLOBAL_MOUSE_DOWN: llega aunque se haga sobre un icono del mapa (los iconos
--     de Questie se tragan el clic y el sistema de clics del mapa no se entera)
--   * el mapa del mundo es un addon de Blizzard que puede cargarse mas tarde (Blizzard_WorldMap): se engancha cuando
--     exista. Antes se intentaba solo al iniciar el addon y, si el mapa aun no estaba, no se volvia a intentar.
--   * el sistema de clics del mapa (AddCanvasClickHandler) solo se usa para tragarse el Mayus / Alt + clic en el mapa
--     vacio, y que no haga zoom en la zona; el punto lo pone el evento global
--- -> "via" (solo Alt), "solo" (solo Mayus) o nil
local function ClickMode()
    if IsControlKeyDown() then return nil end
    local alt, shift = IsAltKeyDown(), IsShiftKeyDown()
    if alt and not shift then return "via" end
    if shift and not alt then return "solo" end
    return nil
end

local function CursorOnMap()
    local wm = WorldMapFrame
    if not (wm and wm:IsShown() and wm.ScrollContainer and wm.ScrollContainer:IsMouseOver()) then return nil end
    local x, y
    if wm.GetNormalizedCursorPosition then x, y = wm:GetNormalizedCursorPosition()
    elseif wm.ScrollContainer.GetNormalizedCursorPosition then x, y = wm.ScrollContainer:GetNormalizedCursorPosition() end
    if issecretvalue and (issecretvalue(x) or issecretvalue(y)) then return nil end
    if type(x) ~= "number" or type(y) ~= "number" or x ~= x or y ~= y or x < 0 or x > 1 or y < 0 or y > 1 then return nil end
    return wm:GetMapID(), x, y
end

--- El punto añadido a mano que hay bajo el cursor (a menos de PICK px en pantalla), o nil. Se compara en el mapa que
--- se esta viendo, asi que vale aunque el punto se pusiera en otro mapa (la zona, el continente...).
local PICK = 14
local function PointAt(map, x, y)
    local wm = WorldMapFrame
    local canvas = wm and wm.GetCanvas and wm:GetCanvas()
    if not canvas then return nil end
    local s = canvas:GetEffectiveScale() / UIParent:GetEffectiveScale()
    local W, H = canvas:GetWidth() * s, canvas:GetHeight() * s
    local best, bestD
    for _, p in ipairs(Waypoints:All()) do
        local px, py
        if p.map == map then px, py = p.x, p.y
        elseif p.wx then px, py = QR:ZoneCoordsFromWorld(p.wx, p.wy, p.inst, map, true) end
        if px and py then
            local dx, dy = (px - x) * W, (py - y) * H
            local d = math.sqrt(dx * dx + dy * dy)
            if d <= PICK and (not bestD or d < bestD) then best, bestD = p, d end
        end
    end
    return best
end

local function OnGlobalMouseDown(_, _, button)
    if button ~= "LeftButton" then return end
    local mode = ClickMode()
    if not mode then return end
    local map, x, y = CursorOnMap()
    if not map then return end
    -- Mayus / Alt + clic encima de un punto que ya hay (de cualquier tipo): se quita
    local hit = PointAt(map, x, y)
    if hit then
        Waypoints:Remove(hit)
        QR:Print(L["Waypoint removed."])
        return
    end
    Waypoints:Add(map, x, y, mode == "via")
end

--- engancha el mapa del mundo (cuando exista): solo para tragarse el Mayus / Alt + clic (sin zoom en la zona)
function Waypoints:HookMap()
    local wm = WorldMapFrame
    if self.hooked or not (wm and wm.AddCanvasClickHandler) then return self.hooked end
    wm:AddCanvasClickHandler(function(_, button)
        return button == "LeftButton" and ClickMode() ~= nil
    end, 1000)
    self.hooked = true
    return true
end

--- /qr wp: estado (para comprobar el Mayus / Alt + clic) y los puntos que hay
function Waypoints:Status()
    QR:Print(string.format(L["Manual waypoints: %d · world map hooked: %s · Shift + left click on the world map adds one (only it), Alt + left click adds one on the way (the guide route continues from it)."],
        #self:All(), self.hooked and L["yes"] or L["no (open the world map once)"]))
    for i, p in ipairs(self:All()) do
        local info = p.map and C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(p.map)
        QR:Print(string.format("  %d. %s (%.1f, %.1f)%s", i, info and info.name or "?", (p.x or 0) * 100, (p.y or 0) * 100,
            p.via and (" · " .. L["on the way"]) or ""))
    end
end

function Waypoints:Init()
    local ev = CreateFrame("Frame")
    pcall(ev.RegisterEvent, ev, "GLOBAL_MOUSE_DOWN")
    ev:RegisterEvent("ADDON_LOADED")
    ev:SetScript("OnEvent", function(self, event, arg)
        if event == "GLOBAL_MOUSE_DOWN" then
            OnGlobalMouseDown(self, event, arg)
        elseif event == "ADDON_LOADED" and arg == "Blizzard_WorldMap" then
            Waypoints:HookMap()
        end
    end)
    self:HookMap()
    local acc = 0
    local f = CreateFrame("Frame")
    f:SetScript("OnUpdate", function(_, el)
        acc = acc + el
        if acc < CHECK then return end
        acc = 0
        if QR.charDB and QR.charDB.waypoints and QR.charDB.waypoints[1] then Waypoints:CheckArrival() end
    end)
end

QR:RegisterModule("Waypoints", function() Waypoints:Init() end)

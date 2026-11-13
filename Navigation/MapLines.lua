-- QuestieRouter: linea animada hacia el objetivo en el mapa del mundo y en el minimapa,
-- con el efecto de Zygor (textura mapline.tga repetida a lo largo de la linea y desplazandose
-- hacia el destino). Estilos: camino, burbujas, flechas y rayo.
--
-- Compatibilidad con OpenMap (mapa del mundo "cosido"):
--   * No usamos pines de HereBeDragons en el mapa del mundo: con OpenMap solo existen para el mapa
--     anfitrion y quedan por debajo de su arte. Dibujamos linea y marcador en una capa propia.
--   * Posiciones: con OpenMap cosido, OpenMapAPI.WorldFromMap (zona -> mundo cosido) y
--     OpenMapAPI.MapFromWorld (mundo cosido -> mapa anfitrion = coordenadas del lienzo). Sin OpenMap,
--     HereBeDragons:GetZoneCoordinatesFromWorld sobre el mapa que se esta viendo.
--   * Capa: por encima de OpenMapAPI.ArtTopLevel(). Los niveles de marco del mapa no se tocan en combate.
--   * El minimapa sigue con el pin flotante de HereBeDragons (OpenMap no cambia el minimapa).

local _, QR = ...

local MapLines = {}
QR.MapLines = MapLines

local REF = "QuestieRouter"
local MEDIA = QR.Skin.MEDIA
local LINE_TEXTURE = MEDIA .. "Lines\\mapline.tga"
local ICON_OBJECTIVE = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1"
local ICON_TURNIN = "Interface\\GossipFrame\\ActiveQuestIcon"
local ICON_PICKUP = "Interface\\GossipFrame\\AvailableQuestIcon"

-- los nombres son claves de traduccion (Options los muestra con L[...])
MapLines.STYLES = { { 1, "Path" }, { 2, "Bubbles" }, { 3, "Arrows" }, { 4, "Beam" } }

---------------------------------------------------------------------------
-- Linea con efecto Zygor
---------------------------------------------------------------------------
local function NewAnimatedLine(owner, layer)
    local line = owner:CreateLine(nil, layer or "OVERLAY")
    line:SetTexture(LINE_TEXTURE, "REPEAT", "CLAMP")
    if line.SetSnapToPixelGrid then line:SetSnapToPixelGrid(false); line:SetTexelSnappingBias(0) end
    line:Hide()
    return line
end

--- Ajusta grosor, color, estilo y la fase de la animacion.
--- length y thickness en LAS MISMAS unidades (las del marco donde esta la linea): asi el dibujo
--- conserva sus proporciones con cualquier zoom, como en Zygor.
local function PaintLine(line, length, thickness, alpha, styleOverride, color)
    local cfg = QR.db.lines
    local style = styleOverride or cfg.style or 1
    line:SetThickness(thickness)
    if color then
        line:SetVertexColor(color[1], color[2], color[3], alpha)
    elseif cfg.colorMode == "WHITE" then
        line:SetVertexColor(1, 1, 1, alpha)
    elseif cfg.colorMode == "CUSTOM" then
        local c = cfg.customColor or { 1, 0.82, 0.3 }
        line:SetVertexColor(c[1], c[2], c[3], alpha)
    else
        local r, g, b = QR.Skin:Color("accent")
        line:SetVertexColor(r * 0.8 + 0.2, g * 0.8 + 0.2, b * 0.8 + 0.2, alpha)
    end
    line:SetBlendMode(style == 4 and "ADD" or "BLEND")
    -- cada repeticion del dibujo ocupa 4 veces el grosor (cada franja de la textura mide 32x8)
    local tile = math.max(0.5, length / (thickness * 4) * (cfg.density or 1))
    -- desplazamiento continuo hacia el destino
    local phase = (GetTime() / math.max(0.2, cfg.speed or 1.4)) % 1
    local u1, u2 = -phase, tile - phase
    -- medio texel hacia dentro: al reducir la textura no se cuelan las franjas vecinas
    local v1, v2 = (style - 1) / 4 + 0.016, style / 4 - 0.016
    line:SetTexCoord(u1, v1, u1, v2, u2, v1, u2, v2)
end

---------------------------------------------------------------------------
-- Marcador del destino: circulo con el numero del paso (o el icono si no hay guia)
---------------------------------------------------------------------------
local function CurrentStepNumber()
    local plan = QR.Planner and QR.Planner:IsActive() and QR.Planner.plan
    if not plan or not plan.currentStep then return nil end
    local h = QR.Steps.History(false)
    return (h and h.count or 0) + 1
end

--- Crea el marcador dentro de 'parent': aro de color, disco oscuro, numero e icono de reserva
local function NewMarker(parent)
    local m = CreateFrame("Frame", nil, parent)
    m.ring = m:CreateTexture(nil, "ARTWORK", nil, 1)
    m.ring:SetAllPoints()
    m.ring:SetTexture(MEDIA .. "Textures\\SoftPanelCircle.tga")
    m.disc = m:CreateTexture(nil, "ARTWORK", nil, 2)
    m.disc:SetPoint("TOPLEFT", 2, -2)
    m.disc:SetPoint("BOTTOMRIGHT", -2, 2)
    m.disc:SetTexture(MEDIA .. "Textures\\SoftPanelCircle.tga")
    m.text = m:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    m.text:SetPoint("CENTER", 0, 0)
    m.icon = m:CreateTexture(nil, "OVERLAY", nil, 3)
    m.icon:SetPoint("TOPLEFT", 3, -3)
    m.icon:SetPoint("BOTTOMRIGHT", -3, 3)
    m:Hide()
    return m
end

--- size en las unidades del padre; fontScale compensa el zoom del lienzo
local ICON_CORPSE = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"

local function PaintMarker(m, t, size, fontScale)
    -- numero solo en "hacer" (matar / conseguir en una zona); coger y entregar usan el icono ? / !
    local num = (t.kind == "objective") and CurrentStepNumber() or nil
    local r, g, b = QR.Skin:Color("accent")
    m:SetSize(size, size)
    m.ring:SetVertexColor(r, g, b, 1)
    m.disc:SetVertexColor(0.05, 0.06, 0.06, 0.95)
    if num then
        -- tamaño de letra fijo en pantalla (el zoom del mapa se compensa con la escala del marcador entero,
        -- como los pines de HereBeDragons): asi el numero no se hace gigante con zoom
        local px = math.max(8, math.min(22, size * 0.55))
        m.text:SetFont(QR.Skin:FontPath("Bold"), px, "OUTLINE")
        m.text:SetText(num)
        m.text:SetTextColor(1, 1, 1)
        m.text:Show()
        m.icon:Hide()
    else
        local travelIcon = (t.travelKind == "flight") and "Gryphon" or (t.travelKind == "border" and "Arrow") or "Boat"
        local icon = (t.kind == "travel" and (MEDIA .. "Icons\\UI\\" .. travelIcon .. ".tga")) or t.kind == "corpse" and ICON_CORPSE
            or (t.kind == "turnin" and ICON_TURNIN or (t.kind == "pickup" and ICON_PICKUP or ICON_OBJECTIVE))
        m.icon:SetTexture(icon)
        if t.kind == "travel" then m.icon:SetVertexColor(QR.Skin:TextAccent()) else m.icon:SetVertexColor(1, 1, 1) end
        m.icon:Show()
        m.text:Hide()
    end
    m:Show()
end

---------------------------------------------------------------------------
-- Mapa del mundo
---------------------------------------------------------------------------
local function OpenMapStitched()
    return OpenMapAPI and OpenMapAPI.IsStitched and OpenMapAPI.IsStitched()
end

--- Punto (zona uiMapID, x, y en 0..1) -> coordenadas del lienzo del mapa del mundo (0..1, puede salirse)
--- Punto del mundo (HereBeDragons: yardas + continente) -> lienzo del mapa que se ve.
--- Funciona solo con HereBeDragons (viene con Questie): en el mapa de un continente salen sus puntos y en
--- el de Azeroth los de los dos continentes. Si OpenMap esta instalado y su mapa cosido sustituye al de
--- Blizzard, se usa su conversion para quedar alineados con su dibujo (opcional: no se depende de el).
local function CanvasFromWorld(wx, wy, inst)
    local host = WorldMapFrame:GetMapID()
    if not host or not wx then return nil end
    if inst and OpenMapAPI and OpenMapAPI.CanvasFromWorldPos and OpenMapAPI.IsStitched and OpenMapAPI.IsStitched() then
        local X, Y = QR.Router.ToHBD(wx, wy) -- (el cambio de ejes es simetrico: vuelve al orden de las tablas)
        local ok, cx, cy = pcall(OpenMapAPI.CanvasFromWorldPos, inst, X, Y)
        if ok and cx then return cx, cy end
    end
    if inst then return QR.HBD:GetZoneCoordinatesFromWorldInstance(wx, wy, inst, host, true) end
    return QR.HBD:GetZoneCoordinatesFromWorld(wx, wy, host, true)
end

local function CanvasFromZone(uiMapId, x, y)
    local host = WorldMapFrame:GetMapID()
    if not host or not uiMapId then return nil end
    if OpenMapStitched() then
        local ok, u, v = pcall(OpenMapAPI.WorldFromMap, uiMapId, x, y)
        if not (ok and u) then return nil end
        local ok2, cx, cy = pcall(OpenMapAPI.MapFromWorld, host, u, v)
        if ok2 and cx then return cx, cy end
        return nil
    end
    local wx, wy, inst = QR.HBD:GetWorldCoordinatesFromZone(x, y, uiMapId)
    if not wx then return nil end
    -- con el continente: un punto de otro continente no se coloca (salvo en el mapa de Azeroth)
    return QR.HBD:GetZoneCoordinatesFromWorldInstance(wx, wy, inst, host, true)
end

local function PlayerZonePosition()
    local x, y, map = QR.HBD:GetPlayerZonePosition(true)
    return map, x, y
end

function MapLines:CreateWorldMap()
    if not WorldMapFrame or not WorldMapFrame.GetCanvas then return end
    local canvas = WorldMapFrame:GetCanvas()
    local owner = CreateFrame("Frame", "QuestieRouterWorldMapLayer", canvas)
    owner:SetAllPoints(canvas)
    self.wm = owner
    owner.line = NewAnimatedLine(owner, "OVERLAY")
    owner.routeLines = {}           -- trozos de la ruta de viaje (se reutilizan)
    owner.endMarker = NewMarker(owner)
    owner.marker = NewMarker(owner)
    owner.glow = owner:CreateTexture(nil, "OVERLAY", nil, 6)
    owner.glow:SetTexture(MEDIA .. "Textures\\SoftPanelCircle.tga")
    owner.glow:Hide()

    -- el lienzo solo se actualiza mientras el mapa esta abierto
    owner:SetScript("OnUpdate", function() MapLines:UpdateWorldMap() end)
end

function MapLines:UpdateWorldMapLevel()
    local owner = self.wm
    if InCombatLockdown() then return end -- (cambiar niveles en el mapa esta restringido en combate)
    local canvas = WorldMapFrame:GetCanvas()
    local level = canvas:GetFrameLevel() + 2300
    local top = OpenMapAPI and OpenMapAPI.ArtTopLevel and OpenMapAPI.ArtTopLevel()
    if top and top + 3 > level then level = top + 3 end
    if owner:GetFrameLevel() ~= level then owner:SetFrameLevel(level) end
end

function MapLines:UpdateWorldMap()
    local owner = self.wm
    local t = QR.target
    local cfg = QR.db.lines
    if not (t and cfg.worldmap and QR.db.enabled) then
        owner.line:Hide(); owner.marker:Hide(); owner.glow:Hide()
        self:HideRoute(owner)
        return
    end
    self.levelCheck = (self.levelCheck or 0) + 1
    if self.levelCheck % 30 == 1 then self:UpdateWorldMapLevel() end

    local canvas = WorldMapFrame:GetCanvas()
    local W, H = canvas:GetWidth(), canvas:GetHeight()
    -- el lienzo se escala con el zoom: compensamos para que el grosor sea constante en pantalla
    local scale = canvas:GetEffectiveScale() / UIParent:GetEffectiveScale()
    if scale <= 0 then scale = 1 end

    -- ruta completa del viaje (de inicio a fin), tambien cuando el destino inmediato no esta en este mapa
    self:DrawRoute(owner, t, W, H, scale)

    local bx, by
    if t.uiMapId then bx, by = CanvasFromZone(t.uiMapId, t.x, t.y) else bx, by = CanvasFromWorld(t.wx, t.wy, t.instance) end
    if not bx then
        owner.line:Hide(); owner.marker:Hide(); owner.glow:Hide()
        return
    end
    -- marcador del destino con el numero del paso (tamaño constante en pantalla). Si el destino es la zona de
    -- mision del juego, el juego ya pone su icono justo ahi: el numero va como insignia pequeña arriba a la
    -- derecha de ese icono, para que se vean los dos.
    -- El marcador tiene tamaño fijo EN PANTALLA: su escala compensa el zoom del lienzo (1 / scale). Por eso su
    -- posicion se da en sus propias unidades (coordenadas del lienzo * scale).
    local badge = t.fromGame and true or false
    local size = badge and 17 or 24
    local off = badge and 13 or 0
    owner.marker:SetScale(1 / scale)
    owner.marker:SetFrameLevel(owner:GetFrameLevel() + 2)
    owner.marker:ClearAllPoints()
    owner.marker:SetPoint("CENTER", owner, "TOPLEFT", bx * W * scale + off, -by * H * scale + off)
    PaintMarker(owner.marker, t, size)
    -- coger / entregar: el NPC ya lleva el icono de Questie (? / !); no lo tapamos con otro marcador
    if t.kind == "pickup" or t.kind == "turnin" then owner.marker:Hide() end
    local r, g, b = QR.Skin:Color("accent")
    owner.glow:SetSize(size * 2.2 / scale, size * 2.2 / scale)
    owner.glow:ClearAllPoints()
    owner.glow:SetPoint("CENTER", owner.marker, "CENTER")
    owner.glow:SetVertexColor(r, g, b, 0.35 + 0.15 * math.sin(GetTime() * 3))
    owner.glow:SetShown(not badge)   -- (sobre el icono del juego el brillo sobra)

    -- linea desde el jugador
    local pmap, px, py = PlayerZonePosition()
    local ax, ay
    if pmap then ax, ay = CanvasFromZone(pmap, px, py) end
    if not ax then owner.line:Hide(); return end
    local x1, y1, x2, y2 = ax * W, -ay * H, bx * W, -by * H
    local dx, dy = x2 - x1, y2 - y1
    local len = math.sqrt(dx * dx + dy * dy)
    if len < 2 then owner.line:Hide(); return end
    -- no tapar la flecha del jugador ni el marcador: recortar los extremos
    local cutA, cutB = math.min(len * 0.3, 10 / scale), math.min(len * 0.3, 12 / scale)
    local ux, uy = dx / len, dy / len
    owner.line:SetStartPoint("TOPLEFT", owner, x1 + ux * cutA, y1 + uy * cutA)
    owner.line:SetEndPoint("TOPLEFT", owner, x2 - ux * cutB, y2 - uy * cutB)
    -- todo en unidades del lienzo: grosor constante en pantalla y dibujo sin deformar con el zoom
    PaintLine(owner.line, len - cutA - cutB, (cfg.thicknessWorld or 9) / scale, cfg.alphaWorld or 0.9)
    owner.line:Show()
end

---------------------------------------------------------------------------
-- Ruta de viaje completa en el mapa del mundo: a pie, vuelos (recorrido real) y barcos / zepelines
---------------------------------------------------------------------------
local ROUTE_COLOR = {
    flight = { 0.38, 0.82, 0.88 },     -- vuelos: turquesa
    boat = { 0.45, 0.62, 1.00 }, zeppelin = { 0.45, 0.62, 1.00 }, airship = { 0.45, 0.62, 1.00 },
    portal = { 0.78, 0.52, 1.00 }, tram = { 0.82, 0.82, 0.88 },   -- portales: violeta; tranvia: gris
}
local ROUTE_STYLE = { flight = 2, boat = 2, zeppelin = 2, airship = 2, portal = 2, tram = 2 }   -- transporte: burbujas

function MapLines:HideRoute(owner)
    for _, l in ipairs(owner.routeLines) do l:Hide() end
    owner.endMarker:Hide()
end

--- Puntos de la ruta en el lienzo: se calculan una vez por ruta y mapa (no en cada fotograma)
local function RouteCanvas(route)
    local host = WorldMapFrame:GetMapID()
    local stitched = OpenMapAPI and OpenMapAPI.IsStitched and OpenMapAPI.IsStitched() or false
    local c = route.canvasCache
    if c and c.host == host and c.stitched == stitched then return c end
    c = { host = host, stitched = stitched, segs = {} }
    for si, seg in ipairs(route.segments) do
        local pts = {}
        for k, p in ipairs(seg.points) do
            local x, y = CanvasFromWorld(p[2], p[3], p[1])
            pts[k] = x and { x, y } or false
        end
        c.segs[si] = pts
    end
    route.canvasCache = c
    return c
end

function MapLines:DrawRoute(owner, t, W, H, scale)
    local route = t.kind == "travel" and t.route
    if not route then self:HideRoute(owner); return end
    local cfg = QR.db.lines
    local c = RouteCanvas(route)
    local thick = (cfg.thicknessWorld or 9) * 0.8 / scale
    local alpha = cfg.alphaWorld or 0.9
    local n = 0
    for si, seg in ipairs(route.segments) do
        -- el primer tramo a pie (desde el jugador) ya lo dibuja la linea principal
        if not seg.fromPlayer then
            local pts = c.segs[si]
            for k = 1, #pts - 1 do
                local a, b = pts[k], pts[k + 1]
                if a and b then
                    local x1, y1, x2, y2 = a[1] * W, -a[2] * H, b[1] * W, -b[2] * H
                    local dx, dy = x2 - x1, y2 - y1
                    local len = math.sqrt(dx * dx + dy * dy)
                    if len > 0.5 then
                        n = n + 1
                        local line = owner.routeLines[n]
                        if not line then
                            line = NewAnimatedLine(owner, "OVERLAY")
                            owner.routeLines[n] = line
                        end
                        line:SetStartPoint("TOPLEFT", owner, x1, y1)
                        line:SetEndPoint("TOPLEFT", owner, x2, y2)
                        PaintLine(line, len, thick, alpha, ROUTE_STYLE[seg.kind], ROUTE_COLOR[seg.kind])
                        line:Show()
                    end
                end
            end
        end
    end
    for k = n + 1, #owner.routeLines do owner.routeLines[k]:Hide() end
    -- marcador del final del viaje (el primer NPC / objetivo de la guia)
    local f = t.final
    local fx, fy
    if f then
        if f.uiMapId then fx, fy = CanvasFromZone(f.uiMapId, f.x, f.y) else fx, fy = CanvasFromWorld(f.wx, f.wy, f.instance) end
    end
    if fx then
        owner.endMarker:SetScale(1 / scale)
        owner.endMarker:SetFrameLevel(owner:GetFrameLevel() + 1)
        owner.endMarker:ClearAllPoints()
        local eoff = f.fromGame and 13 or 0
        owner.endMarker:SetPoint("CENTER", owner, "TOPLEFT", fx * W * scale + eoff, -fy * H * scale + eoff)
        PaintMarker(owner.endMarker, f, f.fromGame and 17 or 22)
    else
        owner.endMarker:Hide()
    end
end

---------------------------------------------------------------------------
-- Minimapa (pin flotante de HereBeDragons + linea desde el centro)
---------------------------------------------------------------------------
function MapLines:CreateMinimap()
    local pin = CreateFrame("Frame", nil, UIParent)
    pin:SetSize(18, 18)
    -- Este pin vive en la copia de HereBeDragons de Questie, y Questie recorre todos sus pines del
    -- minimapa al mostrar sus tooltips esperando un campo "data". Con data + hidden, Questie lo
    -- descarta antes de usarlo (y su bucle de desvanecido lo ignora porque no tiene miniMapIcon).
    pin.data = { QuestieRouter = true }
    pin.hidden = true
    pin.marker = NewMarker(pin)
    pin.marker:SetAllPoints()
    pin:Hide()
    self.mmTarget = pin

    local owner = CreateFrame("Frame", nil, Minimap)
    owner:SetAllPoints(Minimap)
    owner:SetFrameLevel(Minimap:GetFrameLevel() + 2)
    owner.line = NewAnimatedLine(owner, "ARTWORK")
    self.mm = owner
    owner:SetScript("OnUpdate", function() MapLines:UpdateMinimap() end)
end

function MapLines:UpdateMinimap()
    local owner, pin = self.mm, self.mmTarget
    local cfg = QR.db.lines
    if not (QR.target and cfg.minimap and QR.db.enabled and pin:IsShown()) then owner.line:Hide(); return end
    local mx, my = Minimap:GetCenter()
    local tx, ty = pin:GetCenter()
    if not (mx and tx) then owner.line:Hide(); return end
    local ps, ms = pin:GetEffectiveScale(), Minimap:GetEffectiveScale()
    tx, ty = tx * ps / ms, ty * ps / ms
    local dx, dy = tx - mx, ty - my
    local len = math.sqrt(dx * dx + dy * dy)
    if len < 8 then owner.line:Hide(); return end
    local ux, uy = dx / len, dy / len
    local cut = 7
    owner.line:SetStartPoint("CENTER", Minimap, ux * cut, uy * cut)
    owner.line:SetEndPoint("CENTER", Minimap, dx - ux * 6, dy - uy * 6)
    PaintLine(owner.line, len - cut - 6, cfg.thicknessMinimap or 4, cfg.alphaMinimap or 0.9)
    owner.line:Show()
end

---------------------------------------------------------------------------
-- Cambio de destino
---------------------------------------------------------------------------
function MapLines:OnTargetChanged(t)
    local pins = QR.HBDPins
    pins:RemoveMinimapIcon(REF, self.mmTarget)
    self.mmTarget:Hide()
    if not t or not QR.db.enabled or not QR.db.lines.minimap then return end
    PaintMarker(self.mmTarget.marker, t, 18)
    pins:AddMinimapIconWorld(REF, self.mmTarget, t.instance, t.wx, t.wy, true)
end

function MapLines:Init()
    self:CreateMinimap()
    self:CreateWorldMap()
    QR:On("TARGET_CHANGED", function(t) MapLines:OnTargetChanged(t) end)
    QR:On("SETTINGS_CHANGED", function() MapLines:OnTargetChanged(QR.target) end)
    QR:On("HISTORY_CHANGED", function()
        if QR.target and MapLines.mmTarget:IsShown() then PaintMarker(MapLines.mmTarget.marker, QR.target, 18) end
    end)
    self:OnTargetChanged(QR.target)
end

QR:RegisterModule("MapLines", function() MapLines:Init() end)

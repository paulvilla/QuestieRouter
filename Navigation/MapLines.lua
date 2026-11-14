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
    if inst then return QR:ZoneCoordsFromWorld(wx, wy, inst, host, true) end
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
    return QR:ZoneCoordsFromWorld(wx, wy, inst, host, true)
end

local function PlayerZonePosition()
    local x, y, map = QR.HBD:GetPlayerZonePosition(true)
    return map, x, y
end

---------------------------------------------------------------------------
-- Mapa del mundo: la capa se actualiza en cada fotograma mientras el mapa esta abierto, pero solo hace lo que
-- ha cambiado (con una ruta larga y OpenMap, rehacerlo todo en cada fotograma daba tirones al hacer zoom):
--   * geometria  (anclar lineas y marcadores): al cambiar el destino, la ruta, el mapa que se ve o el tamaño
--     del lienzo; la linea del jugador, cuando se mueve (se mira cada PLAYER_INTERVAL s)
--   * escala     (grosor y marcadores de tamaño fijo en pantalla): al cambiar el zoom
--   * animacion  (desplazamiento del dibujo): como mucho a ANIM_FPS y quieta mientras se hace zoom
-- Las posiciones van en unidades del lienzo, que no cambian con el zoom: durante el zoom no se re-ancla nada.
---------------------------------------------------------------------------
local PLAYER_INTERVAL = 0.1
local ANIM_INTERVAL = 1 / 30
local ZOOM_QUIET = 0.15          -- s sin cambiar la escala para volver a animar
local SIMPLIFY = 0.0015          -- tolerancia al simplificar recorridos (fraccion del lienzo)

function MapLines:CreateWorldMap()
    if not WorldMapFrame or not WorldMapFrame.GetCanvas then return end
    local canvas = WorldMapFrame:GetCanvas()
    local owner = CreateFrame("Frame", "QuestieRouterWorldMapLayer", canvas)
    owner:SetAllPoints(canvas)
    self.wm = owner
    owner.line = NewAnimatedLine(owner, "OVERLAY")
    owner.routeLines = {}           -- trozos de la ruta de viaje (se reutilizan)
    owner.nRoute = 0                -- cuantos estan en uso
    owner.endMarker = NewMarker(owner)
    owner.marker = NewMarker(owner)
    owner.glow = owner:CreateTexture(nil, "OVERLAY", nil, 6)
    owner.glow:SetTexture(MEDIA .. "Textures\\SoftPanelCircle.tga")
    owner.glow:Hide()
    owner.st = { geo = true, paint = true }

    -- el lienzo solo se actualiza mientras el mapa esta abierto
    owner:SetScript("OnUpdate", function()
        local p = MapLines.perf
        if p then
            local t0 = debugprofilestop()
            MapLines:UpdateWorldMap()
            local ms = debugprofilestop() - t0
            p.frames, p.total = p.frames + 1, p.total + ms
            if ms > p.max then p.max = ms end
        else
            MapLines:UpdateWorldMap()
        end
    end)
end

--- Fuerza a recolocar y repintar todo en el siguiente fotograma (destino, ajustes, color, numero del paso)
function MapLines:InvalidateWorld()
    local st = self.wm and self.wm.st
    if st then st.geo, st.paint = true, true end
end

function MapLines:UpdateWorldMapLevel()
    local owner = self.wm
    if InCombatLockdown() then return end -- (cambiar niveles en el mapa esta restringido en combate)
    local canvas = WorldMapFrame:GetCanvas()
    local level = canvas:GetFrameLevel() + 2300
    local top = OpenMapAPI and OpenMapAPI.ArtTopLevel and OpenMapAPI.ArtTopLevel()
    if top and top + 3 > level then level = top + 3 end
    if owner:GetFrameLevel() ~= level then
        owner:SetFrameLevel(level)
        owner.marker:SetFrameLevel(level + 2)
        owner.endMarker:SetFrameLevel(level + 1)
    end
end

local function HideAllWorld(owner)
    owner.line:Hide(); owner.marker:Hide(); owner.glow:Hide(); owner.endMarker:Hide()
    for k = 1, owner.nRoute do owner.routeLines[k]:Hide() end
    owner.nRoute = 0
end

--- Color y modo de mezcla de una linea (solo al cambiar el destino, los ajustes o el color de la zona)
local function StyleLine(line, alpha, styleOverride, color)
    local cfg = QR.db.lines
    local style = styleOverride or cfg.style or 1
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
    -- franja de la textura del estilo (medio texel hacia dentro, como PaintLine)
    line.v1, line.v2 = (style - 1) / 4 + 0.016, style / 4 - 0.016
end

--- Grosor y repeticiones del dibujo (con el zoom). length y thickness en unidades del lienzo.
local function SizeLine(line, length, thickness)
    line:SetThickness(thickness)
    line.tile = math.max(0.5, length / (thickness * 4) * (QR.db.lines.density or 1))
end

--- Desplazamiento del dibujo (animacion)
local function PhaseLine(line, phase)
    local u1, u2 = -phase, (line.tile or 1) - phase
    line:SetTexCoord(u1, line.v1, u1, line.v2, u2, line.v1, u2, line.v2)
end

local function Phase()
    return (GetTime() / math.max(0.2, QR.db.lines.speed or 1.4)) % 1
end

--- Clave de lo que muestra un marcador: solo se repinta si cambia
local function MarkerKey(t, size)
    local num = (t.kind == "objective") and CurrentStepNumber() or ""
    local r, g, b = QR.Skin:Color("accent")
    return string.format("%s|%s|%s|%s|%.3f%.3f%.3f", t.kind or "", num, t.travelKind or "", size, r, g, b)
end

function MapLines:UpdateWorldMap()
    local owner, st = self.wm, self.wm.st
    local t = QR.target
    local cfg = QR.db.lines
    if not (t and cfg.worldmap and QR.db.enabled) then
        if st.visible then HideAllWorld(owner); st.visible = false end
        st.geo, st.paint = true, true
        return
    end
    st.visible = true
    self.levelCheck = (self.levelCheck or 0) + 1
    if self.levelCheck % 30 == 1 then self:UpdateWorldMapLevel() end

    local canvas = WorldMapFrame:GetCanvas()
    local W, H = canvas:GetWidth(), canvas:GetHeight()
    -- el lienzo se escala con el zoom: compensamos para que el grosor sea constante en pantalla
    local scale = canvas:GetEffectiveScale() / UIParent:GetEffectiveScale()
    if scale <= 0 then scale = 1 end
    local host = WorldMapFrame:GetMapID()
    local stitched = OpenMapStitched() and true or false
    local routeKey = t.route and t.route.key or false
    local now = GetTime()

    -- 1. ¿Hay que recolocar todo? (destino, ruta, mapa que se ve o tamaño del lienzo)
    if t ~= st.target or routeKey ~= st.routeKey or host ~= st.host or stitched ~= st.stitched or W ~= st.W or H ~= st.H then
        st.target, st.routeKey, st.host, st.stitched, st.W, st.H = t, routeKey, host, stitched, W, H
        st.geo = true
    end
    local geo = st.geo
    if geo then
        st.geo = false
        st.markerKey, st.endKey = nil, nil   -- (un marcador oculto por no caer en el mapa se vuelve a pintar)
        st.bx, st.by = nil, nil
        if t.uiMapId then st.bx, st.by = CanvasFromZone(t.uiMapId, t.x, t.y) else st.bx, st.by = CanvasFromWorld(t.wx, t.wy, t.instance) end
        self:LayoutRoute(owner, t, W, H)
    end

    -- 2. Jugador: se mira cada PLAYER_INTERVAL s (y siempre que se recoloca todo)
    local moved = false
    if geo or now - (st.playerAt or 0) >= PLAYER_INTERVAL then
        st.playerAt = now
        local pmap, px, py = PlayerZonePosition()
        local ax, ay
        if pmap then ax, ay = CanvasFromZone(pmap, px, py) end
        if ax ~= st.ax or ay ~= st.ay then st.ax, st.ay, moved = ax, ay, true end
    end

    -- 3. Zoom
    local zoomed = math.abs(scale - (st.scale or 0)) > 1e-5
    if zoomed then st.scale, st.zoomAt = scale, now end

    -- 4. Marcadores: repintar solo si cambia lo que muestran; colocar con el zoom o al recolocar
    local badge = t.fromGame and true or false
    local size = badge and 17 or 24
    local repaint = st.paint or geo
    if st.paint then
        st.paint = false
        st.markerKey, st.endKey = nil, nil
        for k = 1, owner.nRoute do
            local l = owner.routeLines[k]
            StyleLine(l, cfg.alphaWorld or 0.9, l.styleOverride, l.color)
        end
        StyleLine(owner.line, cfg.alphaWorld or 0.9)
        zoomed = true   -- (grosor y repeticiones con los ajustes nuevos)
    end
    if st.bx then
        local key = repaint and MarkerKey(t, size)
        if key and key ~= st.markerKey then
            st.markerKey = key
            PaintMarker(owner.marker, t, size)
            -- coger / entregar: el NPC ya lleva el icono de Questie (? / !); no lo tapamos con otro marcador
            if t.kind == "pickup" or t.kind == "turnin" then owner.marker:Hide() end
            owner.glow:SetShown(not badge)   -- (sobre el icono del juego el brillo sobra)
        end
        if geo or zoomed then
            -- tamaño fijo EN PANTALLA: la escala del marcador compensa el zoom del lienzo (1 / scale), y por eso su
            -- posicion va en sus propias unidades (coordenadas del lienzo * scale). Con el icono de la zona de mision
            -- del juego, el numero va como insignia pequeña arriba a la derecha.
            local off = badge and 13 or 0
            owner.marker:SetScale(1 / scale)
            owner.marker:ClearAllPoints()
            owner.marker:SetPoint("CENTER", owner, "TOPLEFT", st.bx * W * scale + off, -st.by * H * scale + off)
            owner.glow:SetSize(size * 2.2 / scale, size * 2.2 / scale)
            owner.glow:ClearAllPoints()
            owner.glow:SetPoint("CENTER", owner.marker, "CENTER")
        end
    elseif geo then
        owner.marker:Hide(); owner.glow:Hide()
    end
    local f = t.final
    if f and st.fx then
        local fbadge = f.fromGame and true or false
        local fsize = fbadge and 17 or 22
        local key = repaint and MarkerKey(f, fsize)
        if key and key ~= st.endKey then st.endKey = key; PaintMarker(owner.endMarker, f, fsize) end
        if geo or zoomed then
            local eoff = fbadge and 13 or 0
            owner.endMarker:SetScale(1 / scale)
            owner.endMarker:ClearAllPoints()
            owner.endMarker:SetPoint("CENTER", owner, "TOPLEFT", st.fx * W * scale + eoff, -st.fy * H * scale + eoff)
        end
    elseif geo then
        owner.endMarker:Hide()
    end

    -- 5. Grosor de la ruta: solo con el zoom (sus extremos no cambian: estan en unidades del lienzo)
    if geo or zoomed then
        local thick = (cfg.thicknessWorld or 9) * 0.8 / scale
        for k = 1, owner.nRoute do
            local l = owner.routeLines[k]
            SizeLine(l, l.len, thick)
        end
    end

    -- 6. Linea desde el jugador (sus recortes dependen del zoom)
    if geo or zoomed or moved then self:LayoutPlayerLine(owner, W, H, scale) end

    -- 7. Animacion: como mucho a ANIM_FPS, quieta mientras se hace zoom. Con zoom se reaplica la fase guardada
    -- (las repeticiones cambian con el grosor) para que el dibujo no se estire.
    local animate = now - (st.zoomAt or 0) > ZOOM_QUIET and now - (st.animAt or 0) >= ANIM_INTERVAL
    if animate or geo or zoomed or moved then
        if animate then st.animAt, st.phase = now, Phase() end
        local phase = st.phase or 0
        for k = 1, owner.nRoute do PhaseLine(owner.routeLines[k], phase) end
        if owner.line:IsShown() then PhaseLine(owner.line, phase) end
        if animate and st.bx and not badge then
            local r, g, b = QR.Skin:Color("accent")
            owner.glow:SetVertexColor(r, g, b, 0.35 + 0.15 * math.sin(now * 3))
        end
    end
end

--- Linea del jugador al destino, con los extremos recortados para no tapar la flecha ni el marcador
function MapLines:LayoutPlayerLine(owner, W, H, scale)
    local st = owner.st
    local line = owner.line
    if not (st.ax and st.bx) then line:Hide(); return end
    local x1, y1, x2, y2 = st.ax * W, -st.ay * H, st.bx * W, -st.by * H
    local dx, dy = x2 - x1, y2 - y1
    local len = math.sqrt(dx * dx + dy * dy)
    if len < 2 then line:Hide(); return end
    local cutA, cutB = math.min(len * 0.3, 10 / scale), math.min(len * 0.3, 12 / scale)
    local ux, uy = dx / len, dy / len
    line:SetStartPoint("TOPLEFT", owner, x1 + ux * cutA, y1 + uy * cutA)
    line:SetEndPoint("TOPLEFT", owner, x2 - ux * cutB, y2 - uy * cutB)
    -- todo en unidades del lienzo: grosor constante en pantalla y dibujo sin deformar con el zoom
    SizeLine(line, len - cutA - cutB, (QR.db.lines.thicknessWorld or 9) / scale)
    line:Show()
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
    for k = 1, owner.nRoute do owner.routeLines[k]:Hide() end
    owner.nRoute = 0
    owner.endMarker:Hide()
end

--- Douglas-Peucker sobre { {x, y}, ... }: quita los puntos que casi no cambian la forma del recorrido
local function Simplify(pts, tol)
    local n = #pts
    if n < 3 then return pts end
    local keep = { [1] = true, [n] = true }
    local stack = { { 1, n } }
    while #stack > 0 do
        local a, b = unpack(table.remove(stack))
        local ax, ay, bx, by = pts[a][1], pts[a][2], pts[b][1], pts[b][2]
        local dx, dy = bx - ax, by - ay
        local d2 = dx * dx + dy * dy
        local far, farD = nil, tol * tol
        for i = a + 1, b - 1 do
            local px, py = pts[i][1] - ax, pts[i][2] - ay
            local dist
            if d2 == 0 then
                dist = px * px + py * py
            else
                local cross = px * dy - py * dx
                dist = cross * cross / d2
            end
            if dist > farD then far, farD = i, dist end
        end
        if far then
            keep[far] = true
            stack[#stack + 1] = { a, far }
            stack[#stack + 1] = { far, b }
        end
    end
    local out = {}
    for i = 1, n do if keep[i] then out[#out + 1] = pts[i] end end
    return out
end

--- Puntos de la ruta en el lienzo, ya simplificados: se calculan una vez por ruta y mapa (no en cada fotograma).
--- c.segs[si] = { tramo, tramo, ... } (un recorrido se corta donde hay un punto que no cae en este mapa)
local function RouteCanvas(route)
    local host = WorldMapFrame:GetMapID()
    local stitched = OpenMapAPI and OpenMapAPI.IsStitched and OpenMapAPI.IsStitched() or false
    local c = route.canvasCache
    if c and c.host == host and c.stitched == stitched then return c end
    c = { host = host, stitched = stitched, segs = {} }
    for si, seg in ipairs(route.segments) do
        local runs, run = {}, {}
        for _, p in ipairs(seg.points) do
            local x, y = CanvasFromWorld(p[2], p[3], p[1])
            if x then
                run[#run + 1] = { x, y }
            elseif #run > 0 then
                runs[#runs + 1] = Simplify(run, SIMPLIFY); run = {}
            end
        end
        if #run > 0 then runs[#runs + 1] = Simplify(run, SIMPLIFY) end
        c.segs[si] = runs
    end
    route.canvasCache = c
    return c
end

--- Ancla los trozos de la ruta y calcula la posicion del marcador del final (solo al recolocar)
function MapLines:LayoutRoute(owner, t, W, H)
    local st = owner.st
    local route = t.kind == "travel" and t.route
    st.fx, st.fy = nil, nil
    if not route then self:HideRoute(owner); return end
    local cfg = QR.db.lines
    local c = RouteCanvas(route)
    local n = 0
    for si, seg in ipairs(route.segments) do
        -- el primer tramo a pie (desde el jugador) ya lo dibuja la linea principal
        if not seg.fromPlayer then
            for _, pts in ipairs(c.segs[si]) do
                for k = 1, #pts - 1 do
                    local a, b = pts[k], pts[k + 1]
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
                        line.len = len
                        line.styleOverride, line.color = ROUTE_STYLE[seg.kind], ROUTE_COLOR[seg.kind]
                        StyleLine(line, cfg.alphaWorld or 0.9, line.styleOverride, line.color)
                        line:Show()
                    end
                end
            end
        end
    end
    for k = n + 1, owner.nRoute do owner.routeLines[k]:Hide() end
    owner.nRoute = n
    -- marcador del final del viaje (el primer NPC / objetivo de la guia)
    local f = t.final
    if f then
        if f.uiMapId then st.fx, st.fy = CanvasFromZone(f.uiMapId, f.x, f.y) else st.fx, st.fy = CanvasFromWorld(f.wx, f.wy, f.instance) end
    end
    if not st.fx then owner.endMarker:Hide() end
end

--- /qr perf: mide lo que tarda la capa del mapa del mundo durante 'seconds' segundos y lo escribe en el chat
function MapLines:StartPerf(seconds)
    local L = QR.L
    seconds = seconds or 10
    self.perf = { frames = 0, total = 0, max = 0 }
    QR:Print(string.format(L["Measuring the map lines for %d s: open the world map and zoom in and out."], seconds))
    C_Timer.After(seconds, function()
        local p = MapLines.perf
        MapLines.perf = nil
        if not p or p.frames == 0 then
            QR:Print(L["Map lines: the world map was not open while measuring."])
            return
        end
        QR:Print(string.format(L["Map lines: %d frames, %.3f ms average, %.3f ms max per frame, %d route lines."],
            p.frames, p.total / p.frames, p.max, MapLines.wm and MapLines.wm.nRoute or 0))
    end)
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
    QR:On("TARGET_CHANGED", function(t) MapLines:OnTargetChanged(t); MapLines:InvalidateWorld() end)
    QR:On("SETTINGS_CHANGED", function() MapLines:OnTargetChanged(QR.target); MapLines:InvalidateWorld() end)
    QR:On("SKIN_CHANGED", function() MapLines:InvalidateWorld() end)
    QR:On("HISTORY_CHANGED", function()
        MapLines:InvalidateWorld()   -- (numero del paso en el marcador)
        if QR.target and MapLines.mmTarget:IsShown() then PaintMarker(MapLines.mmTarget.marker, QR.target, 18) end
    end)
    self:OnTargetChanged(QR.target)
end

QR:RegisterModule("MapLines", function() MapLines:Init() end)

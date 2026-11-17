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
        local TRAVEL_MARK = { flight = "Gryphon", border = "Arrow", road = "Arrow", walk = "Arrow", tram = "Tram",
                              portal = "Arrow", door = "Arrow" }
        local travelIcon = TRAVEL_MARK[t.travelKind] or "Boat"
        local icon = (t.kind == "travel" and (MEDIA .. "Icons\\UI\\" .. travelIcon .. ".tga")) or t.kind == "corpse" and ICON_CORPSE
            or (t.kind == "manualpoint" and (MEDIA .. "Icons\\UI\\Pin.tga"))   -- punto añadido a mano (Alt + clic)
            or (t.kind == "turnin" and ICON_TURNIN or (t.kind == "pickup" and ICON_PICKUP or ICON_OBJECTIVE))
        m.icon:SetTexture(icon)
        if t.kind == "travel" or t.kind == "manualpoint" then m.icon:SetVertexColor(QR.Skin:TextAccent())
        else m.icon:SetVertexColor(1, 1, 1) end
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
    for k = 1, (owner.nWalk or 0) do owner.walkLines[k]:Hide() end
    owner.nWalk = 0
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
    local f = t.final or (t.via and t.via.final)
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
        for k = 1, (owner.nWalk or 0) do PhaseLine(owner.walkLines[k], phase) end
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
    -- camino a pie por el terreno (Navigation/Walk.lua): la linea sigue el camino en vez de ir recta
    owner.walkLines = owner.walkLines or {}
    local n = 0
    local px, py, pinst = QR.HBD:GetPlayerWorldPosition()
    local walk = px and QR.Walk and QR.Walk:Remaining(px, py, pinst, QR.target)
    if walk and #walk >= 2 then
        local cfg = QR.db.lines
        local thick = (cfg.thicknessWorld or 9) / scale
        local prev
        for i, p in ipairs(walk) do
            local cx, cy = CanvasFromWorld(p.x, p.y, pinst)
            if cx then
                local pt = { cx * W, -cy * H }
                if prev then
                    local x1, y1, x2, y2 = prev[1], prev[2], pt[1], pt[2]
                    local dx, dy = x2 - x1, y2 - y1
                    local len = math.sqrt(dx * dx + dy * dy)
                    if len > 0.5 then
                        -- el primer trozo no tapa la flecha del jugador
                        if n == 0 then
                            local cut = math.min(len * 0.3, 10 / scale)
                            x1, y1, len = x1 + dx / len * cut, y1 + dy / len * cut, len - cut
                        end
                        n = n + 1
                        local l = owner.walkLines[n]
                        if not l then
                            l = NewAnimatedLine(owner, "OVERLAY")
                            owner.walkLines[n] = l
                        end
                        StyleLine(l, cfg.alphaWorld or 0.9)
                        l:SetStartPoint("TOPLEFT", owner, x1, y1)
                        l:SetEndPoint("TOPLEFT", owner, x2, y2)
                        SizeLine(l, len, thick)
                        l:Show()
                    end
                end
                prev = pt
            end
        end
    end
    for k = n + 1, (owner.nWalk or 0) do owner.walkLines[k]:Hide() end
    owner.nWalk = n
    if n > 0 then line:Hide(); return end
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

--- Ancla los trozos de la ruta y calcula la posicion del marcador del final (solo al recolocar).
--- Rutas que se dibujan: la del viaje (destino "travel") y la de los puntos de paso (Alt + clic en el mapa) hasta la
--- guia, ya calculada por el router desde el punto (Router:RouteFrom: caminos, vuelos, barcos segun los ajustes); si
--- hay que viajar hasta el punto, las dos seguidas.
function MapLines:LayoutRoute(owner, t, W, H)
    local st = owner.st
    st.fx, st.fy = nil, nil
    local routes = {}
    if t.kind == "travel" and t.route then routes[#routes + 1] = t.route end
    local via = t.via or (t.final and t.final.via)
    if via and via.route then routes[#routes + 1] = via.route end
    if #routes == 0 then self:HideRoute(owner); return end
    local cfg = QR.db.lines
    local n = 0
    for _, route in ipairs(routes) do
        local c = RouteCanvas(route)
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
    end
    for k = n + 1, owner.nRoute do owner.routeLines[k]:Hide() end
    owner.nRoute = n
    -- marcador del final: el del viaje (el primer NPC / objetivo de la guia, o el punto de paso) o, yendo a un punto de
    -- paso, el destino de la guia
    local f = t.final or (t.via and t.via.final)
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
-- Minimapa: marcador del destino + linea desde el centro (el camino a pie si lo hay; si no, recta)
-- Todo se coloca aqui a partir de las coordenadas de mundo, sin pines de HereBeDragons: la copia de Questie oculta
-- los pines a mas de 500 yardas del jugador ("questie specific fix" en HereBeDragons-Pins) y con un destino lejano
-- no salia ni el marcador ni la linea.
---------------------------------------------------------------------------
function MapLines:CreateMinimap()
    local owner = CreateFrame("Frame", nil, Minimap)
    owner:SetAllPoints(Minimap)
    owner:SetFrameLevel(Minimap:GetFrameLevel() + 2)
    owner.line = NewAnimatedLine(owner, "ARTWORK")
    owner.walkLines = {}
    owner.nWalk = 0
    -- marcador del destino (por encima de las lineas)
    local m = NewMarker(owner)
    m:SetFrameLevel(owner:GetFrameLevel() + 2)
    owner.marker = m
    self.mm = owner
    owner:SetScript("OnUpdate", function() MapLines:UpdateMinimap() end)
end

-- diametro en yardas que abarca el minimapa en cada nivel de zoom (fuera / dentro de edificios), sin C_Minimap
local MM_OUTDOOR = { [0] = 466 + 2 / 3, 400, 333 + 1 / 3, 266 + 2 / 3, 200, 133 + 1 / 3 }
local MM_INDOOR = { [0] = 300, 240, 180, 120, 80, 50 }
local MM_MARKER = 18
local MM_EDGE = 4        -- px: las lineas acaban un poco antes del borde

--- Proyeccion del mundo al minimapa para este fotograma: -> funcion(wx, wy) -> (x, y) en px desde el centro, el
--- radio en px y si el minimapa es cuadrado; nil sin posicion del jugador
local function MinimapProjection()
    local px, py, pinst = QR.HBD:GetPlayerWorldPosition()
    if not px then return nil end
    local yards
    if C_Minimap and C_Minimap.GetViewRadius then
        local ok, r = pcall(C_Minimap.GetViewRadius)
        if ok and r and r > 0 then yards = r end
    end
    if not yards then
        local zoom = Minimap:GetZoom() or 0
        -- (como HereBeDragons: fuera de edificios minimapZoom coincide con el zoom actual)
        local outdoor = tonumber(GetCVar("minimapZoom") or "") == zoom
        if IsIndoors and IsIndoors() and not outdoor then
            yards = (MM_INDOOR[zoom] or 300) / 2
        else
            yards = (MM_OUTDOOR[zoom] or 466) / 2
        end
    end
    local radius = Minimap:GetWidth() / 2
    local perYard = radius / yards
    local facing = 0
    if GetCVar("rotateMinimap") == "1" then
        facing = GetPlayerFacing()
        if not facing then return nil end
    end
    local square = GetMinimapShape and GetMinimapShape() == "SQUARE"
    local function project(wx, wy)
        local a, d = QR.HBD:GetWorldVector(pinst, px, py, wx, wy)
        if not a then return nil end
        a = a - facing
        return -math.sin(a) * d * perYard, math.cos(a) * d * perYard
    end
    return project, radius, square, pinst, px, py
end

--- ¿Esta (x, y) fuera del borde util? (redondo o cuadrado)
local function OutsideEdge(x, y, lim, square)
    if square then return math.max(math.abs(x), math.abs(y)) > lim end
    return x * x + y * y > lim * lim
end

--- Lleva un punto de fuera al borde util, en la direccion del centro
local function ClampToEdge(x, y, lim, square)
    local k
    if square then k = lim / math.max(math.abs(x), math.abs(y)) else k = lim / math.sqrt(x * x + y * y) end
    return x * k, y * k
end

--- Corta el segmento (x1, y1) -> (x2, y2), que sale del minimapa, en el borde util
local function CutAtEdge(x1, y1, x2, y2, lim, square)
    if square then
        -- busqueda binaria (el primer punto esta dentro)
        local lo, hi = 0, 1
        for _ = 1, 16 do
            local mid = (lo + hi) / 2
            if OutsideEdge(x1 + (x2 - x1) * mid, y1 + (y2 - y1) * mid, lim, true) then hi = mid else lo = mid end
        end
        return x1 + (x2 - x1) * lo, y1 + (y2 - y1) * lo
    end
    local dx, dy = x2 - x1, y2 - y1
    local A, B, C = dx * dx + dy * dy, 2 * (x1 * dx + y1 * dy), x1 * x1 + y1 * y1 - lim * lim
    local disc = B * B - 4 * A * C
    if A > 0 and disc >= 0 then
        local tt = (-B + math.sqrt(disc)) / (2 * A)
        return x1 + dx * tt, y1 + dy * tt
    end
    return x2, y2
end

--- Camino a pie en el minimapa (Navigation/Walk.lua): los tramos que quedan, hasta el borde. -> true si lo dibuja
function MapLines:MinimapWalk(owner, cfg, project, radius, square, pinst, px, py)
    local n = 0
    local walk = QR.Walk and QR.Walk:Remaining(px, py, pinst, QR.target)
    if walk and #walk >= 2 then
        local lim = radius - MM_EDGE
        local prev = { 0, 0 }
        for i = 2, #walk do
            local x2, y2 = project(walk[i].x, walk[i].y)
            if not x2 then break end
            local x1, y1 = prev[1], prev[2]
            -- el tramo que sale del minimapa se corta en el borde (y ahi se acaba)
            local out = OutsideEdge(x2, y2, lim, square)
            local ex, ey = x2, y2
            if out then ex, ey = CutAtEdge(x1, y1, x2, y2, lim, square) end
            local dx, dy = ex - x1, ey - y1
            local len = math.sqrt(dx * dx + dy * dy)
            if len > 1 then
                if n == 0 then   -- el primer trozo no tapa la flecha del jugador
                    local cut = math.min(len * 0.5, 7)
                    x1, y1, len = x1 + dx / len * cut, y1 + dy / len * cut, len - cut
                end
                n = n + 1
                local l = owner.walkLines[n]
                if not l then
                    l = NewAnimatedLine(owner, "ARTWORK")
                    owner.walkLines[n] = l
                end
                l:SetStartPoint("CENTER", Minimap, x1, y1)
                l:SetEndPoint("CENTER", Minimap, ex, ey)
                PaintLine(l, len, cfg.thicknessMinimap or 4, cfg.alphaMinimap or 0.9)
                l:Show()
            end
            if out then break end
            prev = { x2, y2 }
        end
    end
    for k = n + 1, owner.nWalk do owner.walkLines[k]:Hide() end
    owner.nWalk = n
    return n > 0
end

local function HideMinimap(owner)
    owner.line:Hide()
    owner.marker:Hide()
    for k = 1, owner.nWalk do owner.walkLines[k]:Hide() end
    owner.nWalk = 0
end

function MapLines:UpdateMinimap()
    local owner = self.mm
    local cfg = QR.db.lines
    local t = QR.target
    if not (t and t.wx and cfg.minimap and QR.db.enabled) or (UnitOnTaxi and UnitOnTaxi("player")) then
        HideMinimap(owner)
        return
    end
    local project, radius, square, pinst, px, py = MinimapProjection()
    if not project or pinst ~= t.instance then HideMinimap(owner) return end
    local tx, ty = project(t.wx, t.wy)
    if not tx then HideMinimap(owner) return end

    -- marcador: en su sitio o flotando en el borde, en la direccion del destino
    local mlim = radius - MM_MARKER / 2
    local mx, my = tx, ty
    if OutsideEdge(mx, my, mlim, square) then mx, my = ClampToEdge(mx, my, mlim, square) end
    owner.marker:ClearAllPoints()
    owner.marker:SetPoint("CENTER", Minimap, "CENTER", mx, my)
    owner.marker:SetShown(owner.painted and true or false)

    if self:MinimapWalk(owner, cfg, project, radius, square, pinst, px, py) then owner.line:Hide() return end

    -- sin camino: recta hasta el marcador
    local len = math.sqrt(mx * mx + my * my)
    if len < 8 then owner.line:Hide() return end
    local ux, uy = mx / len, my / len
    local cut = 7
    owner.line:SetStartPoint("CENTER", Minimap, ux * cut, uy * cut)
    owner.line:SetEndPoint("CENTER", Minimap, mx - ux * 6, my - uy * 6)
    PaintLine(owner.line, len - cut - 6, cfg.thicknessMinimap or 4, cfg.alphaMinimap or 0.9)
    owner.line:Show()
end

---------------------------------------------------------------------------
-- Cambio de destino
---------------------------------------------------------------------------
function MapLines:OnTargetChanged(t)
    local owner = self.mm
    owner.painted = nil
    owner.marker:Hide()
    if not t or not QR.db.enabled or not QR.db.lines.minimap then return end
    owner.marker:SetSize(MM_MARKER, MM_MARKER)
    PaintMarker(owner.marker, t, MM_MARKER)
    owner.painted = true
end

function MapLines:Init()
    self:CreateMinimap()
    self:CreateWorldMap()
    QR:On("TARGET_CHANGED", function(t) MapLines:OnTargetChanged(t); MapLines:InvalidateWorld() end)
    QR:On("SETTINGS_CHANGED", function() MapLines:OnTargetChanged(QR.target); MapLines:InvalidateWorld() end)
    QR:On("WALK_PATH", function() MapLines:InvalidateWorld() end)
    QR:On("SKIN_CHANGED", function() MapLines:InvalidateWorld() end)
    QR:On("HISTORY_CHANGED", function()
        MapLines:InvalidateWorld()   -- (numero del paso en el marcador)
        if QR.target and MapLines.mm.painted then PaintMarker(MapLines.mm.marker, QR.target, MM_MARKER) end
    end)
    self:OnTargetChanged(QR.target)
end

QR:RegisterModule("MapLines", function() MapLines:Init() end)

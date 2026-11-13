-- QuestieRouter: ventana de la guia, estilo "Round - Minimal" de Fusion.
--
--   [ Tarjeta activa ]  que hay que hacer ahora, con contadores ("te faltan 3") y numero de paso
--   [ Banner ]          ilustracion de la zona con ciclo dia/noche, nombre de la zona y niveles
--   [ Lista ]           pasos hechos (atenuados), el actual (resaltado) y los proximos
--   [ Pie ]             recuento y pestañas Pasos / Misiones
--
-- Sin marco: solo tarjetas redondeadas sobre el mundo. Los botones del banner aparecen al pasar el raton.

local _, QR = ...
local L = QR.L

local UI = {}
QR.GuideUI = UI

local GAP = 4
local PAD = 10
local NUMBER_W = 34

-- motivo del paso (clave interna del planificador) -> clave de traduccion
local REASON_TEXT = {
    hub = "at this spot", desvio = "on the way", campo = "objective area",
    entregar = "pending turn-ins", ["siguiente hub"] = "next group of quests",
    elegido = "step chosen by you", ["en curso"] = "in progress",
    ciudad = "turn-ins in this city first",
}

local function Skin() return QR.Skin end

---------------------------------------------------------------------------
-- Texto de cada paso
---------------------------------------------------------------------------
local function LinesText(lines, dim, section)
    local S = Skin()
    local out = {}
    for _, l in ipairs(lines) do
        local icon = S:IconTag(l.done and "complete" or l.icon, S:IconSize(section), S:SectionTextSize(section))
        if dim or l.done then
            out[#out + 1] = icon .. " " .. S.TEXT.done .. l.text .. "|r"
        else
            out[#out + 1] = icon .. " " .. l.text
        end
    end
    return table.concat(out, "\n")
end

local function StepText(step, dim, section)
    local T = Skin().TEXT
    local sec = Skin():Section(section)
    -- content: "BOTH" (descripcion y requisitos) | "DESC" (solo descripcion) | "REQ" (solo requisitos)
    local mode = sec and sec.content or "BOTH"
    local showDesc = mode ~= "REQ"
    local showReq = mode ~= "DESC"
    local head
    if step.kind == "pickup" then
        head = string.format(L["Talk to %s%s|r and accept:"], T.friendly, step.npc or "?")
    elseif step.kind == "turnin" then
        head = string.format(L["Turn in to %s%s|r:"], T.friendly, step.npc or "?")
    else
        head = (showDesc and step.description and step.description ~= "" and step.description) or step.questName
        if showDesc and step.description and step.questName then
            head = string.format("%s%s|r\n%s", T.warn, step.questName, step.description)
        end
        -- mision de elite (ya cogida): la calavera de elite delante del titulo
        if step.questIds and QR.Bridge:IsDungeonQuest(step.questIds[1]) then
            head = Skin():IconTag("dungeon", Skin():IconSize(section), Skin():SectionTextSize(section, 1)) .. " " .. (head or "")
        end
        if step.questIds and QR.Bridge:IsEliteQuest(step.questIds[1]) then
            head = Skin():IconTag("elite", Skin():IconSize(section), Skin():SectionTextSize(section, 1)) .. " " .. (head or "")
        end
    end
    if dim then head = T.done .. (head or ""):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "") .. "|r" end
    -- requisitos (contadores de objetivos); en coger / entregar las lineas son las misiones: siempre
    local body = (showReq or step.kind ~= "objective") and LinesText(step.lines, dim, section) or ""
    return (head or "") .. (body ~= "" and ("\n" .. body) or "")
end

local HISTORY_HEAD = { pickup = "Accepted", objective = "Objectives completed", turnin = "Turned in" }
local HISTORY_ICON = { pickup = "accept", objective = "complete", turnin = "turnin" }

local function HistoryText(entry)
    local T = Skin().TEXT
    local out = { T.done .. (HISTORY_HEAD[entry.kind] and L[HISTORY_HEAD[entry.kind]] or "") .. ":|r" }
    for _, l in ipairs(entry.lines) do
        out[#out + 1] = Skin():IconTag(HISTORY_ICON[entry.kind] or "complete", Skin():IconSize("list"), Skin():SectionTextSize("list")) .. " " .. T.done .. l .. "|r"
    end
    return table.concat(out, "\n")
end

---------------------------------------------------------------------------
-- Tarjetas
---------------------------------------------------------------------------
local function NewCard(parent)
    local S = Skin()
    local card = S:CreateCard(parent)
    card.bar = card:CreateTexture(nil, "BORDER")
    card.bar:SetPoint("TOPLEFT"); card.bar:SetPoint("BOTTOMLEFT")
    card.bar:SetWidth(3)
    card.bar:SetColorTexture(1, 1, 1, 1)
    card.text = card:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    card.text:SetPoint("TOPLEFT", PAD, -7)
    card.text:SetJustifyH("LEFT")
    card.text:SetJustifyV("TOP")
    card.text:SetWordWrap(true)
    card.text:SetSpacing(2)
    card.num = card:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    -- columna de ancho fijo y centrada: las cifras de LizeUI tienen anchos distintos y el "1", pegado a la
    -- derecha, quedaba desplazado respecto al "2" o el "3"
    card.num:SetPoint("RIGHT", card, "RIGHT", -PAD + 4, 0)
    card.num:SetWidth(NUMBER_W - 4)
    card.num:SetJustifyH("CENTER")
    card.chevron = card:CreateTexture(nil, "OVERLAY")
    card.chevron:SetTexture(S:UIIcon("ArrowLeft"))
    card.chevron:SetSize(12, 12)
    card.chevron:SetPoint("RIGHT", card.num, "LEFT", -4, 0)
    card.hover = card:CreateTexture(nil, "BORDER", nil, 1)
    card.hover:SetAllPoints()
    card.hover:SetColorTexture(1, 1, 1, 0.06)
    card.hover:Hide()
    card:SetScript("OnEnter", function(self) if self.onClick then self.hover:Show() end end)
    card:SetScript("OnLeave", function(self) self.hover:Hide() end)
    card:EnableMouse(true)
    card:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" and self.onClick then self.onClick() end
        if button == "RightButton" and self.onRightClick then self.onRightClick() end
    end)
    return card
end

--- style: "done" | "current" | "next" | "active"
local function PaintCard(card, style, width)
    local S = Skin()
    -- la tarjeta de arriba tiene sus propios ajustes; el resto usan los de la lista de pasos
    local section = style == "active" and "active" or "list"
    S:StyleText(card.text, "body", section)
    S:StyleText(card.num, "number", section)
    card.text:SetWidth(width - PAD - NUMBER_W - PAD)
    local comp = (style == "current" or style == "active") and "active" or "card"
    card.qrComp, card.qrAlpha, card.qrSection = comp, style == "done" and 0.75 or 1, section
    S:PaintCard(card, comp, card.qrAlpha, section)
    local ar, ag, ab = S:Color("accent")
    card.bar:SetVertexColor(ar, ag, ab, 0.9)
    card.bar:SetShown(style == "current" or style == "active")
    S:SetRounded(card, card.bar)
    -- el brillo al pasar el raton tambien con las esquinas redondeadas (si no, se iluminan esquinas que no existen)
    S:SetRounded(card, card.hover)
    card.chevron:SetVertexColor(ar, ag, ab)
    card.chevron:SetTexture(S:UIIcon("ArrowLeft"))
    card.chevron:ClearAllPoints()
    card.chevron:SetPoint("RIGHT", card.num, "LEFT", -4, 0)
    card.chevron:SetShown(style == "current")
    card.onClick = nil
    card.onRightClick = nil
    if style == "done" then
        card.num:SetTextColor(0.5, 0.52, 0.5)
    elseif style == "current" or style == "active" then
        card.num:SetTextColor(S:TextAccent(0.68))
    else
        card.num:SetTextColor(0.85, 0.87, 0.85)
    end
    card.text:SetTextColor(S:Color("text"))
    card:SetHeight(math.max(26, card.text:GetStringHeight() + 14))
end

---------------------------------------------------------------------------
-- Botones del banner (aparecen al pasar el raton)
---------------------------------------------------------------------------
local function IconButton(parent, icon, tip, onClick)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(18, 18)
    b.icon = b:CreateTexture(nil, "OVERLAY")
    b.icon:SetAllPoints()
    b.icon:SetTexture(Skin():UIIcon(icon))
    -- color en reposo (un boton puede cambiarlo, p. ej. el candado cuando esta bloqueado)
    b.BaseColor = function() return 0.9, 0.92, 0.9 end
    b.icon:SetVertexColor(b.BaseColor())
    b:SetScript("OnClick", onClick)
    b:SetScript("OnEnter", function(self)
        local r, g, bl = self.BaseColor()
        self.icon:SetVertexColor(math.min(1, r + 0.15), math.min(1, g + 0.15), math.min(1, bl + 0.15))
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:AddLine(type(tip) == "function" and tip() or tip)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function(self) self.icon:SetVertexColor(self.BaseColor()); GameTooltip:Hide() end)
    return b
end

---------------------------------------------------------------------------
-- Construccion
---------------------------------------------------------------------------
function UI:Create()
    local S = Skin()
    local f = CreateFrame("Frame", "QuestieRouterGuideFrame", UIParent)
    -- misma capa que el seguimiento de misiones y la mochila (MEDIUM), pero con un nivel alto: queda por encima
    -- del seguimiento (Questie lo pone a nivel 0); la mochila se sube al abrirse (ver RaiseBagsOnShow)
    f:SetFrameStrata("MEDIUM")
    f:SetFrameLevel(20)
    f:SetToplevel(true)
    -- Punto de fijado = el banner (imagen y cielo). Un marco invisible del tamaño del banner guarda la posicion
    -- (QR.db.guideWindow.point) y la ventana cuelga de el: la tarjeta de arriba crece hacia arriba y la lista y
    -- el pie quedan siempre debajo del banner, asi nada se mueve aunque cambie el alto de la tarjeta.
    local anchor = CreateFrame("Frame", "QuestieRouterGuideAnchor", UIParent)
    anchor:SetSize(QR.db.skin.width, QR.db.skin.bannerHeight)
    anchor:SetClampedToScreen(true)
    anchor:SetMovable(true)
    local p = QR.db.guideWindow.point
    anchor:SetPoint(p[1], UIParent, p[3], p[4], p[5])
    self.anchor = anchor
    -- WoW guarda la posicion de los marcos con nombre que se han arrastrado (layout-local.txt) y la restaura
    -- al entrar, soltando la ventana del ancla: la posicion la guarda solo el addon (QR.db.guideWindow.point)
    for _, fr in ipairs({ f, anchor }) do
        if fr.SetUserPlaced then pcall(fr.SetUserPlaced, fr, false) end
        if fr.SetDontSavePosition then pcall(fr.SetDontSavePosition, fr, true) end
    end
    f:SetMovable(true)
    f:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, 0)
    self.frame = f

    -- 1. Tarjeta activa
    f.active = NewCard(f)
    f.active:SetPoint("TOPLEFT")
    f.active:SetPoint("TOPRIGHT")

    -- 2. Banner
    f.banner = QR.Banner:Create(f)
    f.banner:EnableMouse(true)
    -- clic derecho en la imagen: menu principal (guias disponibles + configuracion)
    f.banner:SetScript("OnMouseUp", function(_, button)
        if button == "RightButton" then QR.Menu:OpenMain() end
    end)
    f.banner:RegisterForDrag("LeftButton")
    -- se arrastra el ancla (el banner); la ventana la sigue
    f.banner:SetScript("OnDragStart", function() if not QR.db.guideWindow.locked then anchor:StartMoving() end end)
    f.banner:SetScript("OnDragStop", function()
        anchor:StopMovingOrSizing()
        UI:SaveAnchor()
    end)

    local controls = CreateFrame("Frame", nil, f.banner)
    controls:SetSize(120, 18)
    controls:SetPoint("BOTTOMRIGHT", -8, 6)
    controls:SetFrameLevel(f.banner:GetFrameLevel() + 5)
    local lock = IconButton(controls, "Lock", function()
        return QR.db.guideWindow.locked and L["Locked: click to unlock"] or L["Lock position and size"]
    end, function() UI:SetLocked(not QR.db.guideWindow.locked) end)
    -- (se coloca abajo, a la izquierda de los vuelos)
    -- bloqueado: candado cerrado en dorado; desbloqueado: candado abierto en gris
    lock.BaseColor = function()
        if QR.db.guideWindow.locked then return 1, 0.78, 0.25 end
        return 0.62, 0.65, 0.63
    end
    f.lock = lock
    local menu = IconButton(controls, "Menu", L["Menu (also right-click on the picture)"], function() QR.Menu:OpenMain() end)
    menu:SetPoint("RIGHT")
    local cog = IconButton(controls, "Cog", L["Graphics options"], function() QR.Options:Toggle() end)
    cog:SetPoint("RIGHT", menu, "LEFT", -4, 0)
    -- vuelos en las rutas de viaje: blanco activado, rojo desactivado
    local flights = IconButton(controls, "Gryphon", function()
        return QR.db.travel.flights and L["Flight routes: on (click to stop using them)"] or L["Flight routes: off (click to use them)"]
    end, function(self)
        QR.db.travel.flights = not QR.db.travel.flights
        self.icon:SetVertexColor(self.BaseColor())
        if self:IsMouseOver() then self:GetScript("OnEnter")(self) end
        QR:Fire("SETTINGS_CHANGED")
        if QR.Target then QR.Target:Refresh(true) end
    end)
    flights.BaseColor = function()
        if QR.db.travel.flights then return 0.92, 0.94, 0.92 end
        return 0.95, 0.28, 0.25
    end
    flights.icon:SetVertexColor(flights.BaseColor())
    flights:SetPoint("RIGHT", cog, "LEFT", -4, 0)
    lock:SetPoint("RIGHT", flights, "LEFT", -4, 0)
    -- ir al paso actual: vuelve a colocar la lista en el paso en el que estas
    local toCurrent = IconButton(controls, "ScrollTop", L["Go to the current step"], function() UI:ScrollToCurrent() end)
    toCurrent:SetPoint("RIGHT", lock, "LEFT", -4, 0)
    f.flights = flights
    controls:SetAlpha(0)
    f.controls = controls

    -- Mostrar controles solo con el raton encima (como el preset Round - Minimal)
    local hoverAcc = 0
    f:SetScript("OnUpdate", function(_, elapsed)
        hoverAcc = hoverAcc + elapsed
        if hoverAcc < 0.05 then return end
        hoverAcc = 0
        local want = (f:IsMouseOver() or (QR.Options.frame and QR.Options.frame:IsShown())) and 1 or 0
        local a = controls:GetAlpha()
        if a ~= want then controls:SetAlpha(want > a and math.min(1, a + 0.25) or math.max(0, a - 0.15)) end
        -- asa de redimensionar: igual, pero oculta si la ventana esta bloqueada
        local grip = f.grip
        if grip then
            local gwant = ((f:IsMouseOver() or grip.dragging) and not QR.db.guideWindow.locked) and 1 or 0
            local ga = grip:GetAlpha()
            if ga ~= gwant then grip:SetAlpha(gwant > ga and math.min(1, ga + 0.25) or math.max(0, ga - 0.15)) end
            grip:EnableMouse(gwant == 1 or ga > 0)
        end
    end)

    -- 3. Lista con scroll (rueda del raton, sin barra visible)
    local scroll = CreateFrame("ScrollFrame", nil, f)
    scroll:SetPoint("TOPLEFT", f.banner, "BOTTOMLEFT", 0, -GAP)
    scroll:SetPoint("TOPRIGHT", f.banner, "BOTTOMRIGHT", 0, -GAP)
    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(self, delta)
        local max = math.max(0, self.content:GetHeight() - self:GetHeight())
        self:SetVerticalScroll(math.max(0, math.min(max, self:GetVerticalScroll() - delta * 40)))
        self.userScrolled = true
    end)
    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(10, 10)
    scroll:SetScrollChild(content)
    scroll.content = content
    f.scroll = scroll
    f.cards = {}
    f.rows = {}

    -- 4. Pie
    local FLIGHT_ICON_SPACE = 24   -- hueco a la izquierda de la barra de vuelo para el icono
    f.footer = S:CreateCard(f)
    f.footer:SetPoint("TOPLEFT", scroll, "BOTTOMLEFT", 0, -GAP)
    f.footer:SetPoint("TOPRIGHT", scroll, "BOTTOMRIGHT", 0, -GAP)
    f.footer.flightIconSpace = FLIGHT_ICON_SPACE
    f.footer:SetHeight(22)
    -- icono de brujula (el del objeto "Una sencilla brujula") pegado a la izquierda mientras vuelas: cuadrado
    -- de todo el alto del pie; con la mascara del pie le tocan las esquinas redondeadas de la izquierda
    -- (arriba y abajo) y el lado derecho queda recto, junto a la barra
    f.footer.flightIcon = f.footer:CreateTexture(nil, "ARTWORK", nil, 2)
    f.footer.flightIcon:SetTexture(QR.Skin.MEDIA .. "Icons\\Compass.tga")
    f.footer.flightIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)   -- sin el marco del icono
    f.footer.flightIcon:SetPoint("TOPLEFT", 0, 0)
    f.footer.flightIcon:SetPoint("BOTTOMLEFT", 0, 0)
    f.footer.flightIcon:SetWidth(FLIGHT_ICON_SPACE)
    f.footer.flightIcon:Hide()
    -- barra de vuelo: sustituye al pie mientras vuelas (se vacia con el tiempo restante); empieza tras el icono
    f.footer.flightBar = f.footer:CreateTexture(nil, "ARTWORK", nil, 1)
    f.footer.flightBar:SetPoint("TOPLEFT", f.footer.flightIcon, "TOPRIGHT", 0, 0)
    f.footer.flightBar:SetPoint("BOTTOMLEFT", f.footer.flightIcon, "BOTTOMRIGHT", 0, 0)
    f.footer.flightBar:SetColorTexture(1, 1, 1, 1)
    f.footer.flightBar:Hide()
    f.footer.flightTime = f.footer:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.footer.flightTime:SetPoint("RIGHT", -PAD, 0)
    f.footer.flightTime:Hide()
    f.footer.flightText = f.footer:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.footer.flightText:SetPoint("LEFT", f.footer.flightIcon, "RIGHT", 6, 0)
    f.footer.flightText:SetPoint("RIGHT", f.footer.flightTime, "LEFT", -6, 0)
    f.footer.flightText:SetJustifyH("LEFT")
    f.footer.flightText:SetWordWrap(false)
    f.footer.flightText:Hide()
    local flightAcc = 0
    f.footer:SetScript("OnUpdate", function(_, elapsed)
        flightAcc = flightAcc + elapsed
        if flightAcc < 0.1 then return end
        flightAcc = 0
        UI:PaintFlight()
    end)
    f.footer.text = f.footer:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.footer.text:SetPoint("LEFT", PAD, 0)
    f.footer.tabs = {}
    for i, def in ipairs({ { "steps", L["Steps"] }, { "quests", L["Quests"] } }) do
        local b = CreateFrame("Button", nil, f.footer)
        b:SetHeight(18)
        b.text = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        b.text:SetPoint("CENTER")
        b.text:SetText(def[2])
        b.view = def[1]
        b:SetScript("OnClick", function() UI.view = def[1]; f.scroll.userScrolled = nil; UI:Refresh() end)
        f.footer.tabs[i] = b
    end
    f.footer.tabs[2]:SetPoint("RIGHT", -PAD - 14, 0)
    f.footer.tabs[1]:SetPoint("RIGHT", f.footer.tabs[2], "LEFT", -10, 0)

    -- 5. Asa de redimensionar (esquina inferior derecha, solo visible con el raton encima)
    local grip = CreateFrame("Button", nil, f)
    grip:SetSize(16, 16)
    grip:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -3, 3)
    grip:SetFrameLevel(f:GetFrameLevel() + 20)
    grip.icon = grip:CreateTexture(nil, "OVERLAY")
    grip.icon:SetAllPoints()
    grip.icon:SetTexture(S:UIIcon("Resize"))
    grip.icon:SetVertexColor(0.8, 0.82, 0.8)
    grip:SetAlpha(0)
    grip:SetScript("OnEnter", function(self)
        self.icon:SetVertexColor(Skin():Color("accent"))
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(L["Click and drag to resize"])
        GameTooltip:Show()
    end)
    grip:SetScript("OnLeave", function(self)
        if not self.dragging then self.icon:SetVertexColor(0.8, 0.82, 0.8) end
        GameTooltip:Hide()
    end)
    grip:SetScript("OnMouseDown", function(self, button)
        if button ~= "LeftButton" or QR.db.guideWindow.locked then return end
        -- fijar la esquina superior izquierda del banner para que crezca hacia donde se arrastra
        local a = UI.anchor
        local left, top = a:GetLeft(), a:GetTop()
        a:ClearAllPoints()
        a:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
        local scale = f:GetEffectiveScale()
        local cx, cy = GetCursorPosition()
        self.start = { x = cx / scale, y = cy / scale, width = QR.db.skin.width, list = QR.db.skin.listHeight }
        self.dragging = true
        GameTooltip:Hide()
        local acc = 0
        self:SetScript("OnUpdate", function(_, elapsed)
            local x, y = GetCursorPosition()
            x, y = x / scale, y / scale
            local s = QR.db.skin
            s.width = math.floor(math.max(240, math.min(440, self.start.width + (x - self.start.x))))
            s.listHeight = math.floor(math.max(120, math.min(700, self.start.list + (self.start.y - y))))
            UI:Layout()
            -- re-ajustar los textos (el ancho cambia el salto de linea) sin hacerlo cada fotograma
            acc = acc + elapsed
            if acc > 0.05 then acc = 0; UI:Refresh() end
        end)
    end)
    grip:SetScript("OnMouseUp", function(self)
        if not self.dragging then return end
        self.dragging = nil
        self:SetScript("OnUpdate", nil)
        self.icon:SetVertexColor(0.8, 0.82, 0.8)
        UI:SaveAnchor()
        QR:Fire("SETTINGS_CHANGED")
    end)
    f.grip = grip

    self.view = "steps"
end

---------------------------------------------------------------------------
-- Pintado
---------------------------------------------------------------------------
--- Guarda la posicion del ancla (el banner)
function UI:SaveAnchor()
    local point, _, relPoint, x, y = self.anchor:GetPoint(1)
    QR.db.guideWindow.point = { point, "UIParent", relPoint, x, y }
end

function UI:Layout()
    local f, s = self.frame, QR.db.skin
    f:SetWidth(s.width)
    if self.anchor then self.anchor:SetSize(s.width, s.bannerHeight) end
    f.banner:SetHeight(s.bannerHeight)
    f.scroll:SetHeight(s.listHeight)
    f.scroll.content:SetWidth(s.width)
    f.banner:StyleTexts()
    for _, b in ipairs(f.footer.tabs) do
        Skin():StyleText(b.text, "small", "footer")
        b:SetWidth(b.text:GetStringWidth() + 6)
    end
    Skin():StyleText(f.footer.text, "small", "footer")
    local h = math.max(22, math.floor((QR.db.skin.footer.textSize or 11) * 0.85 + 12))
    -- volando, el pie crece si los textos de la barra de vuelo son mas grandes
    if f.footer.flyingShown then
        local textSize, timeSize = self:FlightSizes()
        h = math.max(h, math.floor(math.max(textSize, timeSize) + 10))
    end
    f.footer:SetHeight(h)
end

--- Tamaños de la barra de vuelo (Opciones -> Configuracion tiempos viaje): destino y tiempo restante.
--- Sin elegir, los de siempre (texto pequeño del pie y tamaño del reloj).
function UI:FlightSizes()
    local s, t = QR.db.skin, QR.db.travel
    local textSize = t.flightTextSize or (s.footer.textSize or s.textSize) * 0.85
    local timeSize = t.flightTimeSize or s.clockSize or s.textSize * 0.85
    return textSize, timeSize
end

--- Datos del vuelo: destino, segundos restantes, total y transcurridos (nil si no vuelas).
--- Con el simulador de Opciones activo (QR.flightPreview = momento en que se encendio) da un vuelo
--- de prueba que se repite, aunque no estes volando ni este activada la barra.
local PREVIEW_FLIGHT = 75
function UI:FlightData()
    if QR.flightPreview then
        local t = (GetTime() - QR.flightPreview) % PREVIEW_FLIGHT
        return L["Preview destination"], PREVIEW_FLIGHT - t, PREVIEW_FLIGHT, t
    end
    if QR.Router and QR.db.travel.flightBar ~= false then return QR.Router:FlightInfo() end
end

function UI:PaintColors()
    local f = self.frame
    if not f then return end
    local S = Skin()
    local tr = S.transition
    f.banner:SetZone(S.key, tr and tr.fromKey, tr and tr.fraction or 1)
    S:PaintCard(f.footer, "card", 1, "footer")
    for _, b in ipairs(f.footer.tabs) do
        if b.view == self.view then b.text:SetTextColor(S:TextAccent()) else b.text:SetTextColor(0.7, 0.72, 0.7) end
    end
    f.footer.text:SetTextColor(0.75, 0.78, 0.75)
    -- recolorear tarjetas existentes sin reconstruirlas (fundido de zona)
    local ar, ag, ab = S:Color("accent")
    for _, card in ipairs(f.cards) do
        if card:IsShown() and card.qrComp then
            S:PaintCard(card, card.qrComp, card.qrAlpha, card.qrSection)
            card.bar:SetVertexColor(ar, ag, ab, 0.9)
            card.chevron:SetVertexColor(ar, ag, ab)
        end
    end
    if f.active.qrComp then
        S:PaintCard(f.active, f.active.qrComp, f.active.qrAlpha, "active")
        f.active.bar:SetVertexColor(ar, ag, ab, 0.9)
    end
end

function UI:GetCard(i)
    local f = self.frame
    local c = f.cards[i]
    if not c then
        c = NewCard(f.scroll.content)
        f.cards[i] = c
    end
    return c
end

---------------------------------------------------------------------------
-- Viaje hasta la guia (vuelos, barcos...): etapas que salen antes de los pasos
---------------------------------------------------------------------------
local function TravelRoute()
    local t = QR.target
    return t and t.kind == "travel" and t.route and #t.route.steps > 0 and t.route or nil
end

local TRAVEL_ICON = { walk = "walk", flight = "Gryphon", boat = "Boat", zeppelin = "Boat", airship = "Boat" }

--- Icono de la etapa en el hueco del numero
local function TravelIcon(ts, section)
    local S = Skin()
    local key = TRAVEL_ICON[ts.kind] or "Boat"
    local path = S.ICON[key] or S:UIIcon(key)
    local size = math.floor((S:Section(section) and S:Section(section).numberSize or 15) * 1.1)
    return string.format("|T%s:%d:%d|t", path, size, size)
end

function UI:PaintActive(plan, number)
    local f = self.frame
    local S = Skin()
    local T = S.TEXT
    local card = f.active
    local step = plan and plan.currentStep
    local text
    local travel = TravelRoute()
    if travel then
        local out = { travel.steps[1].text }
        for k = 2, #travel.steps do
            out[#out + 1] = T.done .. travel.steps[k].text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("\n", " · ") .. "|r"
        end
        card.text:SetText(table.concat(out, "\n"))
        card.num:SetText(TravelIcon(travel.steps[1], "active"))
        PaintCard(card, "active", QR.db.skin.width)
        return
    end
    if step then
        text = StepText(step, false, "active")
        local extra = {}
        local showExtra = QR.db.skin.active.extra ~= false
        if step.kind == "objective" and step.remaining then
            if step.remaining > 0 then
                extra[#extra + 1] = string.format(L["%s%d left|r of %d"], T.warn, step.remaining, step.total)
            end
        elseif step.kind == "pickup" then
            extra[#extra + 1] = string.format(L["%s%d quest(s) to pick up here|r"], T.warn, #step.questIds)
        elseif step.kind == "turnin" then
            extra[#extra + 1] = string.format(L["%s%d quest(s) to turn in|r"], T.warn, #step.questIds)
        end
        local d = plan.current and plan.current.dist
        if d and d < 1e6 then
            extra[#extra + 1] = string.format("%s%d yd · %s|r", T.done, d, REASON_TEXT[plan.reason] and L[REASON_TEXT[plan.reason]] or plan.reason or "")
        end
        if showExtra and #extra > 0 then text = text .. "\n" .. table.concat(extra, "   ") end
        -- aviso: algo que recoger de otra mision muy cerca (no cambia el paso)
        if plan.nearby then text = text .. "\n" .. string.format(L["%sWatch out:|r pick up %s"], T.warn, plan.nearby.text) end
        card.num:SetText(number)
    else
        text = (plan and plan.message) or L["Choose a zone to start."]
        card.num:SetText("")
    end
    card.text:SetText(text)
    PaintCard(card, "active", QR.db.skin.width)
end

function UI:FillSteps(plan)
    local width = QR.db.skin.width
    local h = QR.Steps.History(false)
    local entries = h and h.entries or {}
    local count = h and h.count or 0
    local doneVisible = QR.db.skin.doneVisible
    local y, i = 0, 0
    local currentTop

    for k = math.max(1, #entries - doneVisible + 1), #entries do
        i = i + 1
        local card = self:GetCard(i)
        card.text:SetText(HistoryText(entries[k]))
        card.num:SetText(entries[k].number)
        PaintCard(card, "done", width)
        card:ClearAllPoints()
        card:SetPoint("TOPLEFT", 0, -y)
        card:SetWidth(width)
        card:Show()
        y = y + card:GetHeight() + GAP
    end
    local travel = TravelRoute()
    for n, ts in ipairs(travel and travel.steps or {}) do
        i = i + 1
        local card = self:GetCard(i)
        card.text:SetText(ts.text)
        card.num:SetText(TravelIcon(ts, "list"))
        PaintCard(card, n == 1 and "current" or "next", width)
        card.onRightClick = nil
        card:ClearAllPoints()
        card:SetPoint("TOPLEFT", 0, -y)
        card:SetWidth(width)
        card:Show()
        if n == 1 then currentTop = y end
        y = y + card:GetHeight() + GAP
    end
    local maxSteps = QR.db.skin.list.maxSteps or 14
    for n, step in ipairs(plan and plan.steps or {}) do
        if n > maxSteps then break end
        i = i + 1
        local card = self:GetCard(i)
        card.text:SetText(StepText(step, false, "list"))
        card.num:SetText(count + n)
        PaintCard(card, (n == 1 and not travel) and "current" or "next", width)
        card.onRightClick = function() UI:StepMenu(step, count + n) end
        card:ClearAllPoints()
        card:SetPoint("TOPLEFT", 0, -y)
        card:SetWidth(width)
        card:Show()
        if n == 1 and not travel then currentTop = y end
        y = y + card:GetHeight() + GAP
    end
    for k = i + 1, #self.frame.cards do self.frame.cards[k]:Hide() end
    for _, r in ipairs(self.frame.rows) do r:Hide() end
    self.frame.scroll.content:SetHeight(math.max(10, y))
    -- coloca la lista con el PASO ACTUAL arriba del todo (salvo que el jugador haya movido la rueda).
    -- Nada queda cortado por encima: los pasos hechos estan justo arriba y se ven subiendo con la rueda.
    if currentTop and not self.frame.scroll.userScrolled then
        local max = math.max(0, y - self.frame.scroll:GetHeight())
        self.frame.scroll:SetVerticalScroll(math.min(max, math.max(0, currentTop)))
    end
end

---------------------------------------------------------------------------
-- Navegacion sin guia: categorias -> guias de la categoria (con "Atras")
---------------------------------------------------------------------------
local function BrowseCard(self, i, y, text, style, chevron, onClick)
    local width = QR.db.skin.width
    local card = self:GetCard(i)
    card.text:SetText(text)
    card.num:SetText("")
    PaintCard(card, style, width)
    if chevron then
        card.chevron:SetTexture(Skin():UIIcon(chevron))
        card.chevron:SetVertexColor(0.9, 0.92, 0.9)
        -- en las tarjetas de navegacion no hay numero: la flecha va pegada al borde derecho
        card.chevron:ClearAllPoints()
        card.chevron:SetPoint("RIGHT", card, "RIGHT", -PAD, 0)
        card.chevron:Show()
    end
    card.onClick = onClick
    card:ClearAllPoints()
    card:SetPoint("TOPLEFT", 0, -y)
    card:SetWidth(width)
    card:Show()
    return y + card:GetHeight() + GAP
end

function UI:FillBrowse()
    local T = Skin().TEXT
    local y, i = 0, 0
    local cat = self.browseCategory
    if not cat then
        for _, c in ipairs(QR.guideCategories) do
            i = i + 1
            local empty = #c.guides == 0
            local text = string.format("%s%s|r\n%s%s|r", empty and T.done or "|cffffffff", L[c.name],
                T.done, empty and L["Coming soon"] or (L[c.desc] .. " · " .. string.format(L["%d guides"], #c.guides)))
            y = BrowseCard(self, i, y, text, "next", not empty and "ArrowRight" or nil,
                not empty and function() UI.browseCategory = c; UI.frame.scroll:SetVerticalScroll(0); UI:Refresh() end or nil)
        end
    else
        i = i + 1
        y = BrowseCard(self, i, y, Skin():Hex("accent") .. L["Back"] .. "|r", "done", "ArrowLeft",
            function() UI.browseCategory = nil; UI.frame.scroll:SetVerticalScroll(0); UI:Refresh() end)
        local level = UnitLevel("player")
        local suggested = QR:SuggestZoneGuide()
        local suggestedY
        for _, g in ipairs(cat.guides) do
            i = i + 1
            local color = (level < g.minLevel and T.enemy) or (level > g.maxLevel and T.done) or T.friendly
            local badge = g == suggested and ("  " .. T.warn .. L["recommended"] .. "|r") or ""
            local text = string.format(L["|cffffffff%s|r%s\n%sLevels %d-%d|r%s · %d quests|r"],
                g.title or QR.GuideLabel(g), badge, color, g.minLevel, g.maxLevel, T.done, #g.quests)
            if g == suggested then suggestedY = y end
            y = BrowseCard(self, i, y, text, g == suggested and "current" or "next", "ArrowRight",
                function() QR.Planner:SetGuide(g.key) end)
        end
        if suggestedY and not self.frame.scroll.userScrolled then
            local max = math.max(0, y - self.frame.scroll:GetHeight())
            self.frame.scroll:SetVerticalScroll(math.min(max, math.max(0, suggestedY - 60)))
        end
    end
    for k = i + 1, #self.frame.cards do self.frame.cards[k]:Hide() end
    for _, r in ipairs(self.frame.rows) do r:Hide() end
    self.frame.scroll.content:SetHeight(math.max(10, y))
end

local STATUS = {
    done = { "complete", "|cff7f8a84" }, complete = { "turnin", "|cff71d6a2" }, active = { "combat", "|cffffd166" },
    available = { "accept", "|cffffffff" }, lowlevel = { "clock", "|cffff8178" }, locked = { "error", "|cff606660" },
    skipped = { QR.Skin:UIIcon("Minus"), "|cff8a8f8c" },
    elite = { "elite", "|cffffd166" },   -- (para la leyenda; en las filas va junto al icono de estado)
    dungeon = { "dungeon", "|cffb59cff" },
}

-- Leyenda de los iconos de estado (en el mismo orden en que se ven en una zona). Pares izquierda / derecha;
-- un elemento suelto al final va en la columna derecha (mazmorra debajo de elite).
local LEGEND = {
    { "available", "Available to pick up" }, { "active", "In progress" },
    { "complete", "Ready to turn in" }, { "done", "Done" },
    { "lowlevel", "Level too low" }, { "locked", "Locked (prerequisite)" },
    { "skipped", "Skipped (Shift+click)" }, { "elite", "Elite (group recommended)" },
    { "dungeon", "Dungeon quest", right = true },
}

--- Tarjeta de leyenda arriba de la lista de misiones; clic en el titulo para plegar / desplegar.
--- Va FUERA del scroll (fija, como una cabecera): la lista se desplaza por debajo de ella.
function UI:PaintLegend(width)
    local f = self.frame
    local S = Skin()
    local lg = f.legend
    if not lg then
        lg = NewCard(f)
        lg.title = lg:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        lg.title:SetPoint("TOPLEFT", PAD, -6)
        lg.left = lg:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        lg.right = lg:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        for _, fs in ipairs({ lg.left, lg.right }) do fs:SetJustifyH("LEFT"); fs:SetJustifyV("TOP"); fs:SetSpacing(3) end
        lg.left:SetPoint("TOPLEFT", PAD, -20)
        lg.text:Hide(); lg.num:Hide()
        f.legend = lg
    end
    local open = QR.db.skin.list.legend ~= false
    PaintCard(lg, "next", width)
    lg.text:SetText("")
    lg.onClick = function()
        QR.db.skin.list.legend = not open
        UI:Refresh()
    end
    S:StyleText(lg.title, "eyebrow", "quests")
    -- "LEYENDA" en el color de acento y la indicacion en blanco, para que se vea que se puede plegar
    lg.title:SetText(L["LEGEND"] .. "  |cffffffff" .. (open and L["(click to hide and see more of the list)"] or L["(click to show)"]) .. "|r")
    lg.title:SetTextColor(S:TextAccent())
    lg.left:SetShown(open)
    lg.right:SetShown(open)
    local height = 20
    if open then
        local col = math.floor((width - 2 * PAD) / 2)
        lg.right:SetPoint("TOPLEFT", PAD + col, -20)
        local left, right = {}, {}
        local n = 0   -- posicion entre los que se reparten (los marcados con right no cuentan)
        for _, e in ipairs(LEGEND) do
            local st = STATUS[e[1]]
            local line = string.format("%s %s%s|r", S:IconTag(st[1], S:IconSize("quests"), S:SectionTextSize("quests", 0.85)), st[2], L[e[2]])
            if e.right then right[#right + 1] = line
            else
                n = n + 1
                if n % 2 == 1 then left[#left + 1] = line else right[#right + 1] = line end
            end
        end
        for _, fs in ipairs({ lg.left, lg.right }) do S:StyleText(fs, "small", "quests"); fs:SetWidth(col) end
        lg.left:SetText(table.concat(left, "\n"))
        lg.right:SetText(table.concat(right, "\n"))
        height = 26 + math.max(lg.left:GetStringHeight(), lg.right:GetStringHeight())
    end
    lg:SetHeight(height)
    lg:SetWidth(width)
    lg:ClearAllPoints()
    lg:SetPoint("TOPLEFT", f.banner, "BOTTOMLEFT", 0, -GAP)
    lg:Show()
    return height + GAP
end

--- Ruta manual hasta un NPC u objeto (como /qr dungeon): el router calcula el viaje; se quita al llegar
local function RouteTo(p, label)
    QR.Target:SetManual({ kind = "manual", manual = true, questId = -101, questName = label, name = p.name or "?",
        wx = p.wx, wy = p.wy, instance = p.instance, uiMapId = p.uiMapId, x = p.x, y = p.y })
    QR:Print(string.format(L["Route to %s."], p.name or "?"))
end

--- Aviso en el centro de la pantalla, como los del juego ("Fuera de alcance", "Sales de combate"...)
local function CenterWarning(msg)
    if UIErrorsFrame and UIErrorsFrame.AddMessage then
        UIErrorsFrame:AddMessage(msg, 1.0, 0.25, 0.2, 1.0)
    else
        QR:Print(msg)
    end
    if PlaySound and SOUNDKIT and SOUNDKIT.IG_QUEST_LOG_ABANDON_QUEST then pcall(PlaySound, SOUNDKIT.IG_QUEST_LOG_ABANDON_QUEST) end
end

--- ¿Se puede coger ya? Devuelve true o false + motivo (texto para el aviso)
local function CanPickUp(qid)
    local B, P = QR.Bridge, QR.Planner
    local q = B:GetQuest(qid)
    local name = q and q.name or ("#" .. qid)
    local status = B:QuestStatus(qid)
    if status == "done" then return false, string.format(L["You already did \"%s\"."], name) end
    if status == "active" then return false, string.format(L["You already have \"%s\"."], name) end
    if status == "lowlevel" then
        local req = B.QuestieDB.QueryQuestSingle(qid, "requiredLevel") or 1
        return false, string.format(L["You need level %d to pick up \"%s\"."], req, name)
    end
    if status == "locked" then
        local miss = P:MissingPrereqs(qid)
        if #miss > 0 then return false, string.format(L["\"%s\" can't be picked up yet: first \"%s\"."], name, miss[1].name) end
        -- sin misiones anteriores que falten: el motivo lo dice Questie (raza, clase, profesion, reputacion...)
        local reason = B:LockReason(qid)
        if reason then return false, string.format(L["\"%s\" can't be picked up: %s."], name, reason) end
        return false, string.format(L["\"%s\" can't be picked up yet."], name)
    end
    if P:NotOffered(qid) then return false, string.format(L["The NPC doesn't offer \"%s\" yet."], name) end
    return true
end

--- Cadena entera en el orden en que se hace: las anteriores primero (tambien las ya hechas, para ver por donde
--- vas) y la propia mision al final. De las alternativas (preQuestSingle) solo se sigue una: la que ya hiciste, la
--- que ya se puede coger, una que este personaje pueda llegar a hacer o, si ninguna, la primera (asi no sale la
--- mision inicial de otra raza). Las de preQuestGroup (hacen falta todas) se siguen todas.
local function AltRank(id)
    if CanPickUp(id) then return 3 end
    local _, never = QR.Bridge:LockReason(id)
    return never and 1 or 2
end

local function ChainPath(questId)
    local P = QR.Planner
    local out, seen = {}, {}
    local function visit(id, depth)
        if seen[id] then return end
        seen[id] = true
        if depth < 12 then
            local alt, altRank
            for _, m in ipairs(P:ChainPrereqs(id)) do
                if m.single then
                    local r = AltRank(m.id)
                    if not alt or r > altRank then alt, altRank = m.id, r end
                else
                    visit(m.id, depth + 1)
                end
            end
            if alt then visit(alt, depth + 1) end
        end
        out[#out + 1] = id
    end
    visit(questId, 0)
    return out
end

--- Columna derecha del menu de la cadena: estado de la mision (hecha, en curso, para entregar, disponible,
--- nivel que falta, bloqueada) con su icono, y delante los iconos de elite / mazmorra si lo es
local function ChainStatus(qid)
    local B, S = QR.Bridge, Skin()
    local size, ts = S:IconSize("ui"), S:SectionTextSize("ui", 0.85)
    local status = B:QuestStatus(qid)
    local q = B:GetQuest(qid)
    if status == "active" and q and B:IsQuestComplete(q) then status = "complete" end
    local text
    if status == "done" then text = L["Done"]
    elseif status == "active" then text = L["In progress"]
    elseif status == "complete" then text = L["Ready to turn in"]
    elseif status == "lowlevel" then
        text = string.format(L["Level %d"], B.QuestieDB.QueryQuestSingle(qid, "requiredLevel") or 1)
    elseif status == "locked" then
        -- si no falta ninguna anterior, el motivo de Questie (raza, clase, ya hiciste la alternativa...)
        local reason = #QR.Planner:MissingPrereqs(qid) == 0 and B:LockReason(qid)
        text = reason and (L["Locked"] .. ": " .. reason) or L["Locked"]
    else text = L["Available"] end
    local st = STATUS[status] or STATUS.available
    local tags = ""
    if B:IsEliteQuest(qid) then tags = tags .. S:IconTag("elite", size, ts) .. " " end
    if B:IsDungeonQuest(qid) then tags = tags .. S:IconTag("dungeon", size, ts) .. " " end
    return tags .. S:IconTag(st[1], size, ts) .. " " .. st[2] .. text .. "|r", status
end

--- Entrada del menu "ruta hasta quien da qid": si no se puede coger, avisa en el centro de la pantalla
local function RouteEntry(qid, fmt, label)
    local B = QR.Bridge
    local q = B:GetQuest(qid)
    local px, py, pinst = QR.HBD:GetPlayerWorldPosition()
    local p = q and B:NearestNpcOrObject(q.Starts, px, py, pinst)
    local qname = q and q.name or ("#" .. qid)
    if not p then return { text = string.format(L["%s: no known location"], qname), disabled = true } end
    return { text = string.format(fmt, p.name or "?", qname), icon = "Arrow", func = function()
        local ok, why = CanPickUp(qid)
        if not ok then CenterWarning(why) return end
        RouteTo(p, label or qname)
    end }
end

--- Clic derecho en una mision de la lista: ruta hasta quien da las misiones anteriores de la cadena que faltan,
--- o hasta quien da esta; saltarla / recuperarla; quitar la ruta manual
function UI:QuestRowMenu(questId)
    local B, P = QR.Bridge, QR.Planner
    local quest = B:GetQuest(questId)
    local entries = { { text = quest and quest.name or ("#" .. questId), header = true } }
    -- la cadena en el orden en que hay que hacerla, numerada: 1 = la que ya se puede coger ... N = esta mision.
    -- (cada linea: si al pulsarla aun no se puede coger, sale el aviso rojo y no crea ruta)
    if quest then
        -- la cadena entera, numerada en el orden en que se hace (1 = la primera ... N = esta mision), con el estado
        -- de cada una a la derecha. Si es muy larga se ven solo las ultimas (las primeras suelen estar hechas).
        local path = ChainPath(questId)
        local MAX_CHAIN = 14
        local first = math.max(1, #path - MAX_CHAIN + 1)
        if first > 1 then
            entries[#entries + 1] = { text = string.format(L["... %d earlier quests of the chain"], first - 1), disabled = true }
        end
        for i = first, #path do
            local id = path[i]
            local e
            if id == questId then
                e = RouteEntry(id, L["Route to %s (gives this quest: %s)"])
            else
                local pq = B:GetQuest(id)
                local zos = B.QuestieDB.QueryQuestSingle(id, "zoneOrSort")
                local map = type(zos) == "number" and zos > 0 and B:UiMapOf(zos)
                local info = map and C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
                local label = string.format(L["%s (chain)"], pq and pq.name or ("#" .. id)) .. (info and (" · " .. info.name) or "")
                e = RouteEntry(id, L["Route to %s (gives \"%s\")"], label)
            end
            e.text = string.format("%d. %s", i, e.text)
            local right, st = ChainStatus(id)
            e.right = right
            -- hecha / ya cogida: no hace falta ir (gris, sin ruta)
            if st == "done" or st == "active" or st == "complete" then e.disabled = true end
            entries[#entries + 1] = e
        end
    end
    local skipped = QR.charDB.skipped and QR.charDB.skipped[questId]
    entries[#entries + 1] = { text = skipped and L["Restore quest"] or L["Skip quest"], icon = skipped and "Reset" or "Minus",
        func = function()
            QR.charDB.skipped = QR.charDB.skipped or {}
            QR.charDB.skipped[questId] = not QR.charDB.skipped[questId] or nil
            QR.Target:Refresh(true)
        end }
    if QR.Target.manual then
        entries[#entries + 1] = { text = L["Remove manual route"], icon = "Close", func = function() QR.Target:SetManual(nil) end }
    end
    QR.Menu:Open(entries)
end

function UI:FillQuests()
    local f = self.frame
    local width = QR.db.skin.width
    for _, c in ipairs(f.cards) do c:Hide() end
    local skipped = QR.charDB.skipped or {}
    -- la leyenda ocupa la parte de arriba del hueco de la lista; el scroll empieza debajo (mismo alto total)
    local lh = self:PaintLegend(width)
    f.scroll:ClearAllPoints()
    f.scroll:SetPoint("TOPLEFT", f.legend, "BOTTOMLEFT", 0, -GAP)
    f.scroll:SetPoint("TOPRIGHT", f.legend, "BOTTOMRIGHT", 0, -GAP)
    f.scroll:SetHeight(math.max(40, QR.db.skin.listHeight - lh))
    local y = 0
    -- alto de fila segun el tamaño del texto de la lista de misiones (para que los iconos grandes quepan)
    local rowH = math.max(18, math.floor((QR.db.skin.quests.textSize or 12) * 0.85 + 9), Skin():IconSize("quests") + 4)
    for i, r in ipairs(QR.Planner:GetQuestRows()) do
        local row = f.rows[i]
        if not row then
            row = CreateFrame("Button", nil, f.scroll.content)
            row.bg = row:CreateTexture(nil, "BACKGROUND")
            row.bg:SetAllPoints()
            row.bg:SetColorTexture(1, 1, 1, 1)
            row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            row.text:SetPoint("LEFT", PAD, 0)
            row.text:SetPoint("RIGHT", -PAD, 0)
            row.text:SetJustifyH("LEFT")
            row.text:SetWordWrap(false)
            row:RegisterForClicks("LeftButtonUp", "RightButtonUp")
            row:SetScript("OnClick", function(self, button)
                if button == "RightButton" and self.questId then
                    GameTooltip:Hide()
                    UI:QuestRowMenu(self.questId)
                    return
                end
                if IsShiftKeyDown() and self.questId then
                    QR.charDB.skipped = QR.charDB.skipped or {}
                    QR.charDB.skipped[self.questId] = not QR.charDB.skipped[self.questId] or nil
                    QR.Target:Refresh(true)
                end
            end)
            row:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_LEFT")
                GameTooltip:AddLine(self.tipTitle or "")
                GameTooltip:AddLine(self.tipText or "", 1, 1, 1)
                GameTooltip:AddLine(L["Shift+click: skip / restore"], 0.6, 0.6, 0.6)
                GameTooltip:AddLine(L["Right-click: route to the quest giver / to the start of the chain"], 0.6, 0.6, 0.6)
                GameTooltip:Show()
            end)
            row:SetScript("OnLeave", function() GameTooltip:Hide() end)
            f.rows[i] = row
        end
        local status = skipped[r.questId] and "skipped" or r.status
        local st = STATUS[status] or STATUS.locked
        Skin():StyleText(row.text, "small", "quests")
        local extra = status == "lowlevel" and string.format(L[" (level %d)"], r.reqLevel) or ""
        -- cadena que empieza en otra zona: se marca en la fila (en el color de aviso)
        if r.chainZone and status ~= "skipped" then
            extra = extra .. "  " .. Skin().TEXT.warn .. string.format(L["chain: %s"], r.chainZone) .. "|r"
        end
        -- mision de elite: la calavera de elite junto al icono de estado
        local eliteTag = r.elite and (Skin():IconTag("elite", Skin():IconSize("quests"), Skin():SectionTextSize("quests", 0.85)) .. " ") or ""
        -- mision de mazmorra: el icono de mazmorra del juego (despues del de elite si tambien lo es)
        if r.dungeon then eliteTag = eliteTag .. Skin():IconTag("dungeon", Skin():IconSize("quests"), Skin():SectionTextSize("quests", 0.85)) .. " " end
        row.text:SetText(string.format("%s %s%s[%d] %s|r%s", Skin():IconTag(st[1], Skin():IconSize("quests"), Skin():SectionTextSize("quests", 0.85)), eliteTag, st[2], r.level, r.name, extra))
        row.questId = r.questId
        row.tipTitle = r.name
        local tip = string.format(L["ID %d · level %d (requires %d)%s"], r.questId, r.level, r.reqLevel, r.note and ("\n" .. r.note) or "")
        if r.chain then tip = tip .. "\n" .. string.format(L["Needs first: %s"], r.chain) end
        row.tipText = tip
        local cr, cg, cb = Skin():Color(i % 2 == 0 and "card" or "background")
        row.bg:SetVertexColor(cr, cg, cb, 1 - (QR.db.skin.list.transparency or 0) / 100)
        row:SetSize(width, rowH)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", 0, -y)
        row:Show()
        y = y + rowH
    end
    for k = #QR.Planner:GetQuestRows() + 1, #f.rows do f.rows[k]:Hide() end
    f.scroll.content:SetHeight(math.max(10, y))
    -- la lista entera con las esquinas redondeadas (si esta activado): una mascara del tamaño de lo que se ve
    -- (el hueco del scroll, o menos si la lista es mas corta) que recorta el fondo de todas las filas
    local clip = f.rowClip
    if not clip then
        clip = CreateFrame("Frame", nil, f)
        f.rowClip = clip
    end
    clip:ClearAllPoints()
    clip:SetPoint("TOPLEFT", f.scroll, "TOPLEFT")
    clip:SetPoint("TOPRIGHT", f.scroll, "TOPRIGHT")
    clip:SetHeight(math.max(1, math.min(f.scroll:GetHeight(), y)))
    for k = 1, #QR.Planner:GetQuestRows() do Skin():SetRounded(clip, f.rows[k].bg) end
end

function UI:Refresh()
    local f = self.frame
    if not f or not f:IsShown() then return end
    local plan = QR.Planner.plan
    local guide = QR.Planner:GetGuide()
    local h = QR.Steps.History(false)

    -- Banner: nombre de la zona de la guia (localizado) y su rango de niveles
    if guide then
        local map = QR.Bridge:UiMapOf(guide.areaId)
        local info = map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
        local done, total = 0, #guide.quests
        for _, row in ipairs(guide.quests) do if Questie.db.char.complete[row[1]] then done = done + 1 end end
        f.banner:SetTexts(L["QUESTIEROUTER  /  ZONE GUIDE"], info and info.name or guide.zone,
            string.format(L["Levels %d-%d  ·  %d/%d quests"], guide.minLevel, guide.maxLevel, done, total))
    else
        local cat = self.browseCategory
        f.banner:SetTexts(L["QUESTIEROUTER  /  GUIDES"], L["Welcome to QuestieRouter"],
            cat and L[cat.name] or L["Choose a guide:"])
    end

    -- Sin guia: no hay tarjeta activa ni pie, el banner sube arriba del todo
    local showActive = guide ~= nil and QR.db.skin.active.show ~= false
    f.active:SetShown(showActive)
    local flying = self:FlightData() ~= nil
    f.footer:SetShown(guide ~= nil or flying and true or false)
    local top = 0
    if showActive then
        self:PaintActive(plan, (h and h.count or 0) + 1)
        top = f.active:GetHeight() + GAP
    end
    f.banner:ClearAllPoints()
    f.banner:SetPoint("TOPLEFT", f, "TOPLEFT", 0, -top)
    f.banner:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, -top)
    -- la ventana sube lo que ocupe la tarjeta de arriba: el banner queda siempre sobre el ancla
    -- (tambien si algo la ha soltado del ancla, p. ej. la posicion restaurada por WoW)
    local _, rel = f:GetPoint(1)
    if self.anchor and (f.qrTop ~= top or rel ~= self.anchor) then
        f.qrTop = top
        f:ClearAllPoints()
        f:SetPoint("TOPLEFT", self.anchor, "TOPLEFT", 0, top)
    end

    if f.legend and (self.view ~= "quests" or not guide) then f.legend:Hide() end
    -- sin leyenda fija, el scroll va justo debajo del banner con todo el alto de la lista
    f.scroll:ClearAllPoints()
    f.scroll:SetPoint("TOPLEFT", f.banner, "BOTTOMLEFT", 0, -GAP)
    f.scroll:SetPoint("TOPRIGHT", f.banner, "BOTTOMRIGHT", 0, -GAP)
    f.scroll:SetHeight(QR.db.skin.listHeight)
    if not guide then
        self:FillBrowse()
    elseif self.view == "quests" then
        self:FillQuests()
    else
        self:FillSteps(plan)
    end

    local tasks = plan and plan.tasks
    f.footer.text:SetText(tasks and string.format(L["Pick up %d · Do %d · Turn in %d"],
        #tasks.pickup, #tasks.objective, #tasks.turnin) or "")
    self:PaintColors()
    f:SetHeight(top + f.banner:GetHeight() + GAP + QR.db.skin.listHeight + (f.footer:IsShown() and (GAP + f.footer:GetHeight()) or 0))
end

--- Pie en modo vuelo: barra del color de la zona que se vacia, destino y tiempo restante
function UI:PaintFlight()
    local f = self.frame
    local foot = f.footer
    local dest, remaining, total, elapsed = self:FlightData()
    local flying = dest ~= nil
    if flying ~= (foot.flyingShown or false) then
        foot.flyingShown = flying
        foot.text:SetShown(not flying)
        for _, b in ipairs(foot.tabs) do b:SetShown(not flying) end
        foot.flightBar:SetShown(flying)
        foot.flightText:SetShown(flying)
        foot.flightIcon:SetShown(flying)
        foot.flightTime:SetShown(flying)
        -- el alto del pie depende de los tamaños de la barra de vuelo
        UI:Layout()
        UI:Refresh()
    end
    if not flying then return end
    local S = Skin()
    local textSize, timeSize = self:FlightSizes()
    S:StyleText(foot.flightText, "small", "footer")
    S:StyleText(foot.flightTime, "clock")
    local font, _, flags = foot.flightText:GetFont()
    if font then foot.flightText:SetFont(font, textSize, flags) end
    font, _, flags = foot.flightTime:GetFont()
    if font then foot.flightTime:SetFont(font, timeSize, flags) end
    local r, g, b = S:Color("accent")
    foot.flightBar:SetVertexColor(r, g, b, 0.55)
    -- icono cuadrado de todo el alto del pie
    local iconW = foot:GetHeight()
    foot.flightIcon:SetWidth(iconW)
    S:SetRounded(foot, foot.flightIcon)
    local width = math.max(1, foot:GetWidth() - iconW)
    local frac = (total and total > 0) and (remaining / total) or 1
    foot.flightBar:SetWidth(math.max(1, width * frac))
    S:SetRounded(foot, foot.flightBar)
    foot.flightText:SetText(string.format(L["%sFlying to|r %s"], S.TEXT.warn, dest))
    local secs = remaining or elapsed or 0
    foot.flightTime:SetText(string.format("%s%d:%02d", remaining and "" or "+", math.floor(secs / 60), math.floor(secs % 60)))
    foot.flightTime:SetTextColor(1, 1, 1)
end

--- Menu del clic derecho en un paso de la lista
function UI:StepMenu(step, number)
    local P = QR.Planner
    local pinned = P:IsPinned(step)
    local entries = { { text = string.format(L["Step %d"], number), header = true } }
    if step.future then
        -- un "hacer" o "entregar" de una mision que aun no tienes: antes hay que cogerla
        entries[#entries + 1] = { text = L["Go to this step (pick up the quest first)"], disabled = true }
    elseif not pinned then
        entries[#entries + 1] = { text = L["Go to this step"], func = function() P:PinStep(step) end }
    end
    if QR.charDB.pinnedStep then
        entries[#entries + 1] = { text = L["Back to the normal order"], func = function() P:UnpinStep() end }
    end
    entries[#entries + 1] = { text = L["Skip the quests of this step"], func = function()
        QR.charDB.skipped = QR.charDB.skipped or {}
        for _, q in ipairs(step.questIds) do QR.charDB.skipped[q] = true end
        if QR.Target then QR.Target:Refresh(true) end
    end }
    entries[#entries + 1] = { text = L["Close"], func = function() end }
    QR.Menu:Open(entries)
end

--- Coloca la lista de pasos en el paso actual (y vuelve a la pestaña Pasos si estabas en Misiones)
function UI:ScrollToCurrent()
    local f = self.frame
    if not f then return end
    self.view = "steps"
    f.scroll.userScrolled = nil
    self:Refresh()
end

function UI:SetShown(shown)
    QR.db.guideWindow.shown = shown
    self.frame:SetShown(shown)
    if shown then self:Layout(); self:Refresh() end
end

function UI:Toggle() self:SetShown(not self.frame:IsShown()) end

--- Bloquea / desbloquea la ventana (posicion, tamaño y ventanitas) y repinta el candado
function UI:SetLocked(locked)
    QR.db.guideWindow.locked = locked and true or false
    self:PaintLock()
end

function UI:PaintLock()
    local lock = self.frame and self.frame.lock
    if not lock then return end
    lock.icon:SetTexture(Skin():UIIcon(QR.db.guideWindow.locked and "Lock" or "Unlock"))
    if lock:IsMouseOver() then lock:GetScript("OnEnter")(lock) else lock.icon:SetVertexColor(lock.BaseColor()) end
end

--- La mochila (ContainerFrame1..N, misma capa MEDIUM) se pone delante al abrirse, para que la ventana de la guia
--- no la tape. (Las mochilas de otros addons, p. ej. Bagnon, ya van en una capa mas alta.)
local function RaiseBagsOnShow()
    for i = 1, (NUM_CONTAINER_FRAMES or 13) do
        local cf = _G["ContainerFrame" .. i]
        if cf and not cf.qrRaise then
            cf.qrRaise = true
            cf:HookScript("OnShow", function(self) self:Raise() end)
        end
    end
end

function UI:Init()
    RaiseBagsOnShow()
    self:Create()
    self:Layout()
    self:PaintLock()
    self.frame:SetShown(QR.db.guideWindow.shown)
    QR:On("PLAN_UPDATED", function() UI:Refresh() end)
    QR:On("TARGET_CHANGED", function() if UI.frame and UI.frame:IsShown() then UI:Refresh() end end)
    QR:On("HISTORY_CHANGED", function() UI:Refresh() end)
    QR:On("GUIDE_CHANGED", function(g)
        UI.browseCategory = nil
        UI.view = "steps"
        UI.frame.scroll.userScrolled = nil
        UI.frame.scroll:SetVerticalScroll(0)
        UI:SetShown(true)
    end)
    QR:On("SKIN_CHANGED", function() UI:Refresh() end)
    QR:On("SKIN_FADE", function() if UI.frame:IsShown() then UI:PaintColors() end end)
    QR:On("SETTINGS_CHANGED", function()
        UI:Layout(); UI:Refresh()
        if UI.frame.flights then UI.frame.flights.icon:SetVertexColor(UI.frame.flights.BaseColor()) end
    end)
    QR:On("FLIGHT_CHANGED", function() UI:Refresh(); UI:PaintFlight() end)
    QR:On("FONTS_READY", function()
        local f = UI.frame
        if not f then return end
        f.active.text:SetText("")
        for _, c in ipairs(f.cards) do c.text:SetText(""); c.num:SetText("") end
        for _, r in ipairs(f.rows) do r.text:SetText("") end
        f.footer.text:SetText("")
        if f.banner.title then f.banner.title:SetText(""); f.banner.subtitle:SetText(""); f.banner.eyebrow:SetText("") end
    end)
    self:Refresh()
end

QR:RegisterModule("GuideUI", function() UI:Init() end)

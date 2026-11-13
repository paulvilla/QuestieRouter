-- QuestieRouter: ventana de instalacion (primer arranque).
-- Se abre sola la primera vez que se carga el addon (QuestieRouterDB nuevo) y luego con /qr install o con el
-- boton "Asistente de instalacion" de Ajustes > AddOns > QuestieRouter. Mismo estilo que las ventanas de LizeUI
-- (PortraitFrameTemplate con borde HeldBagLayout y botones SharedButtonTemplate).
--   1. Bienvenida: informacion del addon sobre el fondo "ali-horda"
--   2. Tamaño de los textos: tres ajustes ya hechos
--   3. Tarjeta de arriba (paso actual): que se muestra (Opciones > Tarjeta de arriba > Mostrar)
--   4. Lista de pasos: que se muestra en cada paso (Opciones > Lista de pasos > Mostrar)
--   5. Rutas de vuelo: la API de WoW falla hasta abrir el mapa de un maestro de vuelo
--   6. Fin: lamina de cierre (version en español para esES/esMX, en ingles para el resto)
-- Botones: abajo a la izquierda "Atras" y abajo a la derecha "Siguiente"; la primera pagina solo tiene
-- "Siguiente" y la ultima solo "Finalizar", en el centro. Los ajustes se aplican al pulsar cada opcion
-- (la ventana de la guia cambia detras para verlo).

local _, QR = ...
local L = QR.L
local S = QR.Skin

local Install = {}
QR.Install = Install

local MEDIA = S.MEDIA
local IMG = MEDIA .. "Install\\"
local BRAND = "|cff33ccffQuestie|r|cffffd166Router|r"
local ACCENT = { 0, 0.75, 0.98 }   -- el acento de LizeUI (seleccion)
local WIDTH, HEIGHT = 760, 540
-- zona de contenido: 728 x 408 (16:9, lo que miden las imagenes de bienvenida y cierre)
local INSET_X, INSET_TOP, INSET_BOTTOM = 16, 62, 70

---------------------------------------------------------------------------
-- Ajustes ya hechos
---------------------------------------------------------------------------
-- tamaños: texto general, titulo (zona), tarjeta de arriba (texto, numero), lista (texto, numero), pie, misiones
local SIZE_PRESETS = {
    { key = "SMALL",  name = "Small",  desc = "More steps fit in the window.",
      text = 9,  title = 13, activeText = 10, activeNum = 14, listText = 9,  listNum = 12, footer = 8.5, quests = 9 },
    { key = "NORMAL", name = "Normal", desc = "The recommended size.",
      text = 10, title = 14, activeText = 11, activeNum = 16, listText = 10, listNum = 13, footer = 9.5, quests = 10 },
    { key = "LARGE",  name = "Large",  desc = "Easier to read on large screens.",
      text = 12, title = 16, activeText = 13, activeNum = 18, listText = 12, listNum = 15, footer = 11, quests = 12 },
}

local CONTENT_PRESETS = {
    { key = "BOTH", name = "Description and objectives", desc = "Everything: what to do and how much is left." },
    { key = "DESC", name = "Description only",           desc = "Only the explanation of the step." },
    { key = "REQ",  name = "Objectives only",            desc = "Only the objectives and their progress. The most compact." },
}

local function ApplySize(p)
    local sk = QR.db.skin
    sk.textSize, sk.titleSize = p.text, p.title
    sk.active.textSize, sk.active.numberSize = p.activeText, p.activeNum
    sk.list.textSize, sk.list.numberSize = p.listText, p.listNum
    sk.footer.textSize, sk.quests.textSize = p.footer, p.quests
    -- los tamaños que siguen al texto vuelven a seguirlo (iconos, cabecera, reloj, textos de la flecha)
    sk.active.iconSize, sk.list.iconSize, sk.quests.iconSize = nil, nil, nil
    sk.eyebrowSize, sk.clockSize = nil, nil
    QR.db.arrow.titleSize, QR.db.arrow.reqSize, QR.db.arrow.statusSize = nil, nil, nil
    QR:Fire("SETTINGS_CHANGED")
end

local function CurrentSize()
    local sk = QR.db.skin
    for _, p in ipairs(SIZE_PRESETS) do
        if sk.textSize == p.text and sk.active.textSize == p.activeText and sk.list.textSize == p.listText then return p.key end
    end
end

---------------------------------------------------------------------------
-- Piezas
---------------------------------------------------------------------------
local function Font(fs, weight, size)
    if not fs:SetFont(S:FontPath(weight), size, "") then fs:SetFont(STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF", size, "") end
end

--- Borde de 1 px (cuatro lineas)
local function Border(f)
    local lines = {}
    for i = 1, 4 do lines[i] = f:CreateTexture(nil, "BORDER") end
    lines[1]:SetPoint("TOPLEFT"); lines[1]:SetPoint("TOPRIGHT"); lines[1]:SetHeight(1)
    lines[2]:SetPoint("BOTTOMLEFT"); lines[2]:SetPoint("BOTTOMRIGHT"); lines[2]:SetHeight(1)
    lines[3]:SetPoint("TOPLEFT"); lines[3]:SetPoint("BOTTOMLEFT"); lines[3]:SetWidth(1)
    lines[4]:SetPoint("TOPRIGHT"); lines[4]:SetPoint("BOTTOMRIGHT"); lines[4]:SetWidth(1)
    function f:SetBorderColor(r, g, b, a) for _, l in ipairs(lines) do l:SetColorTexture(r, g, b, a) end end
    f:SetBorderColor(0.5, 0.5, 0.5, 0.6)
end

local function Line(parent, y)
    local l = parent:CreateTexture(nil, "ARTWORK")
    l:SetColorTexture(0.5, 0.5, 0.5, 0.6); l:SetHeight(1)
    l:SetPoint("TOPLEFT", parent, "TOPLEFT", 24, y)
    l:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -24, y)
    return l
end

--- Titulo y explicacion de una pagina de opciones
local function Heading(page, title, sub)
    local t = page:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    t:SetPoint("TOP", page, "TOP", 0, -14)
    t:SetText(title)
    local s = page:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    s:SetPoint("TOP", t, "BOTTOM", 0, -8)
    s:SetWidth(640); s:SetJustifyH("CENTER"); s:SetSpacing(2)
    s:SetText(sub)
    Line(page, -84)
end

--- Paso de ejemplo (numero, mision, descripcion y/o objetivo) para ver como queda cada opcion
local function MockStep(parent, mode, textSize, numSize, num, quest, desc, req)
    local f = CreateFrame("Frame", nil, parent)
    local bg = f:CreateTexture(nil, "BACKGROUND"); bg:SetAllPoints(); bg:SetColorTexture(0.06, 0.07, 0.09, 0.92)
    local n = f:CreateFontString(nil, "OVERLAY")
    Font(n, "Number", numSize)
    n:SetTextColor(ACCENT[1], ACCENT[2], ACCENT[3])
    n:SetPoint("TOPLEFT", 8, -6)
    n:SetText(num)
    local lines, prev = {}, nil
    local function Add(text, r, g, b, weight, size)
        local fs = f:CreateFontString(nil, "OVERLAY")
        Font(fs, weight, size)
        fs:SetTextColor(r, g, b)
        fs:SetJustifyH("LEFT"); fs:SetWordWrap(true)
        if prev then fs:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -3) else fs:SetPoint("TOPLEFT", f, "TOPLEFT", 12 + numSize * 1.1, -7) end
        fs:SetPoint("RIGHT", f, "RIGHT", -8, 0)
        fs:SetText(text)
        prev = fs
        lines[#lines + 1] = fs
    end
    Add(quest, 1, 0.82, 0.3, "Bold", textSize)
    if mode ~= "REQ" then Add(desc, 0.78, 0.78, 0.78, "Regular", textSize) end
    if mode ~= "DESC" then Add("|cffffffff•|r " .. req, 0.9, 0.55, 0.45, "Regular", textSize) end
    function f:FitHeight()
        local h = 14
        for _, fs in ipairs(lines) do h = h + (fs:GetStringHeight() or textSize) + 3 end
        f:SetHeight(math.max(h, numSize + 12))
        return f:GetHeight()
    end
    f:SetHeight(numSize + 12)
    -- el alto de un texto con salto de linea solo es fiable cuando ya se ha colocado: se recalcula al verse
    f:SetScript("OnShow", function() C_Timer.After(0, function() f:FitHeight() end) end)
    return f
end

--- Tres tarjetas para elegir; build(card, preset) pinta su ejemplo. Devuelve una funcion para marcar la elegida.
local function Choices(page, presets, current, onPick, build)
    local cards = {}
    local w, gap = 216, 16
    local left = (WIDTH - 2 * INSET_X - (3 * w + 2 * gap)) / 2
    local function Mark(key)
        for _, c in ipairs(cards) do
            local sel = c.preset.key == key
            c:SetBorderColor(sel and ACCENT[1] or 0.5, sel and ACCENT[2] or 0.5, sel and ACCENT[3] or 0.5, sel and 1 or 0.6)
            c.bg:SetColorTexture(sel and ACCENT[1] or 0, sel and ACCENT[2] or 0, sel and ACCENT[3] or 0, sel and 0.14 or 0.35)
            c.check:SetShown(sel)
            c.name:SetFontObject(sel and "GameFontHighlightLarge" or "GameFontNormalLarge")
        end
    end
    for i, p in ipairs(presets) do
        local c = CreateFrame("Button", nil, page)
        c.preset = p
        c:SetSize(w, 300)
        c:SetPoint("TOPLEFT", page, "TOPLEFT", left + (i - 1) * (w + gap), -98)
        c.bg = c:CreateTexture(nil, "BACKGROUND"); c.bg:SetAllPoints()
        Border(c)
        local hl = c:CreateTexture(nil, "HIGHLIGHT"); hl:SetAllPoints(); hl:SetColorTexture(1, 1, 1, 0.06)
        c.name = c:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        c.name:SetPoint("TOP", c, "TOP", 0, -14)
        c.name:SetWidth(w - 40)
        c.name:SetText(L[p.name])
        c.check = c:CreateTexture(nil, "OVERLAY")
        c.check:SetSize(18, 18)
        c.check:SetPoint("TOPRIGHT", -8, -8)
        c.check:SetTexture(S:UIIcon("Check"))
        c.check:SetVertexColor(ACCENT[1], ACCENT[2], ACCENT[3])
        c.desc = c:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        c.desc:SetPoint("BOTTOMLEFT", c, "BOTTOMLEFT", 12, 12)
        c.desc:SetPoint("BOTTOMRIGHT", c, "BOTTOMRIGHT", -12, 12)
        c.desc:SetJustifyH("CENTER"); c.desc:SetSpacing(2)
        c.desc:SetText(L[p.desc])
        build(c, p)
        c:SetScript("OnClick", function() Mark(p.key); onPick(p) end)
        cards[i] = c
    end
    Mark(current)
    return Mark
end

---------------------------------------------------------------------------
-- Paginas
---------------------------------------------------------------------------
local pages = {}

-- 1. Bienvenida
pages[1] = function(page)
    local bg = page:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(IMG .. "Welcome.blp")
    local veil = page:CreateTexture(nil, "BORDER")
    veil:SetAllPoints()
    veil:SetColorTexture(0.04, 0.035, 0.03, 0.62)
    local logo = page:CreateTexture(nil, "ARTWORK")
    logo:SetSize(96, 96)
    logo:SetPoint("TOP", page, "TOP", 0, -42)
    logo:SetTexture(MEDIA .. "Icons\\QuestieRouter-128.tga")
    local title = page:CreateFontString(nil, "OVERLAY")
    if not title:SetFont(MEDIA .. "Fonts\\LizeUI-Bold.ttf", 40, "") then title:SetFontObject("GameFontNormalHuge") end
    title:SetShadowOffset(2, -2); title:SetShadowColor(0, 0, 0, 0.9)
    title:SetPoint("TOP", logo, "BOTTOM", 0, -14)
    title:SetText(BRAND)
    local sub = page:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    sub:SetPoint("TOP", title, "BOTTOM", 0, -8)
    local get = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
    sub:SetText(L["Zone guides on top of Questie"] .. "  |cff888888" .. string.format(L["Version %s"], get and get(QR.name, "Version") or "?") .. "|r")
    local body = page:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    body:SetPoint("TOP", sub, "BOTTOM", 0, -22)
    body:SetWidth(600); body:SetJustifyH("CENTER"); body:SetSpacing(4)
    body:SetShadowOffset(1, -1); body:SetShadowColor(0, 0, 0, 1)
    body:SetText(L["QuestieRouter turns Questie's quests into a guide for each zone: it tells you which quest to pick up, complete and turn in next, with an arrow, lines on the map and travel routes."]
        .. "\n\n|cffffd200" .. L["This short setup lets you choose how the guide window looks. You can change everything later in Options (/qr options)."] .. "|r")
end

-- 2. Tamaño de los textos
pages[2] = function(page)
    Heading(page, L["Text size"], L["Choose the size of the texts in the guide window. You can fine-tune each text later in Options."])
    Choices(page, SIZE_PRESETS, CurrentSize(), ApplySize, function(c, p)
        local aa = c:CreateFontString(nil, "OVERLAY")
        Font(aa, "Bold", p.title * 3)
        aa:SetTextColor(1, 1, 1)
        aa:SetPoint("TOP", c, "TOP", 0, -46)
        aa:SetText("Aa")
        local m = MockStep(c, "BOTH", p.activeText, p.activeNum, "3", L["The People's Militia"],
            L["Kill the Defias in the farms of the west."], L["Defias Thug"] .. "  3/12")
        m:SetPoint("TOPLEFT", c, "TOPLEFT", 10, -112)
        m:SetPoint("RIGHT", c, "RIGHT", -10, 0)
        m:FitHeight()
    end)
end

--- 3 y 4: que se muestra en la tarjeta de arriba / en los pasos de la lista
local function ContentPage(section, title, sub)
    return function(page)
        Heading(page, title, sub)
        local sec = QR.db.skin[section]
        Choices(page, CONTENT_PRESETS, sec.content, function(p)
            sec.content = p.key
            QR:Fire("SETTINGS_CHANGED")
        end, function(c, p)
            local rows = section == "active" and 1 or 2
            local samples = {
                { "3", L["The People's Militia"], L["Kill the Defias in the farms of the west."], L["Defias Thug"] .. "  3/12" },
                { "4", L["Westfall Stew"], L["Bring the ingredients to Salma Saldean."], L["Stringy Vulture Meat"] .. "  2/3" },
            }
            local prev
            for i = 1, rows do
                local s = samples[i]
                local m = MockStep(c, p.key, sec.textSize or 10, sec.numberSize or 13, s[1], s[2], s[3], s[4])
                if prev then m:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -4) else m:SetPoint("TOPLEFT", c, "TOPLEFT", 10, -52) end
                m:SetPoint("RIGHT", c, "RIGHT", -10, 0)
                m:FitHeight()
                prev = m
            end
        end)
    end
end
pages[3] = ContentPage("active", L["Top card (current step)"],
    L["What the card at the top of the window shows for the step you are on."])
pages[4] = ContentPage("list", L["Step list"],
    L["What each of the next steps in the list shows."])

-- 5. Rutas de vuelo
pages[5] = function(page)
    local icon = page:CreateTexture(nil, "ARTWORK")
    icon:SetSize(88, 88)
    icon:SetPoint("TOP", page, "TOP", 0, -26)
    icon:SetTexture(S:UIIcon("Gryphon"))
    icon:SetVertexColor(1, 0.82, 0.3)
    local t = page:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    t:SetPoint("TOP", icon, "BOTTOM", 0, -10)
    t:SetText(L["Flight routes"])
    local body = page:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    body:SetPoint("TOP", t, "BOTTOM", 0, -18)
    body:SetWidth(620); body:SetJustifyH("CENTER"); body:SetSpacing(4)
    body:SetText(L["QuestieRouter suggests routes with flights, boats and zeppelins to reach each quest sooner."]
        .. "\n\n" .. L["The WoW flight path API has errors: the game does not report which flight paths you have learned until you open the map of a flight master."]
        .. "\n\n|cffffd200" .. L["For the routes to be right, talk to a flight master once on each continent (Eastern Kingdoms and Kalimdor) and open their flight map."] .. "|r"
        .. "\n\n|cffaaaaaa" .. L["From then on your flights are checked automatically. Until then, routes may skip flights you have or use ones you have not learned."] .. "|r")
end

-- 6. Fin
pages[6] = function(page)
    local img = page:CreateTexture(nil, "BACKGROUND")
    img:SetAllPoints()
    img:SetTexture(IMG .. (QR.locale == "esES" and "Closing_esES.tga" or "Closing_enUS.tga"))
end

---------------------------------------------------------------------------
-- Ventana
---------------------------------------------------------------------------
local function Finish()
    QR.db.installDone = true
    if Install.frame then Install.frame:Hide() end
end

function Install:Build()
    local f = CreateFrame("Frame", "QuestieRouterInstallWindow", UIParent, "PortraitFrameTemplate")
    self.frame = f
    f:SetSize(WIDTH, HEIGHT)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:SetToplevel(true)
    if f.SetTitleOffsets then f:SetTitleOffsets(0, 0) end
    if f.SetBorder then pcall(f.SetBorder, f, "HeldBagLayout") end
    if f.SetPortraitTextureSizeAndOffset then f:SetPortraitTextureSizeAndOffset(38, -5, 0) end
    if f.SetPortraitTextureRaw then f:SetPortraitTextureRaw(MEDIA .. "Icons\\QuestieRouter-128.tga")
    elseif f.SetPortraitToAsset then f:SetPortraitToAsset(MEDIA .. "Icons\\QuestieRouter-128.tga") end
    f:SetMovable(true); f:EnableMouse(true); f:SetClampedToScreen(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    tinsert(UISpecialFrames, "QuestieRouterInstallWindow")
    -- cerrar con la X o Escape cuenta como hecho (no vuelve a salir; se abre con /qr install)
    f:SetScript("OnHide", function() QR.db.installDone = true end)
    if f.CloseButton then f.CloseButton:SetScript("OnClick", function() f:Hide() end) end

    local title = (f.TitleContainer or f):CreateFontString(nil, "OVERLAY", "GameFontNormal")
    if f.TitleContainer then title:SetPoint("LEFT", f.TitleContainer, "LEFT", 40, 0) else title:SetPoint("TOP", 0, -5) end
    title:SetText(BRAND .. " - " .. L["Installation"])
    f.stepText = (f.TitleContainer or f):CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    f.stepText:SetPoint("TOPRIGHT", f, "TOPRIGHT", -34, -6)

    f.content = CreateFrame("Frame", nil, f)
    f.content:SetPoint("TOPLEFT", f, "TOPLEFT", INSET_X, -INSET_TOP)
    f.content:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -INSET_X, INSET_BOTTOM)
    local cbg = f.content:CreateTexture(nil, "BACKGROUND", nil, -8)
    cbg:SetAllPoints(); cbg:SetColorTexture(0, 0, 0, 0.25)

    local bottom = f:CreateTexture(nil, "ARTWORK")
    bottom:SetColorTexture(0.5, 0.5, 0.5, 0.6); bottom:SetHeight(1)
    bottom:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 25, INSET_BOTTOM - 8)
    bottom:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -25, INSET_BOTTOM - 8)

    local function Btn(label)
        local b = CreateFrame("Button", nil, f, QR.SettingsUI and QR.SettingsUI.BUTTON_TEMPLATE or "UIPanelButtonTemplate")
        b:SetSize(150, 36)
        b:SetText(label)
        return b
    end
    f.back = Btn(L["Back"]); f.back:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 25, 16)
    f.next = Btn(L["Next"]); f.next:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -25, 16)
    f.finish = Btn(L["Finish"]); f.finish:SetPoint("BOTTOM", f, "BOTTOM", 0, 16)
    f.back:SetScript("OnClick", function() Install:Go(Install.page - 1) end)
    f.next:SetScript("OnClick", function() Install:Go(Install.page + 1) end)
    f.finish:SetScript("OnClick", Finish)

    -- puntos de progreso entre Atras y Siguiente
    f.dots = {}
    for i = 1, #pages do
        local d = f:CreateTexture(nil, "ARTWORK")
        d:SetSize(10, 10)
        d:SetTexture(MEDIA .. "Textures\\SegmentCircle.tga")
        d:SetPoint("BOTTOM", f, "BOTTOM", (i - (#pages + 1) / 2) * 18, 29)
        f.dots[i] = d
    end
    f.pages = {}
end

function Install:Go(i)
    local f = self.frame
    i = math.max(1, math.min(#pages, i))
    self.page = i
    for _, p in pairs(f.pages) do p:Hide() end
    if not f.pages[i] then
        -- cada pagina se crea la primera vez que se ve (los ejemplos usan los ajustes de ese momento)
        local p = CreateFrame("Frame", nil, f.content)
        p:SetAllPoints()
        pages[i](p)
        f.pages[i] = p
    end
    f.pages[i]:Show()
    local first, last = i == 1, i == #pages
    f.back:SetShown(not first and not last)
    f.next:SetShown(not last)
    f.finish:SetShown(last)
    for k, d in ipairs(f.dots) do
        d:SetShown(not last)
        if k == i then d:SetVertexColor(ACCENT[1], ACCENT[2], ACCENT[3], 1) else d:SetVertexColor(0.6, 0.6, 0.6, 0.6) end
    end
    f.stepText:SetText(string.format(L["Step %d of %d"], i, #pages))
end

function Install:Show()
    if not self.frame then self:Build() end
    -- se vuelven a crear las paginas para que los ejemplos reflejen los ajustes actuales
    for _, p in pairs(self.frame.pages) do p:Hide() end
    wipe(self.frame.pages)
    self.frame:Show()
    self:Go(1)
end

QR:RegisterModule("Install", function()
    if QR.db.installDone == false then
        -- un momento despues de entrar, cuando la ventana de la guia ya esta colocada
        C_Timer.After(2, function() if not InCombatLockdown() then Install:Show() end end)
    end
end)

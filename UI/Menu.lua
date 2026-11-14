-- QuestieRouter: menu contextual (clic derecho en el banner), con el estilo de la skin (tarjeta redondeada con
-- los colores de la zona). Implementacion propia (sin UIDropDownMenu) con submenus que se abren al pasar el raton.
--
-- Entrada: { text = "...", header = true | disabled = true | checked = bool | icon = "<icono de Media/Icons/UI>",
--            right = "texto alineado a la derecha (admite colores e iconos)",
--            func = function() end, menu = function() return { ...entradas... } end }

local _, QR = ...
local L = QR.L

local Menu = {}
QR.Menu = Menu

local ITEM_H = 24           -- alto de cada opcion
local SEP_H = 9             -- alto de un separador
local PAD = 8               -- margen interior de la tarjeta
local MIN_W = 200
local MAX_ITEMS = 26
local levels = {}

local function Skin() return QR.Skin end

local function CloseFrom(level)
    for i = level, #levels do levels[i]:Hide() end
    -- (la capa que detecta los clics fuera se quita con el menu)
    if level == 1 and levels[1] and levels[1].catcher then levels[1].catcher:Hide() end
end

function Menu:Close() CloseFrom(1) end

-- Cerrar el menu al hacer clic fuera de las ventanas del addon (en el mundo o en otra ventana del juego).
-- Un clic en cualquier ventana del addon (el propio menu y sus submenus, guia, Opciones, flecha, ventanitas,
-- selector de zona) no lo cierra.
local KEEP = { "QuestieRouterGuideFrame", "QuestieRouterOptions", "QuestieRouterArrowList", "QuestieRouterZonePicker",
               "QuestieRouterArrow", "QuestieRouterActiveItems", "QuestieRouterActiveTargets" }
local function ClickedInsideAddon()
    for _, f in ipairs(levels) do
        if f:IsVisible() and f:IsMouseOver() then return true end
    end
    for _, name in ipairs(KEEP) do
        local w = _G[name]
        if type(w) == "table" and w.IsVisible and w:IsVisible() and w:IsMouseOver() then return true end
    end
    return false
end

local function WatchOutsideClicks(f)
    local wasDown = true
    local function Check()
        if f:IsShown() and not ClickedInsideAddon() then Menu:Close() end
    end
    -- tres vias: el evento de clic global, mirar el raton cada fotograma y una capa invisible a pantalla
    -- completa por detras de las ventanas (un clic en el mundo cae en ella)
    local watcher = CreateFrame("Frame", nil, f)
    watcher:SetScript("OnEvent", Check)
    watcher:SetScript("OnUpdate", function()
        local down = IsMouseButtonDown and (IsMouseButtonDown("LeftButton") or IsMouseButtonDown("RightButton")) and true or false
        if down and not wasDown then Check() end
        wasDown = down
    end)
    local catcher = CreateFrame("Frame", "QuestieRouterMenuCatcher", UIParent)
    catcher:SetAllPoints(UIParent)
    catcher:SetFrameStrata("BACKGROUND")
    catcher:EnableMouse(true)
    catcher:Hide()
    catcher:SetScript("OnMouseDown", function() Menu:Close() end)
    local function OnShown()
        wasDown = true   -- el clic que lo abrio no cuenta
        pcall(watcher.RegisterEvent, watcher, "GLOBAL_MOUSE_DOWN")
        catcher:Show()
    end
    f:HookScript("OnShow", OnShown)
    f:HookScript("OnHide", function()
        watcher:UnregisterAllEvents()
        catcher:Hide()
    end)
    f.watcher, f.catcher = watcher, catcher
    -- un marco nuevo nace visible (sin OnShow): la primera vez se activa aqui
    if f:IsShown() then OnShown() end
end

--- Cada nivel del menu es una tarjeta redondeada con los colores de la zona (como Opciones / selector de zona)
local function GetLevel(level)
    local f = levels[level]
    if f then return f end
    f = CreateFrame("Frame", "QuestieRouterMenu" .. level, UIParent)
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:SetFrameLevel(10 + level * 5)
    f:SetClampedToScreen(true)
    f:EnableMouse(true)
    -- borde fino del color de acento (la tarjeta va 1 px por dentro)
    f.edge = f:CreateTexture(nil, "BACKGROUND", nil, -1)
    f.edge:SetAllPoints()
    f.bg = Skin():CreateCard(f)
    f.bg:SetPoint("TOPLEFT", 1, -1)
    f.bg:SetPoint("BOTTOMRIGHT", -1, 1)
    f.bg:SetFrameLevel(f:GetFrameLevel())
    f.items = {}
    f.level = level
    if level == 1 then tinsert(UISpecialFrames, f:GetName()) end
    f:SetScript("OnHide", function() CloseFrom(level + 1) end)
    levels[level] = f
    if level == 1 then WatchOutsideClicks(f) end
    return f
end

local function GetItem(f, i)
    local b = f.items[i]
    if b then return b end
    b = CreateFrame("Button", nil, f)
    b:SetFrameLevel(f:GetFrameLevel() + 3)
    b:SetHeight(ITEM_H)
    -- resalte redondeado al pasar el raton
    b.hl = b:CreateTexture(nil, "BACKGROUND")
    b.hl:SetAllPoints()
    b.hl:SetColorTexture(1, 1, 1, 1)
    b.hl:Hide()
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetSize(14, 14)
    b.icon:SetPoint("LEFT", 8, 0)
    b.text = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    b.text:SetPoint("LEFT", 30, 0)
    b.text:SetJustifyH("LEFT")
    b.arrow = b:CreateTexture(nil, "ARTWORK")
    b.arrow:SetSize(10, 10)
    b.arrow:SetPoint("RIGHT", -8, 0)
    -- columna derecha opcional (entry.right): estado, nivel, iconos...
    b.right = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    b.right:SetPoint("RIGHT", -8, 0)
    b.right:SetJustifyH("RIGHT")
    b.line = b:CreateTexture(nil, "ARTWORK")
    b.line:SetHeight(1)
    b.line:SetPoint("LEFT", 8, 0)
    b.line:SetPoint("RIGHT", -8, 0)
    b.line:SetColorTexture(1, 1, 1, 1)
    b:SetScript("OnEnter", function(self)
        CloseFrom(f.level + 1)
        local e = self.entry
        if e and not (e.header or e.disabled or e.spacer) then self.hl:Show() end
        if e and e.menu and not e.disabled then
            Menu:OpenLevel(f.level + 1, e.menu(), self, "sub")
        end
    end)
    b:SetScript("OnLeave", function(self) self.hl:Hide() end)
    b:SetScript("OnClick", function(self)
        local e = self.entry
        if not e or e.disabled or e.header or e.menu or e.spacer then return end
        Menu:Close()
        if e.func then e.func() end
    end)
    f.items[i] = b
    return b
end

function Menu:OpenLevel(level, entries, anchor, mode)
    local S = Skin()
    local f = GetLevel(level)
    S:PaintCard(f.bg, "background", 0.97, "ui")
    local ar, ag, ab = S:TextAccent()
    f.edge:SetColorTexture(ar, ag, ab, 0.35)
    S:SetRounded(f, f.edge)
    local width = MIN_W
    local n = math.min(#entries, MAX_ITEMS)
    local y = PAD
    for i = 1, n do
        local e = entries[i]
        local b = GetItem(f, i)
        b.entry = e
        b.hl:Hide()
        b.hl:SetVertexColor(ar, ag, ab, 0.22)
        S:SetRounded(b, b.hl)
        local h = e.spacer and SEP_H or ITEM_H
        b:SetHeight(h)
        b.line:SetShown(e.spacer == true)
        b.line:SetVertexColor(ar, ag, ab, 0.3)
        b.text:SetShown(not e.spacer)
        -- cabecera: estilo de titulo de seccion, en el color de acento
        S:StyleText(b.text, e.header and "eyebrow" or "body", "ui")
        b.text:SetText(e.text or "")
        if e.header then
            b.text:SetTextColor(ar, ag, ab)
        elseif e.disabled then
            b.text:SetTextColor(0.5, 0.52, 0.5)
        else
            b.text:SetTextColor(0.92, 0.94, 0.92)
        end
        -- columna izquierda: marca de activado (en el color de acento) o el icono de la opcion
        if e.checked == true then
            b.icon:SetTexture(S:UIIcon("Check"))
            b.icon:SetVertexColor(ar, ag, ab)
            b.icon:Show()
        elseif e.icon and not e.spacer then
            b.icon:SetTexture(S:UIIcon(e.icon))
            if e.disabled then b.icon:SetVertexColor(0.45, 0.47, 0.45) else b.icon:SetVertexColor(0.8, 0.83, 0.8) end
            b.icon:Show()
        else
            b.icon:Hide()
        end
        b.text:ClearAllPoints()
        b.text:SetPoint("LEFT", e.header and 8 or 30, 0)
        -- flechita del submenu, apuntando hacia donde se abre
        b.arrow:SetShown(e.menu ~= nil)
        b.arrow:SetTexture(S:UIIcon(Menu.openLeft and "ArrowLeft" or "ArrowRight"))
        if e.disabled then b.arrow:SetVertexColor(0.45, 0.47, 0.45) else b.arrow:SetVertexColor(ar, ag, ab) end
        S:StyleText(b.right, "small", "ui")
        b.right:SetText(e.right or "")
        b.right:SetShown(e.right ~= nil and not e.spacer)
        local rightW = e.right and (b.right:GetStringWidth() + 24) or 0
        if not e.spacer then width = math.max(width, b.text:GetStringWidth() + 30 + 30 + rightW) end
        b:ClearAllPoints()
        b:SetPoint("TOPLEFT", PAD, -y)
        b:Show()
        y = y + h
    end
    for i = n + 1, #f.items do f.items[i]:Hide() end
    for i = 1, n do f.items[i]:SetWidth(width) end
    f:SetSize(width + PAD * 2, y + PAD)
    f:ClearAllPoints()
    -- en la mitad derecha de la pantalla el menu y sus submenus se abren hacia la izquierda
    if mode == "sub" then
        if Menu.openLeft then
            f:SetPoint("TOPRIGHT", anchor, "TOPLEFT", -PAD - 2, PAD)
        else
            f:SetPoint("TOPLEFT", anchor, "TOPRIGHT", PAD + 2, PAD)
        end
    else
        local x, cy = GetCursorPosition()
        local scale = UIParent:GetEffectiveScale()
        x, cy = x / scale, cy / scale
        Menu.openLeft = x > UIParent:GetWidth() / 2
        if Menu.openLeft then
            f:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", x, cy)
        else
            f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, cy)
        end
    end
    f:Show()
end

--- Abre el menu en la posicion del raton
function Menu:Open(entries)
    CloseFrom(1)
    -- decidir el sentido antes de pintar las flechitas del primer nivel
    local x = GetCursorPosition() / UIParent:GetEffectiveScale()
    Menu.openLeft = x > UIParent:GetWidth() / 2
    self:OpenLevel(1, entries)
    if levels[1] and levels[1].catcher then levels[1].catcher:Show() end
end

local spacer = { text = " ", spacer = true, disabled = true }
Menu.SPACER = spacer

---------------------------------------------------------------------------
-- Menu principal de QuestieRouter
---------------------------------------------------------------------------
function Menu:GuideEntries(category)
    local list = {}
    if #category.guides == 0 then
        return { { text = L["Coming soon"], disabled = true } }
    end
    -- Zonas y mazmorras: agrupadas por tramo de nivel para que el menu no sea eterno
    local bands = { { 1, 20 }, { 20, 30 }, { 30, 40 }, { 40, 50 }, { 50, 60 } }
    local active = QR.Planner:GetGuide()
    for _, band in ipairs(bands) do
        local sub = {}
        for _, g in ipairs(category.guides) do
            if g.minLevel >= band[1] and (g.minLevel < band[2] or (band[2] == 60 and g.minLevel <= 60)) then
                sub[#sub + 1] = {
                    text = string.format("[%d-%d] %s", g.minLevel, g.maxLevel, QR.GuideLabel(g)),
                    checked = g == active,
                    func = function() QR.Planner:SetGuide(g.key) end,
                }
            end
        end
        if #sub > 0 then
            list[#list + 1] = { text = string.format(L["Levels %d-%d"], band[1], band[2]), menu = function() return sub end }
        end
    end
    return list
end

function Menu:Main()
    local entries = { { text = L["Available guides"], header = true } }
    for _, cat in ipairs(QR.guideCategories) do
        entries[#entries + 1] = { text = L[cat.name], icon = "Guides", menu = function()
            if cat.menu then return cat.menu() end
            return Menu:GuideEntries(cat)
        end }
    end
    entries[#entries + 1] = spacer
    local guide = QR.Planner:GetGuide()
    local db = QR.db
    entries[#entries + 1] = { text = L["Options..."], icon = "Cog", func = function() QR.Options:Toggle() end }
    entries[#entries + 1] = { text = L["Skin"], icon = "Appearance", menu = function()
        local s = db.skin
        local function set(mode) return function() s.mode = mode; QR:Fire("SETTINGS_CHANGED") end end
        return {
            { text = L["Automatic (changes with the zone I am in)"], checked = s.mode == "ZONE", func = set("ZONE") },
            { text = L["Based on the guide's zone"], checked = s.mode == "GUIDE", func = set("GUIDE") },
            { text = L["Fixed zone (choose in Options)"], checked = s.mode == "MANUAL", func = set("MANUAL") },
        }
    end }
    -- coger / entregar misiones solas al hablar con el NPC (solo las de los pasos de la guia)
    entries[#entries + 1] = { text = L["Auto-accept guide quests"], checked = db.autoAccept == true, func = function()
        db.autoAccept = not db.autoAccept; QR:Fire("SETTINGS_CHANGED") end }
    entries[#entries + 1] = { text = L["Auto turn-in quests"], checked = db.autoTurnIn == true, func = function()
        db.autoTurnIn = not db.autoTurnIn; QR:Fire("SETTINGS_CHANGED") end }
    entries[#entries + 1] = { text = L["Arrow"], checked = db.arrow.shown, func = function()
        db.arrow.shown = not db.arrow.shown; QR:Fire("SETTINGS_CHANGED") end }
    entries[#entries + 1] = { text = L["3D portraits in \"Target\""], checked = db.activeFrames.portrait3d == true, func = function()
        db.activeFrames.portrait3d = not db.activeFrames.portrait3d; QR:Fire("SETTINGS_CHANGED") end }
    entries[#entries + 1] = { text = L["Zone quest list"], icon = "Search", disabled = not guide, func = function()
        QR.GuideUI.view = QR.GuideUI.view == "quests" and "steps" or "quests"; QR.GuideUI:Refresh() end }
    entries[#entries + 1] = { text = db.guideWindow.locked and L["Unlock window"] or L["Lock window"], icon = db.guideWindow.locked and "Lock" or "Unlock", func = function()
        QR.GuideUI:SetLocked(not db.guideWindow.locked) end }
    entries[#entries + 1] = { text = L["Reset guide history"], icon = "Reset", disabled = not guide, func = function()
        if QR.charDB.history and guide then QR.charDB.history[guide.key] = nil end
        QR:Fire("HISTORY_CHANGED") end }
    entries[#entries + 1] = { text = L["Hide the window"], icon = "Minus", func = function() QR.GuideUI:SetShown(false) end }
    entries[#entries + 1] = { text = L["Leave the guide"], icon = "Back", disabled = not guide, func = function() QR.Planner:SetGuide(nil) end }
    -- "Cerrar" cierra solo este menu (para ocultar la ventana: clic en el boton del minimapa o /qr guide)
    entries[#entries + 1] = { text = L["Close"], icon = "Close", func = function() end }
    return entries
end

function Menu:OpenMain() self:Open(self:Main()) end

-- QuestieRouter: paneles en Ajustes > AddOns (menu de Interfaz del juego).
--   QuestieRouter  las opciones del menu del clic derecho (activables y acciones)
--   Cambios        registro de cambios (Locales/Changelog/<idioma>.lua)
--   Soporte        igual que el de LizeUI (mismos datos y enlaces)
-- El nombre sale con los colores de la marca (Questie en turquesa, Router en dorado). La categoria se registra con
-- el nombre sin colores para que la lista la ordene en su sitio (los codigos de color cambiarian el orden) y el
-- texto coloreado se pone despues en el boton de la lista.

local addonName, QR = ...
local L = QR.L

local SettingsUI = {}
QR.SettingsUI = SettingsUI

local BRAND = "|cff33ccffQuestie|r|cffffd166Router|r"
local MEDIA = QR.Skin.MEDIA
local PATREON_URL = "https://www.patreon.com/cw/Lizerius"
local CURSEFORGE_URL = "https://www.curseforge.com/wow/addons/lizeui-forever"
local ACCENT_HEX = "00c0fa" -- el mismo acento que LizeUI (puntos de la lista de cambios)
-- los botones de LizeUI (SharedButtonTemplate); en clientes sin esa plantilla, el boton clasico
local BUTTON_TEMPLATE = C_XMLUtil and C_XMLUtil.GetTemplateInfo and C_XMLUtil.GetTemplateInfo("SharedButtonTemplate")
    and "SharedButtonTemplate" or "UIPanelButtonTemplate"
SettingsUI.BUTTON_TEMPLATE = BUTTON_TEMPLATE

local function Version()
    local get = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
    return get and get(addonName, "Version") or "?"
end

local function NewPanel(name, parent)
    local panel = CreateFrame("Frame")
    panel.name = name
    panel.parent = parent
    panel.OnCommit = function() end
    panel.OnDefault = function() end
    panel.OnRefresh = function() end
    return panel
end

--- Titulo de seccion centrado con una linea a cada lado; las lineas se ajustan al ancho del titulo
--- (antes iban a una distancia fija y los titulos largos quedaban encima de la linea)
local function Divider(panel, title, y)
    local t = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOP", panel, "TOP", 0, y + 6)
    t:SetText(title)
    local gap = math.floor((t:GetStringWidth() or 120) / 2) + 12
    local l = panel:CreateTexture(nil, "ARTWORK")
    l:SetColorTexture(0.5, 0.5, 0.5, 0.6); l:SetHeight(1)
    l:SetPoint("TOPLEFT", panel, "TOPLEFT", 20, y)
    l:SetPoint("TOPRIGHT", panel, "TOP", -gap, y)
    local r = panel:CreateTexture(nil, "ARTWORK")
    r:SetColorTexture(0.5, 0.5, 0.5, 0.6); r:SetHeight(1)
    r:SetPoint("TOPLEFT", panel, "TOP", gap, y)
    r:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -20, y)
end

local function Header(panel, subtitle)
    local logo = panel:CreateTexture(nil, "ARTWORK")
    logo:SetSize(64, 64)
    logo:SetPoint("TOPLEFT", panel, "TOPLEFT", 25, -20)
    logo:SetTexture(MEDIA .. "Icons\\QuestieRouter-128.tga")
    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    title:SetPoint("TOPLEFT", logo, "TOPRIGHT", 14, -8)
    title:SetText(BRAND)
    local sub = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
    sub:SetText(subtitle .. "  |cff888888" .. string.format(L["Version %s"], Version()) .. "|r")
end

StaticPopupDialogs["QUESTIEROUTER_COPY_URL"] = {
    text = "%s", button1 = CLOSE or "Close", hasEditBox = true, editBoxWidth = 320,
    OnShow = function(self, data)
        local eb = self.editBox or self.EditBox
        if eb then eb:SetText(data or ""); eb:HighlightText(); eb:SetFocus() end
    end,
    EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
    EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
    timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
}
local function CopyUrl(title, url)
    StaticPopupDialogs["QUESTIEROUTER_COPY_URL"].button1 = L["Close"]
    StaticPopup_Show("QUESTIEROUTER_COPY_URL", title, nil, url)
end

---------------------------------------------------------------------------
-- Panel principal: las opciones del menu
---------------------------------------------------------------------------
local function BuildMain()
    local panel = NewPanel("QuestieRouter")
    Header(panel, L["Zone guides on top of Questie"])
    local checks = {}
    local function Check(label, x, y, get, set)
        local c = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
        c:SetPoint("TOPLEFT", panel, "TOPLEFT", x, y)
        local t = c:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        t:SetPoint("LEFT", c, "RIGHT", 2, 1)
        t:SetText(label)
        c:SetScript("OnClick", function(self) set(self:GetChecked() and true or false); QR:Fire("SETTINGS_CHANGED"); SettingsUI:RefreshMain() end)
        checks[#checks + 1] = { c, get }
        return c
    end
    local function Button(label, x, y, w, fn, enabled)
        local b = CreateFrame("Button", nil, panel, BUTTON_TEMPLATE)
        b:SetSize(w, 28)
        b:SetPoint("TOPLEFT", panel, "TOPLEFT", x, y)
        b:SetText(label)
        b:SetScript("OnClick", function() fn(); SettingsUI:RefreshMain() end)
        b.enabledFn = enabled
        return b
    end
    local db = QR.db

    Divider(panel, L["Guide"], -110)
    local buttons = {
        Button(L["Options..."], 25, -125, 180, function() QR.Options:Toggle() end),
        Button(L["Show / hide the window"], 215, -125, 180, function() QR.GuideUI:SetShown(not (QR.GuideUI.frame and QR.GuideUI.frame:IsShown())) end),
        Button(L["Zone quest list"], 405, -125, 180, function()
            QR.GuideUI.view = QR.GuideUI.view == "quests" and "steps" or "quests"; QR.GuideUI:Refresh() end,
            function() return QR.Planner:GetGuide() ~= nil end),
        Button(L["Reset guide history"], 25, -158, 180, function()
            local g = QR.Planner:GetGuide()
            if QR.charDB.history and g then QR.charDB.history[g.key] = nil end
            QR:Fire("HISTORY_CHANGED") end, function() return QR.Planner:GetGuide() ~= nil end),
        Button(L["Leave the guide"], 215, -158, 180, function() QR.Planner:SetGuide(nil) end,
            function() return QR.Planner:GetGuide() ~= nil end),
        Button(L["Setup wizard"], 405, -158, 180, function() if SettingsPanel then HideUIPanel(SettingsPanel) end; QR.Install:Show() end),
    }
    panel.buttons = buttons

    Divider(panel, L["Skin"], -200)
    local function SkinMode(mode) return function() return db.skin.mode == mode end, function() db.skin.mode = mode end end
    local g1, s1 = SkinMode("ZONE"); Check(L["Automatic (changes with the zone I am in)"], 25, -215, g1, s1)
    local g2, s2 = SkinMode("GUIDE"); Check(L["Based on the guide's zone"], 25, -240, g2, s2)
    local g3, s3 = SkinMode("MANUAL"); Check(L["Fixed zone (choose in Options)"], 25, -265, g3, s3)

    Divider(panel, L["Automation"], -305)
    Check(L["Auto-accept guide quests"], 25, -320, function() return db.autoAccept end, function(v) db.autoAccept = v end)
    Check(L["Auto turn-in quests"], 25, -345, function() return db.autoTurnIn end, function(v) db.autoTurnIn = v end)
    local hint = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    hint:SetPoint("TOPLEFT", panel, "TOPLEFT", 55, -372)
    hint:SetText(L["Hold Shift when talking to an NPC to skip the automation."])

    Divider(panel, L["Window, arrow and target"], -400)
    Check(L["Arrow"], 25, -415, function() return db.arrow.shown end, function(v) db.arrow.shown = v end)
    Check(L["Lock window"], 25, -440, function() return db.guideWindow.locked end, function(v) QR.GuideUI:SetLocked(v) end)
    Check(L["Use flight routes"], 25, -465, function() return db.travel.flights end, function(v)
        db.travel.flights = v; if QR.Target then QR.Target:Refresh(true) end end)
    -- (todo en una columna: con textos largos traducidos una segunda columna no cabe)
    Check(L["3D portraits in \"Target\""], 25, -490, function() return db.activeFrames.portrait3d end, function(v) db.activeFrames.portrait3d = v end)
    Check(L["Mark the target when selecting it (each button its own icon)"], 25, -515,
        function() return db.activeFrames.markTarget ~= false end, function(v) db.activeFrames.markTarget = v end)

    panel.checks = checks
    panel:SetScript("OnShow", function() SettingsUI:RefreshMain() end)
    return panel
end

function SettingsUI:RefreshMain()
    local p = self.main
    if not p then return end
    for _, c in ipairs(p.checks or {}) do c[1]:SetChecked(c[2]() and true or false) end
    for _, b in ipairs(p.buttons or {}) do
        if b.enabledFn then b:SetEnabled(b.enabledFn() and true or false) end
    end
end

---------------------------------------------------------------------------
-- Cambios
---------------------------------------------------------------------------
local function BuildChanges(parentName)
    -- misma maqueta que el panel Cambios de LizeUI: versiones a la izquierda, detalle a la derecha
    local panel = NewPanel(L["Changes"], parentName)
    -- el del idioma activo; si no hay, el ingles (cambiar de idioma recarga la interfaz)
    local logs = QR.Changelogs or {}
    local list = logs[QR.locale] or logs.enUS or {}

    local versions = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    versions:SetPoint("TOPLEFT", panel, "TOPLEFT", 25, -25)
    versions:SetText(L["Versions"])

    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", panel, "TOPLEFT", 175, -22)
    title:SetPoint("RIGHT", panel, "RIGHT", -25, 0)
    title:SetJustifyH("LEFT")
    local meta = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    meta:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)

    local headLine = panel:CreateTexture(nil, "ARTWORK")
    headLine:SetColorTexture(0.5, 0.5, 0.5, 0.6); headLine:SetHeight(1)
    headLine:SetPoint("TOPLEFT", panel, "TOPLEFT", 175, -64)
    headLine:SetPoint("RIGHT", panel, "RIGHT", -25, 0)
    local colLine = panel:CreateTexture(nil, "ARTWORK")
    colLine:SetColorTexture(0.5, 0.5, 0.5, 0.4); colLine:SetWidth(1)
    colLine:SetPoint("TOPLEFT", panel, "TOPLEFT", 160, -22)
    colLine:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 160, 20)

    local ok, scroll = pcall(CreateFrame, "ScrollFrame", nil, panel, "ScrollFrameTemplate")
    if not ok or not scroll then scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate") end
    scroll:SetPoint("TOPLEFT", panel, "TOPLEFT", 175, -74)
    scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -30, 20)
    local body = CreateFrame("Frame", nil, scroll)
    body:SetSize(400, 400)
    scroll:SetScrollChild(body)
    local text = body:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("TOPLEFT", body, "TOPLEFT", 0, 0)
    text:SetWidth(400)
    text:SetJustifyH("LEFT"); text:SetJustifyV("TOP")
    text:SetSpacing(3)
    local function Resize()
        local w = scroll:GetWidth()
        if w and w > 0 then body:SetWidth(w); text:SetWidth(w - 10) end
        body:SetHeight(math.max(text:GetStringHeight() + 10, 10))
    end
    scroll:SetScript("OnSizeChanged", Resize)

    --- "# texto" subtitulo, "- texto" o texto suelto = punto de lista, "" linea en blanco
    local function Format(lines)
        local out = {}
        for _, l in ipairs(lines or {}) do
            if l:sub(1, 2) == "# " then out[#out + 1] = "|cffffd200" .. l:sub(3) .. "|r"
            elseif l == "" then out[#out + 1] = ""
            else out[#out + 1] = "|cff" .. ACCENT_HEX .. "•|r " .. (l:sub(1, 2) == "- " and l:sub(3) or l) end
        end
        return table.concat(out, "\n")
    end

    local rows = {}
    local function Select(i)
        panel.selected = i
        local e = list[i]
        for k, r in ipairs(rows) do
            local sel = k == i
            r.bg:SetColorTexture(sel and 0 or 1, sel and 0.75 or 1, sel and 0.98 or 1, sel and 0.35 or (k % 2 == 0 and 0.03 or 0.06))
            r.text:SetFontObject(sel and "GameFontHighlight" or "GameFontNormal")
        end
        if not e then
            title:SetText(L["No changes yet"]); meta:SetText(""); text:SetText("")
        else
            title:SetText(e.title or e.version)
            meta:SetText(string.format(L["Version %s"], e.version) .. "  ·  " .. (e.date or ""))
            text:SetText(Format(e.lines))
        end
        scroll:SetVerticalScroll(0)
        Resize()
    end
    for i, e in ipairs(list) do
        local r = CreateFrame("Button", nil, panel)
        r:SetSize(125, 24)
        r:SetPoint("TOPLEFT", panel, "TOPLEFT", 22, -42 - (i - 1) * 26)
        r.bg = r:CreateTexture(nil, "BACKGROUND"); r.bg:SetAllPoints()
        r.text = r:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        r.text:SetPoint("LEFT", r, "LEFT", 10, 0)
        r.text:SetText((i == 1 and "|TInterface\\COMMON\\Indicator-Green:12:12:0:0|t " or "") .. e.version)
        local hl = r:CreateTexture(nil, "HIGHLIGHT"); hl:SetAllPoints(); hl:SetColorTexture(1, 1, 1, 0.08)
        r:SetScript("OnClick", function() Select(i) end)
        rows[i] = r
    end
    -- el panel nace visible (sin padre), asi que al meterlo en Ajustes no siempre salta OnShow:
    -- se carga el ultimo ya al crearlo y se vuelve a maquetar al mostrarse (el ancho real del scroll
    -- solo se conoce cuando Ajustes lo coloca; OnSizeChanged del scroll lo recoloca tambien)
    Select(1)
    panel:SetScript("OnShow", function() Resize(); C_Timer.After(0, Resize) end)
    return panel
end

---------------------------------------------------------------------------
-- Soporte (igual que el de LizeUI)
---------------------------------------------------------------------------
local function BuildSupport(parentName)
    local panel = NewPanel(L["Support"], parentName)
    Header(panel, L["Interface for WoW Forever"])
    Divider(panel, L["Donations"], -110)
    local donate = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    donate:SetPoint("TOPLEFT", panel, "TOPLEFT", 25, -128)
    donate:SetPoint("RIGHT", panel, "RIGHT", -25, 0)
    donate:SetJustifyH("LEFT"); donate:SetSpacing(3)
    donate:SetText(string.format(L["Thank you for using %s!"], BRAND) .. "\n\n" .. L["With your support I can keep improving the interface and maintaining compatibility with new game updates."]
        .. "\n" .. L["Donations may also give you access to direct communication with development and requests for custom modules."])
    local patreon = CreateFrame("Button", nil, panel, BUTTON_TEMPLATE)
    patreon:SetSize(190, 36)
    patreon:SetPoint("TOP", panel, "TOP", 0, -215)
    patreon:SetText(string.format("|T%s:16:16:0:0|t %s", MEDIA .. "Icons\\UI\\Cafe.tga", L["Donate (Patreon)"]))
    patreon:SetScript("OnClick", function() CopyUrl(L["Donate (Patreon)"], PATREON_URL) end)
    Divider(panel, L["Links"], -280)
    local links = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    links:SetPoint("TOPLEFT", panel, "TOPLEFT", 25, -298)
    links:SetText(L["You can get LizeUI Forever and support its development from these sources:"])
    local function LinkRow(label, url, y)
        local name = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        name:SetPoint("TOPLEFT", panel, "TOPLEFT", 30, y)
        name:SetText(label)
        local box = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
        box:SetSize(420, 20)
        box:SetPoint("LEFT", name, "LEFT", 110, 0)
        box:SetAutoFocus(false)
        box:SetText(url)
        box:SetCursorPosition(0)
        -- solo lectura: siempre vuelve a la URL y la selecciona para copiar
        box:SetScript("OnTextChanged", function(self, user) if user then self:SetText(url); self:HighlightText() end end)
        box:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
        box:SetScript("OnEditFocusLost", function(self) self:HighlightText(0, 0); self:SetCursorPosition(0) end)
        box:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
        box:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    end
    LinkRow("CurseForge", CURSEFORGE_URL, -325)
    LinkRow("Patreon", PATREON_URL, -355)
    return panel
end

---------------------------------------------------------------------------
-- Registro
---------------------------------------------------------------------------
--- Pone el nombre con colores en el boton de la lista de categorias (la categoria se ordena por el nombre limpio)
local function ColorListButton()
    local cat = SettingsUI.category
    local list = cat and SettingsPanel and SettingsPanel.GetCategoryList and SettingsPanel:GetCategoryList()
    local box = list and list.ScrollBox
    if not (box and box.ForEachFrame) then return end
    pcall(box.ForEachFrame, box, function(btn)
        local data = btn.GetElementData and btn:GetElementData()
        data = data and (data.data or data)
        if data and data.category == cat then
            local label = btn.Label or btn.Text or (btn.GetFontString and btn:GetFontString())
            if label and label.SetText then label:SetText(BRAND) end
        end
    end)
end

function SettingsUI:Open(sub)
    local cat = sub == "support" and self.supportCat or sub == "changes" and self.changesCat or self.category
    if cat and Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(cat.ID or (cat.GetID and cat:GetID()))
    elseif self.main and InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory(self.main); InterfaceOptionsFrame_OpenToCategory(self.main)
    end
end

function SettingsUI:Init()
    self.main = BuildMain()
    self:RefreshMain() -- (mismo motivo que en Cambios: OnShow puede no saltar la primera vez)
    local changes = BuildChanges("QuestieRouter")
    local support = BuildSupport("QuestieRouter")
    if Settings and Settings.RegisterCanvasLayoutCategory then
        local cat = Settings.RegisterCanvasLayoutCategory(self.main, "QuestieRouter", "QuestieRouter")
        Settings.RegisterAddOnCategory(cat)
        self.category = cat
        self.changesCat = Settings.RegisterCanvasLayoutSubcategory(cat, changes, L["Changes"], L["Changes"])
        self.supportCat = Settings.RegisterCanvasLayoutSubcategory(cat, support, L["Support"], L["Support"])
        -- al pulsar "QuestieRouter" en la lista se despliegan sus subcategorias (Cambios, Soporte), igual que al
        -- pulsar el [+] y como hace LizeUI, para que se vea que hay mas opciones
        cat.expanded = true
        local function Expand()
            if cat.expanded then return end
            if cat.SetExpanded then pcall(cat.SetExpanded, cat, true) end
            cat.expanded = true
            C_Timer.After(0, function()
                local list = SettingsPanel and SettingsPanel.GetCategoryList and SettingsPanel:GetCategoryList()
                if list and list.CreateCategories then
                    pcall(list.CreateCategories, list)
                elseif Settings.OpenToCategory then
                    pcall(Settings.OpenToCategory, cat.ID or (cat.GetID and cat:GetID()))
                end
            end)
        end
        self.main:HookScript("OnShow", Expand)
        -- (el panel nace visible y su OnShow no siempre salta: tambien al elegir la categoria en la lista)
        if SettingsPanel and SettingsPanel.SelectCategory then
            hooksecurefunc(SettingsPanel, "SelectCategory", function(_, selected)
                if selected == cat then Expand() end
            end)
        end
        -- nombre con colores en la lista, sin cambiar su posicion
        if SettingsCategoryListButtonMixin and SettingsCategoryListButtonMixin.Init then
            hooksecurefunc(SettingsCategoryListButtonMixin, "Init", function() C_Timer.After(0, ColorListButton) end)
        end
        if SettingsPanel then
            SettingsPanel:HookScript("OnShow", function() C_Timer.After(0, ColorListButton); C_Timer.After(0.2, ColorListButton) end)
            local list = SettingsPanel.GetCategoryList and SettingsPanel:GetCategoryList()
            if list and list.ScrollBox and list.ScrollBox.RegisterCallback and ScrollBoxListMixin and ScrollBoxListMixin.Event then
                pcall(list.ScrollBox.RegisterCallback, list.ScrollBox, ScrollBoxListMixin.Event.OnDataRangeChanged, ColorListButton, SettingsUI)
            end
        end
    elseif InterfaceOptions_AddCategory then
        -- cliente antiguo: el panel de Interfaz clasico
        self.main.name = BRAND
        changes.parent, support.parent = BRAND, BRAND
        InterfaceOptions_AddCategory(self.main)
        InterfaceOptions_AddCategory(changes)
        InterfaceOptions_AddCategory(support)
    end
end

QR:RegisterModule("SettingsUI", function() SettingsUI:Init() end)

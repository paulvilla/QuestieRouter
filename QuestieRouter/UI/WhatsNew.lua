-- QuestieRouter: ventana de novedades al actualizar.
-- Al entrar con una version nueva del addon (no en la primera instalacion: para eso esta el instalador) muestra el
-- ultimo registro de cambios (Locales/Changelog) con, arriba y en grande, lo mas importante de la version (en la
-- 0.10.0, el boton "QuestieRouter" del menu del juego, con su imagen). "No volver a mostrar" la apaga para siempre;
-- se puede abrir a mano con /qr novedades.

local _, QR = ...
local L = QR.L

local WhatsNew = {}
QR.WhatsNew = WhatsNew

local WIDTH, HEIGHT = 620, 600
local MEDIA = "Interface\\AddOns\\QuestieRouter\\Media\\"
local BRAND = "|cff33ccffQuestie|r|cffffd166Router|r"

-- lo destacado de cada version: imagen (Media/Install/...) y texto grande
local HIGHLIGHTS = {
    ["0.10.0"] = { image = "Install\\WhatsNew_GameMenu.blp", w = 512, h = 256,
                   title = "New: QuestieRouter button in the game menu",
                   text = "Press Esc and click \"QuestieRouter\" to open the new guide browser: zones, dungeons with their bosses and loot, professions, class quests and skills, events and more." },
}

local function Version()
    local get = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
    return get and get(QR.name or "QuestieRouter", "Version") or "?"
end

local function Changelog()
    local logs = QR.Changelogs or {}
    local list = logs[QR.locale or ""] or logs[GetLocale and GetLocale() or ""] or logs.enUS or {}
    return list[1]
end

function WhatsNew:Build()
    if self.frame then return self.frame end
    local f = CreateFrame("Frame", "QuestieRouterWhatsNew", UIParent, "PortraitFrameTemplate")
    self.frame = f
    f:SetSize(WIDTH, HEIGHT)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:SetToplevel(true)
    if f.SetBorder then pcall(f.SetBorder, f, "HeldBagLayout") end
    if f.SetPortraitTextureSizeAndOffset then f:SetPortraitTextureSizeAndOffset(38, -5, 0) end
    if f.SetPortraitTextureRaw then f:SetPortraitTextureRaw(MEDIA .. "Icons\\QuestieRouter-128.tga")
    elseif f.SetPortraitToAsset then f:SetPortraitToAsset(MEDIA .. "Icons\\QuestieRouter-128.tga") end
    f:SetMovable(true); f:EnableMouse(true); f:SetClampedToScreen(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    tinsert(UISpecialFrames, "QuestieRouterWhatsNew")
    if f.CloseButton then f.CloseButton:SetScript("OnClick", function() f:Hide() end) end

    f.title = (f.TitleContainer or f):CreateFontString(nil, "OVERLAY", "GameFontNormal")
    if f.TitleContainer then f.title:SetPoint("LEFT", f.TitleContainer, "LEFT", 40, 0) else f.title:SetPoint("TOP", 0, -5) end

    local c = CreateFrame("Frame", nil, f)
    c:SetPoint("TOPLEFT", 14, -30)
    c:SetPoint("BOTTOMRIGHT", -14, 56)
    local cbg = c:CreateTexture(nil, "BACKGROUND", nil, -8)
    cbg:SetAllPoints()
    cbg:SetColorTexture(0.05, 0.045, 0.04, 0.92)
    f.content = c

    -- destacado: imagen y texto grande
    f.image = c:CreateTexture(nil, "ARTWORK")
    f.image:SetPoint("TOP", c, "TOP", 0, -14)
    f.hlTitle = c:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    f.hlTitle:SetPoint("TOP", f.image, "BOTTOM", 0, -12)
    f.hlTitle:SetWidth(WIDTH - 60)
    f.hlTitle:SetTextColor(1, 0.82, 0.3)
    f.hlText = c:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.hlText:SetPoint("TOP", f.hlTitle, "BOTTOM", 0, -6)
    f.hlText:SetWidth(WIDTH - 80)
    f.hlText:SetSpacing(2)

    -- registro de cambios con barra
    f.logTitle = c:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    f.scroll = CreateFrame("ScrollFrame", nil, c, "UIPanelScrollFrameTemplate")
    f.scroll:SetPoint("BOTTOMRIGHT", c, "BOTTOMRIGHT", -28, 10)
    f.log = CreateFrame("Frame", nil, f.scroll)
    f.log:SetSize(WIDTH - 90, 10)
    f.scroll:SetScrollChild(f.log)
    f.logText = f.log:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.logText:SetPoint("TOPLEFT")
    f.logText:SetWidth(WIDTH - 90)
    f.logText:SetJustifyH("LEFT")
    f.logText:SetSpacing(3)

    -- abajo: no volver a mostrar, abrir el menu de guias y cerrar
    f.never = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
    f.never:SetSize(24, 24)
    f.never:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 18, 18)
    f.neverText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.neverText:SetPoint("LEFT", f.never, "RIGHT", 4, 0)
    f.neverText:SetText(L["Don't show again"])
    f.never:SetScript("OnClick", function(self) QR.db.whatsNew = not self:GetChecked() end)
    local function Btn(text)
        local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        b:SetSize(150, 24)
        b:SetText(text)
        return b
    end
    f.close = Btn(L["Close"])
    f.close:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -18, 18)
    f.close:SetScript("OnClick", function() f:Hide() end)
    f.open = Btn(L["Open the guide browser"])
    f.open:SetWidth(190)
    f.open:SetPoint("RIGHT", f.close, "LEFT", -8, 0)
    f.open:SetScript("OnClick", function()
        f:Hide()
        if QR.Browser then QR.Browser:Open() end
    end)
    return f
end

function WhatsNew:Show()
    local f = self:Build()
    local ver = Version()
    local log = Changelog()
    f.title:SetText(BRAND .. " - " .. string.format(L["What's new in version %s"], log and log.version or ver))
    local hl = HIGHLIGHTS[log and log.version or ver]
    local top = 14
    if hl then
        f.image:SetTexture(MEDIA .. hl.image)
        f.image:SetSize(hl.w, hl.h)
        f.image:Show()
        f.hlTitle:SetText(L[hl.title])
        f.hlText:SetText(L[hl.text])
        f.hlTitle:Show(); f.hlText:Show()
        top = 14 + hl.h + 12 + f.hlTitle:GetStringHeight() + 6 + f.hlText:GetStringHeight() + 16
    else
        f.image:Hide(); f.hlTitle:Hide(); f.hlText:Hide()
    end
    f.logTitle:ClearAllPoints()
    f.logTitle:SetPoint("TOPLEFT", f.content, "TOPLEFT", 18, -top)
    f.logTitle:SetText(log and log.title or "")
    f.scroll:ClearAllPoints()
    f.scroll:SetPoint("TOPLEFT", f.logTitle, "BOTTOMLEFT", 0, -8)
    f.scroll:SetPoint("BOTTOMRIGHT", f.content, "BOTTOMRIGHT", -28, 10)
    local lines = {}
    for _, l in ipairs(log and log.lines or {}) do
        -- "# texto": subtitulo de un grupo de cambios (como en Ajustes > Cambios); lo demas, un punto de la lista
        if l:sub(1, 2) == "# " then lines[#lines + 1] = "|cffffd200" .. l:sub(3) .. "|r"
        else lines[#lines + 1] = "|cffffd166•|r  " .. l end
    end
    f.logText:SetText(table.concat(lines, "\n\n"))
    f.log:SetHeight(f.logText:GetStringHeight() + 6)
    f.never:SetChecked(QR.db.whatsNew == false)
    f:Show()
end

--- al entrar: si la version es nueva (y no es la primera instalacion), la ventana; despues se apunta la version
local function Check()
    local ver = Version()
    local last = QR.db.lastVersion
    QR.db.lastVersion = ver
    -- primera vez: quien instala ve el instalador; quien ya lo usaba (sin version apuntada, de antes de la 0.10.0)
    -- si ve las novedades
    local updated = (last and last ~= ver) or (not last and QR.db.installDone == true)
    if updated and QR.db.whatsNew ~= false then
        C_Timer.After(4, function() if not InCombatLockdown() then WhatsNew:Show() end end)
    end
end

QR:RegisterModule("WhatsNew", function() Check() end, true)

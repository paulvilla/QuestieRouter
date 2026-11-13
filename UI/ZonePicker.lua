-- QuestieRouter: selector de zona ("¿Que zona quieres completar?").
-- Sale la primera vez (sin guia elegida) y desde el boton de guias del banner.
-- Cada fila es una miniatura del banner de la zona (cielo a la hora actual + ilustracion).

local _, QR = ...
local L = QR.L

local Picker = {}
QR.ZonePicker = Picker

local ROW_H = 54
local WIDTH = 380

local function LocalName(g)
    local map = QR.Bridge:UiMapOf(g.areaId)
    local info = map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
    return info and info.name or g.zone
end

function Picker:Create()
    local S = QR.Skin
    local f = CreateFrame("Frame", "QuestieRouterZonePicker", UIParent)
    f:SetSize(WIDTH, 520)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    tinsert(UISpecialFrames, "QuestieRouterZonePicker") -- se cierra con Escape

    f.bg = S:CreateCard(f)
    f.bg:SetAllPoints()

    f.title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.title:SetPoint("TOPLEFT", 14, -12)
    f.sub = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.sub:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 0, -3)
    f.sub:SetPoint("RIGHT", -14, 0)
    f.sub:SetJustifyH("LEFT")

    local close = CreateFrame("Button", nil, f)
    close:SetSize(16, 16)
    close:SetPoint("TOPRIGHT", -10, -10)
    close.icon = close:CreateTexture(nil, "OVERLAY")
    close.icon:SetAllPoints()
    close.icon:SetTexture(S:UIIcon("Close"))
    close:SetScript("OnClick", function() f:Hide() end)

    local scroll = CreateFrame("ScrollFrame", nil, f)
    scroll:SetPoint("TOPLEFT", 10, -58)
    scroll:SetPoint("BOTTOMRIGHT", -10, 10)
    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(self, delta)
        local max = math.max(0, self.content:GetHeight() - self:GetHeight())
        self:SetVerticalScroll(math.max(0, math.min(max, self:GetVerticalScroll() - delta * ROW_H)))
    end)
    scroll.content = CreateFrame("Frame", nil, scroll)
    scroll.content:SetSize(WIDTH - 20, 10)
    scroll:SetScrollChild(scroll.content)
    f.scroll = scroll
    f.rows = {}
    self.frame = f
end

function Picker:GetRow(i)
    local f = self.frame
    local row = f.rows[i]
    if row then return row end
    row = CreateFrame("Button", nil, f.scroll.content)
    row:SetSize(WIDTH - 20, ROW_H - 4)
    row.banner = QR.Banner:Create(row, { thumb = true })
    row.banner:SetAllPoints()
    -- degradado oscuro a la izquierda para leer el texto
    row.shade = row:CreateTexture(nil, "ARTWORK", nil, 7)
    row.shade:SetPoint("TOPLEFT"); row.shade:SetPoint("BOTTOMLEFT")
    row.shade:SetWidth(230)
    row.shade:SetTexture(QR.Skin.MEDIA .. "Textures\\BannerTextVeil.tga")
    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    row.name:SetPoint("TOPLEFT", 10, -8)
    row.info = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    row.info:SetPoint("TOPLEFT", row.name, "BOTTOMLEFT", 0, -2)
    row.badge = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    row.badge:SetPoint("TOPRIGHT", -10, -8)
    for _, fs in ipairs({ row.name, row.info, row.badge }) do fs:SetShadowOffset(1, -1); fs:SetShadowColor(0, 0, 0, 1) end
    row.hl = row:CreateTexture(nil, "OVERLAY")
    row.hl:SetAllPoints()
    row.hl:SetColorTexture(1, 1, 1, 0.08)
    row.hl:Hide()
    row:SetScript("OnEnter", function(self) self.hl:Show() end)
    row:SetScript("OnLeave", function(self) self.hl:Hide() end)
    row:SetScript("OnClick", function(self)
        QR.Planner:SetGuide(self.guide.key)
        QR:Print(string.format(L["Active guide: %s"], self.guide.key))
        f:Hide()
    end)
    f.rows[i] = row
    return row
end

function Picker:Refresh()
    local S, f = QR.Skin, self.frame
    S:PaintCard(f.bg, "background", 0.97, "ui")
    S:StyleText(f.title, "title")
    S:StyleText(f.sub, "small")
    f.title:SetTextColor(1, 1, 1)
    f.sub:SetTextColor(0.75, 0.78, 0.75)
    f.title:SetText(self.firstRun and L["Which zone do you want to complete?"] or L["Choose a zone"])
    f.sub:SetText(L["Green: your level · red: still too high · grey: already outleveled"])

    local level = UnitLevel("player")
    local suggested = QR:SuggestZoneGuide()
    local active = QR.Planner:GetGuide()
    local y, suggestedY = 0, 0
    for i, g in ipairs(QR.zoneGuides) do
        local row = self:GetRow(i)
        row.guide = g
        local key = S:KeyForGuide(g)
        row.banner:SetZone(key, nil, 1)
        S:SetRounded(row, row.shade)
        S:SetRounded(row, row.hl)
        S:StyleText(row.name, "subtitle")
        S:StyleText(row.info, "small")
        S:StyleText(row.badge, "eyebrow")
        row.name:SetText(LocalName(g))
        row.name:SetTextColor(1, 1, 1)
        local color = (level < g.minLevel and "|cffff8178") or (level > g.maxLevel and "|cff9a9f9c") or "|cff71d6a2"
        row.info:SetText(string.format(L["%sLevels %d-%d|r  ·  %d quests"], color, g.minLevel, g.maxLevel, #g.quests))
        if g == active then
            row.badge:SetText(L["ACTIVE"])
            row.badge:SetTextColor(S:TextAccent())
        elseif g == suggested then
            row.badge:SetText(L["RECOMMENDED"])
            row.badge:SetTextColor(1, 0.82, 0.4)
        else
            row.badge:SetText("")
        end
        if g == suggested then suggestedY = y end
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", 0, -y)
        row:Show()
        y = y + ROW_H
    end
    for k = #QR.zoneGuides + 1, #f.rows do f.rows[k]:Hide() end
    f.scroll.content:SetHeight(math.max(10, y))
    local max = math.max(0, y - f.scroll:GetHeight())
    f.scroll:SetVerticalScroll(math.min(max, math.max(0, suggestedY - ROW_H)))
end

--- firstRun: pregunta inicial (sin guia elegida)
function Picker:Show(firstRun)
    if not self.frame then self:Create() end
    self.firstRun = firstRun
    self.frame:Show()
    -- las miniaturas necesitan tamaño real: pintar en el siguiente frame
    C_Timer.After(0, function() Picker:Refresh() end)
end

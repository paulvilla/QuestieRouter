-- QuestieRouter: aviso de habilidades nuevas al subir de nivel.
-- Al subir de nivel mira que habilidades del entrenador de tu clase (Classes/Skills, datos de What's Training?) puedes
-- aprender ya y aun no tienes, y saca una tarjeta con ellas y un boton para verlas en el menu de guias.
-- En Opciones (seccion "Aviso de habilidades nuevas") se puede encender o apagar, cambiar cuanto dura y previsualizarla
-- para moverla; la previsualizacion se quita sola al cerrar las opciones.

local _, QR = ...
local L = QR.L

local Notice = {}
QR.SkillNotice = Notice

local W, ROW_H, MAX_ROWS = 300, 26, 6

local function S() return QR.Skin end

local function DB()
    QR.db.skillNotice = QR.db.skillNotice or {}
    local d = QR.db.skillNotice
    if d.enabled == nil then d.enabled = true end
    d.duration = d.duration or 20
    return d
end

local function Known(id)
    local f = _G.IsPlayerSpell or _G.IsSpellKnown
    if not f then return false end
    local ok, k = pcall(f, id)
    return ok and k or false
end

local function SpellInfo(id)
    if C_Spell and C_Spell.GetSpellInfo then
        local i = C_Spell.GetSpellInfo(id)
        if i then return i.name, i.iconID end
    end
    if _G.GetSpellInfo then
        local ok, n, _, ic = pcall(_G.GetSpellInfo, id)
        if ok then return n, ic end
    end
end

local function Rank(id)
    local f = (C_Spell and C_Spell.GetSpellSubtext) or _G.GetSpellSubtext
    if not f then return nil end
    local ok, t = pcall(f, id)
    return ok and t ~= "" and t or nil
end

--- habilidades del entrenador que puedes aprender a tu nivel y no tienes (las de tu raza, faccion y talentos);
--- con onlyLevel, solo las que se abren justo en ese nivel
function Notice:Pending(level, onlyLevel)
    local out = {}
    local faction, race = UnitFactionGroup("player"), select(3, UnitRace("player"))
    for _, s in ipairs(QR.ClassSkills or {}) do
        local ok = (not s.race or s.race == race) and (not s.faction or s.faction == faction)
            and (not s.talent or Known(s.talent))
        if ok and s[1] <= level and (not onlyLevel or s[1] == onlyLevel) and not Known(s[2]) then
            out[#out + 1] = s
        end
    end
    return out
end

---------------------------------------------------------------------------
-- Tarjeta
---------------------------------------------------------------------------
function Notice:Create()
    if self.frame then return self.frame end
    local f = CreateFrame("Frame", "QuestieRouterSkillNotice", UIParent)
    f:SetSize(W, 120)
    f:SetFrameStrata("HIGH")
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) if Notice.preview then self:StartMoving() end end)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local p, _, rp, x, y = self:GetPoint()
        DB().pos = { p, rp, x, y }
    end)
    f.bg = S():CreateCard(f)
    f.bg:SetAllPoints()
    f.bg:SetFrameLevel(f:GetFrameLevel())
    -- capa de encima: textos e iconos (un marco hijo se dibuja sobre las texturas de su padre)
    local o = CreateFrame("Frame", nil, f)
    o:SetAllPoints()
    o:SetFrameLevel(f:GetFrameLevel() + 2)
    f.over = o
    f.icon = o:CreateTexture(nil, "OVERLAY")
    f.icon:SetSize(32, 32)
    f.icon:SetPoint("TOPLEFT", 12, -12)
    f.icon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
    f.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    f.title = o:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.title:SetPoint("TOPLEFT", f.icon, "TOPRIGHT", 10, -1)
    f.title:SetPoint("RIGHT", -30, 0)
    f.title:SetJustifyH("LEFT")
    f.sub = o:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.sub:SetPoint("BOTTOMLEFT", f.icon, "BOTTOMRIGHT", 10, 1)
    f.sub:SetPoint("RIGHT", -12, 0)
    f.sub:SetJustifyH("LEFT")
    f.close = CreateFrame("Button", nil, o)
    f.close:SetSize(16, 16)
    f.close:SetPoint("TOPRIGHT", -10, -10)
    f.close.icon = f.close:CreateTexture(nil, "OVERLAY")
    f.close.icon:SetAllPoints()
    f.close.icon:SetTexture(S():UIIcon("Close"))
    f.close:SetScript("OnClick", function()
        if Notice.preview then Notice:SetPreview(false) else f:Hide() end
    end)
    f.rows = {}
    for i = 1, MAX_ROWS do
        local r = o:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        r:SetPoint("TOPLEFT", 14, -54 - (i - 1) * ROW_H)
        r:SetPoint("RIGHT", -12, 0)
        r:SetJustifyH("LEFT")
        f.rows[i] = r
    end
    f.more = o:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.more:SetJustifyH("LEFT")
    f.open = CreateFrame("Button", nil, o)
    f.open:SetSize(W - 24, 26)
    f.open.bg = S():CreateCard(f.open)
    f.open.bg:SetAllPoints()
    f.open.text = f.open.bg:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.open.text:SetPoint("CENTER")
    f.open:SetScript("OnEnter", function(self) self.hover = true; Notice:PaintButton() end)
    f.open:SetScript("OnLeave", function(self) self.hover = nil; Notice:PaintButton() end)
    f.open:SetScript("OnClick", function()
        if Notice.preview then return end
        f:Hide()
        if QR.Browser then
            QR.Browser.classTab = "skills"
            QR.Browser:Open("CLASS")
        end
    end)
    f:SetScript("OnUpdate", function(self, el)
        if Notice.preview or not self.hideAt then return end
        if GetTime() >= self.hideAt and not self:IsMouseOver() then self:Hide() end
    end)
    f:Hide()
    self.frame = f
    self:Place()
    return f
end

function Notice:Place()
    local f, pos = self.frame, DB().pos
    f:ClearAllPoints()
    if pos then f:SetPoint(pos[1], UIParent, pos[2], pos[3], pos[4])
    else f:SetPoint("TOP", UIParent, "TOP", 0, -140) end
end

function Notice:PaintButton()
    local f = self.frame
    S():PaintCard(f.open.bg, f.open.hover and "active" or "card", 1, "ui")
end

--- pinta la tarjeta con una lista de habilidades { { nivel, hechizo, coste, ... } }
function Notice:Fill(level, list)
    local f, Sk = self:Create(), S()
    Sk:PaintCard(f.bg, "background", 0.96, "ui")
    Sk:StyleText(f.title, "subtitle", "ui")
    Sk:StyleText(f.sub, "small", "ui")
    f.title:SetText(L["New skills to learn"])
    f.title:SetTextColor(1, 1, 1)
    f.sub:SetText(Notice.preview and ("|cffffd166" .. L["Preview: drag it where you want it"] .. "|r")
        or string.format(L["Level %d: visit your class trainer"], level))
    f.sub:SetTextColor(Sk:TextAccent())
    local n = math.min(#list, MAX_ROWS)
    for i = 1, MAX_ROWS do
        local r = f.rows[i]
        local s = list[i]
        if i <= n and s then
            Sk:StyleText(r, "body", "ui")
            local name, icon = SpellInfo(s[2])
            local rank = Rank(s[2])
            r:SetText(string.format("|T%s:20:20:0:0:64:64:5:59:5:59|t  %s%s", tostring(icon or 134400), name or ("#" .. s[2]),
                rank and ("  |cff9a9f9c" .. rank .. "|r") or ""))
            r:Show()
        else
            r:Hide()
        end
    end
    local y = 54 + n * ROW_H
    if #list > MAX_ROWS then
        Sk:StyleText(f.more, "small", "ui")
        f.more:ClearAllPoints()
        f.more:SetPoint("TOPLEFT", 14, -y)
        f.more:SetText("|cff9a9f9c" .. string.format(L["and %d more"], #list - MAX_ROWS) .. "|r")
        f.more:Show()
        y = y + 18
    else
        f.more:Hide()
    end
    f.open:ClearAllPoints()
    f.open:SetPoint("TOPLEFT", 12, -(y + 4))
    Sk:StyleText(f.open.text, "body", "ui")
    f.open.text:SetText(L["See skills"])
    f.open.text:SetTextColor(1, 1, 1)
    self:PaintButton()
    f:SetHeight(y + 4 + 26 + 12)
    f:Show()
end

--- muestra el aviso (si esta encendido y hay algo que aprender)
function Notice:Show(level, onlyLevel)
    if not DB().enabled or self.preview then return end
    local list = self:Pending(level, onlyLevel)
    if #list == 0 then return end
    self:Fill(level, list)
    self.frame.hideAt = GetTime() + DB().duration
end

--- previsualizar (para moverla): con las habilidades que tengas pendientes o, si no hay, las de los proximos niveles
function Notice:SetPreview(on)
    on = on and true or false
    if (self.preview or false) == on then return end
    self.preview = on
    local f = self:Create()
    if on then
        local level = UnitLevel("player")
        local list = self:Pending(level)
        if #list == 0 then
            for _, s in ipairs(QR.ClassSkills or {}) do
                if s[1] > level then list[#list + 1] = s end
                if #list >= 4 then break end
            end
        end
        f:EnableMouse(true)
        self:Fill(level, list)
        f.hideAt = nil
    else
        f:Hide()
    end
    if QR.Options and QR.Options.frame and QR.Options.frame:IsShown() then QR.Options:Refresh() end
end

---------------------------------------------------------------------------
-- Subir de nivel
---------------------------------------------------------------------------
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LEVEL_UP")
ev:SetScript("OnEvent", function(_, _, level)
    level = tonumber(level) or UnitLevel("player")
    -- un momento despues: el juego actualiza antes los hechizos conocidos
    C_Timer.After(2, function() Notice:Show(level, level) end)
end)

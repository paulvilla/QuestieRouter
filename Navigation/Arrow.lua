-- QuestieRouter: flecha de navegacion estilo TomTom.
-- Estilos HD de Fusion (sombra + contorno + relleno, 3 capas que giran juntas) o la clasica de Blizzard.
-- Color del relleno: el de la zona (paleta de la skin), verde/rojo segun el rumbo, blanco o un material.

local _, QR = ...
local L = QR.L

local Arrow = {}
QR.Arrow = Arrow

local MEDIA = QR.Skin.MEDIA
local CLASSIC_TEXTURE = "Interface\\Minimap\\MinimapArrow"
local ARRIVED_TEXTURE = MEDIA .. "Icons\\Actions\\Action_complete.tga"
local PI2 = math.pi * 2
local AREA_YARDS = 50   -- dentro de esta distancia del objetivo de "hacer" se considera "en la zona"

Arrow.STYLES = {
    -- RX: puntas de flecha propias (tools/icon/make_rx_arrow.py) que apuntan hacia arriba y giran,
    -- en dos capas: borde (se queda blanco) y relleno (se tiñe). "RX redonda": esquinas redondeadas y base en curva.
    { key = "RX", name = "RX", rotate = MEDIA .. "Arrows\\RX\\arrow.tga",
      border = MEDIA .. "Arrows\\RX\\arrow-border.tga", fillTex = MEDIA .. "Arrows\\RX\\arrow-fill.tga" },
    { key = "RX_ROUND", name = "RX round", rotate = MEDIA .. "Arrows\\RXRound\\arrow.tga",
      border = MEDIA .. "Arrows\\RXRound\\arrow-border.tga", fillTex = MEDIA .. "Arrows\\RXRound\\arrow-fill.tga" },
    -- RX 3D: hojas de 150 fotogramas de 102x68 (1024x1024) + capa de brillo, dibujadas por
    -- tools/icon/make_3d_arrows.py. Se elige el fotograma por angulo (vuelta entera, sin reflejo).
    { key = "RX_PRISM", name = "RX 3D prism", sprite = { dir = MEDIA .. "Arrows\\RXPrism\\", count = 150, mirror = false } },
    { key = "RX_SLAB", name = "RX 3D block", sprite = { dir = MEDIA .. "Arrows\\RXSlab\\", count = 150, mirror = false } },
    { key = "HD_SOFT", name = "Soft", file = "01-Soft" },
    { key = "HD_RIBBON", name = "Ribbon", file = "02-Ribbon" },
    { key = "HD_LAUNCH", name = "Rocket", file = "03-Launch" },
    { key = "HD_HOLLOW", name = "Hollow compass", file = "04-Compass" },
    { key = "HD_TWIN", name = "Twin fin", file = "05-Twin" },
    { key = "HD_ARC", name = "Arc compass", file = "06-Arc" },
    { key = "HD_RAZOR", name = "Razor", file = "07-Razor" },
    { key = "HD_SPLIT", name = "Split compass", file = "08-Split" },
    { key = "HD_PORTAL", name = "Ring", file = "09-Portal" },
    { key = "HD_CLASSIC", name = "Classic HD", file = "10-Classic" },
    { key = "HD_CHEVRON", name = "Chevron", file = "11-Chevron" },
    { key = "HD_DOUBLE", name = "Double chevron", file = "12-DoubleChevron" },
    { key = "HD_SPEAR", name = "Spear", file = "13-Spear" },
    { key = "HD_TRIANGLE", name = "Triangle", file = "14-Triangle" },
    { key = "HD_KITE", name = "Compass", file = "15-Kite" },
    { key = "HD_WIDE", name = "Wide", file = "16-Wide" },
    { key = "HD_NOTCHED", name = "Notched", file = "17-Notched" },
    { key = "HD_OPEN", name = "Open head", file = "18-OpenHead" },
}
local styleByKey = {}
for _, s in ipairs(Arrow.STYLES) do styleByKey[s.key] = s end

--- Registra una flecha mas (lo usa Data/ArrowPack.lua con el paquete de flechas)
function Arrow:AddStyle(s)
    if styleByKey[s.key] then return end
    table.insert(Arrow.STYLES, s)
    styleByKey[s.key] = s
end

Arrow.MATERIALS = {
    { "MAT_CANDY", "Material: candy", "CANDY" },
    { "MAT_CONFETTI", "Material: confetti", "CONFETTI" },
    { "MAT_COW", "Material: cow", "COW" },
    { "MAT_DISCO", "Material: disco", "DISCO" },
    { "MAT_METAL", "Material: steel", "METAL" },
    { "MAT_CASE_HARDENED", "Material: case hardened", "CASE_HARDENED" },
    { "MAT_DOPPLER", "Material: doppler", "DOPPLER" },
}
local materialByKey = {}
for _, m in ipairs(Arrow.MATERIALS) do materialByKey[m[1]] = m[3] end

local function ColorForAngle(angle)
    local p = 1 - math.abs(angle) / math.pi
    if p > 0.5 then return (1 - p) * 2, 1, 0 end
    return 1, p * 2, 0
end

local function SavePosition(f)
    local point, _, relPoint, x, y = f:GetPoint(1)
    QR.db.arrow.point = { point, "UIParent", relPoint, x, y }
end

function Arrow:Create()
    local f = CreateFrame("Frame", "QuestieRouterArrow", UIParent)
    f:SetSize(56, 56)
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(s) if not QR.db.arrow.locked then s:StartMoving() end end)
    f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing(); SavePosition(s) end)

    -- capas: sombra, contorno, relleno (o una sola para la clasica)
    f.layers = {}
    -- las capas van en un submarco para poder ocultar solo el dibujo (al llegar a la zona) y dejar el texto
    f.art = CreateFrame("Frame", nil, f)
    f.art:SetAllPoints()
    for i = 1, 3 do
        local t = f.art:CreateTexture(nil, "ARTWORK", nil, i - 3)
        t:SetPoint("CENTER")
        t:SetSize(56, 56)
        if t.SetSnapToPixelGrid then t:SetSnapToPixelGrid(false); t:SetTexelSnappingBias(0) end
        f.layers[i] = t
    end

    f.spec = f.art:CreateTexture(nil, "ARTWORK", nil, 2)
    f.spec:SetPoint("CENTER")
    f.spec:Hide()

    f.title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.title:SetPoint("TOP", f, "BOTTOM", 0, -2)
    f.title:SetWidth(280)
    f.sub = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.sub:SetPoint("TOP", f.title, "BOTTOM", 0, -2)
    f.sub:SetWidth(280)
    f.sub:SetJustifyH("CENTER")
    f.sub:SetSpacing(2)
    -- tercera linea: estado (distancia o "En la zona"), con su propio tamaño
    f.status = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.status:SetPoint("TOP", f.sub, "BOTTOM", 0, -2)
    f.status:SetWidth(280)
    f.status:SetJustifyH("CENTER")
    for _, fs in ipairs({ f.title, f.sub, f.status }) do fs:SetShadowOffset(1, -1); fs:SetShadowColor(0, 0, 0, 1) end

    f:SetScript("OnUpdate", function(s, elapsed) Arrow:OnUpdate(s, elapsed) end)
    f:SetScript("OnEnter", function(s)
        GameTooltip:SetOwner(s, "ANCHOR_BOTTOM")
        GameTooltip:AddLine("QuestieRouter")
        local t = QR.target
        if t then
            GameTooltip:AddLine(t.questName or "", 1, 1, 1)
            GameTooltip:AddLine(t.name or "", 0.8, 0.8, 0.8)
            -- (los destinos de viaje solo tienen coordenadas de mundo)
            if t.x and t.y then GameTooltip:AddLine(string.format("%.1f, %.1f", t.x * 100, t.y * 100), 0.6, 0.6, 0.6) end
        end
        GameTooltip:AddLine(L["Drag to move. /qr for options."], 0.5, 0.5, 0.5)
        GameTooltip:Show()
    end)
    f:SetScript("OnLeave", function() GameTooltip:Hide() end)

    self.frame = f
    self:ApplySettings()
end

function Arrow:ApplyStyle()
    local f, cfg = self.frame, QR.db.arrow
    local style = styleByKey[cfg.style]
    self.classic = not style
    local L = f.layers
    self.offset = style and style.offset or 0
    self.sprite = style and style.sprite or nil
    self.keepColors = style and style.rotate ~= nil and cfg.color == "WHITE"
    f.spec:Hide()
    for i, t in ipairs(L) do
        t:SetSize(56, 56); t:SetTexCoord(0, 1, 0, 1); t:SetRotation(0)
        t:SetDrawLayer("ARTWORK", i - 3)
    end
    if style and style.sprite then
        -- RX 3D: fotograma elegido por angulo (sin rotacion), proporcion 102x68
        L[1]:Hide(); L[2]:Hide()
        L[3]:SetTexture(style.sprite.dir .. "arrow")
        L[3]:SetDesaturated(false)
        L[3]:SetSize(78, 52)
        f.spec:SetTexture(style.sprite.dir .. "arrow-specular")
        f.spec:SetSize(78, 52)
        f.spec:SetAlpha(0.7)
        f.spec:Show()
        self.fillMode = materialByKey[cfg.color] and "ZONE" or cfg.color
        self.arrived = nil
        return
    elseif style and style.rotate then
        -- RX: en "Blanco / original" se ve tal cual; con cualquier otro color solo se tiñe el
        -- interior y el borde blanco queda intacto (dos capas: relleno debajo, borde encima)
        L[1]:Hide()
        if cfg.color == "WHITE" or not style.border then
            L[2]:Hide()
            L[3]:SetTexture(style.rotate)
            -- las de color propio (p. ej. "Neon rojo") se desaturan para teñirse bien con otro color
            L[3]:SetDesaturated((style.keepColors and cfg.color ~= "WHITE") and true or false)
        else
            L[3]:SetTexture(style.fillTex)
            L[3]:SetDesaturated(false)
            L[2]:SetTexture(style.border)
            L[2]:SetDesaturated(false)
            L[2]:SetVertexColor(1, 1, 1)
            L[2]:SetDrawLayer("ARTWORK", 1)
            L[2]:SetSize(46, 46)
            L[2]:Show()
        end
        L[3]:SetSize(46, 46)
        self.fillMode = materialByKey[cfg.color] and "ZONE" or cfg.color
        self.arrived = nil
        return
    elseif style and style.single then
        local mat = materialByKey[cfg.color]
        L[3]:SetTexture(mat and (MEDIA .. "ArrowMaterials\\" .. mat .. "-ZoneArrow.tga") or style.single)
        L[3]:SetDesaturated(not mat)
        L[1]:Hide(); L[2]:Hide()
    elseif style then
        local base = MEDIA .. "Arrows\\" .. style.file
        L[1]:SetTexture(base .. "-shadow.tga")
        L[2]:SetTexture(base .. "-outline-mask.tga")
        local mat = materialByKey[cfg.color]
        if mat then
            L[3]:SetTexture(MEDIA .. "ArrowMaterials\\" .. mat .. "-" .. style.file .. ".tga")
            L[3]:SetDesaturated(false)
        else
            L[3]:SetTexture(base .. "-fill.tga")
            L[3]:SetDesaturated(true)
        end
        L[1]:Show(); L[2]:Show()
    else
        L[3]:SetTexture(CLASSIC_TEXTURE)
        L[3]:SetDesaturated(false)
        L[1]:Hide(); L[2]:Hide()
    end
    self.fillMode = materialByKey[cfg.color] and "MATERIAL" or cfg.color
    self.arrived = nil
end

function Arrow:ApplySettings()
    local f, cfg = self.frame, QR.db.arrow
    if not f then return end
    f:ClearAllPoints()
    local p = cfg.point
    f:SetPoint(p[1], _G[p[2]] or UIParent, p[3], p[4], p[5])
    f:SetScale(cfg.scale)
    -- tres tamaños independientes: titulo, requisitos y estado
    local function sized(fs, role, size)
        QR.Skin:StyleText(fs, role)
        if size then
            local path = QR.Skin:FontPath(role == "subtitle" and "SemiBold" or "Regular")
            if not fs:SetFont(path, size, "") then fs:SetFont(STANDARD_TEXT_FONT or "Fonts/FRIZQT__.TTF", size, "") end
        end
    end
    sized(f.title, "subtitle", cfg.titleSize)
    sized(f.sub, "small", cfg.reqSize)
    sized(f.status, "small", cfg.statusSize)
    self:ApplyStyle()
    self:UpdateVisibility()
end

function Arrow:UpdateVisibility()
    local f = self.frame
    if not f then return end
    f:SetShown(QR.db.enabled and QR.db.arrow.shown and QR.target ~= nil)
end

--- Coordenadas del fotograma n (1..count) en una hoja de 1024x1024 con fotogramas de 102x68 (10 por fila)
local SPR_W, SPR_H, INROW = 102 / 1024, 68 / 1024, 10
local function SpriteCoords(n)
    local row, col = math.floor((n - 1) / INROW), (n - 1) % INROW
    return col * SPR_W, (col + 1) * SPR_W, row * SPR_H, (row + 1) * SPR_H
end

--- Flechas 3D: elige el fotograma para un angulo (radianes, 0 = de frente, creciendo hacia la izquierda)
local function SetSpriteAngle(f, sprite, rot)
    local deg = math.deg(rot) % 360
    local n, flip
    if sprite.mirror then
        -- 150 fotogramas = media vuelta por la izquierda; la derecha es el reflejo
        if deg <= 180 then n = 1 + math.floor(deg / 180 * (sprite.count - 1) + 0.5)
        else n = 1 + math.floor((360 - deg) / 180 * (sprite.count - 1) + 0.5); flip = true end
    else
        n = 1 + math.floor(deg / 360 * sprite.count + 0.5) % sprite.count
    end
    local x1, x2, y1, y2 = SpriteCoords(n)
    if flip then x1, x2 = x2, x1 end
    f.layers[3]:SetTexCoord(x1, x2, y1, y2)
    f.spec:SetTexCoord(x1, x2, y1, y2)
end

local function SetRotationAll(f, rot)
    if Arrow.sprite then SetSpriteAngle(f, Arrow.sprite, rot) return end
    rot = rot + (Arrow.offset or 0)
    for _, t in ipairs(f.layers) do t:SetRotation(rot) end
end

function Arrow:PaintFill(rel)
    local fill = self.frame.layers[3]
    if self.fillMode == "MATERIAL" then fill:SetVertexColor(1, 1, 1); return end
    if self.fillMode == "WHITE" then fill:SetVertexColor(1, 1, 1); return end
    if self.fillMode == "CUSTOM" then
        local c = QR.db.arrow.customColor or { 1, 0.82, 0.3 }
        fill:SetVertexColor(c[1], c[2], c[3])
        return
    end
    if self.fillMode == "DIRECTION" or self.classic then
        if rel > math.pi then rel = rel - PI2 end
        fill:SetVertexColor(ColorForAngle(rel))
        return
    end
    local r, g, b = QR.Skin:Color("accent")
    fill:SetVertexColor(r * 0.85 + 0.15, g * 0.85 + 0.15, b * 0.85 + 0.15)
end

function Arrow:SetArrived(arrived)
    if self.arrived == arrived then return end
    self.arrived = arrived
    local L = self.frame.layers
    if arrived then
        L[1]:Hide(); L[2]:Hide()
        self.frame.spec:Hide()
        L[3]:SetSize(56, 56)
        L[3]:SetTexCoord(0, 1, 0, 1)
        L[3]:SetTexture(ARRIVED_TEXTURE)
        L[3]:SetDesaturated(false)
        L[3]:SetVertexColor(1, 1, 1)
        local t = L[3]
        t:SetRotation(0)
    else
        self:ApplyStyle()
    end
end

---------------------------------------------------------------------------
-- Texto bajo la flecha: que falta por conseguir y distancia
---------------------------------------------------------------------------

local function ObjectiveDone(o)
    return o.Completed == true or (o.Needed and o.Collected and o.Needed == o.Collected)
end

function Arrow:InfoLines(t)
    local T = QR.Skin.TEXT
    local lines = {}
    if t.kind == "travel" then
        local lines = {}
        for i, l in ipairs(t.travelLines or {}) do lines[i] = l end
        return lines, "travel"
    end
    if t.kind == "corpse" then
        return { T.done .. L["Recover your body to continue the guide"] .. "|r" }, "corpse"
    end
    if t.manual then   -- ruta elegida a mano (clic derecho en una mision de la lista)
        return { string.format(L["%sRoute to|r %s%s|r"], T.warn, T.friendly, t.name or "?"), T.done .. (t.questName or "") .. "|r" }, "manual"
    end
    local step = QR.Planner and QR.Planner:IsActive() and QR.Planner.plan and QR.Planner.plan.currentStep
    local kind = t.kind or (t.isTurnIn and "turnin" or "objective")
    if step and step.kind ~= "objective" then
        local fmt = step.kind == "pickup" and L["%sPick up|r from %s%s|r"] or L["%sTurn in|r to %s%s|r"]
        lines[1] = string.format(fmt, T.warn, T.friendly, step.npc or t.name or "")
        for i, l in ipairs(step.lines) do
            if i > 3 then lines[#lines + 1] = string.format(L["%s+%d more|r"], T.done, #step.lines - 3) break end
            lines[#lines + 1] = l.text
        end
        return lines, kind
    end
    if kind == "turnin" then
        lines[1] = string.format(L["%sTurn in|r to %s%s|r"], T.warn, T.friendly, t.name or "")
        return lines, kind
    end
    -- objetivos pendientes de la mision (con contador)
    local quest = t.questId and QR.Bridge:GetQuest(t.questId)
    local shown = 0
    for _, o in pairs(quest and quest.Objectives or {}) do
        if not ObjectiveDone(o) and shown < 4 then
            shown = shown + 1
            local color = o.Type == "item" and T.loot or T.enemy
            if o.Needed and o.Needed > 1 then
                lines[#lines + 1] = string.format("%s%s|r  %d/%d", color, o.Description or "?", o.Collected or 0, o.Needed)
            else
                lines[#lines + 1] = color .. (o.Description or "?") .. "|r"
            end
        end
    end
    if shown == 0 and t.name then lines[1] = T.enemy .. t.name .. "|r" end
    -- aviso: otra mision tiene algo que recoger muy cerca (no cambia el paso, solo avisa)
    local near = QR.Planner and QR.Planner.plan and QR.Planner.plan.nearby
    if near then lines[#lines + 1] = string.format(L["%sWatch out:|r pick up %s"], T.warn, near.text) end
    return lines, kind
end

local throttle = 0
function Arrow:OnUpdate(f, elapsed)
    local t = QR.target
    if not t then return end
    -- en vuelo la flecha no sirve: se oculta hasta aterrizar
    if UnitOnTaxi and UnitOnTaxi("player") then f:SetAlpha(0) return end

    local px, py, pinst = QR.HBD:GetPlayerWorldPosition()
    if not px then f:SetAlpha(0.4) return end

    if pinst ~= t.instance then
        self:SetArrived(false)
        SetRotationAll(f, 0)
        f.layers[3]:SetVertexColor(0.6, 0.6, 0.6)
        f.title:SetText(t.questName or "")
        f.sub:SetText(t.name or "")
        f.status:SetText("|cffff8178" .. L["Another continent"] .. "|r")
        return
    end

    local angle, dist = QR.HBD:GetWorldVector(pinst, px, py, t.wx, t.wy)
    local facing = GetPlayerFacing()
    if not angle or not facing then f:SetAlpha(0.4) return end
    f:SetAlpha(1)

    -- En el area de los objetivos la flecha sobra: se oculta el dibujo y queda el texto
    local kindNow = t.kind or (t.isTurnIn and "turnin" or "objective")
    local inAreaNow = kindNow == "objective" and dist <= AREA_YARDS
    f.art:SetShown(not (inAreaNow and QR.db.arrow.hideInArea ~= false))

    if dist <= QR.db.arrow.arrivalDistance then
        self:SetArrived(true)
    else
        self:SetArrived(false)
        local rel = (angle - facing) % PI2
        SetRotationAll(f, rel)
        self:PaintFill(rel)
    end

    throttle = throttle - elapsed
    if throttle <= 0 then
        throttle = 0.2
        f.title:SetText(t.questName or "")
        f.title:SetTextColor(1, 1, 1)
        local lines, kind = self:InfoLines(t)
        -- dentro del area del objetivo no tiene sentido la distancia: se indica "En la zona"
        local inArea = kind == "objective" and dist <= AREA_YARDS
        f.sub:SetText(table.concat(lines, "\n"))
        if inArea then
            f.status:SetText(QR.Skin.TEXT.friendly .. L["In the area"] .. "|r")
        else
            f.status:SetText(string.format("|cffffffff%d yd|r", math.floor(dist)))
        end
    end
end

function Arrow:Init()
    self:Create()
    QR:On("TARGET_CHANGED", function() Arrow:UpdateVisibility() end)
    QR:On("SETTINGS_CHANGED", function() Arrow:ApplySettings() end)
end

QR:RegisterModule("Arrow", function() Arrow:Init() end)

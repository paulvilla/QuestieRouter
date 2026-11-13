-- QuestieRouter: opciones graficas (inspiradas en el menu de Fusion).
-- Controles propios (interruptor, selector con flechas y deslizador) para no depender de
-- plantillas de Blizzard que cambian entre clientes.

local _, QR = ...
local L = QR.L

local Options = {}
QR.Options = Options

local WIDTH, HEIGHT = 360, 540
local ROW = 30

local function Changed() QR:Fire("SETTINGS_CHANGED") end

---------------------------------------------------------------------------
-- Controles
---------------------------------------------------------------------------
local function Label(parent, text)
    local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    QR.Skin:StyleText(fs, "body")
    fs:SetText(L[text])
    fs:SetTextColor(0.88, 0.9, 0.88)
    return fs
end

local function Toggle(parent, text, get, set)
    local row = CreateFrame("Button", nil, parent)
    row:SetHeight(ROW)
    row.label = Label(row, text)
    row.label:SetPoint("LEFT", 4, 0)
    row.box = CreateFrame("Frame", nil, row)
    row.box:SetSize(34, 16)
    row.box:SetPoint("RIGHT", -4, 0)
    row.track = QR.Skin:CreateCard(row.box)
    row.track:SetAllPoints()
    -- la bola va en una capa por encima de la pista (si no, la pista la tapa)
    row.knobFrame = CreateFrame("Frame", nil, row.box)
    row.knobFrame:SetSize(14, 14)
    row.knobFrame:SetFrameLevel(row.track:GetFrameLevel() + 3)
    row.knobShadow = row.knobFrame:CreateTexture(nil, "ARTWORK", nil, 1)
    row.knobShadow:SetPoint("TOPLEFT", -1, 0)
    row.knobShadow:SetPoint("BOTTOMRIGHT", 1, -2)
    row.knobShadow:SetTexture(QR.Skin.MEDIA .. "Textures\\SoftPanelCircle.tga")
    row.knobShadow:SetVertexColor(0, 0, 0, 0.55)
    row.knob = row.knobFrame:CreateTexture(nil, "ARTWORK", nil, 2)
    row.knob:SetAllPoints()
    row.knob:SetTexture(QR.Skin.MEDIA .. "Textures\\SoftPanelCircle.tga")
    function row:Update()
        local on = get()
        local r, g, b = QR.Skin:Color("accent")
        -- encendido: pista del color de la zona y bola blanca a la derecha; apagado: todo apagado a la izquierda
        if on then
            row.track.bg:SetVertexColor(r, g, b, 1)
            row.knob:SetVertexColor(1, 1, 1, 1)
        else
            row.track.bg:SetVertexColor(0.16, 0.17, 0.17, 1)
            row.knob:SetVertexColor(0.55, 0.57, 0.56, 1)
        end
        row.knobFrame:ClearAllPoints()
        row.knobFrame:SetPoint(on and "RIGHT" or "LEFT", row.box, on and "RIGHT" or "LEFT", on and -1 or 1, 0)
    end
    row:SetScript("OnClick", function() set(not get()); row:Update(); Changed() end)
    return row
end

--- values: lista de { value, text }
local function Cycle(parent, text, values, get, set)
    local row = CreateFrame("Frame", nil, parent)
    row:SetHeight(ROW)
    row.label = Label(row, text)
    row.label:SetPoint("LEFT", 4, 0)
    local function arrow(icon, dir)
        local b = CreateFrame("Button", nil, row)
        b:SetSize(14, 14)
        b.icon = b:CreateTexture(nil, "OVERLAY")
        b.icon:SetAllPoints()
        b.icon:SetTexture(QR.Skin:UIIcon(icon))
        b:SetScript("OnClick", function()
            local list = type(values) == "function" and values() or values
            local cur = get()
            local idx = 1
            for i, v in ipairs(list) do if v[1] == cur then idx = i end end
            idx = (idx - 1 + dir) % #list + 1
            set(list[idx][1])
            row:Update()
            Changed()
        end)
        return b
    end
    row.right = arrow("ArrowRight", 1)
    row.right:SetPoint("RIGHT", -4, 0)
    row.value = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    QR.Skin:StyleText(row.value, "small")
    row.value:SetPoint("RIGHT", row.right, "LEFT", -6, 0)
    row.value:SetWidth(130)
    row.value:SetJustifyH("CENTER")
    row.left = arrow("ArrowLeft", -1)
    row.left:SetPoint("RIGHT", row.value, "LEFT", -6, 0)
    function row:Update()
        local list = type(values) == "function" and values() or values
        local cur = get()
        local text = tostring(cur)
        for _, v in ipairs(list) do if v[1] == cur then text = L[v[2]] end end
        row.value:SetText(text)
        row.value:SetTextColor(QR.Skin:TextAccent())
    end
    return row
end

local function Slider(parent, text, min, max, step, get, set, fmt)
    local row = CreateFrame("Frame", nil, parent)
    row:SetHeight(ROW + 8)
    row.label = Label(row, text)
    row.label:SetPoint("TOPLEFT", 4, -2)
    row.value = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    QR.Skin:StyleText(row.value, "small")
    row.value:SetPoint("TOPRIGHT", -4, -3)
    local s = CreateFrame("Slider", nil, row)
    s:SetOrientation("HORIZONTAL")
    s:SetHeight(14)
    s:SetPoint("BOTTOMLEFT", 4, 4)
    s:SetPoint("BOTTOMRIGHT", -4, 4)
    s:SetMinMaxValues(min, max)
    s:SetValueStep(step)
    if s.SetObeyStepOnDrag then s:SetObeyStepOnDrag(true) end
    s.track = s:CreateTexture(nil, "BACKGROUND")
    s.track:SetPoint("LEFT"); s.track:SetPoint("RIGHT")
    s.track:SetHeight(4)
    s.track:SetColorTexture(1, 1, 1, 1)
    s:SetThumbTexture(QR.Skin.MEDIA .. "Textures\\RoundedThumb.tga")
    local thumb = s:GetThumbTexture()
    if thumb then thumb:SetSize(14, 14) end
    -- la rueda NO cambia el valor: asi pasa a la barra de desplazamiento de la ventana
    -- y se puede bajar por las opciones sin tocar nada sin querer
    s:EnableMouseWheel(false)
    row.slider = s
    local updating = false
    s:SetScript("OnValueChanged", function(_, v)
        v = math.floor(v / step + 0.5) * step
        row.value:SetText(fmt and fmt(v) or tostring(v))
        if updating then return end
        if v ~= get() then set(v); Changed() end
    end)
    function row:Update()
        updating = true
        s:SetValue(get())
        updating = false
        row.value:SetText(fmt and fmt(get()) or tostring(get()))
        local r, g, b = QR.Skin:Color("accent")
        s.track:SetVertexColor(r * 0.6, g * 0.6, b * 0.6, 0.8)
        row.value:SetTextColor(QR.Skin:TextAccent())
    end
    return row
end

--- Cuadricula con la vista previa de todas las flechas (las de Fusion + la clasica)
local function ArrowGrid(parent)
    local COLS, CELL = 6, 52
    local row = CreateFrame("Frame", nil, parent)
    local styles = {}
    for _, s in ipairs(QR.Arrow.STYLES) do styles[#styles + 1] = s end
    row:SetHeight(math.ceil(#styles / COLS) * CELL + 6)
    row.cells = {}
    for i, s in ipairs(styles) do
        local b = CreateFrame("Button", nil, row)
        b:SetSize(CELL - 4, CELL - 4)
        b:SetPoint("TOPLEFT", ((i - 1) % COLS) * CELL + 2, -math.floor((i - 1) / COLS) * CELL - 2)
        b.bg = QR.Skin:CreateCard(b)
        b.bg:SetAllPoints()
        -- la tarjeta de fondo es un marco hijo y taparia las flechas: van en una capa por encima
        b.art = CreateFrame("Frame", nil, b)
        b.art:SetAllPoints()
        b.art:SetFrameLevel(b.bg:GetFrameLevel() + 2)
        b.layers = {}
        local paths
        if s.sprite then
            paths = { s.sprite.dir .. "arrow" }
        elseif s.rotate then
            paths = s.border and { s.border, s.fillTex } or { s.rotate }
        elseif s.single then
            paths = { s.single }
        elseif s.file then
            local base = QR.Skin.MEDIA .. "Arrows\\" .. s.file
            paths = { base .. "-shadow.tga", base .. "-outline-mask.tga", base .. "-fill.tga" }
        else
            paths = { "Interface/Minimap/MinimapArrow" }
        end
        for k, path in ipairs(paths) do
            local t = b.art:CreateTexture(nil, "ARTWORK", nil, k - 3)
            t:SetPoint("CENTER")
            t:SetSize(CELL - 14, CELL - 14)
            t:SetTexture(path)
            if s.offset then t:SetRotation(s.offset) end
            b.layers[k] = t
        end
        b.fill = b.layers[#b.layers]
        if s.sprite then
            -- primer fotograma (de frente), proporcion 102x68
            b.fill:SetTexCoord(0, 102 / 1024, 0, 68 / 1024)
            b.fill:SetSize(CELL - 8, (CELL - 8) * 68 / 102)
        end
        if s.file or s.single then b.fill:SetDesaturated(true) end
        if s.rotate and s.border then
            -- borde encima del relleno (blanco, sin teñir)
            b.layers[1]:SetDrawLayer("ARTWORK", 1)
            b.ringTex = b.layers[1]
        end
        b.style = s
        b:SetScript("OnClick", function()
            QR.db.arrow.style = s.key
            Changed()
        end)
        b:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:AddLine(L[s.name])
            GameTooltip:Show()
        end)
        b:SetScript("OnLeave", function() GameTooltip:Hide() end)
        row.cells[i] = b
    end
    function row:Update()
        local r, g, bl = QR.Skin:Color("accent")
        for _, b in ipairs(row.cells) do
            local selected = QR.db.arrow.style == b.style.key
            QR.Skin:PaintCard(b.bg, selected and "active" or "card", 1, "ui")
            b.bg.bg:SetVertexColor(selected and r * 0.45 or 0.10, selected and g * 0.45 or 0.11, selected and bl * 0.45 or 0.11, 0.95)
            -- relleno legible: color de la zona aclarado; la seleccionada en blanco sobre su fondo de color
            -- todas con el color de la zona (tambien las RX); la seleccionada en blanco
            if selected then b.fill:SetVertexColor(1, 1, 1) else b.fill:SetVertexColor(QR.Skin:TextAccent(0.7)) end
        end
    end
    return row
end

--- Abre el selector de color de WoW (API nueva SetupColorPickerAndShow o la clasica)
local function OpenColorPicker(color, onChange)
    local r, g, b = color[1], color[2], color[3]
    local function apply(nr, ng, nb)
        color[1], color[2], color[3] = nr, ng, nb
        onChange()
    end
    local cpf = ColorPickerFrame
    if not cpf then return end
    if cpf.SetupColorPickerAndShow then
        cpf:SetupColorPickerAndShow({
            r = r, g = g, b = b, hasOpacity = false,
            swatchFunc = function() apply(cpf:GetColorRGB()) end,
            cancelFunc = function() apply(r, g, b) end,
        })
    else
        cpf:Hide()
        cpf.hasOpacity = false
        cpf.previousValues = { r, g, b }
        cpf.func = function() apply(cpf:GetColorRGB()) end
        cpf.cancelFunc = function() apply(r, g, b) end
        cpf:SetColorRGB(r, g, b)
        cpf:Show()
    end
end

--- Fila con una muestra de color; clic = selector de color. getColor devuelve la tabla {r, g, b}
local function ColorSwatch(parent, text, getColor)
    local row = CreateFrame("Frame", nil, parent)
    row:SetHeight(ROW)
    row.label = Label(row, text)
    row.label:SetPoint("LEFT", 4, 0)
    local b = CreateFrame("Button", nil, row)
    b:SetSize(44, 16)
    b:SetPoint("RIGHT", -4, 0)
    b.edge = b:CreateTexture(nil, "BACKGROUND")
    b.edge:SetAllPoints()
    b.edge:SetColorTexture(0, 0, 0, 0.9)
    b.swatch = b:CreateTexture(nil, "ARTWORK")
    b.swatch:SetPoint("TOPLEFT", 1, -1)
    b.swatch:SetPoint("BOTTOMRIGHT", -1, 1)
    b.swatch:SetColorTexture(1, 1, 1, 1)
    b:SetScript("OnClick", function()
        OpenColorPicker(getColor(), function() row:Update(); Changed() end)
    end)
    row.button = b
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:AddLine(L["Click to choose the color"])
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    function row:Update()
        local c = getColor()
        b.swatch:SetVertexColor(c[1], c[2], c[3], 1)
    end
    return row
end

--- Casilla donde se arrastra una habilidad desde el libro de hechizos (clic derecho en la casilla = quitar)
local function SpellDrop(parent, text)
    local function GetSpellName(id)
        if C_Spell and C_Spell.GetSpellName then return C_Spell.GetSpellName(id) end
        if GetSpellInfo then return (GetSpellInfo(id)) end
    end
    local function GetSpellIcon(id)
        if C_Spell and C_Spell.GetSpellTexture then return C_Spell.GetSpellTexture(id) end
        if GetSpellInfo then return (select(3, GetSpellInfo(id))) end
    end
    local row = CreateFrame("Frame", nil, parent)
    row:SetHeight(ROW + 14)
    row.label = Label(row, text)
    row.label:SetPoint("TOPLEFT", 4, -4)
    row.label:SetPoint("RIGHT", row, "RIGHT", -48, 0)
    row.label:SetJustifyH("LEFT")
    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    QR.Skin:StyleText(row.name, "small")
    row.name:SetPoint("TOPLEFT", row.label, "BOTTOMLEFT", 0, -3)
    local slot = CreateFrame("Button", nil, row)
    slot:SetSize(34, 34)
    slot:SetPoint("RIGHT", -4, 0)
    slot.bg = slot:CreateTexture(nil, "BACKGROUND")
    slot.bg:SetAllPoints()
    slot.bg:SetColorTexture(0, 0, 0, 0.6)
    slot.icon = slot:CreateTexture(nil, "ARTWORK")
    slot.icon:SetPoint("TOPLEFT", 1, -1)
    slot.icon:SetPoint("BOTTOMRIGHT", -1, 1)
    slot.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    slot:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    local function take()
        local kind, a, b, c = GetCursorInfo()
        if kind ~= "spell" then return end
        -- clientes modernos: ("spell", indice, libro, spellID); clasicos: ("spell", indice, libro)
        local id = c
        if not id and a and b and GetSpellBookItemInfo then id = select(2, GetSpellBookItemInfo(a, b)) end
        if not id and a and C_SpellBook and C_SpellBook.GetSpellBookItemInfo then
            local info = C_SpellBook.GetSpellBookItemInfo(a, b)
            id = info and (info.spellID or info.actionID)
        end
        if id then
            QR.charDB.targetSpell = id
            ClearCursor()
            row:Update()
            Changed()
        end
    end
    slot:SetScript("OnReceiveDrag", take)
    slot:SetScript("OnClick", function(_, button)
        if button == "RightButton" then
            QR.charDB.targetSpell = nil
            row:Update()
            Changed()
        else
            take()
        end
    end)
    slot:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        local id = QR.charDB.targetSpell
        if id and GameTooltip.SetSpellByID then GameTooltip:SetSpellByID(id) else GameTooltip:AddLine(L["Right-click ability"]) end
        GameTooltip:AddLine(L["Drag an ability here from your spellbook."], 0.7, 0.7, 0.7)
        GameTooltip:AddLine(L["Right-click: remove."], 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    slot:SetScript("OnLeave", function() GameTooltip:Hide() end)
    row.slot = slot
    function row:Update()
        local id = QR.charDB.targetSpell
        if id then
            slot.icon:SetTexture(GetSpellIcon(id))
            row.name:SetText(GetSpellName(id) or ("#" .. id))
            row.name:SetTextColor(QR.Skin:TextAccent())
        else
            slot.icon:SetTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot")
            row.name:SetText(L["None (right-click only targets)"])
            row.name:SetTextColor(0.6, 0.62, 0.6)
        end
    end
    return row
end

--- Vista previa de una flecha dentro de 'holder' (capas reutilizables), teñida como en la cuadricula
local function PaintArrowPreview(holder, s, size, color)
    holder.layers = holder.layers or {}
    for i = 1, 3 do
        if not holder.layers[i] then
            local t = holder:CreateTexture(nil, "ARTWORK", nil, i - 3)
            t:SetPoint("CENTER")
            holder.layers[i] = t
        end
        local t = holder.layers[i]
        t:Hide(); t:SetTexCoord(0, 1, 0, 1); t:SetRotation(0); t:SetDesaturated(false)
        t:SetVertexColor(1, 1, 1); t:SetSize(size, size); t:SetDrawLayer("ARTWORK", i - 3)
    end
    local L = holder.layers
    local fill
    local MEDIA = QR.Skin.MEDIA
    if s.sprite then
        L[1]:SetTexture(s.sprite.dir .. "arrow")
        L[1]:SetTexCoord(0, 102 / 1024, 0, 68 / 1024)
        L[1]:SetSize(size, size * 68 / 102)
        fill = L[1]
    elseif s.rotate and s.border then
        L[1]:SetTexture(s.fillTex)
        L[2]:SetTexture(s.border); L[2]:SetDrawLayer("ARTWORK", 1); L[2]:Show()
        fill = L[1]
    elseif s.rotate then
        L[1]:SetTexture(s.rotate)
        L[1]:SetDesaturated(s.keepColors and true or false)
        fill = L[1]
    elseif s.single then
        L[1]:SetTexture(s.single)
        L[1]:SetDesaturated(true)
        if s.offset then L[1]:SetRotation(s.offset) end
        fill = L[1]
    elseif s.file then
        local base = MEDIA .. "Arrows\\" .. s.file
        L[1]:SetTexture(base .. "-shadow.tga"); L[1]:Show()
        L[2]:SetTexture(base .. "-outline-mask.tga"); L[2]:Show()
        L[3]:SetTexture(base .. "-fill.tga"); L[3]:SetDesaturated(true)
        fill = L[3]
    end
    if fill then
        fill:Show()
        fill:SetVertexColor(color[1], color[2], color[3])
    end
end

--- Grupo de cada flecha en el desplegable
local function ArrowGroup(s)
    if s.pack then return 3, "ARROW PACK" end
    if s.sprite or s.rotate then return 2, "RX" end
    return 1, "FUSION"
end

--- Desplegable de flechas: boton con la flecha elegida; al abrirlo, lista con vista previa de cada una
local function ArrowDropdown(parent)
    local ROWH, LIST_H = 30, 320
    local row = CreateFrame("Frame", nil, parent)
    row:SetHeight(ROW + 30)
    row.label = Label(row, "Arrow style")
    row.label:SetPoint("TOPLEFT", 4, -4)

    local btn = CreateFrame("Button", nil, row)
    btn:SetPoint("TOPLEFT", 4, -22)
    btn:SetPoint("TOPRIGHT", -4, -22)
    btn:SetHeight(32)
    btn.bg = QR.Skin:CreateCard(btn)
    btn.bg:SetAllPoints()
    btn.art = CreateFrame("Frame", nil, btn)
    btn.art:SetSize(26, 26)
    btn.art:SetPoint("LEFT", 6, 0)
    btn.art:SetFrameLevel(btn.bg:GetFrameLevel() + 2)
    btn.text = btn.art:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    btn.text:SetPoint("LEFT", btn.art, "RIGHT", 8, 0)
    btn.chev = btn.art:CreateTexture(nil, "OVERLAY")
    btn.chev:SetSize(12, 12)
    btn.chev:SetPoint("RIGHT", btn, "RIGHT", -10, 0)
    btn.chev:SetTexture(QR.Skin:UIIcon("ArrowDown"))
    row.button = btn

    -- lista desplegable (sobre todo lo demas; se cierra al elegir, con Escape o al cerrar Opciones)
    local pop = CreateFrame("Frame", "QuestieRouterArrowList", UIParent)
    pop:SetFrameStrata("FULLSCREEN_DIALOG")
    pop:SetClampedToScreen(true)
    pop:EnableMouse(true)
    pop:Hide()
    tinsert(UISpecialFrames, "QuestieRouterArrowList")
    pop.bg = QR.Skin:CreateCard(pop)
    pop.bg:SetAllPoints()
    local scroll = CreateFrame("ScrollFrame", nil, pop)
    scroll:SetPoint("TOPLEFT", 4, -4)
    scroll:SetPoint("BOTTOMRIGHT", -4, 4)
    scroll:EnableMouseWheel(true)
    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(10, 10)
    scroll:SetScrollChild(content)
    scroll:SetScript("OnMouseWheel", function(self, d)
        local max = math.max(0, content:GetHeight() - self:GetHeight())
        self:SetVerticalScroll(math.max(0, math.min(max, self:GetVerticalScroll() - d * ROWH * 2)))
    end)
    pop.rows, pop.heads = {}, {}

    local function sorted()
        local list = {}
        for i, s in ipairs(QR.Arrow.STYLES) do list[#list + 1] = { s = s, i = i, g = (ArrowGroup(s)) } end
        table.sort(list, function(a, b) if a.g ~= b.g then return a.g < b.g end return a.i < b.i end)
        return list
    end

    local function fill()
        local accent = { QR.Skin:TextAccent(0.7) }
        local width = btn:GetWidth()
        pop:SetSize(width, LIST_H)
        content:SetWidth(width - 8)
        QR.Skin:PaintCard(pop.bg, "background", 0.98, "ui")
        local y, lastGroup, ri, hi = 0, nil, 0, 0
        local selectedY
        for _, e in ipairs(sorted()) do
            local g, gname = ArrowGroup(e.s)
            if g ~= lastGroup then
                lastGroup = g
                hi = hi + 1
                local h = pop.heads[hi]
                if not h then
                    h = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                    pop.heads[hi] = h
                end
                QR.Skin:StyleText(h, "eyebrow")
                h:SetTextColor(QR.Skin:TextAccent())
                h:SetText(L[gname])
                h:ClearAllPoints()
                h:SetPoint("TOPLEFT", 8, -(y + 8))
                h:Show()
                y = y + 22
            end
            ri = ri + 1
            local r = pop.rows[ri]
            if not r then
                r = CreateFrame("Button", nil, content)
                r:SetHeight(ROWH)
                r.hl = r:CreateTexture(nil, "BACKGROUND")
                r.hl:SetAllPoints()
                r.hl:SetColorTexture(1, 1, 1, 1)
                r.art = CreateFrame("Frame", nil, r)
                r.art:SetSize(24, 24)
                r.art:SetPoint("LEFT", 6, 0)
                r.text = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                r.text:SetPoint("LEFT", r.art, "RIGHT", 8, 0)
                r:SetScript("OnEnter", function(self) self.hover = true; self:Paint() end)
                r:SetScript("OnLeave", function(self) self.hover = nil; self:Paint() end)
                r:SetScript("OnClick", function(self)
                    QR.db.arrow.style = self.style.key
                    pop:Hide()
                    row:Update()
                    Changed()
                end)
                function r:Paint()
                    local sel = QR.db.arrow.style == self.style.key
                    local ar, ag, ab = QR.Skin:Color("accent")
                    QR.Skin:SetRounded(self, self.hl)
                    if sel then self.hl:SetVertexColor(ar * 0.45, ag * 0.45, ab * 0.45, 0.9)
                    elseif self.hover then self.hl:SetVertexColor(1, 1, 1, 0.08)
                    else self.hl:SetVertexColor(0, 0, 0, 0) end
                end
                pop.rows[ri] = r
            end
            r.style = e.s
            QR.Skin:StyleText(r.text, "small")
            r.text:SetText(L[e.s.name])
            r.text:SetTextColor(0.9, 0.92, 0.9)
            PaintArrowPreview(r.art, e.s, 22, accent)
            r:ClearAllPoints()
            r:SetPoint("TOPLEFT", 0, -y)
            r:SetPoint("RIGHT", content, "RIGHT")
            r:Paint()
            r:Show()
            if QR.db.arrow.style == e.s.key then selectedY = y end
            y = y + ROWH
        end
        for k = ri + 1, #pop.rows do pop.rows[k]:Hide() end
        for k = hi + 1, #pop.heads do pop.heads[k]:Hide() end
        content:SetHeight(y + 4)
        -- abrir con la flecha elegida a la vista
        local max = math.max(0, y + 4 - (LIST_H - 8))
        scroll:SetVerticalScroll(math.min(max, math.max(0, (selectedY or 0) - LIST_H / 2)))
    end

    btn:SetScript("OnClick", function()
        if pop:IsShown() then pop:Hide() return end
        pop:ClearAllPoints()
        pop:SetPoint("TOPLEFT", btn, "BOTTOMLEFT", 0, -2)
        fill()
        pop:Show()
    end)
    -- al cerrarse Opciones (o desplazarse la fila fuera de la vista) se cierra la lista
    row:SetScript("OnHide", function() pop:Hide() end)

    function row:Update()
        local s
        for _, st in ipairs(QR.Arrow.STYLES) do if st.key == QR.db.arrow.style then s = st end end
        s = s or QR.Arrow.STYLES[1]
        QR.Skin:PaintCard(btn.bg, "card", 1, "ui")
        QR.Skin:StyleText(btn.text, "body")
        btn.text:SetText(L[s.name])
        btn.text:SetTextColor(1, 1, 1)
        btn.chev:SetVertexColor(QR.Skin:TextAccent())
        PaintArrowPreview(btn.art, s, 24, { QR.Skin:TextAccent(0.7) })
        if pop:IsShown() then fill() end
    end
    return row
end

--- Marca un control para que solo se vea cuando cond() es verdadero
local function Visible(control, cond)
    control.visibleIf = cond
    return control
end

local function Header(parent, text)
    local row = CreateFrame("Frame", nil, parent)
    row:SetHeight(ROW)
    row.label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    QR.Skin:StyleText(row.label, "eyebrow")
    row.label:SetPoint("BOTTOMLEFT", 4, 4)
    row.label:SetText(L[text])
    row.isHeader = true
    function row:Update() row.label:SetTextColor(QR.Skin:TextAccent()) end
    return row
end

---------------------------------------------------------------------------
-- Barra de desplazamiento propia (carril fino + tirador del color de la zona)
---------------------------------------------------------------------------
local function CreateScrollBar(f, scroll, content)
    local bar = CreateFrame("Frame", nil, f)
    bar:SetWidth(6)
    bar:SetPoint("TOPRIGHT", f, "TOPRIGHT", -8, -42)
    bar:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 14)
    bar.track = bar:CreateTexture(nil, "BACKGROUND")
    bar.track:SetAllPoints()
    bar.track:SetColorTexture(1, 1, 1, 0.08)
    QR.Skin:SetRounded(bar, bar.track)
    local thumb = CreateFrame("Button", nil, bar)
    thumb:SetWidth(6)
    thumb.tex = thumb:CreateTexture(nil, "ARTWORK")
    thumb.tex:SetAllPoints()
    thumb.tex:SetColorTexture(1, 1, 1, 1)
    bar.thumb = thumb

    local function maxScroll() return math.max(0, content:GetHeight() - scroll:GetHeight()) end
    function bar:Sync()
        local max = maxScroll()
        local trackH = bar:GetHeight()
        if max <= 0 or trackH <= 0 then bar:Hide(); return end
        bar:Show()
        local h = math.max(24, trackH * scroll:GetHeight() / content:GetHeight())
        thumb:SetHeight(h)
        local ratio = scroll:GetVerticalScroll() / max
        thumb:ClearAllPoints()
        thumb:SetPoint("TOP", bar, "TOP", 0, -(trackH - h) * ratio)
        local r, g, b = QR.Skin:Color("accent")
        thumb.tex:SetVertexColor(r, g, b, thumb.dragging and 1 or 0.75)
    end
    local function scrollTo(v)
        scroll:SetVerticalScroll(math.max(0, math.min(maxScroll(), v)))
        bar:Sync()
    end
    bar.ScrollTo = scrollTo
    thumb:SetScript("OnMouseDown", function(self)
        local _, cy = GetCursorPosition()
        self.startY, self.startScroll, self.dragging = cy / f:GetEffectiveScale(), scroll:GetVerticalScroll(), true
        self:SetScript("OnUpdate", function()
            local _, y = GetCursorPosition()
            y = y / f:GetEffectiveScale()
            local free = bar:GetHeight() - self:GetHeight()
            if free > 0 then scrollTo(self.startScroll + (self.startY - y) / free * maxScroll()) end
        end)
    end)
    thumb:SetScript("OnMouseUp", function(self)
        self.dragging = nil
        self:SetScript("OnUpdate", nil)
        bar:Sync()
    end)
    -- clic en el carril: salta a esa altura
    bar:EnableMouse(true)
    bar:SetScript("OnMouseDown", function()
        local _, cy = GetCursorPosition()
        local top = bar:GetTop()
        if not top then return end
        local ratio = (top - cy / f:GetEffectiveScale()) / bar:GetHeight()
        scrollTo(ratio * maxScroll())
    end)
    return bar
end

---------------------------------------------------------------------------
-- Ventana
---------------------------------------------------------------------------
local function ZoneValues()
    local list = {}
    for _, e in ipairs(QR.Skin.zoneOrder) do
        local info = e.mapID and C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(e.mapID)
        list[#list + 1] = { e.key, info and info.name or e.name }
    end
    return list
end

local function FontValues()
    local list = {}
    for _, f in ipairs(QR.Skin.fonts) do list[#list + 1] = { f.key, f.name } end
    return list
end

local function SectionFontValues()
    local list = { { "INHERIT", "Same as general" } }
    for _, f in ipairs(QR.Skin.fonts) do list[#list + 1] = { f.key, f.name } end
    return list
end

local function ArrowStyleValues()
    local list = {}
    for _, a in ipairs(QR.Arrow.STYLES) do list[#list + 1] = { a.key, a.name } end
    return list
end

local function ArrowColorValues()
    local list = { { "ZONE", "Zone color" }, { "CUSTOM", "Custom" }, { "DIRECTION", "Green/red by heading" },
                   { "WHITE", "White / original" } }
    for _, m in ipairs(QR.Arrow.MATERIALS) do list[#list + 1] = { m[1], m[2] } end
    return list
end

function Options:Create()
    local S = QR.Skin
    local db = QR.db
    local f = CreateFrame("Frame", "QuestieRouterOptions", UIParent)
    f:SetSize(WIDTH, HEIGHT)
    f:SetPoint("CENTER", 200, 0)
    f:SetFrameStrata("DIALOG")
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true) -- (bloquea clics al mundo, pero no arrastra: solo la barra de titulo)
    tinsert(UISpecialFrames, "QuestieRouterOptions")
    -- al cerrar las opciones (boton, Esc o /qr) se apaga el simulador de la barra de vuelo
    f:SetScript("OnHide", function()
        if QR.flightPreview then
            QR.flightPreview = nil
            QR:Fire("FLIGHT_CHANGED")
        end
    end)
    f.bg = S:CreateCard(f)
    f.bg:SetAllPoints()

    -- barra de titulo: el unico sitio desde el que se arrastra la ventana
    local titleBar = CreateFrame("Frame", nil, f)
    titleBar:SetPoint("TOPLEFT", 0, 0)
    titleBar:SetPoint("TOPRIGHT", -30, 0)
    titleBar:SetHeight(34)
    titleBar:EnableMouse(true)
    titleBar:RegisterForDrag("LeftButton")
    titleBar:SetScript("OnDragStart", function() f:StartMoving() end)
    titleBar:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)
    f.titleBar = titleBar

    f.title = titleBar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.title:SetPoint("LEFT", 14, -2)
    f.title:SetText(L["QuestieRouter Options"])
    local close = CreateFrame("Button", nil, f)
    close:SetSize(16, 16)
    close:SetPoint("TOPRIGHT", -10, -10)
    close.icon = close:CreateTexture(nil, "OVERLAY")
    close.icon:SetAllPoints()
    close.icon:SetTexture(S:UIIcon("Close"))
    close:SetScript("OnClick", function() f:Hide() end)

    local scroll = CreateFrame("ScrollFrame", nil, f)
    scroll:SetPoint("TOPLEFT", 12, -40)
    scroll:SetPoint("BOTTOMRIGHT", -22, 12)
    scroll:EnableMouseWheel(true)
    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(WIDTH - 34, 10)
    scroll:SetScrollChild(content)
    local bar = CreateScrollBar(f, scroll, content)
    f.scrollBar = bar
    scroll:SetScript("OnMouseWheel", function(self, d) bar.ScrollTo(self:GetVerticalScroll() - d * 40) end)

    local sk, ar = db.skin, db.arrow
    local function pct(v) return v .. " %" end
    local function px(v) return v .. " px" end
    local controls = {
        Header(content, "SKIN"),
        Cycle(content, "Skin based on", { { "ZONE", "Automatic" }, { "GUIDE", "Guide zone" }, { "MANUAL", "Fixed zone" } },
            function() return sk.mode end, function(v) sk.mode = v end),
        Visible(Cycle(content, "Fixed zone", ZoneValues, function() return sk.manualZone end, function(v) sk.manualZone = v end),
            function() return sk.mode == "MANUAL" end),
        Cycle(content, "Accent color", { { "ZONE", "Zone color" }, { "CUSTOM", "Custom" } },
            function() return sk.accentMode end, function(v) sk.accentMode = v end),
        Visible(ColorSwatch(content, "Custom accent", function() return sk.customAccent end),
            function() return sk.accentMode == "CUSTOM" end),
        Cycle(content, "Font", FontValues, function() return sk.font end, function(v) sk.font = v end),
        Toggle(content, "Rounded corners", function() return sk.rounded end, function(v) sk.rounded = v end),

        -- al hablar con un NPC (Mayus pulsada = nada automatico)
        Header(content, "QUESTS"),
        Toggle(content, "Auto-accept guide quests", function() return db.autoAccept end, function(v) db.autoAccept = v end),
        Toggle(content, "Auto turn-in quests", function() return db.autoTurnIn end, function(v) db.autoTurnIn = v end),

        Header(content, "BANNER AND SKY"),
        Slider(content, "Banner height", 50, 150, 2, function() return sk.bannerHeight end, function(v) sk.bannerHeight = v end, px),
        Slider(content, "Title size (zone name)", 11, 28, 0.5, function() return sk.titleSize end,
            function(v) sk.titleSize = v end),
        Slider(content, "Banner transparency", 0, 90, 5, function() return sk.bannerTransparency end,
            function(v) sk.bannerTransparency = v end, pct),
        Toggle(content, "Night stars", function() return sk.stars end, function(v) sk.stars = v end),
        Toggle(content, "Dawn fog", function() return sk.fog end, function(v) sk.fog = v end),
        Slider(content, "Addon title size (header)", 6, 16, 0.5,
            function() return sk.eyebrowSize or math.floor(math.max(7, sk.textSize * 0.62) * 2 + 0.5) / 2 end,
            function(v) sk.eyebrowSize = v end),
        Toggle(content, "Clock on the banner", function() return sk.clock end, function(v) sk.clock = v end),
        Visible(Slider(content, "Clock size", 8, 22, 0.5,
            function() return sk.clockSize or math.floor(sk.textSize * 0.85 * 2 + 0.5) / 2 end,
            function(v) sk.clockSize = v end), function() return sk.clock end),
        Slider(content, "Time preview (0 = real)", 0, 24, 0.25,
            function() return QR.skyPreviewMinutes and QR.skyPreviewMinutes / 60 or 0 end,
            function(v) QR.skyPreviewMinutes = (v > 0) and math.floor(v * 60) % 1440 or nil end,
            function(v) return v > 0 and string.format("%02d:%02d", math.floor(v) % 24, (v % 1) * 60) or L["real"] end),

        Header(content, "TOP CARD (ACTIVE STEP)"),
        Toggle(content, "Show top card", function() return sk.active.show end, function(v) sk.active.show = v end),
        Slider(content, "Text size", 9, 18, 0.5, function() return sk.active.textSize end, function(v) sk.active.textSize = v end),
        Slider(content, "Number size", 10, 30, 1, function() return sk.active.numberSize end, function(v) sk.active.numberSize = v end),
        Slider(content, "Icon size", 8, 28, 1, function() return sk.active.iconSize or math.floor(sk.active.textSize + 2) end,
            function(v) sk.active.iconSize = v end),
        Slider(content, "Transparency", 0, 90, 5, function() return sk.active.transparency end,
            function(v) sk.active.transparency = v end, pct),
        Cycle(content, "Show", { { "BOTH", "Description and objectives" }, { "DESC", "Description only" }, { "REQ", "Objectives only" } },
            function() return sk.active.content end, function(v) sk.active.content = v end),
        Toggle(content, "\"Left to do\" and distance", function() return sk.active.extra end, function(v) sk.active.extra = v end),

        Header(content, "STEP LIST (BOTTOM)"),
        Slider(content, "Text size", 9, 18, 0.5, function() return sk.list.textSize end, function(v) sk.list.textSize = v end),
        Slider(content, "Number size", 10, 30, 1, function() return sk.list.numberSize end, function(v) sk.list.numberSize = v end),
        Slider(content, "Icon size", 8, 28, 1, function() return sk.list.iconSize or math.floor(sk.list.textSize + 2) end,
            function(v) sk.list.iconSize = v end),
        Slider(content, "Transparency", 0, 90, 5, function() return sk.list.transparency end,
            function(v) sk.list.transparency = v end, pct),
        Cycle(content, "Show", { { "BOTH", "Description and objectives" }, { "DESC", "Description only" }, { "REQ", "Objectives only" } },
            function() return sk.list.content end, function(v) sk.list.content = v end),
        Slider(content, "Visible completed steps", 0, 10, 1, function() return sk.doneVisible end, function(v) sk.doneVisible = v end),
        Slider(content, "Visible upcoming steps", 1, 14, 1, function() return sk.list.maxSteps end, function(v) sk.list.maxSteps = v end),

        Header(content, "WINDOW FOOTER"),
        Slider(content, "Footer text size", 8, 16, 0.5, function() return sk.footer.textSize end,
            function(v) sk.footer.textSize = v end),
        Slider(content, "Footer transparency", 0, 90, 5, function() return sk.footer.transparency end,
            function(v) sk.footer.transparency = v end, pct),

        Header(content, "QUEST LIST (QUESTS TAB)"),
        Slider(content, "Text size", 8, 18, 0.5, function() return sk.quests.textSize end,
            function(v) sk.quests.textSize = v end),
        Slider(content, "Icon size", 8, 28, 1, function() return sk.quests.iconSize or math.floor(sk.quests.textSize + 2) end,
            function(v) sk.quests.iconSize = v end),

        Header(content, "WINDOW"),
        Slider(content, "Width", 240, 440, 5, function() return sk.width end, function(v) sk.width = v end, px),
        Slider(content, "List height", 120, 700, 10, function() return sk.listHeight end, function(v) sk.listHeight = v end, px),

        Header(content, "ARROW"),
        Toggle(content, "Show arrow", function() return ar.shown end, function(v) ar.shown = v end),
        Slider(content, "Title size (quest)", 8, 26, 0.5,
            function() return ar.titleSize or math.floor(sk.titleSize * 0.72 * 2 + 0.5) / 2 end,
            function(v) ar.titleSize = v end),
        Slider(content, "Objectives size", 7, 22, 0.5,
            function() return ar.reqSize or math.floor(sk.textSize * 0.85 * 2 + 0.5) / 2 end,
            function(v) ar.reqSize = v end),
        Slider(content, "Status size (distance / In the area)", 7, 24, 0.5,
            function() return ar.statusSize or math.floor(sk.textSize * 0.85 * 2 + 0.5) / 2 end,
            function(v) ar.statusSize = v end),
        Toggle(content, "Hide the arrow when reaching the area", function() return ar.hideInArea end,
            function(v) ar.hideInArea = v end),
        ArrowDropdown(content),
        Cycle(content, "Color", ArrowColorValues, function() return ar.color end, function(v) ar.color = v end),
        Visible(ColorSwatch(content, "Custom color", function() return ar.customColor end),
            function() return ar.color == "CUSTOM" end),
        Slider(content, "Scale", 0.5, 2, 0.05, function() return ar.scale end, function(v) ar.scale = v end,
            function(v) return string.format("%.2f", v) end),

        Header(content, "ITEMS WINDOW (USE QUEST ITEMS)"),
        Toggle(content, "Show items window", function() return QR.db.activeFrames.items end,
            function(v) QR.db.activeFrames.items = v end),
        Visible(Slider(content, "Button size", 22, 56, 2, function() return QR.db.activeFrames.itemsSize end,
            function(v) QR.db.activeFrames.itemsSize = v end, px), function() return QR.db.activeFrames.items end),
        Visible(Cycle(content, "Button corner", { { "STEP", "Step number" }, { "NONE", "Nothing" } },
            function() return QR.db.activeFrames.itemsBadge end, function(v) QR.db.activeFrames.itemsBadge = v end),
            function() return QR.db.activeFrames.items end),

        Header(content, "TARGET WINDOW (TARGET MOBS / NPCS)"),
        Toggle(content, "Show target window", function() return QR.db.activeFrames.targets end,
            function(v) QR.db.activeFrames.targets = v end),
        Visible(Slider(content, "Button size", 22, 56, 2, function() return QR.db.activeFrames.targetsSize end,
            function(v) QR.db.activeFrames.targetsSize = v end, px), function() return QR.db.activeFrames.targets end),
        Visible(Cycle(content, "Button corner", { { "STEP", "Step number" }, { "ICON", "Icon (kill / pick up / turn in)" }, { "NONE", "Nothing" } },
            function() return QR.db.activeFrames.targetsBadge end, function(v) QR.db.activeFrames.targetsBadge = v end),
            function() return QR.db.activeFrames.targets end),
        Visible(Toggle(content, "3D portraits (otherwise still 2D)", function() return QR.db.activeFrames.portrait3d end,
            function(v) QR.db.activeFrames.portrait3d = v end), function() return QR.db.activeFrames.targets end),
        Visible(Toggle(content, "Mark the target when selecting it (each button its own icon)", function() return QR.db.activeFrames.markTarget ~= false end,
            function(v) QR.db.activeFrames.markTarget = v end), function() return QR.db.activeFrames.targets end),
        Visible(SpellDrop(content, "Right-click on enemies: cast this ability"),
            function() return QR.db.activeFrames.targets end),

        Header(content, "TRAVEL"),
        Toggle(content, "Suggest travel routes", function() return QR.db.travel.enabled end, function(v) QR.db.travel.enabled = v end),
        Visible(Toggle(content, "Use flights (gryphons / bats)", function() return QR.db.travel.flights end,
            function(v) QR.db.travel.flights = v end), function() return QR.db.travel.enabled end),
        Visible(Toggle(content, "Use boats, zeppelins and airships", function() return QR.db.travel.boats end,
            function(v) QR.db.travel.boats = v end), function() return QR.db.travel.enabled end),
        Toggle(content, "Flight bar in the footer (time left)", function() return QR.db.travel.flightBar end,
            function(v) QR.db.travel.flightBar = v end),

        -- barra de vuelo del pie: simulador (solo mientras esta ventana esta abierta) y tamaños de los textos
        Header(content, "TRAVEL TIME SETTINGS"),
        Toggle(content, "Preview the flight bar", function() return QR.flightPreview ~= nil end,
            function(v)
                QR.flightPreview = v and GetTime() or nil
                -- para verlo, la ventana de la guia tiene que estar abierta
                if v and QR.GuideUI and QR.GuideUI.frame and not QR.GuideUI.frame:IsShown() then QR.GuideUI:SetShown(true) end
                QR:Fire("FLIGHT_CHANGED")
            end),
        Slider(content, "Destination text size", 7, 20, 0.5,
            function() return math.floor(select(1, QR.GuideUI:FlightSizes()) * 2 + 0.5) / 2 end,
            function(v) QR.db.travel.flightTextSize = v end),
        Slider(content, "Time left size", 8, 32, 0.5,
            function() return math.floor(select(2, QR.GuideUI:FlightSizes()) * 2 + 0.5) / 2 end,
            function(v) QR.db.travel.flightTimeSize = v end),

        Header(content, "MAP"),
        Toggle(content, "Minimap button", function() return QR.MinimapButton:IsShown() end,
            function(v) QR.MinimapButton:SetShown(v) end),
        Toggle(content, "Line on the world map", function() return db.lines.worldmap end, function(v) db.lines.worldmap = v end),
        Toggle(content, "Line on the minimap", function() return db.lines.minimap end, function(v) db.lines.minimap = v end),
        Cycle(content, "Line style", QR.MapLines.STYLES, function() return db.lines.style end, function(v) db.lines.style = v end),
        Cycle(content, "Line color", { { "ZONE", "Zone color" }, { "CUSTOM", "Custom" }, { "WHITE", "White" } },
            function() return db.lines.colorMode end, function(v) db.lines.colorMode = v end),
        Visible(ColorSwatch(content, "Custom line color", function() return db.lines.customColor end),
            function() return db.lines.colorMode == "CUSTOM" end),
        Slider(content, "Thickness on the map", 4, 20, 1, function() return db.lines.thicknessWorld end,
            function(v) db.lines.thicknessWorld = v end, px),
        Slider(content, "Thickness on the minimap", 3, 14, 1, function() return db.lines.thicknessMinimap end,
            function(v) db.lines.thicknessMinimap = v end, px),
        Slider(content, "Animation speed", 0.2, 3, 0.1, function() return db.lines.speed end,
            function(v) db.lines.speed = v end, function(v) return string.format("%.1f s", v) end),
        Slider(content, "Pattern density", 0.5, 3, 0.25, function() return db.lines.density end,
            function(v) db.lines.density = v end, function(v) return string.format("%.2f", v) end),
        Slider(content, "Opacity on the map", 20, 100, 5, function() return math.floor(db.lines.alphaWorld * 100 + 0.5) end,
            function(v) db.lines.alphaWorld = v / 100 end, pct),
        Slider(content, "Opacity on the minimap", 20, 100, 5, function() return math.floor(db.lines.alphaMinimap * 100 + 0.5) end,
            function(v) db.lines.alphaMinimap = v / 100 end, pct),
    }
    f.content = content
    f.controls = controls
    f.groups = {}
    self.frame = f
    self:Layout()
end

--- Coloca los controles visibles en grupos (cada titulo abre un panel con un tinte suave de la zona).
--- Se repite en cada refresco: los controles con condicion (p. ej. "Fixed zone") aparecen o desaparecen.
function Options:Layout()
    local f = self.frame
    local content = f.content
    local GROUP_PAD, GROUP_GAP = 8, 10
    local y = 0
    local used, group = 0, nil
    local baseLevel = content:GetFrameLevel()
    local function closeGroup()
        if group then
            group:SetHeight(y - group.top + GROUP_PAD)
            y = y + GROUP_PAD + GROUP_GAP
        end
    end
    for _, c in ipairs(f.controls) do
        local visible = not c.visibleIf or c.visibleIf()
        c:SetShown(visible)
        if visible then
            if c.isHeader then
                closeGroup()
                used = used + 1
                group = f.groups[used]
                if not group then
                    group = QR.Skin:CreateCard(content)
                    group:SetFrameLevel(baseLevel)
                    f.groups[used] = group
                end
                group.top = y
                group:ClearAllPoints()
                group:SetPoint("TOPLEFT", 0, -y)
                group:SetPoint("RIGHT", content, "RIGHT")
                group:Show()
                c:SetHeight(ROW - 6)
                y = y + 2
            end
            c:SetFrameLevel(baseLevel + 2)
            c:ClearAllPoints()
            c:SetPoint("TOPLEFT", GROUP_PAD, -y)
            c:SetPoint("RIGHT", content, "RIGHT", -GROUP_PAD, 0)
            y = y + c:GetHeight()
        end
    end
    closeGroup()
    for i = used + 1, #f.groups do f.groups[i]:Hide() end
    content:SetHeight(y)
end

function Options:Refresh()
    local f = self.frame
    if not f then return end
    self:Layout()
    QR.Skin:PaintCard(f.bg, "background", 0.97, "ui")
    QR.Skin:StyleText(f.title, "subtitle")
    f.title:SetTextColor(1, 1, 1)
    for _, c in ipairs(f.controls) do if c.Update then c:Update() end end
    -- fondo de cada grupo: tarjeta oscura teñida levemente con el acento de la zona
    local cr, cg, cb = QR.Skin:Color("card")
    local ar, ag, ab = QR.Skin:Color("accent")
    for _, g in ipairs(f.groups or {}) do
        g.bg:SetVertexColor(cr + (ar - cr) * 0.16, cg + (ag - cg) * 0.16, cb + (ab - cb) * 0.16, 0.95)
        QR.Skin:SetRounded(g, g.bg)
    end
    if f.scrollBar then f.scrollBar:Sync() end
end

function Options:Toggle()
    -- la primera vez se crea: un marco nuevo ya nace visible, asi que se muestra sin alternar
    -- (antes se creaba y se ocultaba en el mismo clic, y hacia falta pulsar dos veces)
    if not self.frame then
        self:Create()
        self.frame:Show()
    else
        self.frame:SetShown(not self.frame:IsShown())
    end
    if self.frame:IsShown() then self:Refresh() end
end

QR:RegisterModule("Options", function()
    QR:On("SETTINGS_CHANGED", function() if Options.frame and Options.frame:IsShown() then Options:Refresh() end end)
    QR:On("SKIN_CHANGED", function() if Options.frame and Options.frame:IsShown() then Options:Refresh() end end)
end)

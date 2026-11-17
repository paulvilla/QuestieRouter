-- QuestieRouter: ventana para escribir una nota (clic derecho en un paso de mision o en una mision: "Añadir nota...").
-- No es una nota personal: es un error de la guia / la mision o un consejo para hacerla, que se envia con la
-- exportacion. Hay que elegir el tipo (Error / Consejo para la mision). Guardar llama a onSave(texto, tipo) con tipo
-- "e" | "c"; Cancelar, Escape o un texto vacio no guardan nada.

local _, QR = ...
local L = QR.L

local NoteEditor = {}
QR.NoteEditor = NoteEditor

local MAX_LETTERS = 500
local TYPES = { { key = "e", text = "Error" }, { key = "c", text = "Tip for the quest" } }

local function Button(parent, text, onClick, width)
    local S = QR.Skin
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(width or 110, 26)
    b.bg = S:CreateCard(b)
    b.bg:SetAllPoints()
    b.art = CreateFrame("Frame", nil, b)
    b.art:SetAllPoints()
    b.art:SetFrameLevel(b.bg:GetFrameLevel() + 2)
    b.text = b.art:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    S:StyleText(b.text, "body", "ui")
    b.text:SetPoint("CENTER")
    b.text:SetText(text)
    b:SetScript("OnEnter", function(s) s.bg.bg:SetAlpha(1) end)
    b:SetScript("OnLeave", function(s) s.bg.bg:SetAlpha(0.85) end)
    b:SetScript("OnClick", onClick)
    return b
end

function NoteEditor:Create()
    local S = QR.Skin
    local f = CreateFrame("Frame", "QuestieRouterNoteEditor", UIParent)
    f:SetSize(460, 300)
    f:SetPoint("CENTER", 0, 80)
    f:SetFrameStrata("DIALOG")
    f:SetClampedToScreen(true)
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:Hide()
    tinsert(UISpecialFrames, "QuestieRouterNoteEditor")   -- (Escape la cierra: es cancelar)
    f.bg = S:CreateCard(f)
    f.bg:SetAllPoints()
    f.bg:SetFrameLevel(f:GetFrameLevel())

    f.title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.title:SetPoint("TOPLEFT", 16, -14)
    f.title:SetPoint("RIGHT", -16, 0)
    f.title:SetJustifyH("LEFT")
    f.sub = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.sub:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 0, -4)
    f.sub:SetPoint("RIGHT", -16, 0)
    f.sub:SetJustifyH("LEFT")
    f.sub:SetWordWrap(true)

    -- tipo de nota: Error / Consejo para la mision (hay que elegir uno)
    f.typeLabel = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.typeLabel:SetPoint("TOPLEFT", 16, -82)
    f.types = {}
    local prev
    for _, t in ipairs(TYPES) do
        local b = Button(f, L[t.text], function() NoteEditor:SetType(t.key) end, t.key == "e" and 90 or 170)
        if prev then b:SetPoint("LEFT", prev, "RIGHT", 8, 0) else b:SetPoint("LEFT", f.typeLabel, "RIGHT", 10, 0) end
        b.key = t.key
        f.types[#f.types + 1] = b
        prev = b
    end

    -- cuadro de texto (varias lineas) sobre una tarjeta mas oscura
    local box = CreateFrame("Frame", nil, f)
    box:SetPoint("TOPLEFT", 16, -112)
    box:SetPoint("BOTTOMRIGHT", -16, 50)
    box.bg = S:CreateCard(box)
    box.bg:SetAllPoints()
    f.box = box
    local scroll = CreateFrame("ScrollFrame", nil, box, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 8, -8)
    scroll:SetPoint("BOTTOMRIGHT", -28, 8)
    local edit = CreateFrame("EditBox", nil, scroll)
    edit:SetMultiLine(true)
    edit:SetAutoFocus(false)
    edit:SetMaxLetters(MAX_LETTERS)
    edit:SetFontObject(ChatFontNormal)
    edit:SetWidth(380)
    edit:SetScript("OnEscapePressed", function() NoteEditor:Cancel() end)
    edit:SetScript("OnTextChanged", function() NoteEditor:Count() end)
    scroll:SetScrollChild(edit)
    box:EnableMouse(true)
    box:SetScript("OnMouseDown", function() edit:SetFocus() end)
    f.edit = edit
    -- texto de ayuda: se ve mientras el cuadro esta vacio y se quita al escribir
    f.hint = box:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.hint:SetPoint("TOPLEFT", 12, -10)
    f.hint:SetPoint("RIGHT", -32, 0)
    f.hint:SetJustifyH("LEFT")
    f.hint:SetJustifyV("TOP")
    f.hint:SetWordWrap(true)

    f.count = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.count:SetPoint("BOTTOMLEFT", 18, 18)
    f.save = Button(f, L["Save"], function() NoteEditor:Save() end)
    f.save:SetPoint("BOTTOMRIGHT", -16, 12)
    f.cancel = Button(f, L["Cancel"], function() NoteEditor:Cancel() end)
    f.cancel:SetPoint("RIGHT", f.save, "LEFT", -8, 0)
    f:SetScript("OnHide", function() NoteEditor.ctx = nil end)   -- (cerrar sin guardar no guarda nada)
    self.frame = f
end

--- tipo elegido: su boton con el color de la zona, el otro apagado
function NoteEditor:SetType(key)
    local f, S = self.frame, QR.Skin
    self.noteType = key
    local r, g, b = S:Color("accent")
    for _, btn in ipairs(f.types) do
        if btn.key == key then
            btn.bg.bg:SetVertexColor(r * 0.85, g * 0.85, b * 0.85, 1)
            btn.text:SetTextColor(1, 1, 1)
        else
            btn.bg.bg:SetVertexColor(0.2, 0.21, 0.21, 1)
            btn.text:SetTextColor(0.7, 0.72, 0.7)
        end
        btn.bg.bg:SetAlpha(0.85)
    end
    f.typeLabel:SetTextColor(0.75, 0.78, 0.75)
end

function NoteEditor:Count()
    local f = self.frame
    local text = f.edit:GetText() or ""
    local n = f.edit.GetNumLetters and f.edit:GetNumLetters() or #text
    f.count:SetText(string.format("|cff9a9f9c%d/%d|r", n, MAX_LETTERS))
    f.hint:SetShown(text == "")
end

--- ctx = { title, subtitle, onSave = function(texto, tipo) }
function NoteEditor:Open(ctx)
    if not self.frame then self:Create() end
    local f, S = self.frame, QR.Skin
    S:PaintCard(f.bg, "background", 0.97, "ui")
    S:PaintCard(f.box.bg, "card", 1, "ui")
    S:StyleText(f.title, "subtitle", "ui")
    S:StyleText(f.sub, "small", "ui")
    S:StyleText(f.count, "small", "ui")
    S:StyleText(f.typeLabel, "body", "ui")
    S:StyleText(f.hint, "body", "ui")
    f.title:SetText(ctx.title or "")
    f.title:SetTextColor(S:TextAccent())
    f.sub:SetText(ctx.subtitle or "")
    f.sub:SetTextColor(0.75, 0.78, 0.75)
    f.typeLabel:SetText(L["Type:"])
    f.hint:SetText(L["Describe an error in the guide or the quest, or a tip that helps to do it. This is not a personal note: it goes with your export so the guides can be fixed for everyone."])
    f.hint:SetTextColor(0.5, 0.52, 0.5)
    local r, g, b = S:Color("accent")
    f.save.bg.bg:SetVertexColor(r * 0.85, g * 0.85, b * 0.85, 1)
    f.save.bg.bg:SetAlpha(0.85)
    f.cancel.bg.bg:SetVertexColor(0.2, 0.21, 0.21, 1)
    f.cancel.bg.bg:SetAlpha(0.85)
    f.edit:SetText("")
    self.ctx = ctx
    self:SetType(nil)   -- (sin elegir: hay que decir si es un error o un consejo)
    self:Count()
    f:Show()
    f.edit:SetFocus()
end

function NoteEditor:Save()
    local f, ctx = self.frame, self.ctx
    local text = f and (f.edit:GetText() or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if ctx and text and text ~= "" and not self.noteType then
        -- falta elegir el tipo: se avisa y no se cierra
        f.typeLabel:SetTextColor(1, 0.45, 0.4)
        QR:Print(L["Choose whether it is an error or a tip for the quest."])
        return
    end
    -- (sin texto es como cancelar)
    if ctx and ctx.onSave and text and text ~= "" then ctx.onSave(text, self.noteType) end
    self.ctx = nil
    if f then f:Hide() end
end

function NoteEditor:Cancel()
    self.ctx = nil
    if self.frame then self.frame:Hide() end
end

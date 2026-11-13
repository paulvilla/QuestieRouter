-- QuestieRouter: boton del minimapa (LibDataBroker + LibDBIcon, que ya vienen con Questie)
-- y entrada en el compartimento de addons (declarada en el .toc con AddonCompartmentFunc).
--
--   Clic izquierdo         mostrar / ocultar la ventana de la guia
--   Clic derecho           menu principal (guias disponibles, opciones...)
--   Mayus + clic izquierdo opciones graficas

local _, QR = ...
local L = QR.L

local Button = {}
QR.MinimapButton = Button

local ICON = "Interface\\AddOns\\QuestieRouter\\Media\\Icons\\QuestieRouter.tga"
Button.ICON = ICON

local function OnClick(button)
    if button == "RightButton" then
        QR.Menu:OpenMain()
    elseif IsShiftKeyDown() then
        QR.Options:Toggle()
    else
        -- clic: activar / desactivar el addon entero (ventana, flecha, lineas y ventanitas)
        QR:SetEnabled(not QR.db.enabled)
    end
end

local function FillTooltip(tt)
    tt:AddLine("|cff33ccffQuestie|r|cffffd166Router|r")
    local guide = QR.Planner and QR.Planner:GetGuide()
    if guide then
        tt:AddLine(QR.GuideLabel(guide) .. string.format("  (%d-%d)", guide.minLevel, guide.maxLevel), 1, 1, 1)
        local t = QR.target
        if t then
            local kind = t.kind and QR.Planner.KIND_TEXT[t.kind] or ""
            tt:AddLine(kind .. ": " .. (t.questName or ""), 0.85, 0.85, 0.85)
        end
    else
        tt:AddLine(L["No guide chosen"], 0.7, 0.7, 0.7)
    end
    tt:AddLine(" ")
    tt:AddLine(QR.db.enabled and L["|cffffd166Click|r: disable QuestieRouter"] or L["|cffffd166Click|r: enable QuestieRouter"], 0.8, 0.8, 0.8)
    tt:AddLine(L["|cffffd166Right-click|r: menu"], 0.8, 0.8, 0.8)
    tt:AddLine(L["|cffffd166Shift+click|r: options"], 0.8, 0.8, 0.8)
end

function Button:Init()
    local LDB = LibStub and LibStub("LibDataBroker-1.1", true)
    local DBIcon = LibStub and LibStub("LibDBIcon-1.0", true)
    if not (LDB and DBIcon) then return end
    QR.db.minimapIcon = QR.db.minimapIcon or { hide = false }
    self.broker = LDB:NewDataObject("QuestieRouter", {
        type = "launcher",
        text = "QuestieRouter",
        icon = ICON,
        OnClick = function(_, button) OnClick(button) end,
        OnTooltipShow = FillTooltip,
    })
    DBIcon:Register("QuestieRouter", self.broker, QR.db.minimapIcon)
    self.DBIcon = DBIcon
end

function Button:SetShown(shown)
    if not self.DBIcon then return end
    QR.db.minimapIcon.hide = not shown
    if shown then self.DBIcon:Show("QuestieRouter") else self.DBIcon:Hide("QuestieRouter") end
end

function Button:IsShown()
    return QR.db.minimapIcon and not QR.db.minimapIcon.hide
end

-- Compartimento de addons (lista del boton de addons junto al minimapa)
function QuestieRouter_OnAddonCompartmentClick(_, button)
    if not QR.ready then return end
    OnClick(button)
end

function QuestieRouter_OnAddonCompartmentEnter(_, frame)
    if not QR.ready then return end
    GameTooltip:SetOwner(frame, "ANCHOR_LEFT")
    FillTooltip(GameTooltip)
    GameTooltip:Show()
end

function QuestieRouter_OnAddonCompartmentLeave()
    GameTooltip:Hide()
end

QR:RegisterModule("MinimapButton", function() Button:Init() end)

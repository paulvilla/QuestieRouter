-- QuestieRouter: boton "QuestieRouter" en el menu del juego (Esc). Abre el menu de guias (UI/Browser.lua).
--
-- El menu de Forever (Blizzard_GameMenu) crea sus botones en InitButtons y luego los apila por layoutIndex; un
-- topPadding abre una seccion nueva. El nuestro es un boton propio, hecho con la misma plantilla que los del
-- menu, con un layoutIndex justo despues de "Tienda" (o de "Opciones" si no hay tienda): una seccion propia.
-- Polestar pone el suyo a mitad del hueco entre Tienda y el boton siguiente; el nuestro va antes (al 40 %), asi
-- que siempre queda encima, y si Polestar esta, el suyo pasa a ir pegado debajo del nuestro (misma seccion).
-- No se toca nada de Blizzard: solo se leen los botones del menu y se ponen campos en el nuestro.

local _, QR = ...
local L = QR.L

local GameMenu = {}
QR.GameMenu = GameMenu

local SECTION = 20    -- separacion entre secciones del menu (la del propio menu)
local GAP = 4         -- entre nuestro boton y el de Polestar

local button

local function Open()
    local menu = _G.GameMenuFrame
    if menu and menu:IsShown() then
        if HideUIPanel then HideUIPanel(menu) else menu:Hide() end
    end
    if QR.Browser then QR.Browser:Open() end
end

local function Build(menu, template)
    if button then return button end
    button = CreateFrame("Button", "QuestieRouterGameMenuButton", UIParent, template)
    button:SetParent(menu)
    button:SetSize(144, 21)
    button:SetText("QuestieRouter")
    button:SetScript("OnClick", function()
        if PlaySound and SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION then PlaySound(SOUNDKIT.IG_MAINMENU_OPTION) end
        Open()
    end)
    button:Hide()
    return button
end

local function Wanted() return QR.db and QR.db.gameMenuButton ~= false end

--- El boton del menu tras el que va el nuestro (Tienda, o Opciones) y el layoutIndex del siguiente
local function After(menu)
    local pool = menu.buttonPool
    if not (pool and pool.EnumerateActive) then return nil end
    local shop, options, indexes = nil, nil, {}
    for b in pool:EnumerateActive() do
        local text = b.GetText and b:GetText()
        if text and text == _G.BLIZZARD_STORE then shop = b end
        if text and text == _G.GAMEMENU_OPTIONS then options = b end
        if type(b.layoutIndex) == "number" then indexes[#indexes + 1] = b.layoutIndex end
    end
    local ref = shop or options
    if not (ref and type(ref.layoutIndex) == "number") then return nil end
    local nextIndex = ref.layoutIndex + 1
    for _, i in ipairs(indexes) do
        if i > ref.layoutIndex and i < nextIndex then nextIndex = i end
    end
    return ref, ref.layoutIndex, nextIndex
end

--- Tras InitButtons (antes de que el menu se coloque): nuestro boton para esta apertura
local function Place(menu)
    if not Wanted() then
        if button then button:Hide() end
        return
    end
    local ref, index, nextIndex = After(menu)
    if not ref then
        if button then button:Hide() end
        return
    end
    local b = Build(menu, type(menu.buttonTemplate) == "string" and menu.buttonTemplate or "MainMenuFrameButtonTemplate")
    local w, h = ref:GetWidth(), ref:GetHeight()
    if w and w > 0 and h and h > 0 then b:SetSize(w, h) end
    b:ClearAllPoints()
    b.layoutIndex = index + (nextIndex - index) * 0.4
    b.topPadding = SECTION
    -- Polestar: su boton (a mitad del hueco) queda debajo del nuestro, en la misma seccion
    local pole = _G.PolestarGameMenuButton
    if pole and pole:IsShown() and type(pole.layoutIndex) == "number" and pole.layoutIndex > b.layoutIndex then
        pole.topPadding = GAP
    end
    -- el texto con la fuente y el color de los botones del menu
    local mine, theirs = b:GetFontString(), ref.GetFontString and ref:GetFontString()
    if mine and theirs then
        local path, size, flags = theirs:GetFont()
        if path then mine:SetFont(path, size, flags or "") end
    end
    b:Show()
end

--- Menu antiguo (sin InitButtons): el boton debajo del menu
local function PlaceOld()
    local menu = _G.GameMenuFrame
    if not menu then return end
    if not Wanted() then
        if button then button:Hide() end
        return
    end
    Build(menu, "UIPanelButtonTemplate")
    local ref = _G.GameMenuButtonContinue
    local w, h = ref and ref:GetWidth() or 0, ref and ref:GetHeight() or 0
    button:SetSize(w > 0 and w or 144, h > 0 and h or 21)
    button:ClearAllPoints()
    -- si Polestar ya puso el suyo debajo del menu, el nuestro va entre el menu y el suyo
    local pole = _G.PolestarGameMenuButton
    button:SetPoint("TOP", menu, "BOTTOM", 0, -4)
    if pole and pole:IsShown() then
        pole:ClearAllPoints()
        pole:SetPoint("TOP", button, "BOTTOM", 0, -GAP)
    end
    button:Show()
end

function GameMenu:Hook()
    local menu = _G.GameMenuFrame
    if not menu or self.hooked then return end
    self.hooked = true
    if type(rawget(menu, "InitButtons")) == "function" then
        hooksecurefunc(menu, "InitButtons", Place)
    else
        menu:HookScript("OnShow", PlaceOld)
    end
end

QR:RegisterModule("GameMenu", function() GameMenu:Hook() end, true)

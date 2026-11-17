-- QuestieRouter: boton "QuestieRouter" en el menu del juego (Esc). Abre el menu de guias (UI/Browser.lua).
--
-- El menu de Forever (Blizzard_GameMenu) crea sus botones en InitButtons y luego los apila por layoutIndex; un
-- topPadding abre una seccion nueva. El nuestro es un boton propio, hecho con la misma plantilla que los del
-- menu, con un layoutIndex justo despues de "Tienda" (o de "Opciones" si no hay tienda): una seccion propia.
-- Polestar pone el suyo a mitad del hueco entre Tienda y el boton siguiente; el nuestro va antes (al 40 %), asi
-- que siempre queda encima, y si Polestar esta, el suyo pasa a ir pegado debajo del nuestro (misma seccion).
-- No se toca nada de Blizzard: solo se leen los botones del menu y se ponen campos en el nuestro.
--
-- EllesmereUI: pone su boton (y el de "Unlock Mode") a mano debajo de Tienda tras el Layout del menu y baja solo los
-- botones de Blizzard; el nuestro quedaba encima del suyo. Con EllesmereUI el nuestro va pegado debajo de los suyos
-- (se recoloca tras cada Layout). Si su modulo de aspectos de Blizzard (EllesmereUIBlizzardSkin) restila el menu,
-- el nuestro lleva el mismo aspecto oscuro que sus botones.

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

---------------------------------------------------------------------------
-- EllesmereUI
---------------------------------------------------------------------------
local function AddOnLoaded(name)
    if C_AddOns and C_AddOns.IsAddOnLoaded then return C_AddOns.IsAddOnLoaded(name) end
    return IsAddOnLoaded and IsAddOnLoaded(name)
end

--- ¿EllesmereUI restila el menu del juego? (lo mismo que mira EllesmereUI para sus botones; como ellos, se decide
--- al entrar: si se cambia la opcion hace falta /reload)
local function EllesmereSkin()
    local E = _G.EllesmereUI
    return E and AddOnLoaded("EllesmereUIBlizzardSkin")
        and not (_G.EllesmereUIDB and _G.EllesmereUIDB.reskinGameMenu == false)
end

--- El ultimo boton de EllesmereUI en el menu (Unlock Mode va debajo del suyo). Se decide con sus mismas opciones y no
--- con IsShown: su gancho de Layout puede ir despues del nuestro y mostrar / ocultar sus botones entonces.
local function EllesmereLast()
    local db = _G.EllesmereUIDB
    local unlock, eui = _G.EllesmereUI_UnlockMenuButton, _G.EllesmereUI_GameMenuButton
    if unlock and db and db.hideUnlockMenuButton == false then return unlock end
    if eui and not (db and db.hideGameMenuButton) then return eui end
    return nil
end

--- Aspecto oscuro de los botones de EllesmereUI (copiado de como restilan los suyos)
local function SkinEllesmere(b)
    local E = _G.EllesmereUI
    if b.qrSkin or not E then return end
    local fs = b:GetFontString()
    for _, r in ipairs({ b:GetRegions() }) do
        if r and r:IsObjectType("Texture") and r ~= fs then r:SetAlpha(0) end
    end
    for _, key in ipairs({ "Left", "Middle", "Right" }) do
        local tex = b[key]
        if tex and tex.SetAlpha then
            tex:SetAlpha(0)
            hooksecurefunc(tex, "SetAlpha", function(self, a) if a > 0 then self:SetAlpha(0) end end)
        end
    end
    local inset = CreateFrame("Frame", nil, b)
    inset:SetPoint("TOPLEFT", 2, -2)
    inset:SetPoint("BOTTOMRIGHT", -2, 2)
    inset:SetFrameLevel(b:GetFrameLevel())
    local bg = inset:CreateTexture(nil, "BACKGROUND", nil, -6)
    bg:SetAllPoints()
    local hl = b:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints(inset)
    hl:SetColorTexture(1, 1, 1, 0.1)
    b.qrSkin = { inset = inset, bg = bg }
end

--- Colores, borde y letra de EllesmereUI (en cada apertura: asi siguen los cambios de sus opciones)
local function PaintEllesmere(b)
    local E, s = _G.EllesmereUI, b.qrSkin
    if not (E and s) then return end
    local c = _G.EllesmereUIDB and _G.EllesmereUIDB.popupMenuButtonBackgroundColor or { r = .1, g = .1, b = .1, a = .8 }
    s.bg:SetColorTexture(c.r, c.g, c.b, c.a == nil and .8 or c.a)
    if E._applyBlizzardConfiguredBorder then pcall(E._applyBlizzardConfiguredBorder, s.inset, "popupMenuButton", 1) end
    local fs = b:GetFontString()
    if fs then
        local font = E.GetFontPath and E.GetFontPath() or "Fonts\\FRIZQT__.TTF"
        fs:SetFont(font, 13, "")
        if E._getPopupMenuElementMode and E._getPopupMenuElementMode() ~= "native" and E._getPopupMenuButtonTextColor then
            local r, g, bl = E._getPopupMenuButtonTextColor()
            fs:SetTextColor(r, g, bl, 1)
        end
    end
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
    -- EllesmereUI con sus aspectos de Blizzard: el mismo aspecto oscuro que sus botones
    if EllesmereSkin() then
        SkinEllesmere(b)
        PaintEllesmere(b)
    end
    b:Show()
end

--- Tras cada Layout del menu: con EllesmereUI, el nuestro pegado debajo de sus botones (y el de Polestar debajo del
--- nuestro). El hueco ya esta: el menu deja sitio a nuestro boton y EllesmereUI baja los de Blizzard por los suyos.
local function AfterLayout()
    if not (button and button:IsShown()) or InCombatLockdown() then return end   -- (en combate EllesmereUI oculta los suyos)
    local last = EllesmereLast()
    if not last then return end
    button:ClearAllPoints()
    button:SetPoint("TOP", last, "BOTTOM", 0, -GAP)
    local pole = _G.PolestarGameMenuButton
    if pole and pole:IsShown() then
        pole:ClearAllPoints()
        pole:SetPoint("TOP", button, "BOTTOM", 0, -GAP)
    end
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
        if type(menu.Layout) == "function" then hooksecurefunc(menu, "Layout", AfterLayout) end
    else
        menu:HookScript("OnShow", PlaceOld)
    end
end

QR:RegisterModule("GameMenu", function() GameMenu:Hook() end, true)

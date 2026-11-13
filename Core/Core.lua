-- QuestieRouter: nucleo.
-- Espacio de nombres, ajustes guardados, bus de eventos interno y arranque cuando Questie esta listo.

local ADDON_NAME, QR = ...
_G.QuestieRouter = QR

QR.name = ADDON_NAME
QR.version = "0.8.0"

---------------------------------------------------------------------------
-- Ajustes
---------------------------------------------------------------------------
local DEFAULTS = {
    enabled = true,
    -- idioma de la interfaz: nil = el del cliente; "esES", "enUS", ... (lo cambia /qr load_xx)
    locale = nil,
    arrow = {
        shown = true,
        locked = false,
        scale = 1.0,
        point = { "TOP", "UIParent", "TOP", 0, -120 },
        arrivalDistance = 10, -- yardas: por debajo se considera "has llegado"
        style = "HD_ARC",     -- flecha por defecto en una instalacion nueva: "Brujula de arco" (ver Arrow.STYLES)
        color = "ZONE",       -- ZONE | DIRECTION | WHITE | MAT_*
        hideInArea = true,
        customColor = { 1.0, 0.82, 0.30 },  -- color de la flecha en modo "Personalizado"    -- ocultar el dibujo de la flecha dentro del area de los objetivos
    },
    -- Viajes: vuelos, barcos, zepelines y dirigibles
    travel = {
        enabled = true,
        flights = true,
        boats = true,
        flightBar = true,
        taxiSpeed = 32,       -- yardas/segundo (se ajusta sola con cada vuelo)
        -- axisSwap: se calibra sola al abrir un mapa de vuelos
    },
    -- Ventanitas de objetos activos y objetivo activo
    activeFrames = {
        items = true,
        targets = true,
        size = 32,            -- (antiguo, comun a las dos ventanas)
        itemsSize = nil,      -- tamaño de los botones de la ventana de objetos
        targetsSize = nil,    -- tamaño de los botones de la ventana de objetivo
        itemsTitle = "TOP",   -- titulo de la ventanita: TOP (arriba) | BOTTOM (abajo) | HIDDEN
        targetsTitle = "TOP",
        itemsBadge = "STEP",  -- esquina de los botones: STEP (numero de paso) | NONE
        targetsBadge = "STEP", -- STEP | ICON (espada, coger, entregar) | NONE
        portrait3d = false,   -- false: retrato 2D (quieto, nitido); true: modelo 3D del NPC
        markTarget = true,    -- al seleccionar desde "Objetivo": marca encima (estrella, y rota si marcas a otro)
        itemsPoint = { "RIGHT", "UIParent", "RIGHT", -380, -160 },
        targetsPoint = { "RIGHT", "UIParent", "RIGHT", -380, -90 },
    },
    lines = {
        worldmap = true,
        minimap = true,
        -- efecto de Zygor: estilo 1 camino, 2 burbujas, 3 flechas, 4 rayo
        style = 1,
        thicknessWorld = 9,
        thicknessMinimap = 6,
        speed = 1.4,          -- segundos por repeticion del dibujo (menos = mas rapido)
        density = 1,
        alphaWorld = 0.9,
        alphaMinimap = 0.9,
        colorMode = "ZONE",   -- ZONE | WHITE | CUSTOM
        customColor = { 1.0, 0.82, 0.30 },
    },
    -- Al hablar con un NPC: coger solas las misiones de la guia (las de los pasos, nada de mucho mas nivel) y
    -- entregar solas las completas. Mayus pulsada al hablar = no hacer nada automatico.
    autoAccept = false,
    autoTurnIn = false,
    -- Solo cambia de spawn si el nuevo esta este % mas cerca (evita que la flecha "baile").
    retargetHysteresis = 0.25,
    -- Segundos entre recalculos del objetivo (la flecha gira cada frame, esto solo elige el destino).
    retargetInterval = 1.5,
    -- Si no hay mision enfocada en Questie, usar la mision supertrackeada de Blizzard.
    followSuperTrack = true,
    guideWindow = { shown = true, locked = false, point = { "RIGHT", "UIParent", "RIGHT", -60, 60 } },
    -- Apariencia (preset "Round - Minimal" de Fusion)
    skin = {
        mode = "ZONE",            -- ZONE (interactivo: donde estoy) | GUIDE (zona de la guia) | MANUAL
        accentMode = "ZONE",      -- ZONE (color de la zona) | CUSTOM
        customAccent = { 0.58, 0.74, 0.36 },
        manualZone = "ELWYNN_FOREST",
        font = "CLIENT",          -- por defecto: la fuente del sistema (la del juego; sirve en todos los idiomas)
        textSize = 10,
        titleSize = 14,
        cardTransparency = 0,
        bannerTransparency = 0,
        rounded = true,
        stars = true,
        fog = true,
        clock = true,
        width = 300,
        bannerHeight = 92,
        listHeight = 340,
        doneVisible = 3,
        -- Tarjeta de arriba (paso activo)
        active = {
            show = true, font = "INHERIT", textSize = 11, numberSize = 16,
            transparency = 0, extra = true,
        },
        -- Pie de la ventana (recuento, pestañas, barra de vuelo)
        footer = { textSize = 9.5, transparency = nil },
        -- Lista de misiones (pestaña Misiones): filas y leyenda
        quests = { textSize = 10 },
        -- Lista de pasos de abajo
        list = {
            font = "INHERIT", textSize = 10, numberSize = 13,
            transparency = 0, maxSteps = 14,
        },
    },
}

local function ApplyDefaults(dst, src)
    for k, v in pairs(src) do
        if type(v) == "table" then
            if type(dst[k]) ~= "table" then dst[k] = {} end
            ApplyDefaults(dst[k], v)
        elseif dst[k] == nil then
            dst[k] = v
        end
    end
end

---------------------------------------------------------------------------
-- Bus de eventos interno (callbacks simples entre modulos)
---------------------------------------------------------------------------
local listeners = {}

function QR:On(message, fn)
    listeners[message] = listeners[message] or {}
    table.insert(listeners[message], fn)
end

function QR:Fire(message, ...)
    for _, fn in ipairs(listeners[message] or {}) do
        local ok, err = pcall(fn, ...)
        if not ok then
            QR:Print(string.format(QR.L["|cffff5555error|r in %s: %s"], message, tostring(err)))
        end
    end
end

--- Activa / desactiva el addon entero: ventana, flecha, lineas del mapa y ventanitas
function QR:SetEnabled(enabled)
    QR.db.enabled = enabled and true or false
    if QR.GuideUI and QR.GuideUI.frame then QR.GuideUI:SetShown(QR.db.enabled) end
    if QR.Target then QR.Target:Refresh(true) end   -- sin destino: la flecha y las lineas se ocultan
    QR:Fire("SETTINGS_CHANGED")
    QR:Print(QR.db.enabled and QR.L["|cff33ff33enabled|r"] or QR.L["|cffff3333disabled|r (click the minimap button to enable it again)"])
end

function QR:Print(...)
    print("|cff33ccffQuestieRouter|r:", ...)
end

---------------------------------------------------------------------------
-- Arranque
---------------------------------------------------------------------------
local frame = CreateFrame("Frame")
QR.eventFrame = frame

local modulesToInit = {}

--- Cada modulo registra aqui su funcion de inicializacion. Se llaman cuando Questie esta listo.
function QR:RegisterModule(name, initFn)
    table.insert(modulesToInit, { name = name, init = initFn })
end

---------------------------------------------------------------------------
-- Precarga de fuentes
-- WoW carga los archivos de fuente de forma asincrona: un texto escrito antes de que termine se
-- queda en blanco hasta que se vuelve a escribir (por eso en la primera carga solo se veia el reloj,
-- que se reescribe cada fraccion de segundo). Se aplican las fuentes a textos invisibles fuera de la
-- pantalla en cuanto carga el addon, y al arrancar se repintan todos los textos un par de veces.
---------------------------------------------------------------------------
local FONT_DIR = "Interface\\AddOns\\QuestieRouter\\Media\\Fonts\\"
local preloadFrame = CreateFrame("Frame", nil, UIParent)
preloadFrame:SetSize(1, 1)
preloadFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -500, 500)
preloadFrame:SetAlpha(0)
local preloaded = {}

-- Cada fuente tiene un texto de prueba invisible. Mientras el archivo no ha cargado, el texto mide 0;
-- cuando mide algo, la fuente esta lista. Si alguna no lo estaba al pintar, se repinta UNA vez en
-- cuanto lo esta (sin esperas fijas ni /reload).
local probes = {}         -- path -> fontstring de prueba
local waiting = {}        -- path -> true mientras no este lista
local watchFrame = CreateFrame("Frame")
local watchElapsed = 0

local function FontReady(path)
    local fs = probes[path]
    return fs and (fs:GetStringWidth() or 0) > 0
end

watchFrame:Hide()
watchFrame:SetScript("OnUpdate", function(self, elapsed)
    watchElapsed = watchElapsed + elapsed
    local pending, becameReady = false, false
    for path in pairs(waiting) do
        if FontReady(path) then waiting[path] = nil; becameReady = true else pending = true end
    end
    if becameReady and QR.ready then QR:RefreshFonts() end
    -- tope de seguridad: 10 s (si una fuente no carga nunca, se repinta igual y se deja de mirar)
    if not pending or watchElapsed > 10 then
        if pending and QR.ready then QR:RefreshFonts() end
        wipe(waiting)
        self:Hide()
    end
end)

function QR:PreloadFont(path)
    if not path or preloaded[path] then return end
    preloaded[path] = true
    local fs = preloadFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    fs:SetPoint("TOPLEFT")
    fs:SetFont(path, 12, "")
    fs:SetText("QuestieRouter 0123456789 ÁÉÍÓÚáéíóúñÑ")
    probes[path] = fs
    if not FontReady(path) then
        waiting[path] = true
        watchElapsed = 0
        watchFrame:Show()
    end
end

-- Imagenes: lo mismo que las fuentes. WoW las carga en segundo plano y lo que se pinta antes sale
-- como un cuadrado verde (iconos dentro del texto) hasta que se vuelve a pintar. Se aplican a
-- texturas invisibles en cuanto carga el addon para que esten listas al pintar la ventana.
local preloadedTex = {}
function QR:PreloadTexture(path)
    if not path or preloadedTex[path] then return end
    local t = preloadFrame:CreateTexture(nil, "ARTWORK")
    t:SetSize(1, 1)
    t:SetPoint("TOPLEFT")
    t:SetTexture(path)
    preloadedTex[path] = t
end

--- ¿Estan cargadas todas las fuentes que se han pedido?
function QR:FontsPending()
    return next(waiting) ~= nil
end

-- la fuente del addon (LizeUI) siempre: es la de por defecto
for _, weight in ipairs({ "Regular", "Medium", "Demi", "Bold", "Number" }) do
    QR:PreloadFont(FONT_DIR .. "LizeUI-" .. weight .. ".ttf")
end

--- Vuelve a escribir todos los textos (cuando las fuentes ya estan cargadas)
function QR:RefreshFonts()
    QR:Fire("FONTS_READY")
    QR:Fire("SETTINGS_CHANGED")
end

local function InitModules()
    if QR.ready then return end
    QR.ready = true
    for _, m in ipairs(modulesToInit) do
        local ok, err = pcall(m.init, QR)
        if not ok then
            QR:Print(string.format(QR.L["failed to start %s: %s"], m.name, tostring(err)))
        end
    end
    QR:Fire("READY")
    -- si alguna fuente aun estaba cargando al pintar, el vigilante de fuentes repintara al terminar;
    -- si ya estaban todas listas (lo normal con Fonts.xml) no hace falta nada mas
    if QR:FontsPending() then watchFrame:Show() end
    -- los iconos dentro del texto no se vuelven a dibujar solos al terminar de cargar sus imagenes:
    -- repintar un par de veces al arrancar (barato: solo reescribe textos)
    C_Timer.After(1, function() QR:RefreshFonts() end)
    C_Timer.After(3, function() QR:RefreshFonts() end)
end

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        local fresh = QuestieRouterDB == nil
        QuestieRouterDB = QuestieRouterDB or {}
        ApplyDefaults(QuestieRouterDB, DEFAULTS)
        QR.db = QuestieRouterDB
        -- ventana de instalacion (UI/Install.lua): solo la primera vez que se carga el addon; quien ya lo
        -- usaba no la ve (se puede abrir con /qr install)
        if QR.db.installDone == nil then QR.db.installDone = not fresh end
        -- idioma: el guardado con /qr load_xx o, si no hay, el del cliente
        QR:SetLocale(QR.db.locale)
        -- Letra mas pequeña por defecto (para que quepa todo, tambien en idiomas largos).
        -- Solo se cambian los tamaños que siguen en algun valor por defecto anterior
        -- (v0.7 o el primero de v0.8): lo que el jugador haya cambiado a mano se respeta.
        if (QR.db.sizesVersion or 0) < 2 then
            local sk = QR.db.skin
            local function shrink(tbl, key, new, ...)
                for _, old in ipairs({ ... }) do
                    if tbl[key] == old then tbl[key] = new return end
                end
            end
            shrink(sk, "textSize", 10, 12, 11); shrink(sk, "titleSize", 14, 16, 15)
            shrink(sk.active, "textSize", 11, 13, 12); shrink(sk.active, "numberSize", 16, 18, 17)
            shrink(sk.footer, "textSize", 9.5, 11, 10); shrink(sk.quests, "textSize", 10, 12, 11)
            shrink(sk.list, "textSize", 10, 12, 11); shrink(sk.list, "numberSize", 13, 15, 14)
            QR.db.sizesVersion = 2
            QR.db.sizesMigrated08 = nil
        end
        -- el pie tiene su propia transparencia (antes la compartia con otros paneles)
        if QR.db.skin.footer.transparency == nil then QR.db.skin.footer.transparency = QR.db.skin.cardTransparency or 0 end
        if QR.db.skin.font == "LIZEUI_LIGHT" then QR.db.skin.font = "LIZEUI_REGULAR" end
        -- el titulo de las ventanitas vuelve a ir siempre arriba (la opcion se quito)
        QR.db.activeFrames.itemsTitle, QR.db.activeFrames.targetsTitle = "TOP", "TOP"
        -- la flecha clasica de Blizzard ya no esta disponible: pasa a la "Brujula de arco"
        if QR.db.arrow.style == "CLASSIC" then QR.db.arrow.style = "HD_ARC" end
        if QR.db.arrow.style == "RXP" then QR.db.arrow.style = "RX" end
        -- la flecha "Ojo" del paquete se cambio por la flecha oficial (la de los pasos de viaje)
        if QR.db.arrow.style == "PK_ojo" then QR.db.arrow.style = "PK_flecha-oficial" end
        -- flechas quitadas: la de zona de Fusion y las de Zygor (licencia GPL) -> las propias
        local gone = { ZONE_ARROW = "HD_ARC", ZYGOR_STEALTH = "RX_PRISM", ZYGOR_STARLIGHT = "RX_SLAB" }
        if gone[QR.db.arrow.style] then QR.db.arrow.style = gone[QR.db.arrow.style] end
        -- v0.7: "descripcion si/no" pasa a "Mostrar: descripcion / requisitos / ambos" (campo content)
        for _, key in ipairs({ "active", "list" }) do
            local sec = QR.db.skin[key]
            if sec.content == nil then sec.content = (sec.description == false) and "REQ" or "BOTH" end
        end
        -- v0.6: cada ventanita con su propio tamaño (parte del tamaño comun que hubiera)
        local af = QR.db.activeFrames
        af.itemsSize = af.itemsSize or af.size or 32
        af.targetsSize = af.targetsSize or af.size or 32
        -- v0.5: lineas mas gruesas por defecto (el camino de Zygor se veia como una cuerda)
        if not QR.db.linesMigrated05 then
            if QR.db.lines.thicknessWorld == 5 or QR.db.lines.thicknessWorld == 6 then QR.db.lines.thicknessWorld = 9 end
            if QR.db.lines.thicknessMinimap == 3 or QR.db.lines.thicknessMinimap == 4 then QR.db.lines.thicknessMinimap = 6 end
            QR.db.linesMigrated05 = true
        end
        -- v0.4: la flecha por defecto cambia (solo si no se habia cambiado)
        if not QR.db.arrowMigrated04 then
            if QR.db.arrow.style == "HD_SOFT" then QR.db.arrow.style = "HD_ARC" end
            QR.db.arrowMigrated04 = true
        end
        QuestieRouterCharDB = QuestieRouterCharDB or {}
        QR.charDB = QuestieRouterCharDB
    elseif event == "PLAYER_LOGIN" then
        if not (Questie and Questie.API) then
            QR:Print(QR.L["Questie is not loaded; QuestieRouter is disabled."])
            return
        end
        if Questie.API.RegisterOnReady then
            Questie.API.RegisterOnReady(InitModules)
        else
            -- Versiones antiguas de Questie sin RegisterOnReady: sondear isReady.
            local ticker
            ticker = C_Timer.NewTicker(1, function()
                if Questie.API.isReady then
                    ticker:Cancel()
                    InitModules()
                end
            end)
        end
    end
end)

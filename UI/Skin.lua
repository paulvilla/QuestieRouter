-- QuestieRouter: motor de skin (estilo "Round - Minimal" de Fusion).
--
-- * Tabla de zonas: clave de arte, uiMapID de Classic/Forever y color de acento (de Fusion).
-- * Deteccion de la zona del jugador (subiendo por los mapas padre) o de la zona de la guia.
-- * Paleta derivada del acento con las mismas reglas que Fusion (superficies muy oscuras teñidas).
-- * Fundido suave de paleta y arte al cambiar de zona. Emite "SKIN_CHANGED".

local _, QR = ...

local Skin = {}
QR.Skin = Skin

local MEDIA = "Interface\\AddOns\\QuestieRouter\\Media\\"
Skin.MEDIA = MEDIA

---------------------------------------------------------------------------
-- Zonas (claves y colores de Fusion, UI/Zones.lua)
---------------------------------------------------------------------------
local defs, byMap, order = {}, {}, {}
local function zone(key, name, map, kind, rgb, area)
    local e = { key = key, name = name, mapID = map, kind = kind or "outdoor", accent = rgb, areaID = area }
    defs[key] = e
    order[#order + 1] = e
    if map then byMap[map] = e end
end
zone("DUROTAR", "Durotar", 1411, nil, { 0.93, 0.43, 0.19 })
zone("THE_BARRENS", "The Barrens", 1413, nil, { 0.85, 0.66, 0.28 })
zone("MULGORE", "Mulgore", 1412, nil, { 0.53, 0.72, 0.38 })
zone("TELDRASSIL", "Teldrassil", 1438, nil, { 0.60, 0.48, 0.79 })
zone("DARKSHORE", "Darkshore", 1439, nil, { 0.43, 0.62, 0.70 })
zone("ASHENVALE", "Ashenvale", 1440, nil, { 0.38, 0.68, 0.59 })
zone("STONETALON_MOUNTAINS", "Stonetalon Mountains", 1442, nil, { 0.66, 0.65, 0.43 })
zone("DESOLACE", "Desolace", 1443, nil, { 0.67, 0.64, 0.57 })
zone("THOUSAND_NEEDLES", "Thousand Needles", 1441, nil, { 0.80, 0.61, 0.42 })
zone("DUSTWALLOW_MARSH", "Dustwallow Marsh", 1445, nil, { 0.54, 0.65, 0.40 })
zone("FERALAS", "Feralas", 1444, nil, { 0.35, 0.68, 0.45 })
zone("TANARIS", "Tanaris", 1446, nil, { 0.89, 0.76, 0.49 })
zone("AZSHARA", "Azshara", 1447, nil, { 0.90, 0.57, 0.29 })
zone("FELWOOD", "Felwood", 1448, nil, { 0.57, 0.75, 0.27 })
zone("UNGORO_CRATER", "Un'Goro Crater", 1449, nil, { 0.43, 0.74, 0.31 })
zone("MOONGLADE", "Moonglade", 1450, nil, { 0.43, 0.69, 0.65 })
zone("SILITHUS", "Silithus", 1451, nil, { 0.78, 0.65, 0.43 })
zone("WINTERSPRING", "Winterspring", 1452, nil, { 0.73, 0.70, 0.91 })
zone("ELWYNN_FOREST", "Elwynn Forest", 1429, nil, { 0.58, 0.74, 0.36 })
zone("WESTFALL", "Westfall", 1436, nil, { 0.87, 0.72, 0.40 })
zone("REDRIDGE_MOUNTAINS", "Redridge Mountains", 1433, nil, { 0.84, 0.55, 0.34 })
zone("DUSKWOOD", "Duskwood", 1431, nil, { 0.48, 0.57, 0.73 })
zone("DUN_MOROGH", "Dun Morogh", 1426, nil, { 0.70, 0.84, 0.94 })
zone("LOCH_MODAN", "Loch Modan", 1432, nil, { 0.43, 0.68, 0.78 })
zone("WETLANDS", "Wetlands", 1437, nil, { 0.47, 0.67, 0.69 })
zone("TIRISFAL_GLADES", "Tirisfal Glades", 1420, nil, { 0.52, 0.65, 0.43 })
zone("SILVERPINE_FOREST", "Silverpine Forest", 1421, nil, { 0.43, 0.64, 0.58 })
zone("HILLSBRAD_FOOTHILLS", "Hillsbrad Foothills", 1424, nil, { 0.48, 0.67, 0.52 })
zone("ALTERAC_MOUNTAINS", "Alterac Mountains", 1416, nil, { 0.65, 0.76, 0.86 })
zone("ARATHI_HIGHLANDS", "Arathi Highlands", 1417, nil, { 0.66, 0.73, 0.43 })
zone("THE_HINTERLANDS", "The Hinterlands", 1425, nil, { 0.49, 0.68, 0.52 })
zone("STRANGLETHORN_VALE", "Stranglethorn Vale", 1434, nil, { 0.37, 0.72, 0.49 })
zone("BADLANDS", "Badlands", 1418, nil, { 0.85, 0.59, 0.36 })
zone("SEARING_GORGE", "Searing Gorge", 1427, nil, { 0.84, 0.48, 0.29 })
zone("BURNING_STEPPES", "Burning Steppes", 1428, nil, { 0.94, 0.43, 0.22 })
zone("SWAMP_OF_SORROWS", "Swamp of Sorrows", 1435, nil, { 0.48, 0.65, 0.34 })
zone("BLASTED_LANDS", "Blasted Lands", 1419, nil, { 0.85, 0.38, 0.30 })
zone("DEADWIND_PASS", "Deadwind Pass", 1430, nil, { 0.55, 0.57, 0.70 })
zone("WESTERN_PLAGUELANDS", "Western Plaguelands", 1422, nil, { 0.68, 0.67, 0.38 })
zone("EASTERN_PLAGUELANDS", "Eastern Plaguelands", 1423, nil, { 0.79, 0.56, 0.34 })
zone("ZEPHRAS_ISLE", "Zephras Isle", 2521, nil, { 0.55, 0.78, 0.89 })
zone("RIVERGLADES", "Riverglades", nil, nil, { 0.52, 0.73, 0.59 }, 16591)
zone("MOUNT_HYJAL", "Mount Hyjal", nil, nil, { 0.49, 0.71, 0.43 })
zone("SHENDRALAS", "Shen'dralas", nil, nil, { 0.42, 0.65, 0.69 }, 16651)
zone("STORMWIND", "Stormwind City", 1453, "city", { 0.43, 0.65, 0.88 })
zone("IRONFORGE", "Ironforge", 1455, "city", { 0.92, 0.59, 0.30 })
zone("DARNASSUS", "Darnassus", 1457, "city", { 0.65, 0.52, 0.84 })
zone("ORGRIMMAR", "Orgrimmar", 1454, "city", { 0.91, 0.43, 0.26 })
zone("THUNDER_BLUFF", "Thunder Bluff", 1456, "city", { 0.74, 0.64, 0.39 })
zone("UNDERCITY", "Undercity", 1458, "city", { 0.53, 0.75, 0.36 })
Skin.zones, Skin.zoneOrder = defs, order

local NEUTRAL_ACCENT = { 0.85, 0.72, 0.49 }

---------------------------------------------------------------------------
-- Arte
---------------------------------------------------------------------------
function Skin:GetOrnament(key)
    if not key or not defs[key] then return MEDIA .. "Icons\\Neutral.tga", true end
    if key == "HILLSBRAD_FOOTHILLS" then
        local f = UnitFactionGroup("player")
        if f == "Alliance" or f == "Horde" then return MEDIA .. "Ornaments\\" .. key .. "_" .. f:upper() .. ".blp" end
    end
    return MEDIA .. "Ornaments\\" .. key .. ".blp"
end

function Skin:GetSky(key)
    return key and defs[key] and (MEDIA .. "Skies\\" .. key .. ".blp") or nil
end

-- Recorte vertical de la ilustracion (lienzo 1024x512): todas apoyadas en el borde inferior; el banner muestra
-- la franja de abajo con la altura que le toque (las ilustraciones nuevas no necesitan ajustes por zona).
function Skin:GetOrnamentCrop(key)
    if not key or not defs[key] then return 0.10, 0.90 end
    local span = 341 / 512
    return 1 - span, 1
end

---------------------------------------------------------------------------
-- Paleta (reglas de Fusion: base + acento * factor)
---------------------------------------------------------------------------
local rules = { background = { 0.052, 0.060 }, card = { 0.060, 0.090 }, header = { 0.07, 0.15 },
                active = { 0.090, 0.200 }, border = { 0.09, 0.46 } }
local lift = {
    ALTERAC_MOUNTAINS = 0.010, DUN_MOROGH = 0.012, WINTERSPRING = 0.012, TANARIS = 0.012, WESTFALL = 0.010,
    THE_BARRENS = 0.008, THOUSAND_NEEDLES = 0.010, BADLANDS = 0.008, SILITHUS = 0.008, ELWYNN_FOREST = 0.008,
    HILLSBRAD_FOOTHILLS = 0.008, MULGORE = 0.008, ARATHI_HIGHLANDS = 0.008, LOCH_MODAN = 0.008, WETLANDS = 0.006,
    STORMWIND = 0.008, THUNDER_BLUFF = 0.008, ZEPHRAS_ISLE = 0.008,
}

function Skin:ComputePalette(key)
    local accent = defs[key] and defs[key].accent or NEUTRAL_ACCENT
    local s = QR.db and QR.db.skin
    if s and s.accentMode == "CUSTOM" and s.customAccent then accent = s.customAccent end
    local p = { accent = { accent[1], accent[2], accent[3] } }
    for comp, r in pairs(rules) do
        local base = r[1] + ((comp == "background" or comp == "card") and (lift[key] or 0) or 0)
        p[comp] = { base + accent[1] * r[2], base + accent[2] * r[2], base + accent[3] * r[2] }
    end
    p.text = { 0.90, 0.92, 0.90 }
    p.dim = { 0.55, 0.58, 0.56 }
    return p
end

local function lerp(a, b, t) return a + (b - a) * t end

--- Color actual (con fundido en curso). comp: background | card | header | active | border | accent | text | dim
function Skin:Color(comp)
    local to = self.palette and self.palette[comp]
    if not to then return 1, 1, 1 end
    local tr = self.transition
    if tr and tr.from[comp] then
        local f, t = tr.from[comp], tr.fraction
        return lerp(f[1], to[1], t), lerp(f[2], to[2], t), lerp(f[3], to[3], t)
    end
    return to[1], to[2], to[3]
end

--- Color de la zona para TEXTO: el mismo tono, pero aclarado hasta que se lea bien sobre los fondos
--- oscuros de la skin (luminancia minima ~0.62). Si ya es claro, se queda igual.
function Skin:TextAccent(minLum)
    minLum = minLum or 0.62
    local r, g, b = self:Color("accent")
    local lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
    if lum >= minLum then return r, g, b end
    local t = (minLum - lum) / math.max(0.001, 1 - lum)
    return r + (1 - r) * t, g + (1 - g) * t, b + (1 - b) * t
end

function Skin:Hex(comp)
    local r, g, b = self:Color(comp)
    return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end

-- Colores semanticos del texto (los de Fusion, suaves)
Skin.TEXT = {
    friendly = "|cff71d6a2", enemy = "|cffff8178", loot = "|cff62d2e0", warn = "|cffffd166",
    pick = "|cffbda0ff", done = "|cff7f8a84",
}

---------------------------------------------------------------------------
-- Deteccion de zona
---------------------------------------------------------------------------
local function MapName(map)
    local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
    return info and info.name, info and info.parentMapID
end

local function KeyByName(name)
    if not name then return nil end
    name = name:gsub("^The ", "")
    for _, e in ipairs(order) do
        if name == e.name:gsub("^The ", "") then return e.key end
    end
end

function Skin:KeyForMap(map)
    for _ = 1, 8 do
        if not map then return nil end
        if byMap[map] then return byMap[map].key end
        local name, parent = MapName(map)
        local k = KeyByName(name)
        if k then return k end
        if not parent or parent == map then return nil end
        map = parent
    end
end

function Skin:KeyForGuide(guide)
    if not guide then return nil end
    local map = QR.Bridge and QR.Bridge.UiMapOf and QR.Bridge:UiMapOf(guide.areaId)
    return (map and self:KeyForMap(map)) or KeyByName(guide.zone)
end

function Skin:DetectPlayerZone()
    local _, instanceType = GetInstanceInfo()
    if instanceType and instanceType ~= "none" then return nil end
    local map = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    return self:KeyForMap(map) or KeyByName(GetRealZoneText and GetRealZoneText())
end

--- Zona que debe mostrar la skin segun el modo elegido en opciones.
function Skin:ResolveKey()
    local s = QR.db.skin
    if s.mode == "MANUAL" and defs[s.manualZone] then return s.manualZone end
    if s.mode == "GUIDE" then
        local k = self:KeyForGuide(QR.Planner and QR.Planner:GetGuide())
        if k then return k end
    end
    return self:DetectPlayerZone() or self:KeyForGuide(QR.Planner and QR.Planner:GetGuide()) or self.key
end

---------------------------------------------------------------------------
-- Cambio de zona con fundido
---------------------------------------------------------------------------
local FADE_SECONDS = 2.5

function Skin:Apply(key, instant)
    if key == self.key and self.palette then return end
    local previous = self.key
    local from = {}
    if self.palette and not instant then
        for comp in pairs(self.palette) do from[comp] = { self:Color(comp) } end
    end
    self.key = key
    self.previousKey = previous
    self.palette = self:ComputePalette(key)
    if instant or not next(from) then
        self.transition = nil
    else
        self.transition = { from = from, fraction = 0, start = GetTime(), fromKey = previous }
        self.ticker = self.ticker or CreateFrame("Frame")
        self.ticker:SetScript("OnUpdate", function(f)
            local tr = Skin.transition
            if not tr then f:SetScript("OnUpdate", nil) return end
            tr.fraction = math.min(1, (GetTime() - tr.start) / FADE_SECONDS)
            QR:Fire("SKIN_FADE", tr.fraction)
            if tr.fraction >= 1 then
                Skin.transition = nil
                f:SetScript("OnUpdate", nil)
                QR:Fire("SKIN_FADE", 1)
            end
        end)
    end
    QR:Fire("SKIN_CHANGED", key, previous)
end

function Skin:Refresh(instant)
    self:Apply(self:ResolveKey(), instant)
end

---------------------------------------------------------------------------
-- Fuentes (las de Fusion, licencia OFL) y ayudas de texto
---------------------------------------------------------------------------
Skin.fonts = {
    -- fuente propia del addon (por defecto): LizeUI Demi para todo el texto
    { key = "QUESTIEROUTER", name = "QuestieRouter", file = "LizeUI",
      weights = { Regular = "Demi", SemiBold = "Demi", Bold = "Demi" }, number = "Demi" },
    { key = "CLIENT", name = "Game font" },
    { key = "BARLOW", name = "Barlow", file = "Barlow" },
    { key = "BARLOW_CONDENSED", name = "Barlow Condensed", file = "BarlowCondensed" },
    { key = "INTER", name = "Inter", file = "Inter" },
    { key = "FIRA", name = "Fira Sans", file = "FiraSans" },
    { key = "LATO", name = "Lato", file = "Lato" },
    { key = "RAJDHANI", name = "Rajdhani", file = "Rajdhani" },
    { key = "SOURCE", name = "Source Sans 3", file = "SourceSans3" },
    -- AvantGarde de LizeUI, renombrada LizeUI-<tipo> (Regular, Medium, Demi, Bold, Number)
    -- LizeUI combinada: Medium en el texto, Demi / Bold en titulos y Number en los numeros
    { key = "LIZEUI", name = "LizeUI (combined)", file = "LizeUI",
      weights = { Regular = "Medium", SemiBold = "Demi", Bold = "Bold" }, number = "Number" },
    -- cada archivo de LizeUI como fuente propia (todo el texto con ese archivo)
    { key = "LIZEUI_REGULAR", name = "LizeUI Regular", file = "LizeUI",
      weights = { Regular = "Regular", SemiBold = "Regular", Bold = "Regular" }, number = "Regular" },
    { key = "LIZEUI_MEDIUM", name = "LizeUI Medium", file = "LizeUI",
      weights = { Regular = "Medium", SemiBold = "Medium", Bold = "Medium" }, number = "Medium" },
    { key = "LIZEUI_DEMI", name = "LizeUI Demi", file = "LizeUI",
      weights = { Regular = "Demi", SemiBold = "Demi", Bold = "Demi" }, number = "Demi" },
    { key = "LIZEUI_BOLD", name = "LizeUI Bold", file = "LizeUI",
      weights = { Regular = "Bold", SemiBold = "Bold", Bold = "Bold" }, number = "Bold" },
    { key = "LIZEUI_NUMBER", name = "LizeUI Number", file = "LizeUI",
      weights = { Regular = "Number", SemiBold = "Number", Bold = "Number" }, number = "Number" },
}
local fontByKey = {}
for _, f in ipairs(Skin.fonts) do fontByKey[f.key] = f end


-- Fuentes del addon sin letras cirilicas (comprobado con fontTools). En ruso se cambian por Fira Sans
-- (que si las tiene) para que el texto no salga en blanco o con cuadros.
local NO_CYRILLIC = { LizeUI = true, Barlow = true, BarlowCondensed = true, Rajdhani = true }

function Skin:FontPath(weight, fontKey)
    local f = fontByKey[fontKey or QR.db.skin.font]
    if QR.locale == "ruRU" then
        -- la fuente del juego solo trae cirilico seguro en un cliente ruso (probar /qr load_ru en otro cliente)
        local clientRu = GetLocale and GetLocale() == "ruRU"
        if (f and f.file and NO_CYRILLIC[f.file]) or ((not f or not f.file) and not clientRu) then
            f = fontByKey.FIRA
        end
    end
    if not f or not f.file then return STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF" end
    weight = weight or "Regular"
    if weight == "Number" then weight = f.number or "Bold" end
    if f.weights and f.weights[weight] then weight = f.weights[weight] end
    if weight == "SemiBold" and (f.file == "Lato") then weight = "Bold" end
    return MEDIA .. "Fonts\\" .. f.file .. "-" .. weight .. ".ttf"
end

-- Precargar TODOS los archivos de fuente al cargar el addon (como la de por defecto): cada uno se
-- aplica a un texto invisible, asi WoW los carga durante la pantalla de carga y al elegirlos en
-- Opciones ya estan listos. Usa FontPath para precargar solo archivos que existen.
do
    local seen = {}
    for _, f in ipairs(Skin.fonts) do
        if f.file and QR.PreloadFont then
            for _, w in ipairs({ "Regular", "SemiBold", "Bold", "Number" }) do
                local path = Skin:FontPath(w, f.key)
                if not seen[path] then
                    seen[path] = true
                    QR:PreloadFont(path)
                end
            end
        end
    end
end

--- Ajustes propios de un apartado de la ventana: "active" (tarjeta de arriba) o "list" (pasos de abajo)
-- Paneles de interfaz (opciones, selector de zona): nunca transparentes, para que se lean siempre
local UI_SECTION = { transparency = 0 }

function Skin:Section(section)
    if section == "ui" then return UI_SECTION end
    return section and QR.db.skin[section] or nil
end

--- Aplica la fuente elegida. role: body | title | subtitle | number | small | eyebrow
--- section (opcional): usa la fuente/tamaños de ese apartado si los tiene
function Skin:StyleText(fs, role, section)
    local s = QR.db.skin
    local sec = self:Section(section)
    local base = (sec and sec.textSize) or s.textSize
    local fontKey = s.font -- una sola fuente para todo (se elige en Opciones -> Skin)
    local size, weight, flags = base, "Regular", ""
    if role == "title" then size, weight = s.titleSize, "Bold"
    elseif role == "subtitle" then size, weight = s.titleSize * 0.72, "SemiBold"
    elseif role == "number" then size, weight = (sec and sec.numberSize) or base * 1.3, "Number"
    elseif role == "small" then size = base * 0.85
    elseif role == "clock" then size, weight = s.clockSize or base * 0.85, "Number"
    elseif role == "eyebrow" then size, weight = s.eyebrowSize or math.max(7, base * 0.62), "Bold" end
    if not fs:SetFont(self:FontPath(weight, fontKey), size, flags) then
        fs:SetFont(STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF", size, flags)
    end
    fs.qrRole = role
end

---------------------------------------------------------------------------
-- Tarjeta redondeada (minimal: sin borde, radio 10, mascara de 9 cortes de Fusion)
---------------------------------------------------------------------------
local sliceOK = nil
local function SupportsSlicedMasks(owner)
    if sliceOK ~= nil then return sliceOK end
    local probe = owner:CreateMaskTexture()
    sliceOK = probe.SetTextureSliceMargins ~= nil and probe.SetTextureSliceMode ~= nil
        and Enum and Enum.UITextureSliceMode ~= nil
    probe:Hide()
    return sliceOK
end

function Skin:SetRounded(owner, texture, shape)
    if not texture.AddMaskTexture or not owner.CreateMaskTexture then return end
    if not QR.db.skin.rounded or not SupportsSlicedMasks(owner) then
        if owner.qrMask and owner.qrMasked and owner.qrMasked[texture] then
            texture:RemoveMaskTexture(owner.qrMask)
            owner.qrMasked[texture] = nil
        end
        return
    end
    shape = shape or "All"
    if not owner.qrMask then
        owner.qrMask = owner:CreateMaskTexture()
        owner.qrMask:SetAllPoints(owner)
        owner.qrMasked = {}
    end
    if owner.qrMaskShape ~= shape then
        owner.qrMask:SetTexture(MEDIA .. "Textures\\RoundMask" .. shape .. ".tga", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        owner.qrMask:SetTextureSliceMargins(10, 10, 10, 10)
        owner.qrMask:SetTextureSliceMode(Enum.UITextureSliceMode.Stretched)
        owner.qrMaskShape = shape
    end
    if not owner.qrMasked[texture] then
        texture:AddMaskTexture(owner.qrMask)
        owner.qrMasked[texture] = true
    end
end

function Skin:CreateCard(parent)
    local card = CreateFrame("Frame", nil, parent)
    card.bg = card:CreateTexture(nil, "BACKGROUND")
    card.bg:SetAllPoints()
    card.bg:SetColorTexture(1, 1, 1, 1)
    self:SetRounded(card, card.bg)
    return card
end

--- comp: componente de la paleta; alphaMul opcional
function Skin:PaintCard(card, comp, alphaMul, section)
    local r, g, b = self:Color(comp or "card")
    local sec = self:Section(section)
    local transparency = (sec and sec.transparency) or QR.db.skin.cardTransparency or 0
    local a = (1 - transparency / 100) * (alphaMul or 1)
    card.bg:SetVertexColor(r, g, b, a)
    self:SetRounded(card, card.bg)
end

---------------------------------------------------------------------------
-- Iconos de accion (GuideHD de Fusion)
---------------------------------------------------------------------------
local ACTION = MEDIA .. "Icons\\Actions\\Action_"
Skin.ICON = {
    accept = ACTION .. "accept.tga", turnin = ACTION .. "turnin.tga", combat = ACTION .. "combat.tga",
    collect = ACTION .. "collect.tga", complete = ACTION .. "complete.tga", gossip = ACTION .. "gossip.tga",
    arrow = ACTION .. "arrow.tga", error = ACTION .. "error.tga", xp = ACTION .. "xp.tga",
    clock = ACTION .. "clock.tga", marker = ACTION .. "marker.tga",
    walk = ACTION .. "walk.tga",   -- pasos de viaje a pie (la forma del "Ojo", plateada)
    elite = MEDIA .. "Icons\\Elite_Skull.tga",            -- calavera de elite/jefe (de icons/Islands-AzeriteBoss.tga)
    dungeon = "Interface\\MINIMAP\\Dungeon",             -- icono de mazmorra del propio juego (archivo del cliente)
}
--- Tamaño de icono para el texto de una seccion ("active", "list", "footer"...): sigue a su texto
--- Tamaño de icono de una seccion: el elegido en Opciones o, si no, el de su texto + 2
function Skin:IconSize(section)
    local sec = self:Section(section)
    if sec and sec.iconSize then return math.floor(sec.iconSize) end
    return math.floor(((sec and sec.textSize) or QR.db.skin.textSize) + 2)
end

--- Tamaño del texto de una seccion (para centrar sus iconos); scale: rol del texto (0.85 = "small")
function Skin:SectionTextSize(section, scale)
    local sec = self:Section(section)
    return ((sec and sec.textSize) or QR.db.skin.textSize) * (scale or 1)
end

--- Icono en linea. Con textSize, se desplaza para quedar centrado con la linea de texto
--- (WoW alinea los iconos por la base del texto: si el icono es mas grande queda descolgado).
--- Iconos con mucho margen transparente: se recortan (px de la textura: tamaño, izq, der, arriba, abajo)
--- para que el dibujo llene el hueco y no se vea pequeño al lado de los demas.
Skin.ICON_CROP = {
    elite = { 32, 6, 26, 6, 26 },     -- la calavera ocupa ~18 de sus 32 px
    dungeon = { 32, 4, 28, 4, 28 },   -- icono de mazmorra del minimapa
}
function Skin:IconTag(name, size, textSize)
    size = size or math.floor(QR.db.skin.textSize + 2)
    local yoff = textSize and math.floor((textSize - size) / 2 + 0.5) or 0
    local c = self.ICON_CROP[name]
    if c then
        return string.format("|T%s:%d:%d:0:%d:%d:%d:%d:%d:%d:%d|t", self.ICON[name], size, size, yoff,
            c[1], c[1], c[2], c[3], c[4], c[5])
    end
    return string.format("|T%s:%d:%d:0:%d|t", self.ICON[name] or name, size, size, yoff)
end
function Skin:UIIcon(name) return MEDIA .. "Icons\\UI\\" .. name .. ".tga" end

-- Precargar las imagenes del addon (iconos de accion, de la interfaz, mascaras, cielo...) al cargar
-- el addon: asi no salen cuadrados verdes la primera vez que se pinta la ventana.
do
    local list = {
        "Icons\\Actions\\Action_accept.tga",
        "Icons\\Actions\\Action_arrow.tga",
        "Icons\\Actions\\Action_clock.tga",
        "Icons\\Actions\\Action_collect.tga",
        "Icons\\Actions\\Action_combat.tga",
        "Icons\\Actions\\Action_complete.tga",
        "Icons\\Actions\\Action_error.tga",
        "Icons\\Actions\\Action_gossip.tga",
        "Icons\\Actions\\Action_marker.tga",
        "Icons\\Actions\\Action_turnin.tga",
        "Icons\\Actions\\Action_xp.tga",
        "Icons\\Actions\\Action_walk.tga",
        "Icons\\UI\\Appearance.tga",
        "Icons\\UI\\Arrow.tga",
        "Icons\\UI\\ArrowDown.tga",
        "Icons\\UI\\ArrowLeft.tga",
        "Icons\\UI\\ArrowRight.tga",
        "Icons\\UI\\Automatic.tga",
        "Icons\\UI\\Back.tga",
        "Icons\\UI\\Boat.tga",
        "Icons\\UI\\Check.tga",
        "Icons\\UI\\Chevron.tga",
        "Icons\\UI\\Close.tga",
        "Icons\\UI\\Cog.tga",
        "Icons\\UI\\Font.tga",
        "Icons\\UI\\Gryphon.tga",
        "Icons\\UI\\Guides.tga",
        "Icons\\UI\\Lock.tga",
        "Icons\\UI\\Menu.tga",
        "Icons\\UI\\Minus.tga",
        "Icons\\UI\\Reset.tga",
        "Icons\\UI\\Resize.tga",
        "Icons\\UI\\ScrollTop.tga",
        "Icons\\UI\\Search.tga",
        "Icons\\UI\\Unlock.tga",
        "Textures\\BannerTextVeil.tga",
        "Textures\\BrandAurora.tga",
        "Textures\\ClassCorner.tga",
        "Textures\\DockGlowCorners.tga",
        "Textures\\RoundBorderRing.tga",
        "Textures\\RoundCornerCover.tga",
        "Textures\\RoundMaskAll.tga",
        "Textures\\RoundMaskTop.tga",
        "Textures\\RoundedThumb.tga",
        "Textures\\SegmentCircle.tga",
        "Textures\\SoftPanel.tga",
        "Textures\\SoftPanelCircle.tga",
        "Icons\\BodyWash.tga",
        "Icons\\Neutral.tga",
        "Icons\\QuestieRouter-128.tga",
        "Icons\\QuestieRouter.tga",
        "Icons\\ReflectionFade.tga",
        "Icons\\ScrollBar.tga",
        "Icons\\ScrollMarker.tga",
        "Sky\\ForegroundMist.tga",
        "Sky\\Moon.tga",
        "Sky\\Stars.tga",
        "Sky\\SubtitleMist.tga",
        "Sky\\TextShade.tga",
        "Lines\\mapline.tga"
    }
    if QR.PreloadTexture then
        for _, rel in ipairs(list) do QR:PreloadTexture(MEDIA .. rel) end
    end
end

---------------------------------------------------------------------------
--- Precarga los archivos de la fuente elegida (ver QR:PreloadFont en Core.lua)
function Skin:PreloadCurrentFont()
    if not QR.PreloadFont then return end
    for _, w in ipairs({ "Regular", "SemiBold", "Bold", "Number" }) do
        QR:PreloadFont(self:FontPath(w))
    end
end

function Skin:Init()
    self:PreloadCurrentFont()
    self:Refresh(true)
    local f = CreateFrame("Frame")
    f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    f:RegisterEvent("ZONE_CHANGED")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    local queued = false
    f:SetScript("OnEvent", function()
        if queued then return end
        queued = true
        C_Timer.After(0.5, function() queued = false; Skin:Refresh() end)
    end)
    QR:On("GUIDE_CHANGED", function() Skin:Refresh() end)
    Skin.lastFont = QR.db.skin.font
    QR:On("SETTINGS_CHANGED", function()
        Skin:PreloadCurrentFont()
        -- fuente nueva: volver a aplicarla a todos los textos varias veces en los primeros segundos
        -- (si su archivo aun estaba cargando, los textos se quedan en blanco hasta reaplicarla;
        -- antes habia que elegir la fuente dos veces)
        if QR.db.skin.font ~= Skin.lastFont then
            Skin.lastFont = QR.db.skin.font
            for _, delay in ipairs({ 0.15, 0.5, 1.0, 2.0 }) do
                C_Timer.After(delay, function() QR:RefreshFonts() end)
            end
        end
        Skin:Refresh(true)
        -- el acento personalizado puede haber cambiado sin cambiar de zona
        if Skin.key ~= nil or Skin.palette then Skin.palette = Skin:ComputePalette(Skin.key) end
    end)
end

QR:RegisterModule("Skin", function() Skin:Init() end)

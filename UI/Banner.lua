-- QuestieRouter: banner de zona con ciclo dia/noche (adaptado de Fusion).
--
-- Capas, de atras adelante:
--   fondo (color de cabecera de la paleta)
--   cielo        Media\Skies\<ZONA>.blp: tira panoramica dia -> noche. El recorte avanza con la hora
--                del juego (GetGameTime) y la tira se refleja, asi el ciclo es continuo.
--   estrellas    solo de noche y en zonas despejadas
--   luna         (Tanaris, cuyo cielo no la trae pintada)
--   ilustracion  Media\Ornaments\<ZONA>.blp: silueta de la zona con alfa, recortada por la base
--   niebla       amaneceres en bosques/costas/pantanos brumosos, se desplaza despacio
--   velo         oscurece detras del texto para que se lea siempre
--   texto        cabecera, titulo, subtitulo y reloj
-- Al cambiar de zona hay dos juegos de cielo/ilustracion y se funden.

local _, QR = ...

local Banner = {}
QR.Banner = Banner

local MEDIA = QR.Skin.MEDIA
local SKY = MEDIA .. "Sky\\"

local skyZones = {}
for key in pairs(QR.Skin.zones) do skyZones[key] = true end

local starZones = {
    DUROTAR = true, THE_BARRENS = true, MULGORE = true, TELDRASSIL = true, ASHENVALE = true,
    STONETALON_MOUNTAINS = true, THOUSAND_NEEDLES = true, FERALAS = true, AZSHARA = true, WINTERSPRING = true,
    ELWYNN_FOREST = true, WESTFALL = true, REDRIDGE_MOUNTAINS = true, DUN_MOROGH = true, LOCH_MODAN = true,
    HILLSBRAD_FOOTHILLS = true, ALTERAC_MOUNTAINS = true, ARATHI_HIGHLANDS = true, THE_HINTERLANDS = true,
    STRANGLETHORN_VALE = true, BADLANDS = true, STORMWIND = true, DARNASSUS = true, ORGRIMMAR = true,
    THUNDER_BLUFF = true,
}

-- { intensidad, suelo diurno, r, g, b }
local fogZones = {
    DUSKWOOD = { 0.15, 0.60, 0.70, 0.80, 0.86 },
    TIRISFAL_GLADES = { 0.15, 0.55, 0.72, 0.80, 0.70 },
    SILVERPINE_FOREST = { 0.12, 0.30, 0.72, 0.81, 0.79 },
    DARKSHORE = { 0.10, 0.22, 0.71, 0.81, 0.88 },
    DUSTWALLOW_MARSH = { 0.11, 0.20, 0.81, 0.81, 0.71 },
    SWAMP_OF_SORROWS = { 0.12, 0.38, 0.74, 0.82, 0.70 },
}
local fogTimes = { { 0, 0.75 }, { 4, 0.85 }, { 6, 1 }, { 8, 0.45 }, { 10, 0 }, { 16, 0 }, { 18, 0.20 }, { 21, 0.65 }, { 24, 0.75 } }

local skyTimes = {
    { 0, 0.60, 0.70, 0.85 }, { 5, 0.65, 0.74, 0.87 }, { 7, 0.85, 0.91, 0.95 }, { 12, 1.00, 1.00, 1.00 },
    { 17, 0.94, 0.96, 0.98 }, { 19, 0.78, 0.76, 0.88 }, { 21, 0.63, 0.71, 0.86 }, { 24, 0.60, 0.70, 0.85 },
}

local function smooth(x) return x * x * (3 - 2 * x) end
local function mirror(p) return math.abs(1 - p % 2) end

function Banner.SkyTime()
    if QR.skyPreviewMinutes then
        return math.floor(QR.skyPreviewMinutes / 60), QR.skyPreviewMinutes % 60
    end
    if GetGameTime then return GetGameTime() end
    return 12, 0
end

local function DaylightOf(t)
    for i = 1, #skyTimes - 1 do
        local a, b = skyTimes[i], skyTimes[i + 1]
        if t <= b[1] then
            local f = (t - a[1]) / (b[1] - a[1])
            local r = a[2] + (b[2] - a[2]) * f
            local g = a[3] + (b[3] - a[3]) * f
            local bl = a[4] + (b[4] - a[4]) * f
            return math.max(0, math.min(1, (r * 0.2126 + g * 0.7152 + bl * 0.0722 - 0.70) / 0.30))
        end
    end
    return 1
end

local function NightOf(t)
    local n = 1
    if t >= 4 and t < 8 then n = (8 - t) / 4
    elseif t >= 8 and t <= 18 then n = 0
    elseif t > 18 and t < 22 then n = (t - 18) / 4 end
    return smooth(n)
end

local function FogOf(key, t)
    local prof = key and fogZones[key]
    if not prof then return 0 end
    for i = 1, #fogTimes - 1 do
        local a, b = fogTimes[i], fogTimes[i + 1]
        if t <= b[1] then
            local f = smooth((t - a[1]) / (b[1] - a[1]))
            local w = a[2] + (b[2] - a[2]) * f
            return prof[1] * (prof[2] + (1 - prof[2]) * w)
        end
    end
    return 0
end

---------------------------------------------------------------------------
-- Construccion
---------------------------------------------------------------------------
local function Tex(owner, layer, sub)
    local t = owner:CreateTexture(nil, layer, nil, sub)
    if t.SetSnapToPixelGrid then t:SetSnapToPixelGrid(false); t:SetTexelSnappingBias(0) end
    t:Hide()
    return t
end

--- opts.thumb = true: miniatura estatica (sin niebla, sin animacion, sin textos grandes)
function Banner:Create(parent, opts)
    opts = opts or {}
    local b = CreateFrame("Frame", nil, parent)
    b.opts = opts
    b.base = b:CreateTexture(nil, "BACKGROUND")
    b.base:SetAllPoints()
    b.base:SetColorTexture(1, 1, 1, 1)
    -- dos juegos (actual y anterior) para el fundido
    b.sets = {}
    for i = 1, 2 do
        b.sets[i] = {
            sky = Tex(b, "BORDER", 0), skyCont = Tex(b, "BORDER", 0),
            orn = Tex(b, "ARTWORK", i == 1 and 0 or -1),
        }
    end
    b.stars, b.starsCont = Tex(b, "BORDER", 1), Tex(b, "BORDER", 1)
    b.stars:SetTexture(SKY .. "Stars.tga"); b.starsCont:SetTexture(SKY .. "Stars.tga")
    b.moon = Tex(b, "BORDER", 2); b.moon:SetTexture(SKY .. "Moon.tga")
    b.fog, b.fogCont = Tex(b, "ARTWORK", 1), Tex(b, "ARTWORK", 1)
    for _, f in ipairs({ b.fog, b.fogCont }) do f:SetTexture(SKY .. "ForegroundMist.tga"); f:SetDesaturated(true) end
    b.veil = Tex(b, "ARTWORK", 6)
    b.veil:SetTexture(MEDIA .. "Textures\\BannerTextVeil.tga")

    if not opts.thumb then
        b.eyebrow = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        b.eyebrow:SetPoint("TOPLEFT", 10, -8)
        b.title = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        b.title:SetPoint("TOPLEFT", b.eyebrow, "BOTTOMLEFT", 0, -1)
        b.title:SetPoint("RIGHT", b, "RIGHT", -50, 0)
        b.title:SetJustifyH("LEFT")
        b.subtitle = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        b.subtitle:SetPoint("TOPLEFT", b.title, "BOTTOMLEFT", 0, -1)
        b.subtitle:SetJustifyH("LEFT")
        b.clock = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        b.clock:SetPoint("TOPRIGHT", -10, -8)
        for _, fs in ipairs({ b.eyebrow, b.title, b.subtitle, b.clock }) do
            fs:SetShadowOffset(1, -1)
            fs:SetShadowColor(0, 0, 0, 0.9)
        end
        -- animacion: 5 repintados por segundo bastan para el reloj y la niebla
        local acc = 0
        b:SetScript("OnUpdate", function(self, elapsed)
            acc = acc + elapsed
            if acc < 0.2 then return end
            acc = 0
            self:Paint()
        end)
    end

    b.SetZone = Banner.SetZone
    b.Paint = Banner.Paint
    b.SetTexts = Banner.SetTexts
    b.StyleTexts = Banner.StyleTexts
    if not opts.thumb then b:StyleTexts() end
    return b
end

function Banner:StyleTexts()
    if not self.title then return end
    QR.Skin:StyleText(self.eyebrow, "eyebrow")
    QR.Skin:StyleText(self.title, "title")
    QR.Skin:StyleText(self.subtitle, "subtitle")
    QR.Skin:StyleText(self.clock, "clock")
end

function Banner:SetTexts(eyebrow, title, subtitle)
    if not self.title then return end
    self.eyebrow:SetText(eyebrow or "")
    self.title:SetText(title or "")
    self.subtitle:SetText(subtitle or "")
end

--- key: zona actual; oldKey/fraction: fundido desde la zona anterior (fraction 0..1)
function Banner:SetZone(key, oldKey, fraction)
    self.key, self.oldKey, self.fraction = key, oldKey, fraction or 1
    self:Paint()
end

---------------------------------------------------------------------------
-- Pintado
---------------------------------------------------------------------------
local function PaintSet(b, set, key, alpha, t, W, H)
    local Skin = QR.Skin
    -- Ilustracion: conserva la proporcion recortando por arriba (la base del suelo queda fija)
    local orn, neutral = Skin:GetOrnament(key)
    -- TRILINEAR: usa los mipmaps de la BLP (tools/media/smooth_ornaments.py); sin ellos, al reducirla salen dientes de sierra
    if set.ornPath ~= orn then set.orn:SetTexture(orn, "CLAMP", "CLAMP", "TRILINEAR"); set.ornPath = orn end
    local top, bottom = Skin:GetOrnamentCrop(key)
    if neutral then top, bottom = 0.13, 0.72 end
    -- fraccion vertical que mantiene la proporcion del lienzo 1024x512 para este ancho/alto
    local wanted = (1024 * H / W) / 512
    top = math.max(0, bottom - wanted)
    set.orn:SetAllPoints(b)
    set.orn:SetTexCoord(0, 1, top, bottom)
    set.orn:SetAlpha(alpha * (neutral and 0.6 or 1))
    set.orn:SetShown(alpha > 0.001)
    Skin:SetRounded(b, set.orn)

    -- Cielo: tira de 2048x256, se muestra un 35 % del ancho; avanza 1 "vuelta" cada 24 h
    local sky = skyZones[key] and Skin:GetSky(key)
    if not sky or alpha <= 0.001 then
        set.sky:Hide(); set.skyCont:Hide()
        return
    end
    if set.skyPath ~= sky then set.sky:SetTexture(sky); set.skyCont:SetTexture(sky); set.skyPath = sky end
    local span = 0.35
    local cropTop = math.max(0, 1 - (span * 2048 * H / W) / 256)
    local phase = (1 + t / 12 - span / 2) % 2
    local first = math.min(span, math.floor(phase) + 1 - phase)
    local split = first / span
    local left, right = mirror(phase), mirror(phase + first)
    set.sky:ClearAllPoints()
    set.sky:SetPoint("TOPLEFT", b, "TOPLEFT")
    set.sky:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT")
    set.sky:SetWidth(math.max(1, W * split))
    set.sky:SetTexCoord(left, right, cropTop, 1)
    set.sky:SetAlpha(alpha)
    set.sky:Show()
    Skin:SetRounded(b, set.sky)
    if split < 0.999 then
        set.skyCont:ClearAllPoints()
        set.skyCont:SetPoint("TOPLEFT", b, "TOPLEFT", W * split, 0)
        set.skyCont:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT")
        set.skyCont:SetTexCoord(right, mirror(phase + span), cropTop, 1)
        set.skyCont:SetAlpha(alpha)
        set.skyCont:Show()
        Skin:SetRounded(b, set.skyCont)
    else
        set.skyCont:Hide()
    end
end

local function PaintStars(b, t, W, H)
    local s = QR.db.skin
    local w = 0
    if starZones[b.key] then w = w + b.fraction end
    if starZones[b.oldKey] then w = w + (1 - b.fraction) end
    local strength = math.min(1, w) * NightOf(t) * 0.85
    if not s.stars or strength <= 0.001 then b.stars:Hide(); b.starsCont:Hide(); return end
    local span = 0.80
    local phase = (1 - t / 12 - span / 2) % 2
    local first = math.min(span, math.floor(phase) + 1 - phase)
    local split = first / span
    local left, right = mirror(phase), mirror(phase + first)
    local cropTop = 1 - span
    b.stars:ClearAllPoints()
    b.stars:SetPoint("TOPLEFT", b, "TOPLEFT")
    b.stars:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT")
    b.stars:SetWidth(math.max(1, W * split))
    b.stars:SetTexCoord(left, right, cropTop, 1)
    b.stars:SetAlpha(strength)
    b.stars:Show()
    QR.Skin:SetRounded(b, b.stars)
    if split < 0.999 then
        b.starsCont:ClearAllPoints()
        b.starsCont:SetPoint("TOPLEFT", b, "TOPLEFT", W * split, 0)
        b.starsCont:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT")
        b.starsCont:SetTexCoord(right, mirror(phase + span), cropTop, 1)
        b.starsCont:SetAlpha(strength)
        b.starsCont:Show()
        QR.Skin:SetRounded(b, b.starsCont)
    else
        b.starsCont:Hide()
    end
end

local function PaintMoon(b, t, W, H)
    local fade = (b.key == "TANARIS" and b.fraction or 0) + (b.oldKey == "TANARIS" and (1 - b.fraction) or 0)
    local a = math.min(1, fade) * math.max(0, math.cos(t * math.pi / 12))
    if a <= 0.001 then b.moon:Hide(); return end
    local size = math.max(1, H * 0.22)
    b.moon:SetSize(size, size)
    b.moon:ClearAllPoints()
    b.moon:SetPoint("CENTER", b, "TOPLEFT", W * (0.55 + 0.12 * math.sin(t * math.pi / 12)), -H * 0.20)
    b.moon:SetAlpha(a)
    b.moon:Show()
end

local function PaintFog(b, t, W, H)
    local inc, out = FogOf(b.key, t) * b.fraction, FogOf(b.oldKey, t) * (1 - b.fraction)
    local strength = (inc + out) * 1.64
    if not QR.db.skin.fog or b.opts.thumb or strength <= 0.001 then b.fog:Hide(); b.fogCont:Hide(); return end
    local np, op = fogZones[b.key], fogZones[b.oldKey]
    local total = inc + out
    local r = ((np and np[3] or 0) * inc + (op and op[3] or 0) * out) / total
    local g = ((np and np[4] or 0) * inc + (op and op[4] or 0) * out) / total
    local bl = ((np and np[5] or 0) * inc + (op and op[5] or 0) * out) / total
    local h = H * 0.75
    local phase = (GetTime() / 110) % 2
    if QR.skyPreviewMinutes then phase = (phase + QR.skyPreviewMinutes / 1440) % 2 end
    local split = math.floor(phase) + 1 - phase
    local left, right = 1 - math.abs(1 - phase), phase < 1 and 1 or 0
    b.fog:ClearAllPoints()
    b.fog:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT")
    b.fog:SetSize(math.max(1, W * split), h)
    b.fog:SetTexCoord(left, right, 0, 1)
    b.fog:SetVertexColor(r, g, bl)
    b.fog:SetAlpha(strength)
    b.fog:Show()
    QR.Skin:SetRounded(b, b.fog)
    if split < 0.999 then
        b.fogCont:ClearAllPoints()
        b.fogCont:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", W * split, 0)
        b.fogCont:SetSize(math.max(1, W * (1 - split)), h)
        b.fogCont:SetTexCoord(right, 1 - math.abs(1 - (phase + 1) % 2), 0, 1)
        b.fogCont:SetVertexColor(r, g, bl)
        b.fogCont:SetAlpha(strength)
        b.fogCont:Show()
        QR.Skin:SetRounded(b, b.fogCont)
    else
        b.fogCont:Hide()
    end
end

function Banner:Paint()
    local W, H = self:GetWidth(), self:GetHeight()
    if not W or W < 2 or H < 2 then return end
    local Skin = QR.Skin
    local hour, minute = Banner.SkyTime()
    -- interpola los segundos entre cambios de minuto del reloj del juego
    if not self.opts.thumb and not QR.skyPreviewMinutes then
        local clockMinute = hour * 60 + minute
        if self.skyMinute ~= clockMinute then self.skyMinute, self.skyMinuteStart = clockMinute, GetTime() end
        minute = minute + math.min(59, GetTime() - self.skyMinuteStart) / 60
    end
    local t = (hour + minute / 60) % 24
    local surface = 1 - (QR.db.skin.bannerTransparency or 0) / 100

    local r, g, b = Skin:Color("header")
    self.base:SetVertexColor(r, g, b, surface)
    Skin:SetRounded(self, self.base)

    local fraction = self.fraction or 1
    PaintSet(self, self.sets[1], self.key, fraction * surface, t, W, H)
    PaintSet(self, self.sets[2], self.oldKey, (self.oldKey and (1 - fraction) or 0) * surface, t, W, H)
    PaintStars(self, t, W, H)
    PaintMoon(self, t, W, H)
    PaintFog(self, t, W, H)

    if self.title then
        -- velo detras del bloque de texto
        local tw = math.max(self.title:GetStringWidth(), self.subtitle:GetStringWidth(), self.eyebrow:GetStringWidth())
        self.veil:ClearAllPoints()
        self.veil:SetPoint("TOPLEFT", self, "TOPLEFT")
        self.veil:SetSize(math.min(W, tw + 70), math.min(H, H * 0.95))
        self.veil:SetAlpha(surface)
        self.veil:Show()
        Skin:SetRounded(self, self.veil)
        -- sombra del texto mas fuerte cuando es de dia (el cielo es mas claro)
        local daylight = DaylightOf(t)
        self.subtitle:SetShadowColor(0, 0, 0, 0.55 + 0.40 * daylight)
        self.title:SetShadowColor(0, 0, 0, 0.65 + 0.35 * daylight)
        local ar, ag, ab = Skin:Color("accent")
        local er, eg, eb = Skin:TextAccent(0.7)
        self.eyebrow:SetTextColor(er, eg, eb, 0.9)
        self.title:SetTextColor(1, 1, 1)
        self.subtitle:SetTextColor(0.88, 0.90, 0.88)
        if QR.db.skin.clock then
            self.clock:SetText(string.format("%02d:%02d", hour, math.floor(minute)))
            self.clock:SetTextColor(1, 1, 1, 0.8)
            self.clock:Show()
        else
            self.clock:Hide()
        end
    end
end

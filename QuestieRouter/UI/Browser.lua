-- QuestieRouter: menu de guias (boton "QuestieRouter" del menu del juego, /qr menu).
--
--   [secciones] | [lista de la seccion] | [detalle de lo elegido + "Cargar guia"]
--
-- Secciones: zonas, mazmorras, profesiones, eventos, speedrun, clase y otras, y abajo Opciones. A la izquierda
-- solo la palabra clave; dentro, el nombre entero. Las guias de zona y de mazmorra salen como tarjetas con la
-- ilustracion de su zona (las miniaturas del banner); al elegir una, a la derecha su lista de misiones con el
-- estado de cada una (los mismos iconos y la misma leyenda que la pestaña Misiones) y un boton para ver su zona
-- en el mapa. Las profesiones se separan en las que tienes y las que no. En Opciones, la lista es el indice de
-- secciones y a la derecha van todas las opciones (UI/Options.lua): al pulsar una seccion se salta a ella.
-- Todo con los colores de la skin de la zona.

local _, QR = ...
local L = QR.L

local Browser = {}
QR.Browser = Browser

local W, H = 1060, 640
local RAIL_W, LIST_W = 78, 318
local DETAIL_X = RAIL_W + LIST_W
local ART_H = 150
local ROW_GUIDE, ROW_PLAIN, ROW_HEADER = 60, 48, 28
local QROW_H = 21
local BAR_W = 5
local TEXT_DELTA = -2    -- todos los textos del menu: px de mas o de menos sobre los tamaños de abajo
local DESC_H = 66        -- alto fijo del texto de la zona (con barra si no cabe)

local function S() return QR.Skin end

-- Secciones de la barra de la izquierda (icono en Media/Icons/Menu)
local SECTIONS = {
    { key = "ZONES", icon = "Zones", short = "Zones", title = "Zone completion guides", desc = "Every quest in each zone, in order" },
    { key = "DUNGEONS", icon = "Dungeons", short = "Dungeons", title = "Dungeon guides", desc = "Dungeon quests and routes" },
    { key = "PROFESSIONS", icon = "Professions", short = "Professions", title = "Profession guides", desc = "Level up professions" },
    { key = "CLASS", icon = "Class", short = "Class", title = "Class guides", desc = "Class quests, spells and trainers" },
    { key = "EVENTS", icon = "Events", short = "Events", title = "Event guides", desc = "World events, as they arrive in the game" },
    -- speedrun: aun no hay guias; el boton sale desactivado y su tooltip dice "Proximamente"
    { key = "SPEEDRUN", icon = "Speedrun", short = "Speedrun", title = "Speedrun guides", desc = "Coming soon", disabled = true },
    { key = "OTHER", icon = "Other", short = "Other", title = "Other guides", desc = "Reputations, collectibles and more" },
}
local OPTIONS = { key = "OPTIONS", short = "Options", title = "Options", desc = "Everything about the look and the behaviour of QuestieRouter" }

-- Profesiones: linea de habilidad, icono del juego y nombres (para el cliente sin API de profesiones)
local PROFESSIONS = {
    { id = 171, key = "Alchemy", icon = "Interface\\Icons\\Trade_Alchemy", names = { "Alchemy", "Alquimia" } },
    { id = 164, key = "Blacksmithing", icon = "Interface\\Icons\\Trade_BlackSmithing", names = { "Blacksmithing", "Herrería", "Herreria" } },
    { id = 333, key = "Enchanting", icon = "Interface\\Icons\\Trade_Engraving", names = { "Enchanting", "Encantamiento" } },
    { id = 202, key = "Engineering", icon = "Interface\\Icons\\Trade_Engineering", names = { "Engineering", "Ingeniería", "Ingenieria" } },
    { id = 165, key = "Leatherworking", icon = "Interface\\Icons\\INV_Misc_ArmorKit_17", names = { "Leatherworking", "Peletería", "Peleteria" } },
    { id = 197, key = "Tailoring", icon = "Interface\\Icons\\Trade_Tailoring", names = { "Tailoring", "Sastrería", "Sastreria" } },
    { id = 182, key = "Herbalism", icon = "Interface\\Icons\\Spell_Nature_NatureTouchGrow", names = { "Herbalism", "Herboristería", "Herboristeria" }, gathering = true },
    { id = 186, key = "Mining", icon = "Interface\\Icons\\Trade_Mining", names = { "Mining", "Minería", "Mineria" }, gathering = true },
    { id = 393, key = "Skinning", icon = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01", names = { "Skinning", "Desuello" }, gathering = true },
    { id = 185, key = "Cooking", icon = "Interface\\Icons\\INV_Misc_Food_15", names = { "Cooking", "Cocina" }, secondary = true },
    { id = 129, key = "First Aid", icon = "Interface\\Icons\\Spell_Holy_SealOfSacrifice", names = { "First Aid", "Primeros auxilios" }, secondary = true },
    { id = 356, key = "Fishing", icon = "Interface\\Icons\\Trade_Fishing", names = { "Fishing", "Pesca" }, secondary = true },
}

-- Rangos de profesion (1-300 en el clasico)
local RANKS = {
    { 1, 75, "Apprentice", 5 }, { 75, 150, "Journeyman", 10 }, { 150, 225, "Expert", 20 }, { 225, 300, "Artisan", 35 },
}

---------------------------------------------------------------------------
-- Profesiones aprendidas: GetProfessions (cliente moderno), C_SkillInfo (Forever) o la lista de habilidades
---------------------------------------------------------------------------
local function LearnedProfessions()
    local out = {}
    if GetProfessions and GetProfessionInfo then
        for _, index in pairs({ GetProfessions() }) do
            if index then
                local ok, _, _, rank, maxRank, _, _, line = pcall(GetProfessionInfo, index)
                if ok and line then out[line] = { rank = rank, max = maxRank } end
            end
        end
    end
    local SI = C_SkillInfo
    if not next(out) and SI and SI.GetSkillLineInfoByID then
        for _, p in ipairs(PROFESSIONS) do
            local ok, a, b = pcall(SI.GetSkillLineInfoByID, p.id)
            if ok then
                local rank, maxRank
                if type(a) == "table" then
                    rank = a.skillLineRank or a.rank or a.currentLevel
                    maxRank = a.skillLineMaxRank or a.maxRank or a.maxLevel
                else
                    rank, maxRank = a, b
                end
                if type(rank) == "number" and rank > 0 then out[p.id] = { rank = rank, max = maxRank } end
            end
        end
    end
    if not next(out) and GetNumSkillLines and GetSkillLineInfo then
        local byName = {}
        for _, p in ipairs(PROFESSIONS) do
            for _, n in ipairs(p.names) do byName[n:lower()] = p.id end
            byName[L[p.key]:lower()] = p.id
        end
        for i = 1, GetNumSkillLines() do
            local name, header, _, rank, _, _, maxRank = GetSkillLineInfo(i)
            local id = not header and name and byName[name:lower()]
            if id then out[id] = { rank = rank, max = maxRank } end
        end
    end
    return out
end

---------------------------------------------------------------------------
-- Piezas
---------------------------------------------------------------------------
local function Text(parent, layer)
    local fs = parent:CreateFontString(nil, layer or "OVERLAY", "GameFontHighlight")
    fs:SetJustifyH("LEFT")
    fs:SetShadowOffset(1, -1)
    fs:SetShadowColor(0, 0, 0, 1)
    return fs
end

--- tamaño fijo (los titulos del menu no siguen al tamaño de texto de la guia)
local function Size(fs, size)
    local path, _, flags = fs:GetFont()
    if path then fs:SetFont(path, math.max(8, size + TEXT_DELTA), flags or "") end
end

--- barra de desplazamiento fina a la derecha de un ScrollFrame (carril + tirador del color de la zona)
local function ScrollBar(sc)
    local bar = CreateFrame("Frame", nil, sc:GetParent())
    bar:SetWidth(BAR_W)
    bar:SetPoint("TOPLEFT", sc, "TOPRIGHT", 4, 0)
    bar:SetPoint("BOTTOMLEFT", sc, "BOTTOMRIGHT", 4, 0)
    bar.track = bar:CreateTexture(nil, "BACKGROUND")
    bar.track:SetAllPoints()
    bar.track:SetColorTexture(1, 1, 1, 0.07)
    local thumb = CreateFrame("Button", nil, bar)
    thumb:SetWidth(BAR_W)
    thumb.tex = thumb:CreateTexture(nil, "ARTWORK")
    thumb.tex:SetAllPoints()
    thumb.tex:SetColorTexture(1, 1, 1, 1)
    local function maxScroll() return math.max(0, sc.content:GetHeight() - sc:GetHeight()) end
    function bar:Sync()
        local max, trackH = maxScroll(), bar:GetHeight()
        if max <= 0 or not trackH or trackH <= 0 then bar:Hide(); return end
        bar:Show()
        local h = math.max(24, trackH * sc:GetHeight() / sc.content:GetHeight())
        thumb:SetHeight(h)
        thumb:ClearAllPoints()
        thumb:SetPoint("TOP", bar, "TOP", 0, -(trackH - h) * (sc:GetVerticalScroll() / max))
        local r, g, b = S():Color("accent")
        thumb.tex:SetVertexColor(r, g, b, thumb.dragging and 1 or 0.8)
        S():SetRounded(bar, bar.track)
        S():SetRounded(thumb, thumb.tex)
    end
    function bar.ScrollTo(v)
        sc:SetVerticalScroll(math.max(0, math.min(maxScroll(), v)))
        bar:Sync()
    end
    thumb:SetScript("OnMouseDown", function(self)
        local _, cy = GetCursorPosition()
        local scale = bar:GetEffectiveScale()
        self.startY, self.startScroll, self.dragging = cy / scale, sc:GetVerticalScroll(), true
        self:SetScript("OnUpdate", function()
            local _, y = GetCursorPosition()
            local free = bar:GetHeight() - self:GetHeight()
            if free > 0 then bar.ScrollTo(self.startScroll + (self.startY - y / scale) / free * maxScroll()) end
        end)
    end)
    thumb:SetScript("OnMouseUp", function(self)
        self.dragging = nil
        self:SetScript("OnUpdate", nil)
        bar:Sync()
    end)
    bar:EnableMouse(true)
    bar:SetScript("OnMouseDown", function()
        local _, cy = GetCursorPosition()
        local top = bar:GetTop()
        if top then bar.ScrollTo((top - cy / bar:GetEffectiveScale()) / bar:GetHeight() * maxScroll()) end
    end)
    sc.bar = bar
    return bar
end

local function Scroll(parent, step)
    local sc = CreateFrame("ScrollFrame", nil, parent)
    sc:EnableMouseWheel(true)
    sc.content = CreateFrame("Frame", nil, sc)
    sc.content:SetSize(10, 10)
    sc:SetScrollChild(sc.content)
    ScrollBar(sc)
    sc:SetScript("OnMouseWheel", function(self, delta) self.bar.ScrollTo(self:GetVerticalScroll() - delta * step) end)
    return sc
end

--- boton con fondo de tarjeta redondeada y un brillo suave al pasar el raton (sin la textura cuadrada de WoW)
local function CardButton(parent)
    local b = CreateFrame("Button", nil, parent)
    b.bg = S():CreateCard(b)
    b.bg:SetAllPoints()
    b.bg:SetFrameLevel(b:GetFrameLevel())
    b.icon = b.bg:CreateTexture(nil, "OVERLAY")
    b.icon:Hide()
    b.text = b.bg:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    b.text:SetPoint("CENTER")
    b:SetScript("OnEnter", function(self) self.hover = true; if self.Paint then self:Paint() end end)
    b:SetScript("OnLeave", function(self) self.hover = nil; if self.Paint then self:Paint() end end)
    return b
end

--- borde de un icono: anillo del color de la zona y un filete negro por dentro (texturas en la capa del icono)
local function IconBorder(owner, icon, layer)
    icon:SetDrawLayer(layer or "ARTWORK", 2)   -- el icono encima de su borde
    local ring = owner:CreateTexture(nil, layer or "ARTWORK", nil, 0)
    ring:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2)
    ring:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
    local inner = owner:CreateTexture(nil, layer or "ARTWORK", nil, 1)
    inner:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
    inner:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
    inner:SetColorTexture(0, 0, 0, 1)
    icon.ring, icon.inner = ring, inner
    function icon:PaintBorder(shown)
        ring:SetShown(shown); inner:SetShown(shown)
        if shown then local r, g, b = S():TextAccent(); ring:SetColorTexture(r, g, b, 0.9) end
    end
    icon:PaintBorder(false)
end

---------------------------------------------------------------------------
-- Spoken (opcional): texto y audio de cada zona. Spoken publica sus paquetes de lugares en la tabla global
-- SpokenPlacesAudioPacks[<addon>] = { addon, language, zones = { [uiMapID] = { file, len, text } } }; solo se
-- leen si Spoken esta instalado (nada de Spoken va dentro de QuestieRouter).
---------------------------------------------------------------------------
local function SpokenPack()
    local packs = _G.SpokenPlacesAudioPacks
    if type(packs) ~= "table" then return nil end
    local want, first = GetLocale and GetLocale(), nil
    for _, pack in pairs(packs) do
        if type(pack) == "table" and type(pack.zones) == "table" then
            if pack.language == want then return pack end
            first = first or pack
        end
    end
    return first
end

local function SpokenZone(map)
    local pack = map and SpokenPack()
    local z = pack and pack.zones[map]
    if type(z) == "table" and type(z.text) == "string" then return z, pack end
    return nil
end

-- Mazmorras: Spoken las narra como subzona de la zona de su entrada (pack.subzones[mapa][clave]); la clave es el
-- nombre en ingles en minusculas, sin apostrofos ni "the" delante. Algunas se llaman distinto alli.
local SPOKEN_DUNGEON_KEY = { [109] = "temple of atalhakkar", [229] = "blackrock mountain", [230] = "blackrock mountain",
                             [409] = "blackrock mountain", [469] = "blackrock mountain", [2959] = "dalaran" }
local function SpokenKey(name)
    name = (name or ""):lower():gsub("%s*%-.*$", ""):gsub("'", ""):gsub("^the%s+", "")
    return name
end

--- jefes de una mazmorra con audio en Spoken: { map, key, name } (nombre en el idioma del juego)
local function SpokenBosses(instanceId)
    local SB, data = _G.SpokenBossesAddon, _G.SpokenBosses
    if not (instanceId and SB and SB.GetAudioClip and SB.PlayStory and type(data) == "table" and data.maps) then return nil end
    local list, out = data.maps[instanceId], {}
    local loc = GetLocale and GetLocale()
    for _, b in ipairs(list or {}) do
        if b.key and SB:GetAudioClip(instanceId, b.key) then
            out[#out + 1] = { map = instanceId, key = b.key, name = (loc and b[loc]) or b[1] or b.key }
        end
    end
    return #out > 0 and out or nil
end

--- ¿Suena (o espera en cabeza) el audio de este jefe?
local function BossPlaying(b)
    local SB, SP = _G.SpokenBossesAddon, _G.Spoken
    if not (SB and SB.QueuedStory and SP and SP.GetCurrent) then return false end
    local clip = SB:QueuedStory(b.map, b.key)
    return clip ~= nil and SP:GetCurrent() == clip
end

--- texto y audio de una mazmorra: entrada, mapa de su zona y clave de la subzona
local function SpokenDungeon(instanceId)
    local pack = instanceId and SpokenPack()
    if not (pack and type(pack.subzones) == "table") then return nil end
    local key = SPOKEN_DUNGEON_KEY[instanceId]
    if not key then
        for _, d in ipairs(QR.DungeonData or {}) do
            for _, i in ipairs(d[5] or {}) do
                if i[1] == instanceId then key = SpokenKey(i[2]) break end
            end
            if key then break end
        end
    end
    if not key then return nil end
    for map, list in pairs(pack.subzones) do
        local z = type(list) == "table" and list[key]
        if type(z) == "table" and type(z.text) == "string" then return z, map, key end
    end
    return nil
end

---------------------------------------------------------------------------
-- Guias de clase: recompensas (objetos y hechizos) e icono de la clase
---------------------------------------------------------------------------
local CLASS_CIRCLES = "Interface\\TargetingFrame\\UI-Classes-Circles"

--- rango de un hechizo ("Rango 3"), descripcion y precio con monedas
local function SpellRank(id)
    local f = (C_Spell and C_Spell.GetSpellSubtext) or _G.GetSpellSubtext
    if not f then return nil end
    local ok, t = pcall(f, id)
    return ok and t ~= "" and t or nil
end

local function SpellDescription(id)
    local f = (C_Spell and C_Spell.GetSpellDescription) or _G.GetSpellDescription
    if not f then return nil end
    local ok, t = pcall(f, id)
    return ok and t ~= "" and t or nil
end

local function CoinText(copper)
    if not copper or copper <= 0 then return L["Free"] end
    local f = (C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString) or _G.GetCoinTextureString or _G.GetMoneyString
    if f then
        local ok, t = pcall(f, copper)
        if ok and t and t ~= "" then return t end
    end
    -- sin funcion del juego: solo las monedas que haya (oro, plata, cobre), con sus iconos
    local g, sv, c = math.floor(copper / 10000), math.floor(copper / 100) % 100, copper % 100
    local parts = {}
    if g > 0 then parts[#parts + 1] = g .. "|TInterface\\MoneyFrame\\UI-GoldIcon:0|t" end
    if sv > 0 then parts[#parts + 1] = sv .. "|TInterface\\MoneyFrame\\UI-SilverIcon:0|t" end
    if c > 0 then parts[#parts + 1] = c .. "|TInterface\\MoneyFrame\\UI-CopperIcon:0|t" end
    return table.concat(parts, " ")
end

--- icono de la clase (circulo de la clase del juego): textura y coordenadas
local function ClassIcon(tex, cls)
    local c = CLASS_ICON_TCOORDS and CLASS_ICON_TCOORDS[cls or ""]
    tex:SetTexture(CLASS_CIRCLES)
    if c then tex:SetTexCoord(c[1], c[2], c[3], c[4]) else tex:SetTexCoord(0, 1, 0, 1) end
end

-- este cliente ya no tiene GetItemInfo global (esta en C_Item)
local GetItemInfoAny = (C_Item and C_Item.GetItemInfo) or _G.GetItemInfo
local function ItemData(id)
    local name, quality, icon
    if GetItemInfoAny then
        local ok, n, _, q, _, _, _, _, _, _, ic = pcall(GetItemInfoAny, id)
        if ok then name, quality, icon = n, q, ic end
    end
    if not icon and C_Item and C_Item.RequestLoadItemDataByID then pcall(C_Item.RequestLoadItemDataByID, id) end
    if not icon then
        icon = (C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(id)) or (GetItemIcon and GetItemIcon(id))
    end
    return name, quality, icon
end

local function SpellData(id)
    if C_Spell and C_Spell.GetSpellInfo then
        local i = C_Spell.GetSpellInfo(id)
        if i then return i.name, i.iconID end
    end
    if _G.GetSpellInfo then
        local ok, name, _, icon = pcall(_G.GetSpellInfo, id)
        if ok then return name, icon end
    end
end

--- recompensas de una guia de clase, ya en orden (habilidades, objetos, a elegir, reputacion; tools/class_guides.py):
--- { kind = "spell" | "item" | "choice" | "rep", id, quest (o puntos de reputacion) }
local function ClassRewards(g)
    if g.rewardList then return g.rewardList end
    local out = {}
    for _, r in ipairs(g.rewards or {}) do
        local kind = r[1]
        out[#out + 1] = { kind = kind == "choice" and "item" or kind, id = r[2], choice = kind == "choice",
                          quest = kind ~= "rep" and r[3] ~= 0 and r[3] or nil, amount = kind == "rep" and r[3] or nil }
    end
    g.rewardList = out
    return out
end

--- la recompensa principal: la primera que no es reputacion (una habilidad antes que un objeto); si solo da
--- reputacion, la reputacion
local function MainReward(g)
    local list = ClassRewards(g)
    for _, r in ipairs(list) do
        if r.kind ~= "rep" then return r end
    end
    return list[1]
end

local REP_ICON = "Interface\\Icons\\Spell_Holy_ChampionsBond"

--- icono de la recompensa principal de una guia de clase (sin ella, el de la clase): pone textura y coordenadas
local function MainRewardIcon(tex, g)
    local m = MainReward(g)
    local icon = m and (m.kind == "spell" and select(2, SpellData(m.id)) or m.kind == "item" and select(3, ItemData(m.id))
        or m.kind == "rep" and REP_ICON)
    if icon then
        tex:SetTexture(icon)
        tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    else
        ClassIcon(tex, g.class)
    end
end

-- nombres de las facciones con reputacion del clasico, por si el juego no da el de una que aun no conoces
local FACTION_NAMES = {
    [21] = "Booty Bay", [47] = "Ironforge", [54] = "Gnomeregan Exiles", [59] = "Thorium Brotherhood", [68] = "Undercity",
    [69] = "Darnassus", [72] = "Stormwind", [76] = "Orgrimmar", [81] = "Thunder Bluff", [87] = "Bloodsail Buccaneers",
    [92] = "Gelkis Clan Centaur", [93] = "Magram Clan Centaur", [270] = "Zandalar Tribe", [349] = "Ravenholdt",
    [369] = "Gadgetzan", [470] = "Ratchet", [509] = "The League of Arathor", [510] = "The Defilers",
    [529] = "Argent Dawn", [530] = "Darkspear Trolls", [576] = "Timbermaw Hold", [577] = "Everlook",
    [589] = "Wintersaber Trainers", [609] = "Cenarion Circle", [729] = "Frostwolf Clan", [730] = "Stormpike Guard",
    [749] = "Hydraxian Waterlords", [809] = "Shen'dralar", [889] = "Warsong Outriders", [890] = "Silverwing Sentinels",
    [909] = "Darkmoon Faire", [910] = "Brood of Nozdormu",
}

--- nombre de una faccion (reputacion)
local function FactionName(id)
    if C_Reputation and C_Reputation.GetFactionDataByID then
        local d = C_Reputation.GetFactionDataByID(id)
        if d and d.name then return d.name end
    end
    if _G.GetFactionInfoByID then
        local ok, name = pcall(_G.GetFactionInfoByID, id)
        if ok and name then return name end
    end
    return FACTION_NAMES[id]
end

---------------------------------------------------------------------------
-- Ventana
---------------------------------------------------------------------------
local function RailButton(parent, icon)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(RAIL_W, 58)
    b.sel = b:CreateTexture(nil, "BACKGROUND")
    b.sel:SetAllPoints()
    b.bar = b:CreateTexture(nil, "ARTWORK")
    b.bar:SetPoint("TOPLEFT", 0, -6); b.bar:SetPoint("BOTTOMLEFT", 0, 6); b.bar:SetWidth(3)
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetSize(24, 24)
    b.icon:SetPoint("TOP", 0, -8)
    b.icon:SetTexture(icon)
    b.label = Text(b)
    b.label:SetJustifyH("CENTER")
    b.label:SetPoint("TOP", b.icon, "BOTTOM", 0, -5)
    b.label:SetWidth(RAIL_W - 4)
    b.hl = b:CreateTexture(nil, "HIGHLIGHT")
    b.hl:SetAllPoints()
    b.hl:SetColorTexture(1, 1, 1, 0.05)
    b:SetScript("OnClick", function(self)
        if self.section.disabled then return end
        Browser:SelectSection(self.section.key)
    end)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(L[self.section.title])
        GameTooltip:AddLine(L[self.section.desc], 0.8, 0.8, 0.8, true)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return b
end

function Browser:Create()
    local f = CreateFrame("Frame", "QuestieRouterBrowser", UIParent)
    f:SetSize(W, H)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:SetToplevel(true)
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    -- se arrastra solo desde la barra de la izquierda y desde la parte de arriba (cabecera de la lista y banner)
    local function Handle(h)
        h:EnableMouse(true)
        h:RegisterForDrag("LeftButton")
        h:SetScript("OnDragStart", function() f:StartMoving() end)
        h:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)
    end
    f.Handle = Handle
    f:Hide()
    tinsert(UISpecialFrames, "QuestieRouterBrowser")   -- se cierra con Escape

    f.bg = S():CreateCard(f)
    f.bg:SetAllPoints()
    f.bg:SetFrameLevel(f:GetFrameLevel())

    -- barra de secciones
    f.rail = S():CreateCard(f)
    f.rail:SetPoint("TOPLEFT"); f.rail:SetPoint("BOTTOMLEFT"); f.rail:SetWidth(RAIL_W)
    Handle(f.rail)
    f.logo = f.rail:CreateTexture(nil, "ARTWORK")
    f.logo:SetSize(40, 40)
    f.logo:SetPoint("TOP", 0, -16)
    f.logo:SetTexture(S().MEDIA .. "Icons\\QuestieRouter-128.tga")
    f.tabs = {}
    for i, sec in ipairs(SECTIONS) do
        local b = RailButton(f.rail, S().MEDIA .. "Icons\\Menu\\" .. sec.icon .. ".tga")
        b:SetPoint("TOPLEFT", 0, -72 - (i - 1) * 58)
        b.section = sec
        f.tabs[i] = b
    end
    -- opciones, abajo del todo (una seccion mas del menu)
    local opt = RailButton(f.rail, S():UIIcon("Cog"))
    opt:SetPoint("BOTTOMLEFT", 0, 8)
    opt.section = OPTIONS
    f.tabs[#f.tabs + 1] = opt

    -- lista de la seccion
    f.list = CreateFrame("Frame", nil, f)
    f.list:SetPoint("TOPLEFT", RAIL_W, 0); f.list:SetPoint("BOTTOMLEFT", RAIL_W, 0); f.list:SetWidth(LIST_W)
    f.eyebrow = Text(f.list)
    f.eyebrow:SetPoint("TOPLEFT", 18, -18)
    f.title = Text(f.list)
    f.title:SetPoint("TOPLEFT", f.eyebrow, "BOTTOMLEFT", 0, -4)
    f.title:SetPoint("RIGHT", -14, 0)
    f.sub = Text(f.list)
    f.sub:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 0, -5)
    f.sub:SetPoint("RIGHT", -14, 0)
    f.sub:SetWordWrap(true)
    -- cabecera de la lista (titulo de la seccion): asa para mover la ventana
    local head = CreateFrame("Frame", nil, f.list)
    head:SetPoint("TOPLEFT"); head:SetPoint("TOPRIGHT"); head:SetHeight(94)
    Handle(head)
    -- pestañas de la lista (en Clase: Misiones / Habilidades); con ellas la lista baja un poco
    f.listTabs = CreateFrame("Frame", nil, f.list)
    f.listTabs:SetPoint("TOPLEFT", 12, -98)
    f.listTabs:SetSize(LIST_W - 26, 26)
    f.listTabs:Hide()
    f.listTabBtn = {}
    for i, key in ipairs({ "quests", "skills" }) do
        local t = CardButton(f.listTabs)
        t:SetHeight(26)
        t.key = key
        if i == 1 then t:SetPoint("LEFT") else t:SetPoint("LEFT", f.listTabBtn[1], "RIGHT", 6, 0) end
        t:SetScript("OnClick", function(self)
            if Browser.classTab == self.key or (Browser.classTab == nil and self.key == "quests") then return end
            Browser.classTab = self.key
            Browser:SelectSection("CLASS")
        end)
        function t:Paint()
            local Sk = S()
            Sk:StyleText(self.text, "body", "ui")
            Size(self.text, 12)
            local on = (Browser.classTab or "quests") == self.key
            self.text:SetTextColor(on and 1 or 0.78, on and 1 or 0.8, on and 1 or 0.78)
            self:SetWidth(self.text:GetStringWidth() + 28)
            Sk:PaintCard(self.bg, (on or self.hover) and "active" or "card", 1, "ui")
        end
        f.listTabBtn[i] = t
    end
    f.scroll = Scroll(f.list, ROW_GUIDE)
    f.scroll:SetPoint("TOPLEFT", 12, -100)
    f.scroll:SetPoint("BOTTOMRIGHT", -14 - BAR_W, 12)
    f.scroll.content:SetWidth(LIST_W - 26 - BAR_W)
    f.rows = {}

    -- detalle
    local d = CreateFrame("Frame", nil, f)
    d:SetPoint("TOPLEFT", DETAIL_X, 0); d:SetPoint("BOTTOMRIGHT")
    f.detail = d
    d.bg = S():CreateCard(d)
    d.bg:SetAllPoints()
    d.bg:SetFrameLevel(d:GetFrameLevel())
    d.body = CreateFrame("Frame", nil, d)   -- textos del detalle, sobre el fondo
    d.body:SetAllPoints()
    d.art = QR.Banner:Create(d, { thumb = true })
    d.art:SetPoint("TOPLEFT", 8, -8); d.art:SetPoint("TOPRIGHT", -8, -8); d.art:SetHeight(ART_H)
    local top = CreateFrame("Frame", nil, d)
    top:SetAllPoints(d.art)
    top:SetFrameLevel(d.art:GetFrameLevel() + 3)
    d.top = top
    Handle(top)   -- el banner del detalle tambien mueve la ventana (la X de cerrar sigue funcionando: es un boton encima)
    d.shade = top:CreateTexture(nil, "ARTWORK", nil, 7)
    d.shade:SetPoint("TOPLEFT"); d.shade:SetPoint("BOTTOMLEFT"); d.shade:SetWidth(460)
    d.shade:SetTexture(S().MEDIA .. "Textures\\BannerTextVeil.tga")
    d.shade2 = top:CreateTexture(nil, "ARTWORK", nil, 6)
    d.shade2:SetPoint("TOPLEFT"); d.shade2:SetPoint("BOTTOMLEFT"); d.shade2:SetWidth(360)
    d.shade2:SetTexture(S().MEDIA .. "Textures\\BannerTextVeil.tga")
    -- guias de clase: el mapa de la zona donde se hace la cadena (Media/Maps), centrado en ella; sin mapa, fondo liso
    -- con el color de la clase y su emblema a la derecha
    d.classMap = top:CreateTexture(nil, "BACKGROUND", nil, 0)
    d.classMap:SetAllPoints()
    d.classMap:Hide()
    d.classTint = top:CreateTexture(nil, "BACKGROUND", nil, 2)
    d.classTint:SetAllPoints()
    d.classTint:SetColorTexture(0, 0, 0, 0.28)
    d.classTint:Hide()
    d.classBg = top:CreateTexture(nil, "BACKGROUND", nil, 1)
    d.classBg:SetAllPoints()
    d.classBg:Hide()
    d.classMark = top:CreateTexture(nil, "BORDER")
    d.classMark:SetSize(170, 170)
    d.classMark:SetPoint("RIGHT", -24, -6)
    d.classMark:SetAlpha(0.16)
    d.classMark:Hide()
    -- pantalla de carga de la mazmorra (Media/Dungeons), por debajo del velo
    d.photo = top:CreateTexture(nil, "BACKGROUND")
    d.photo:SetAllPoints()
    d.photo:Hide()
    d.bigIcon = top:CreateTexture(nil, "OVERLAY")
    d.bigIcon:SetSize(54, 54)
    d.bigIcon:SetPoint("BOTTOMLEFT", d.art, "BOTTOMLEFT", 18, 18)
    IconBorder(top, d.bigIcon, "OVERLAY")
    d.eyebrow = Text(top)
    d.name = Text(top)
    d.name:SetPoint("BOTTOMLEFT", d.art, "BOTTOMLEFT", 18, 16)
    d.eyebrow:SetPoint("BOTTOMLEFT", d.name, "TOPLEFT", 0, 4)
    local close = CreateFrame("Button", nil, top)
    close:SetSize(18, 18)
    close:SetPoint("TOPRIGHT", d.art, "TOPRIGHT", -10, -10)
    close.icon = close:CreateTexture(nil, "OVERLAY")
    close.icon:SetAllPoints()
    close.icon:SetTexture(S():UIIcon("Close"))
    close:SetScript("OnClick", function() f:Hide() end)
    d.chips = {}
    -- boton del mapa, a la derecha de la fila de etiquetas
    local map = CardButton(d)
    map:SetSize(86, 24)
    map:SetPoint("TOPRIGHT", d.art, "BOTTOMRIGHT", -2, -11)
    map.icon:Show()
    map.icon:SetTexture("Interface\\Icons\\INV_Misc_Map_01")
    map.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    map.icon:SetSize(15, 15)
    map.icon:SetPoint("LEFT", 10, 0)
    map.text:ClearAllPoints()
    map.text:SetPoint("LEFT", map.icon, "RIGHT", 6, 0)
    map:SetScript("OnClick", function() Browser:OpenMap() end)
    function map:Paint()
        local Sk = S()
        Sk:StyleText(self.text, "body", "ui")
        Size(self.text, 12)
        self.text:SetText(L["Map"])
        self.text:SetTextColor(1, 1, 1)
        self:SetWidth(self.text:GetStringWidth() + 46)
        Sk:PaintCard(self.bg, self.hover and "active" or "card", 1, "ui")
    end
    d.map = map
    -- escuchar la zona (con Spoken): a la izquierda del boton del mapa
    local listen = CardButton(d)
    listen:SetSize(100, 24)
    listen.icon:Show()
    listen.icon:SetTexture("Interface\\AddOns\\Spoken\\icon.tga")
    listen.icon:SetSize(15, 15)
    listen.icon:SetPoint("LEFT", 10, 0)
    listen.text:ClearAllPoints()
    listen.text:SetPoint("LEFT", listen.icon, "RIGHT", 6, 0)
    listen:SetScript("OnClick", function() Browser:ToggleListen() end)
    function listen:Paint()
        local Sk = S()
        Sk:StyleText(self.text, "body", "ui")
        Size(self.text, 12)
        local on = Browser:IsListening()
        self.text:SetText(on and L["Stop"] or L["Listen"])
        self.text:SetTextColor(1, 1, 1)
        self:SetWidth(self.text:GetStringWidth() + 46)
        Sk:PaintCard(self.bg, (self.hover or on) and "active" or "card", 1, "ui")
    end
    -- lo que pase en Spoken (terminar, pausar, parar desde su ventana) se refleja en el boton
    local acc = 0
    d:HookScript("OnUpdate", function(_, el)
        acc = acc + el
        if acc < 0.5 then return end
        acc = 0
        if listen:IsShown() then
            local on = Browser:IsListening()
            if on ~= listen.wasOn then listen.wasOn = on; listen:Paint() end
        end
        if d.bossRows then Browser:PaintBossRows() end
    end)
    d.listen = listen
    -- mazmorras: pestañas encima de la lista (Misiones / Jefes y botin)
    d.tabs = CreateFrame("Frame", nil, d)
    d.tabs:SetSize(300, 26)
    d.tabs:Hide()
    d.tabBtn = {}
    for i, key in ipairs({ "quests", "loot" }) do
        local t = CardButton(d.tabs)
        t:SetHeight(26)
        t.key = key
        if i == 1 then t:SetPoint("LEFT") else t:SetPoint("LEFT", d.tabBtn[1], "RIGHT", 6, 0) end
        t:SetScript("OnClick", function(self)
            local tf = Browser.tabsFor
            if tf then Browser[tf.field] = self.key end
            Browser:PaintDetail()
        end)
        function t:Paint()
            local Sk = S()
            Sk:StyleText(self.text, "body", "ui")
            Size(self.text, 12)
            local tf = Browser.tabsFor
            local on = tf and (Browser[tf.field] or tf[1].key) == self.key
            self.text:SetTextColor(on and 1 or 0.78, on and 1 or 0.8, on and 1 or 0.78)
            self:SetWidth(self.text:GetStringWidth() + 28)
            Sk:PaintCard(self.bg, (on or self.hover) and "active" or "card", 1, "ui")
        end
        d.tabBtn[i] = t
    end
    local filter = CardButton(d.tabs)
    filter:SetHeight(26)
    filter:SetPoint("RIGHT")
    filter.icon:Show()
    filter.icon:SetTexture(S():UIIcon("Search"))
    filter.icon:SetSize(13, 13)
    filter.icon:SetPoint("LEFT", 10, 0)
    filter.text:ClearAllPoints()
    filter.text:SetPoint("LEFT", filter.icon, "RIGHT", 6, 0)
    filter:SetScript("OnClick", function() Browser:OpenLootFilter() end)
    function filter:Paint()
        local Sk = S()
        Sk:StyleText(self.text, "body", "ui")
        Size(self.text, 12)
        self.text:SetText(Browser:LootFilterText())
        self.text:SetTextColor(1, 1, 1)
        self.icon:SetVertexColor(1, 1, 1)
        self:SetWidth(self.text:GetStringWidth() + 42)
        local on = Browser.lootClass or Browser.lootType
        Sk:PaintCard(self.bg, (on or self.hover) and "active" or "card", 1, "ui")
    end
    d.filter = filter
    -- texto de la zona: alto fijo, con barra si no cabe
    d.dscroll = Scroll(d.body, 18)
    d.dscroll:SetPoint("TOPLEFT", d.art, "BOTTOMLEFT", 10, -48)
    d.dscroll:SetPoint("RIGHT", d, "RIGHT", -18 - BAR_W - 4, 0)
    d.dscroll:SetHeight(DESC_H)
    d.desc = Text(d.dscroll.content)
    d.desc:SetPoint("TOPLEFT", 0, 0)
    d.desc:SetWordWrap(true)
    d.desc:SetJustifyV("TOP")
    -- leyenda (como la de la pestaña Misiones) y la lista
    d.legend = S():CreateCard(d)
    d.legend:SetHeight(64)
    d.legend.left = Text(d.legend)
    d.legend.right = Text(d.legend)
    for _, fs in ipairs({ d.legend.left, d.legend.right }) do fs:SetJustifyV("TOP"); fs:SetSpacing(3) end
    d.legend.left:SetPoint("TOPLEFT", 12, -30)
    -- cabecera: "Leyenda" y una flecha (abierta / cerrada); clic para plegarla (se recuerda)
    local lh = CreateFrame("Button", nil, d.legend)
    lh:SetPoint("TOPLEFT"); lh:SetPoint("TOPRIGHT"); lh:SetHeight(26)
    lh.text = Text(lh)
    lh.text:SetPoint("LEFT", 12, 0)
    lh.arrow = lh:CreateTexture(nil, "OVERLAY")
    lh.arrow:SetSize(12, 12)
    lh.arrow:SetPoint("RIGHT", -12, 0)
    lh.hl = lh:CreateTexture(nil, "HIGHLIGHT")
    lh.hl:SetAllPoints()
    lh.hl:SetColorTexture(1, 1, 1, 0.04)
    lh:SetScript("OnClick", function()
        QR.db.browserLegendClosed = not QR.db.browserLegendClosed or nil
        Browser:PaintDetail()
    end)
    d.legend.head = lh
    d.qscroll = Scroll(d, QROW_H * 3)
    d.qrows = {}
    d.lines = {}
    -- barra de abajo: estado y "Cargar guia"
    d.state = Text(d.body)
    d.state:SetPoint("BOTTOMLEFT", 18, 24)
    local load = CardButton(d)
    load:SetSize(160, 36)
    load:SetPoint("BOTTOMRIGHT", -16, 14)
    load.text:SetShadowOffset(0, 0)   -- texto oscuro sobre el acento: sin sombra
    load:SetScript("OnClick", function() Browser:LoadSelected() end)
    function load:Paint()
        local Sk = S()
        Sk:StyleText(self.text, "subtitle", "ui")
        Size(self.text, 13)
        self:SetWidth(math.max(160, self.text:GetStringWidth() + 44))
        if self:IsEnabled() then
            local r, g, b = Sk:Color("accent")
            local k = self.hover and 1.15 or 1
            self.bg.bg:SetVertexColor(math.min(1, r * k), math.min(1, g * k), math.min(1, b * k), 1)
            Sk:SetRounded(self.bg, self.bg.bg)
            self.text:SetTextColor(0.06, 0.05, 0.04)
        else
            Sk:PaintCard(self.bg, "card", 1, "ui")
            self.text:SetTextColor(0.6, 0.62, 0.6)
        end
    end
    d.load = load

    -- opciones: panel con su propio fondo, en el sitio del detalle
    local o = CreateFrame("Frame", nil, f)
    o:SetPoint("TOPLEFT", DETAIL_X, 0); o:SetPoint("BOTTOMRIGHT")
    o.bg = S():CreateCard(o)
    o.bg:SetAllPoints()
    o.bg:SetFrameLevel(o:GetFrameLevel())
    o.host = CreateFrame("Frame", nil, o)
    o.host:SetAllPoints()
    o:Hide()
    f.options = o

    self.frame = f
    QR:On("GUIDE_CHANGED", function() if f:IsShown() then Browser:Refresh() end end)
    QR:On("SKIN_CHANGED", function() if f:IsShown() then Browser:Refresh() end end)
end

---------------------------------------------------------------------------
-- Entradas de cada seccion
---------------------------------------------------------------------------
local function GuideLevelColor(g)
    local level = UnitLevel("player")
    return (level < g.minLevel and "|cffff8178") or (level > g.maxLevel and "|cff9a9f9c") or "|cff71d6a2"
end

--- estado de una guia para el icono de su tarjeta: "done" (hecha), "active" (empezada), "lowlevel" (aun no tienes
--- el nivel de su primera mision) o nil (sin empezar y a tu nivel). Comun con el menu rapido: Guide/ZoneGuides.lua
local function GuideState(g)
    return QR.GuideState(g)
end

local function GuideEntries(list, isDungeon)
    local out = {}
    local active, suggested = QR.Planner:GetGuide(), (not isDungeon) and QR:SuggestZoneGuide()
    for _, g in ipairs(list) do
        out[#out + 1] = { kind = "guide", guide = g, active = g == active, suggested = g == suggested,
                          new = isDungeon and (g.instanceId or 0) >= 2000 }
    end
    return out
end

--- habilidades del entrenador de tu clase (What's Training?): primero las que ya puedes aprender, luego las de
--- los proximos niveles y al final las que ya sabes. Fuera las de otra raza o faccion y las de talentos que no tienes.
local function KnowsSpellId(id)
    local f = _G.IsPlayerSpell or _G.IsSpellKnown
    if not f then return false end
    local ok, known = pcall(f, id)
    return ok and known or false
end

function Browser:SkillEntries()
    local level, faction = UnitLevel("player"), UnitFactionGroup("player")
    local race = select(3, UnitRace("player"))
    local now, later, known = {}, {}, {}
    local seen = {}
    for _, s in ipairs(QR.ClassSkills or {}) do seen[s[2]] = true end
    -- hechizos que se consiguen con misiones (demonios, posturas, formas...): la variante de tu raza
    for _, q in ipairs(QR.ClassQuestSkills or {}) do
        if not seen[q[1]] then
            local pick
            for _, v in ipairs(q[2] or {}) do
                local mine = #v.races == 0
                for _, r in ipairs(v.races) do if r == race then mine = true end end
                if mine then pick = v break end
            end
            if pick then
                seen[q[1]] = true
                local e = { kind = "skill", skill = q, level = pick.level, id = q[1], cost = 0, quests = pick.quests }
                if KnowsSpellId(q[1]) then e.status = "done"; known[#known + 1] = e
                elseif pick.level <= level then e.status = "available"; now[#now + 1] = e
                else e.status = "lowlevel"; later[#later + 1] = e end
            end
        end
    end
    for _, s in ipairs(QR.ClassSkills or {}) do
        local ok = (not s.race or s.race == race) and (not s.faction or s.faction == faction)
            and (not s.talent or KnowsSpellId(s.talent))
        if ok then
            local e = { kind = "skill", skill = s, level = s[1], id = s[2], cost = s[3] }
            if KnowsSpellId(s[2]) then e.status = "done"; known[#known + 1] = e
            elseif s[1] <= level then e.status = "available"; now[#now + 1] = e
            else e.status = "lowlevel"; later[#later + 1] = e end
        end
    end
    table.sort(later, function(a, b) if a.level ~= b.level then return a.level < b.level end return a.id < b.id end)
    local out = {}
    if #now > 0 then
        out[#out + 1] = { kind = "header", text = string.format(L["AVAILABLE NOW (%d)"], #now) }
        for _, e in ipairs(now) do out[#out + 1] = e end
    end
    local last
    for _, e in ipairs(later) do
        if e.level ~= last then
            last = e.level
            out[#out + 1] = { kind = "header", text = string.format(L["LEVEL %d"], e.level) }
        end
        out[#out + 1] = e
    end
    if #known > 0 then
        out[#out + 1] = { kind = "header", text = string.format(L["ALREADY LEARNED (%d)"], #known) }
        for _, e in ipairs(known) do out[#out + 1] = e end
    end
    return out
end

function Browser:Entries(key)
    if key == "ZONES" then return GuideEntries(QR.zoneGuides) end
    if key == "DUNGEONS" then return GuideEntries(QR.dungeonGuides, true) end
    if key == "OTHER" and #QR.otherGuides > 0 then return GuideEntries(QR.otherGuides) end
    if key == "CLASS" and self.classTab == "skills" and QR.ClassSkills then return self:SkillEntries() end
    if key == "CLASS" and #QR.classGuides > 0 then
        -- dos guias con el mismo nombre: se les añade la zona donde se hacen (y si aun coinciden, los niveles)
        local count = {}
        for _, g in ipairs(QR.classGuides) do g.labelSuffix = nil end
        for _, g in ipairs(QR.classGuides) do local n = QR.GuideLabel(g); count[n] = (count[n] or 0) + 1 end
        for _, g in ipairs(QR.classGuides) do
            if count[QR.GuideLabel(g)] > 1 then
                local map = QR.Bridge and QR.Bridge.UiMapOf and QR.Bridge:UiMapOf(g.areaId)
                local info = map and C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
                g.labelSuffix = " (" .. ((info and info.name) or g.zone or string.format("%d-%d", g.minLevel, g.maxLevel)) .. ")"
            end
        end
        return GuideEntries(QR.classGuides)
    end
    if key == "PROFESSIONS" then
        local learned = LearnedProfessions()
        local mine, others = {}, {}
        for _, p in ipairs(PROFESSIONS) do
            local e = { kind = "profession", prof = p, learned = learned[p.id] }
            table.insert(e.learned and mine or others, e)
        end
        local out = {}
        if #mine > 0 then
            out[#out + 1] = { kind = "header", text = L["YOUR PROFESSIONS"] }
            for _, e in ipairs(mine) do out[#out + 1] = e end
        end
        out[#out + 1] = { kind = "header", text = #mine > 0 and L["OTHER PROFESSIONS"] or L["PROFESSIONS"] }
        for _, e in ipairs(others) do out[#out + 1] = e end
        return out
    end
    if key == "EVENTS" then
        local out = {}
        local active = QR.Planner:GetGuide()
        self.collapsed = self.collapsed or {}
        for _, ev in ipairs(QR.Events and QR.Events.list or {}) do
            if ev.active and ev.sections then
                local open = not self.collapsed[ev.key]
                local hasActive = false
                for _, g in ipairs(ev.sections) do if g == active then hasActive = true end end
                out[#out + 1] = { kind = "event", ev = ev, open = open, status = ev.Status and ev.Status(),
                                  hasActive = hasActive }
                if open then
                    for _, g in ipairs(ev.sections) do
                        out[#out + 1] = { kind = "evguide", guide = g, active = g == active, event = true }
                    end
                end
            end
        end
        out[#out + 1] = { kind = "header", text = L["COMING SOON"] }
        for _, ev in ipairs(QR.Events and QR.Events.list or {}) do
            if not ev.active then out[#out + 1] = { kind = "soon", text = L[ev.name], soonEvent = true, eventIcon = ev.icon } end
        end
        return out
    end
    if key == "OPTIONS" then
        local out = {}
        for i, sec in ipairs(QR.Options:Sections()) do
            -- las cabeceras de Opciones van en mayusculas: en el indice, solo la primera letra
            local t = sec.text or ""
            out[#out + 1] = { kind = "optsec", index = i, text = t:sub(1, 1) .. t:sub(2):lower() }
        end
        return out
    end
    return { { kind = "soon", text = L["Coming soon"] } }
end

---------------------------------------------------------------------------
-- Filas de la lista
---------------------------------------------------------------------------
local VEIL = "Textures\\BannerTextVeil.tga"

function Browser:GetRow(i)
    local f = self.frame
    local row = f.rows[i]
    if row then return row end
    row = CreateFrame("Button", nil, f.scroll.content)
    row.bg = S():CreateCard(row)
    row.bg:SetAllPoints()
    row.bg:SetFrameLevel(row:GetFrameLevel())
    row.banner = QR.Banner:Create(row, { thumb = true })
    row.banner:SetAllPoints()
    row.banner:SetFrameLevel(row:GetFrameLevel() + 1)
    -- capa de encima: velo, iconos y textos (un marco hijo se dibuja sobre las texturas de su padre)
    local o = CreateFrame("Frame", nil, row)
    o:SetAllPoints()
    o:SetFrameLevel(row:GetFrameLevel() + 3)
    row.over = o
    row.shade = o:CreateTexture(nil, "ARTWORK", nil, 7)
    row.shade:SetPoint("TOPLEFT"); row.shade:SetPoint("BOTTOMLEFT"); row.shade:SetWidth(250)
    row.shade:SetTexture(S().MEDIA .. VEIL)
    row.shade2 = o:CreateTexture(nil, "ARTWORK", nil, 6)
    row.shade2:SetPoint("TOPLEFT"); row.shade2:SetPoint("BOTTOMLEFT"); row.shade2:SetWidth(210)
    row.shade2:SetTexture(S().MEDIA .. VEIL)
    row.photo = o:CreateTexture(nil, "BACKGROUND")   -- pantalla de carga de la mazmorra
    row.photo:SetAllPoints()
    row.photo:Hide()
    -- estado de la guia a la derecha de la tarjeta (guias de clase): hecha, en curso o te falta nivel
    row.state = Text(o)
    row.state:SetPoint("RIGHT", -18, 0)
    row.arrow = o:CreateTexture(nil, "OVERLAY")
    row.arrow:SetSize(14, 14)
    row.arrow:SetPoint("BOTTOMRIGHT", -10, 9)
    row.arrow:Hide()
    row.icon = o:CreateTexture(nil, "OVERLAY")
    row.icon:SetSize(30, 30)
    row.icon:SetPoint("LEFT", 12, 0)
    IconBorder(o, row.icon, "OVERLAY")
    row.name = Text(o)
    row.info = Text(o)
    local pill = S():CreateCard(o)
    pill:SetHeight(18)
    pill:SetPoint("TOPRIGHT", -8, -7)
    pill:SetFrameLevel(o:GetFrameLevel() + 1)
    pill.bg:SetVertexColor(0, 0, 0, 0.62)
    pill.tick = pill:CreateTexture(nil, "OVERLAY")
    pill.tick:SetSize(11, 11)
    pill.tick:SetPoint("LEFT", 7, 0)
    pill.tick:SetTexture(S():UIIcon("Check"))
    pill.tick:SetVertexColor(0.42, 0.92, 0.52)
    row.pill = pill
    row.badge = Text(pill)
    row.badge:SetJustifyH("LEFT")
    --- texto, color (r, g, b) y tick verde opcional; sin texto, la pastilla se oculta
    function row:SetBadge(text, r, g, b, tick)
        if not text or text == "" then pill:Hide(); return end
        self.badge:SetText(text)
        self.badge:SetTextColor(r or 1, g or 1, b or 1)
        pill.tick:SetShown(tick and true or false)
        self.badge:ClearAllPoints()
        self.badge:SetPoint("LEFT", tick and 21 or 8, 0)
        pill:SetWidth(self.badge:GetStringWidth() + (tick and 29 or 16))
        pill.bg:SetVertexColor(0, 0, 0, 0.62)
        S():SetRounded(pill, pill.bg)
        pill:Show()
    end
    -- marca de seleccion: franja del color de la zona, recortada por las esquinas redondeadas de la tarjeta
    row.sel = o:CreateTexture(nil, "OVERLAY", nil, 7)
    row.sel:SetPoint("TOPLEFT"); row.sel:SetPoint("BOTTOMLEFT"); row.sel:SetWidth(4)
    row.hl = o:CreateTexture(nil, "OVERLAY", nil, 5)
    row.hl:SetAllPoints()
    row.hl:SetColorTexture(1, 1, 1, 0.07)
    row.hl:Hide()
    row:SetScript("OnEnter", function(self) if self.entry and self.entry.kind ~= "header" then self.hl:Show() end end)
    row:SetScript("OnLeave", function(self) self.hl:Hide() end)
    row:SetScript("OnClick", function(self)
        if self.entry and self.entry.kind ~= "header" then Browser:Select(self.entry) end
    end)
    f.rows[i] = row
    return row
end

local function SameEntry(a, b)
    if not a or not b then return false end
    if a.ev or b.ev then return a.ev == b.ev end
    if a.skill or b.skill then return a.skill == b.skill end
    if a.guide or b.guide then return a.guide == b.guide end
    if a.prof or b.prof then return a.prof == b.prof end
    if a.index or b.index then return a.index == b.index end
    return a.text == b.text and a.kind == b.kind
end

function Browser:PaintRow(row, e, width)
    local Sk = S()
    local selected = SameEntry(e, self.selected)
    row.entry = e
    row:SetWidth(width)
    row.banner:Hide(); row.shade:Hide(); row.shade2:Hide(); row.icon:Hide(); row.bg:Show(); row.sel:Hide(); row.photo:Hide()
    row.arrow:Hide()
    row.state:SetText("")
    row.name:SetAlpha(1)
    row.icon:SetSize(30, 30)
    row.icon:SetDesaturated(false)
    row.name:SetWordWrap(true)
    S():SetRounded(row.over, row.hl)   -- el resaltado al pasar el raton, con las esquinas de la tarjeta
    row.icon:PaintBorder(false)
    row:SetBadge(nil)
    row.pill:ClearAllPoints()
    row.pill:SetPoint("TOPRIGHT", -8, -7)
    row.name:ClearAllPoints(); row.info:ClearAllPoints()
    Sk:StyleText(row.name, "subtitle", "ui"); Sk:StyleText(row.info, "small", "ui"); Sk:StyleText(row.badge, "eyebrow", "ui")
    Size(row.badge, 9.5)
    row.info:SetText("")
    if e.kind == "header" then
        row:SetHeight(ROW_HEADER)
        row.bg:Hide()
        row.name:SetPoint("BOTTOMLEFT", 4, 6)
        Sk:StyleText(row.name, "eyebrow", "ui")
        Size(row.name, 10)
        row.name:SetText(e.text)
        row.name:SetTextColor(Sk:TextAccent())
        row:EnableMouse(false)
        return ROW_HEADER
    end
    row:EnableMouse(true)
    local h
    if e.kind == "event" then
        -- tarjeta del evento: su ilustracion una sola vez, estado y numero de guias; clic = plegar / desplegar
        local ev = e.ev
        h = ROW_GUIDE + 6
        row:SetHeight(h - 4)
        row.bg:Hide()
        row.banner:Show(); row.shade:Show(); row.shade2:Show()
        row.banner:SetZone(Sk:KeyForGuide(ev.sections[1]) or Sk.key, nil, 1)
        Sk:SetRounded(row.over, row.shade)
        Sk:SetRounded(row.over, row.shade2)
        local tx = 14
        if ev.icon then
            row.icon:Show()
            row.icon:SetSize(34, 34)
            row.icon:SetTexture(ev.icon)
            row.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
            row.icon:PaintBorder(true)
            tx = 14 + 34 + 10
        end
        if ev.icon then
            row.name:SetPoint("TOPLEFT", row.icon, "TOPRIGHT", 12, -2)
            row.info:SetPoint("BOTTOMLEFT", row.icon, "BOTTOMRIGHT", 12, 3)
        else
            row.name:SetPoint("TOPLEFT", tx, -10)
            row.info:SetPoint("BOTTOMLEFT", tx, 9)
        end
        Size(row.name, 15.5)
        Size(row.info, 11.5)
        row.name:SetText(L[ev.name])
        row.name:SetTextColor(1, 1, 1)
        local st = e.status
        local stText = st and (st.up and ("|cff71d6a2" .. st.short .. "|r") or ("|cff9a9f9c" .. st.short .. "|r"))
        row.info:SetText((stText and (stText .. "  ·  ") or "") .. string.format(L["%d guides"], #ev.sections))
        if st and st.up then row:SetBadge(L["ACTIVE"], 0.62, 0.96, 0.68, true) end
        row.arrow:SetTexture(Sk:UIIcon(e.open and "ArrowDown" or "ArrowRight"))
        row.arrow:SetVertexColor(1, 1, 1, 0.9)
        row.arrow:Show()
        return h
    elseif e.kind == "evguide" then
        -- guia de un evento: fila compacta sin imagen, sangrada bajo su evento
        h = 44
        row:SetHeight(h - 4)
        local g = e.guide
        Sk:PaintCard(row.bg, selected and "active" or "card", 0.95, "ui")
        row.name:SetPoint("TOPLEFT", 14, -6)
        row.info:SetPoint("BOTTOMLEFT", 14, 6)
        Size(row.name, 13)
        Size(row.info, 11)
        row.name:SetText(QR.L[g.titleKey])
        row.name:SetTextColor(1, 1, 1)
        row.info:SetText(string.format(L["%sLevels %d-%d|r  ·  %d quests"], GuideLevelColor(g), g.minLevel, g.maxLevel, #g.quests))
        if e.active then row:SetBadge(L["ACTIVE"], 0.62, 0.96, 0.68, true) end
        row.pill:ClearAllPoints()
        row.pill:SetPoint("RIGHT", -8, 0)
    elseif e.kind == "skill" then
        -- habilidad: icono, nombre y rango; abajo nivel y coste; a la derecha su estado
        h = ROW_PLAIN + 4
        row:SetHeight(h - 4)
        Sk:PaintCard(row.bg, selected and "active" or "card", 0.95, "ui")
        local name, icon = SpellData(e.id)
        row.icon:Show()
        row.icon:SetSize(30, 30)
        row.icon:SetTexture(icon or 134400)
        row.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        row.icon:SetDesaturated(e.status == "lowlevel")
        row.icon:PaintBorder(true)
        row.name:SetPoint("TOPLEFT", row.icon, "TOPRIGHT", 12, -1)
        row.name:SetPoint("RIGHT", -44, 0)
        row.name:SetWordWrap(false)
        row.info:SetPoint("BOTTOMLEFT", row.icon, "BOTTOMRIGHT", 12, 2)
        Size(row.name, 13)
        Size(row.info, 11)
        local rank = SpellRank(e.id)
        row.name:SetText((name or ("#" .. e.id)) .. (rank and ("  |cff9a9f9c" .. rank .. "|r") or ""))
        row.name:SetTextColor(1, 1, 1)
        row.name:SetAlpha(e.status == "done" and 0.6 or 1)
        local lc = e.status == "lowlevel" and "|cffff8178" or (e.status == "done" and "|cff7f8a84" or "|cff71d6a2")
        row.info:SetText(string.format("%s" .. L["Level %d"] .. "|r  ·  %s", lc, e.level,
            e.quests and ("|cffffd166" .. L["Class quest"] .. "|r") or CoinText(e.cost)))
        row.state:SetText(Sk:IconTag(QR.GuideUI.STATUS[e.status][1], 18))
        row.state:ClearAllPoints()
        row.state:SetPoint("RIGHT", -16, 0)
    elseif e.kind == "guide" and e.guide.class then
        -- guia de clase: sin la zona de fondo; icono de su recompensa principal a la izquierda del titulo
        local g = e.guide
        h = ROW_GUIDE
        row:SetHeight(h - 4)
        Sk:PaintCard(row.bg, selected and "active" or "card", 0.95, "ui")
        row.icon:Show()
        row.icon:SetSize(34, 34)
        MainRewardIcon(row.icon, g)
        row.icon:PaintBorder(true)
        row.name:SetPoint("TOPLEFT", row.icon, "TOPRIGHT", 12, -2)
        row.name:SetPoint("RIGHT", -70, 0)
        row.name:SetWordWrap(false)
        row.info:SetPoint("BOTTOMLEFT", row.icon, "BOTTOMRIGHT", 12, 3)
        Size(row.name, 14)
        Size(row.info, 11.5)
        row.name:SetText(QR.GuideLabel(g))
        row.name:SetTextColor(1, 1, 1)
        row.info:SetText(string.format(L["%sLevels %d-%d|r  ·  %d quests"], GuideLevelColor(g), g.minLevel, g.maxLevel, #g.quests))
        if e.active then row:SetBadge(L["ACTIVE"], 0.62, 0.96, 0.68, true) end
        local st = GuideState(g)
        if st then
            row.state:SetText(Sk:IconTag(QR.GuideUI.STATUS[st][1], 20))
            row.state:ClearAllPoints()
            row.state:SetPoint("RIGHT", -18, e.active and -9 or 0)   -- con la pastilla ACTIVA arriba, algo mas abajo
        end
    elseif e.kind == "guide" then
        local g = e.guide
        h = ROW_GUIDE
        row:SetHeight(h - 4)
        row.bg:Hide()
        row.banner:Show(); row.shade:Show(); row.shade2:Show()
        row.banner:SetZone(Sk:KeyForGuide(g) or Sk.key, nil, 1)
        if self:SetDungeonPhoto(row.photo, g, width, h - 4) then
            row.banner:Hide()
            Sk:SetRounded(row.over, row.photo)
        end
        Sk:SetRounded(row.over, row.shade)
        Sk:SetRounded(row.over, row.shade2)
        row.name:SetPoint("TOPLEFT", 14, -9)
        row.info:SetPoint("BOTTOMLEFT", 14, 8)
        Size(row.name, 15)
        Size(row.info, 11.5)
        row.name:SetText(e.event and QR.L[g.titleKey] or QR.GuideLabel(g))
        row.name:SetTextColor(1, 1, 1)
        local icon = e.guide.instanceId and (Sk:IconTag("dungeon", 18) .. " ") or ""
        row.info:SetText(string.format(L["%sLevels %d-%d|r  ·  %d quests"], icon .. GuideLevelColor(g), g.minLevel, g.maxLevel, #g.quests))
        if e.active then row:SetBadge(L["ACTIVE"], 0.62, 0.96, 0.68, true)
        elseif e.new then row:SetBadge(L["NEW"], 1, 0.82, 0.4)
        elseif e.suggested then row:SetBadge(L["RECOMMENDED"], 1, 0.82, 0.4) end
    else
        h = (e.kind == "optsec") and 38 or (e.kind == "profession") and ROW_GUIDE or ROW_PLAIN
        row:SetHeight(h - 4)
        Sk:PaintCard(row.bg, selected and "active" or "card", 0.95, "ui")
        if e.kind == "profession" then
            local p = e.prof
            row.icon:Show()
            row.icon:SetTexture(p.icon)
            row.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
            row.icon:PaintBorder(true)
            row.icon:SetSize(34, 34)
            row.name:SetPoint("TOPLEFT", row.icon, "TOPRIGHT", 12, -2)
            row.info:SetPoint("BOTTOMLEFT", row.icon, "BOTTOMRIGHT", 12, 3)
            Size(row.name, 13.5)
            Size(row.info, 11)
            row.name:SetText(L[p.key])
            row.name:SetTextColor(1, 1, 1)
            if e.learned then
                row.info:SetText(string.format("|cff71d6a2" .. L["Skill %d/%d"] .. "|r", e.learned.rank or 0, e.learned.max or 0))
            else
                row.info:SetText("|cff9a9f9c" .. (p.secondary and L["Secondary profession"] or L["Primary profession"]) .. "|r")
            end
            if not QR.professionGuides[p.id] then row:SetBadge(L["SOON"], 0.7, 0.72, 0.7) end
        elseif e.kind == "optsec" then
            row.name:SetPoint("LEFT", 14, 0)
            Size(row.name, 12.5)
            row.name:SetText(e.text)
            row.name:SetTextColor(selected and 1 or 0.86, selected and 1 or 0.88, selected and 1 or 0.86)
        else
            if e.eventIcon then
                row.icon:Show()
                row.icon:SetSize(26, 26)
                row.icon:SetTexture(e.eventIcon)
                row.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
                row.icon:SetDesaturated(true)   -- aun no esta en el juego
                row.icon:PaintBorder(true)
                row.name:SetPoint("LEFT", row.icon, "RIGHT", 12, 0)
            else
                row.name:SetPoint("LEFT", 14, 0)
            end
            Size(row.name, 13)
            row.name:SetText("|cff9a9f9c" .. e.text .. "|r")
        end
    end
    if selected then
        row.sel:Show()
        row.sel:SetColorTexture(Sk:TextAccent())
        Sk:SetRounded(row.over, row.sel)
    end
    return h
end

---------------------------------------------------------------------------
-- Detalle
---------------------------------------------------------------------------
local function Chip(d, i)
    local c = d.chips[i]
    if c then return c end
    c = S():CreateCard(d)
    c:SetHeight(24)
    c.text = Text(c)
    c.text:SetPoint("CENTER")
    d.chips[i] = c
    return c
end

--- etiquetas en fila; si no caben antes de los botones (Escuchar, Mapa), siguen en otra fila debajo
local function SetChips(d, list, reserve)
    local Sk = S()
    local x, y = 10, 0
    local limit = (W - DETAIL_X - 16) - 10 - (reserve or 0)
    d.chipRows = 1
    for i, t in ipairs(list) do
        local c = Chip(d, i)
        Sk:StyleText(c.text, "small", "ui")
        Size(c.text, 11.5)
        c.text:SetText(t)
        c:SetWidth(c.text:GetStringWidth() + 22)
        Sk:PaintCard(c, "card", 1, "ui")
        if x > 10 and x + c:GetWidth() > limit then
            x, y = 10, y + 30
            d.chipRows = d.chipRows + 1
            limit = (W - DETAIL_X - 16) - 10   -- la segunda fila ya no tiene botones al lado
        end
        c:ClearAllPoints()
        c:SetPoint("TOPLEFT", d.art, "BOTTOMLEFT", x, -11 - y)
        c:Show()
        x = x + c:GetWidth() + 6
    end
    for i = #list + 1, #d.chips do d.chips[i]:Hide() end
end

--- tooltip al lado de la ventana (como en las bolsas): a la derecha del menu de guias, a la altura de la fila; si no
--- cabe en la pantalla, a la izquierda. Asi no tapa la fila ni lo que hay alrededor del raton.
local function TipBeside(row)
    local win = Browser.frame
    GameTooltip:SetOwner(row, "ANCHOR_NONE")
    GameTooltip:ClearAllPoints()
    local right = win and win:GetRight() or row:GetRight() or 0
    if right + 340 < (UIParent:GetRight() or 0) then
        GameTooltip:SetPoint("TOPLEFT", row, "TOPLEFT", (right - (row:GetLeft() or 0)) + 10, 0)
    else
        local left = win and win:GetLeft() or row:GetLeft() or 0
        GameTooltip:SetPoint("TOPRIGHT", row, "TOPLEFT", (left - (row:GetLeft() or 0)) - 10, 0)
    end
end

local function QuestRow(d, i)
    local r = d.qrows[i]
    if r then return r end
    r = CreateFrame("Frame", nil, d.qscroll.content)
    r.bg = r:CreateTexture(nil, "BACKGROUND")
    r.bg:SetAllPoints()
    r.text = Text(r)
    r.text:SetPoint("LEFT", 10, 0)
    r.text:SetPoint("RIGHT", -90, 0)
    r.text:SetWordWrap(false)
    r.right = Text(r)
    r.right:SetPoint("RIGHT", -10, 0)
    r.right:SetJustifyH("RIGHT")
    r.hl = r:CreateTexture(nil, "HIGHLIGHT")
    r.hl:SetAllPoints()
    r.hl:SetColorTexture(1, 1, 1, 0.06)
    r:EnableMouse(true)
    r:SetScript("OnEnter", function(self)
        if self.reward and self.reward.kind ~= "rep" then
            TipBeside(self)
            if self.reward.kind == "spell" then GameTooltip:SetSpellByID(self.reward.id)
            else GameTooltip:SetItemByID(self.reward.id) end
            GameTooltip:Show()
            return
        end
        if not self.tip then return end
        TipBeside(self)
        GameTooltip:AddLine(self.tip[1])
        GameTooltip:AddLine(self.tip[2], 1, 1, 1, true)
        GameTooltip:Show()
    end)
    r:SetScript("OnLeave", function() GameTooltip:Hide() end)
    -- clic derecho en una mision sin hacer: la cadena que falta y la ruta hasta quien la da (UI:QuestRowMenu)
    r:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" and self.toggleKey then
            -- paso de la guia de profesion: desplegar / plegar su detalle
            Browser.stepOpen = Browser.stepOpen or {}
            Browser.stepOpen[self.toggleKey] = not Browser.stepOpen[self.toggleKey] or nil
            Browser:PaintDetail()
            return
        end
        if button == "LeftButton" and self.recipeSpell then
            -- receta: desplegar / plegar sus materiales
            Browser.recipeOpen = Browser.recipeOpen or {}
            Browser.recipeOpen[self.recipeSpell] = not Browser.recipeOpen[self.recipeSpell] or nil
            Browser:PaintDetail()
            return
        end
        if button == "LeftButton" and self.lootBoss then
            -- a la derecha (Escuchar / Detener): el audio; en el resto de la fila: desplegar su botin
            local scale = self:GetEffectiveScale()
            local x = GetCursorPosition() / scale - (self:GetLeft() or 0)
            if self.boss and x > self:GetWidth() - 100 then Browser:ToggleBoss(self.boss) return end
            Browser.lootOpen = Browser.lootOpen or {}
            Browser.lootOpen[self.lootBoss] = not Browser.lootOpen[self.lootBoss] or nil
            Browser:PaintDetail()
            return
        end
        if button == "LeftButton" and self.boss then Browser:ToggleBoss(self.boss) return end
        if button == "LeftButton" and self.questId and self.mapButton then
            local scale = self:GetEffectiveScale()
            local x = GetCursorPosition() / scale - (self:GetLeft() or 0)
            if x > self:GetWidth() - 70 then GameTooltip:Hide(); Browser:ShowQuestOnMap(self.questId) return end
        end
        if button == "RightButton" and self.questId and self.status ~= "done" and QR.GuideUI.QuestRowMenu then
            GameTooltip:Hide()
            QR.GuideUI:QuestRowMenu(self.questId)
        end
    end)
    -- la rueda pasa a la lista (si no, la fila se la queda)
    r:EnableMouseWheel(true)
    r:SetScript("OnMouseWheel", function(_, delta) d.qscroll.bar.ScrollTo(d.qscroll:GetVerticalScroll() - delta * QROW_H * 3) end)
    d.qrows[i] = r
    return r
end

local function Line(d, i)
    local l = d.lines[i]
    if l then return l end
    l = Text(d.qscroll.content)
    l:SetWordWrap(true)
    d.lines[i] = l
    return l
end

--- lista de abajo: filas de misiones (rows) o lineas de texto (lines)
function Browser:FillList(rows, lines, legend, bosses, rewards)
    local Sk, d = S(), self.frame.detail
    local width = W - DETAIL_X - 40 - BAR_W
    -- texto de la zona: caja de alto fijo con su barra (los de Spoken pueden ser largos)
    local dw = width
    d.desc:SetWidth(dw)
    local hasDesc = (d.desc:GetText() or "") ~= ""
    d.dscroll:SetShown(hasDesc)
    local textH = d.desc:GetStringHeight() or 0
    d.dscroll:SetHeight(math.min(DESC_H, math.max(18, textH + 2)))
    d.dscroll.content:SetSize(dw, math.max(10, textH + 2))
    d.dscroll:SetVerticalScroll(0)
    C_Timer.After(0, function() d.dscroll.bar:Sync() end)
    -- la leyenda justo debajo del texto (el texto empieza a 48 px del banner, bajo la fila de etiquetas)
    local extra = ((d.chipRows or 1) - 1) * 30   -- filas de etiquetas de mas
    d.dscroll:ClearAllPoints()
    d.dscroll:SetPoint("TOPLEFT", d.art, "BOTTOMLEFT", 10, -48 - extra)
    d.dscroll:SetPoint("RIGHT", d, "RIGHT", -18 - BAR_W - 4, 0)
    local top = 48 + extra + (hasDesc and (d.dscroll:GetHeight() + 8) or 0)
    d.legend:ClearAllPoints()
    d.legend:SetPoint("TOPLEFT", d.art, "BOTTOMLEFT", 10, -top)
    d.legend:SetWidth(width + BAR_W + 4)
    -- pestañas de la mazmorra (Misiones / Jefes y botin) entre el texto y la leyenda
    if self.tabsFor then
        d.tabs:ClearAllPoints()
        d.tabs:SetPoint("TOPLEFT", d.art, "BOTTOMLEFT", 10, -top)
        d.tabs:SetPoint("RIGHT", d, "RIGHT", -18 - BAR_W - 4, 0)
        local tf = self.tabsFor
        local cur = self[tf.field] or tf[1].key
        d.filter:SetShown(tf.filter ~= nil and cur == tf.filter)
        if d.filter:IsShown() then d.filter:Paint() end
        for i = 1, 2 do
            d.tabBtn[i].key = tf[i].key
            d.tabBtn[i].text:SetText(tf[i].text)
            d.tabBtn[i]:Paint()
        end
        d.tabs:Show()
        top = top + 34
        d.legend:ClearAllPoints()
        d.legend:SetPoint("TOPLEFT", d.art, "BOTTOMLEFT", 10, -top)
    else
        d.tabs:Hide()
    end
    local listTop = top
    if legend then
        local STATUS, LEGEND = QR.GuideUI.STATUS, QR.GuideUI.LEGEND
        local left, right, n = {}, {}, 0
        for _, e in ipairs(LEGEND) do
            local st = STATUS[e[1]]
            local line = string.format("%s %s%s|r", Sk:IconTag(st[1], 15, 11), st[2], L[e[2]])
            if e.right then right[#right + 1] = line else
                n = n + 1
                if n % 2 == 1 then left[#left + 1] = line else right[#right + 1] = line end
            end
        end
        for _, fs in ipairs({ d.legend.left, d.legend.right }) do
            Sk:StyleText(fs, "small", "ui")
            Size(fs, 11)
            fs:SetWidth(width / 2 - 16)
        end
        d.legend.right:SetPoint("TOPLEFT", width / 2, -30)
        d.legend.left:SetText(table.concat(left, "\n"))
        d.legend.right:SetText(table.concat(right, "\n"))
        local closed = QR.db.browserLegendClosed
        local head = d.legend.head
        Sk:StyleText(head.text, "eyebrow", "ui")
        Size(head.text, 10.5)
        head.text:SetText(L["Legend"]:upper())
        head.text:SetTextColor(Sk:TextAccent())
        head.arrow:SetTexture(Sk:UIIcon(closed and "ArrowRight" or "ArrowDown"))
        -- resaltado con las esquinas de la tarjeta: las cuatro si esta cerrada, solo las de arriba si esta abierta
        Sk:SetRounded(head, head.hl, closed and "All" or "Top")
        d.legend.left:SetShown(not closed)
        d.legend.right:SetShown(not closed)
        d.legend:SetHeight(closed and 26
            or (math.max(d.legend.left:GetStringHeight(), d.legend.right:GetStringHeight()) + 18 + 21))
        Sk:PaintCard(d.legend, "card", 0.9, "ui")
        d.legend:Show()
        listTop = top + d.legend:GetHeight() + 6
    else
        d.legend:Hide()
    end
    d.qscroll:ClearAllPoints()
    d.qscroll:SetPoint("TOPLEFT", d.art, "BOTTOMLEFT", 10, -listTop)
    d.qscroll:SetPoint("BOTTOMRIGHT", -18 - BAR_W - 4, 62)
    d.qscroll.content:SetWidth(width)
    for _, r in ipairs(d.qrows) do r.text:SetWordWrap(false); r.text:SetAlpha(1); r.recipeSpell = nil; r.toggleKey = nil; r.mapButton = nil end   -- (las de profesion cambian esto)
    local y = 0
    local STATUS = QR.GuideUI.STATUS
    for i, r in ipairs(rows or {}) do
        local q = QuestRow(d, i)
        local st = STATUS[r.status] or STATUS.locked
        Sk:StyleText(q.text, "body", "ui")
        Size(q.text, 12)
        local tags = (r.elite and (Sk:IconTag("elite", 15, 12) .. " ") or "") .. (r.dungeon and (Sk:IconTag("dungeon", 15, 12) .. " ") or "")
        local extra = r.status == "lowlevel" and string.format(L[" (level %d)"], r.reqLevel) or ""
        if r.chainZone then extra = extra .. "  " .. Sk.TEXT.warn .. string.format(L["chain: %s"], r.chainZone) .. "|r" end
        q.text:SetText(string.format("%s %s%s[%d] %s|r%s", Sk:IconTag(st[1], 15, 12), tags, st[2], r.level, r.name, extra))
        local cr, cg, cb = Sk:Color(i % 2 == 0 and "card" or "background")
        q.bg:SetColorTexture(cr, cg, cb, 1)
        local tip = string.format(L["ID %d · level %d (requires %d)%s"], r.questId, r.level, r.reqLevel, r.note and ("\n" .. r.note) or "")
        if r.chain then tip = tip .. "\n" .. string.format(L["Needs first: %s"], r.chain) end
        if r.status ~= "done" then tip = tip .. "\n|cff999999" .. L["Right-click: route to the quest giver / to the start of the chain"] .. "|r" end
        tip = tip .. "\n|cff999999" .. L["Map (right): show it on the world map"] .. "|r"
        q.tip = { r.name, tip }
        q.questId, q.status, q.boss, q.reward, q.lootBoss = r.questId, r.status, nil, nil, nil
        -- a la derecha: ver en el mapa donde esta (quien la da, o quien la recoge si ya la llevas)
        Sk:StyleText(q.right, "small", "ui")
        Size(q.right, 11)
        q.right:SetText("|TInterface\\Icons\\INV_Misc_Map_01:14:14:0:0:64:64:5:59:5:59|t |cffd8c9a8" .. L["Map"] .. "|r")
        q.mapButton = true
        q.text:SetPoint("RIGHT", -70, 0)
        q.hl:Hide()
        q:SetSize(width, QROW_H)
        q:ClearAllPoints()
        q:SetPoint("TOPLEFT", 0, -y)
        q:Show()
        y = y + QROW_H
    end
    local n = #(rows or {})
    if bosses then
        -- cabecera
        n = n + 1
        local h = QuestRow(d, n)
        Sk:StyleText(h.text, "eyebrow", "ui")
        Size(h.text, 10.5)
        h.text:SetText(string.format("%s%s|r  |cff9a9f9c·  %s|r", Sk:Hex("accent"), L["BOSSES"], L["Spoken's narration of each boss"]))
        h.text:SetPoint("RIGHT", -10, 0)
        h.right:SetText("")
        h.bg:SetColorTexture(0, 0, 0, 0)
        h.tip, h.questId, h.boss, h.reward = nil, nil, nil, nil
        h.hl:Hide()
        h:SetSize(width, QROW_H + 10)
        h:ClearAllPoints()
        h:SetPoint("TOPLEFT", 0, -(y + 4))
        h:Show()
        y = y + QROW_H + 14
        for i, b in ipairs(bosses) do
            n = n + 1
            local q = QuestRow(d, n)
            Sk:StyleText(q.text, "body", "ui")
            Sk:StyleText(q.right, "small", "ui")
            Size(q.text, 12)
            Size(q.right, 11)
            q.text:SetPoint("RIGHT", -90, 0)
            q.text:SetText(Sk:IconTag("dungeon", 15) .. " " .. b.name)
            local cr, cg, cb = Sk:Color(i % 2 == 0 and "card" or "background")
            q.bg:SetColorTexture(cr, cg, cb, 1)
            q.tip, q.questId, q.status = { b.name, L["Click: listen to the boss's story with Spoken"] }, nil, nil
            q.boss, q.reward, q.lootBoss = b, nil, nil
            q.hl:Show()
            q:SetSize(width, QROW_H)
            q:ClearAllPoints()
            q:SetPoint("TOPLEFT", 0, -y)
            q:Show()
            y = y + QROW_H
        end
    end
    if rewards and #rewards > 0 then
        n = n + 1
        local h = QuestRow(d, n)
        Sk:StyleText(h.text, "eyebrow", "ui")
        Size(h.text, 10.5)
        h.text:SetText(string.format("%s%s|r  |cff9a9f9c·  %s|r", Sk:Hex("accent"), L["REWARDS"], L["everything this chain gives you"]))
        h.text:SetPoint("RIGHT", -10, 0)
        h.right:SetText("")
        h.bg:SetColorTexture(0, 0, 0, 0)
        h.tip, h.questId, h.boss, h.reward = nil, nil, nil, nil
        h.hl:Hide()
        h:SetSize(width, QROW_H + 10)
        h:ClearAllPoints()
        h:SetPoint("TOPLEFT", 0, -(y + 4))
        h:Show()
        y = y + QROW_H + 14
        local missing = false
        for i, rw in ipairs(rewards) do
            n = n + 1
            local q = QuestRow(d, n)
            Sk:StyleText(q.text, "body", "ui")
            Sk:StyleText(q.right, "small", "ui")
            Size(q.text, 12)
            Size(q.right, 11)
            local name, icon, color = nil, nil, "|cffffffff"
            if rw.kind == "rep" then
                name = string.format(L["%s reputation (+%d)"], FactionName(rw.id) or ("#" .. rw.id), rw.amount or 0)
                icon = REP_ICON
                color = "|cffbda0ff"
            elseif rw.kind == "spell" then
                name, icon = SpellData(rw.id)
                color = "|cff71d6a2"
            else
                local quality
                name, quality, icon = ItemData(rw.id)
                local qc = quality and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[quality]
                if qc and qc.hex then color = qc.hex end
            end
            if not name and rw.kind ~= "rep" then missing = true end
            local iconTag = icon and string.format("|T%s:18:18:0:0:64:64:5:59:5:59|t ", tostring(icon)) or ""
            q.text:SetPoint("RIGHT", -150, 0)
            q.text:SetText(iconTag .. color .. (name or ("#" .. rw.id)) .. "|r")
            local quest = rw.quest and QR.Bridge and QR.Bridge:GetQuest(rw.quest)
            local right = (rw.kind == "spell" and L["Spell"]) or (rw.choice and L["Choice"]) or (rw.kind == "rep" and L["Reputation"]) or ""
            if quest and quest.name then right = (right ~= "" and (right .. " · ") or "") .. quest.name end
            q.right:SetText("|cff9a9f9c" .. right .. "|r")
            q.right:SetWidth(140)
            q.right:SetWordWrap(false)
            local cr, cg, cb = Sk:Color(i % 2 == 0 and "card" or "background")
            q.bg:SetColorTexture(cr, cg, cb, 1)
            q.tip, q.questId, q.status, q.boss = nil, nil, nil, nil
            q.reward, q.lootBoss = rw, nil
            q.hl:Show()
            q:SetSize(width, QROW_H + 4)
            q:ClearAllPoints()
            q:SetPoint("TOPLEFT", 0, -y)
            q:Show()
            y = y + QROW_H + 4
        end
        -- objetos que el juego aun no tenia en memoria: se vuelve a pintar cuando llegan
        local key = rewards[1] and (rewards[1].kind .. rewards[1].id) or ""
        if key ~= self.rewardKey then self.rewardKey, self.rewardTries = key, 0 end
        if missing and not self.rewardRetry and self.rewardTries < 6 then
            self.rewardRetry = true
            self.rewardTries = self.rewardTries + 1
            C_Timer.After(0.6, function()
                Browser.rewardRetry = nil
                if Browser.frame:IsShown() and Browser.selected and Browser.selected.guide and Browser.selected.guide.class then
                    Browser:PaintDetail()
                end
            end)
        end
    end
    d.bossRows = bosses and true or nil
    self:PaintBossRows()
    for i = n + 1, #d.qrows do d.qrows[i]:Hide() end
    for i, t in ipairs(lines or {}) do
        local l = Line(d, i)
        Sk:StyleText(l, "body", "ui")
        Size(l, 12.5)
        l:SetWidth(width - 8)
        l:SetText(t)
        l:ClearAllPoints()
        l:SetPoint("TOPLEFT", 4, -y)
        l:Show()
        y = y + l:GetStringHeight() + 12
    end
    for i = #(lines or {}) + 1, #d.lines do d.lines[i]:Hide() end
    d.qscroll.content:SetHeight(math.max(10, y))
    d.qscroll:SetVerticalScroll(0)
    C_Timer.After(0, function() d.qscroll.bar:Sync() end)
end

function Browser:SetLoad(enabled, text)
    local b = self.frame.detail.load
    b.text:SetText(text)
    if enabled then b:Enable() else b:Disable() end
    b:Paint()
end

function Browser:PaintDetail()
    local Sk, d, e = S(), self.frame.detail, self.selected
    Sk:PaintCard(d.bg, "header", 0.98, "ui")
    Sk:SetRounded(d.top, d.shade)
    Sk:SetRounded(d.top, d.shade2)
    Sk:StyleText(d.eyebrow, "eyebrow", "ui")
    Sk:StyleText(d.name, "title", "ui")
    Sk:StyleText(d.desc, "body", "ui")
    Sk:StyleText(d.state, "small", "ui")
    Size(d.eyebrow, 10.5)
    Size(d.name, 22)
    Size(d.desc, 12.5)
    Size(d.state, 11)
    d.eyebrow:SetTextColor(Sk:TextAccent())
    d.name:SetTextColor(1, 1, 1)
    d.desc:SetTextColor(0.84, 0.86, 0.84)
    d.bigIcon:Hide()
    d.bigIcon:PaintBorder(false)
    d.classBg:Hide()
    d.classMark:Hide()
    d.classMap:Hide()
    d.classTint:Hide()
    d.map:Hide()
    d.listen:Hide()
    d.photo:Hide()
    d.art:Show()
    d.name:ClearAllPoints()
    d.name:SetPoint("BOTTOMLEFT", d.art, "BOTTOMLEFT", 18, 16)
    d.state:SetText("")
    self.tabsFor = nil
    local sec = self:SectionInfo(self.section)
    if not e then
        d.art:SetZone(Sk.key, nil, 1)
        d.eyebrow:SetText(L[sec.title]:upper())
        d.name:SetText(L[sec.short])
        d.desc:SetText(L[sec.desc])
        SetChips(d, {})
        self:FillList(nil, { L["Coming soon"] }, false)
        self:SetLoad(false, L["Coming soon"])
        return
    end
    if e.kind == "guide" or e.kind == "evguide" then
        local g = e.guide
        d.art:SetZone(Sk:KeyForGuide(g) or Sk.key, nil, 1)
        if self:SetDungeonPhoto(d.photo, g, W - DETAIL_X - 16, ART_H) then
            d.art:Hide()
            Sk:SetRounded(d.top, d.photo)   -- con las esquinas redondeadas del banner
        end
        if g.class then
            -- fondo con el color de la clase, su emblema y el icono de la recompensa principal junto al titulo
            local c = (RAID_CLASS_COLORS and RAID_CLASS_COLORS[g.class]) or { r = 0.6, g = 0.6, b = 0.6 }
            d.classBg:SetColorTexture(1, 1, 1, 1)
            if d.classBg.SetGradient and CreateColor then
                d.classBg:SetGradient("HORIZONTAL", CreateColor(c.r * 0.42, c.g * 0.42, c.b * 0.42, 1),
                    CreateColor(c.r * 0.16, c.g * 0.16, c.b * 0.16, 1))
            else
                d.classBg:SetColorTexture(c.r * 0.3, c.g * 0.3, c.b * 0.3, 1)
            end
            Sk:SetRounded(d.top, d.classBg)
            -- fondo: el banner de la clase (imagenes/classes); sin el, el mapa de la zona; sin mapa, el color de la clase
            if not self:SetClassBanner(g.class) and not self:SetClassMap(g) then
                d.classBg:Show()
                ClassIcon(d.classMark, g.class)
                d.classMark:Show()
            end
            d.bigIcon:Show()
            MainRewardIcon(d.bigIcon, g)
            d.bigIcon:PaintBorder(true)
            d.name:ClearAllPoints()
            d.name:SetPoint("BOTTOMLEFT", d.bigIcon, "BOTTOMRIGHT", 16, 2)
        end
        d.eyebrow:SetText(e.event and L[g.eventName]:upper()
            or g.class and ((LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[g.class] or g.class):upper())
            or L[sec.title]:upper())
        d.name:SetText(e.event and L[g.titleKey] or QR.GuideLabel(g))
        local rows = QR.Planner:GetQuestRows(g)
        local done = 0
        for _, r in ipairs(rows) do if r.status == "done" then done = done + 1 end end
        local faction = g.faction == "Alliance" and L["Alliance"] or g.faction == "Horde" and L["Horde"] or nil
        local chips = { string.format(L["%sLevels %d-%d|r"], GuideLevelColor(g), g.minLevel, g.maxLevel) }
        if faction then chips[#chips + 1] = faction end
        chips[#chips + 1] = string.format(L["%d quests"], #rows)
        chips[#chips + 1] = string.format(L["%d/%d done"], done, #rows)
        if e.new then chips[#chips + 1] = "|cffffd166" .. L["NEW"] .. "|r" end
        if g.pvp then chips[#chips + 1] = "|cffff8178" .. L["Hard: PvP zones"] .. "|r" end
        if g.group then chips[#chips + 1] = "|cffbda0ff" .. L["Group recommended"] .. "|r" end
        local mapId = self:MapFor(g)
        if mapId then d.map:Show(); d.map:Paint() end
        -- texto de la zona: el de Spoken si esta instalado y tiene esta zona; si no, uno general
        local spokenMap = QR.Bridge:UiMapOf(g.areaId) or mapId
        local spoken, spokenKey
        if g.instanceId then
            spoken, spokenMap, spokenKey = SpokenDungeon(g.instanceId)
        elseif not e.event and not g.class then
            spoken = SpokenZone(spokenMap)
        end
        self.spoken, self.spokenMap, self.spokenKey = spoken, spoken and spokenMap or nil, spoken and spokenKey or nil
        d.desc:SetText(spoken and spoken.text
            or g.misc and L["Loose quests for your class and race: each one on its own, at the level it asks for."]
            or g.class and L["A class quest chain: the planner takes you through it in order, from the first quest to the reward."]
            or g.descKey and (L[g.descKey] .. (g.pvp and ("\n\n|cffff8178" .. L["It goes through contested zones where you can run into players of the other faction: better done in a group."] .. "|r") or ""))
            or g.instanceId and L["First the quests outside the dungeon (if any), then the route to the entrance."]
            or e.event and L["Added as each world event goes live in the game."]
            or L["Every quest in the zone, in order, following its story from start to finish."])
        d.listen:ClearAllPoints()
        d.listen:SetPoint("TOPRIGHT", mapId and d.map or d.art, mapId and "TOPLEFT" or "BOTTOMRIGHT", mapId and -6 or -2, mapId and 0 or -11)
        if spoken and spoken.file then d.listen:Show(); d.listen:Paint() end
        local reserve = (mapId and d.map:GetWidth() + 8 or 0) + (spoken and spoken.file and d.listen:GetWidth() + 8 or 0)
        SetChips(d, chips, reserve)
        local loot = g.instanceId and QR.DungeonLoot and QR.DungeonLoot[g.instanceId]
        if loot then
            self.tabsFor = { field = "dungeonTab", filter = "loot",
                { key = "quests", text = string.format(L["Quests (%d)"], #rows) },
                { key = "loot", text = string.format(L["Bosses and loot (%d)"], #loot) } }
        end
        if loot and self.dungeonTab == "loot" then
            self:FillLoot(g, loot)
        else
            self:FillList(rows, nil, true, g.instanceId and SpokenBosses(g.instanceId) or nil, g.class and ClassRewards(g) or nil)
        end
        -- se puede cargar? no si su evento no esta, si ya la has hecho entera o (clase) si aun te falta nivel
        local evUp = true
        if e.event then
            for _, ev in ipairs(QR.Events and QR.Events.list or {}) do
                for _, sg in ipairs(ev.sections or {}) do
                    if sg == g then local st = ev.Status and ev.Status(); evUp = not st or st.up ~= false end
                end
            end
        end
        local gs = GuideState(g)
        local minReq
        for _, row in ipairs(g.quests) do minReq = math.min(minReq or row[3], row[3]) end
        if e.active then
            d.state:SetText(Sk:Hex("accent") .. L["This is your active guide"] .. "|r")
            self:SetLoad(false, L["Loaded"])
        elseif not evUp then
            self:SetLoad(false, L["Event not available"])
        elseif gs == "done" then
            self:SetLoad(false, L["Already completed"])
        elseif g.class and gs == "lowlevel" then
            self:SetLoad(false, string.format(L["From level %d"], minReq or 1))
        else
            self:SetLoad(true, L["Load guide"])
        end
        return
    end
    if e.kind == "skill" then
        local g = { class = select(2, UnitClass("player")) }
        local c = (RAID_CLASS_COLORS and RAID_CLASS_COLORS[g.class]) or { r = 0.6, g = 0.6, b = 0.6 }
        d.classBg:SetColorTexture(1, 1, 1, 1)
        if d.classBg.SetGradient and CreateColor then
            d.classBg:SetGradient("HORIZONTAL", CreateColor(c.r * 0.42, c.g * 0.42, c.b * 0.42, 1),
                CreateColor(c.r * 0.16, c.g * 0.16, c.b * 0.16, 1))
        end
        Sk:SetRounded(d.top, d.classBg)
        if not self:SetClassBanner(g.class) then
            d.classBg:Show()
            ClassIcon(d.classMark, g.class)
            d.classMark:Show()
        end
        local name, icon = SpellData(e.id)
        d.bigIcon:Show()
        d.bigIcon:SetTexture(icon or 134400)
        d.bigIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        d.bigIcon:PaintBorder(true)
        d.name:ClearAllPoints()
        d.name:SetPoint("BOTTOMLEFT", d.bigIcon, "BOTTOMRIGHT", 16, 2)
        d.eyebrow:SetText(((LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[g.class]) or g.class):upper()
            .. "  ·  " .. L["Skills"]:upper())
        local rank = SpellRank(e.id)
        d.name:SetText((name or ("#" .. e.id)) .. (rank and ("  |cffbfc4c0" .. rank .. "|r") or ""))
        local stText = e.status == "done" and ("|cff7f8a84" .. L["Already learned"] .. "|r")
            or e.status == "available" and ("|cff71d6a2" .. L["You can learn it now"] .. "|r")
            or ("|cffff8178" .. string.format(L["From level %d"], e.level) .. "|r")
        SetChips(d, { string.format(L["Level %d"], e.level),
            e.quests and ("|cffffd166" .. L["Class quest"] .. "|r") or CoinText(e.cost), stText })
        d.desc:SetText(SpellDescription(e.id) or "")
        -- todos los rangos de esta habilidad (mismo nombre), con su nivel, coste y si ya los tienes
        local lines = {}
        for _, s in ipairs(QR.ClassSkills or {}) do
            local n2 = SpellData(s[2])
            if n2 and n2 == name then
                local mark = KnowsSpellId(s[2]) and "|cff7f8a84" or (s[1] <= UnitLevel("player") and "|cff71d6a2" or "|cffe6e9e6")
                lines[#lines + 1] = string.format("%s%s  ·  " .. L["Level %d"] .. "  ·  %s|r", mark, SpellRank(s[2]) or name, s[1], CoinText(s[3]))
            end
        end
        if #lines > 0 then table.insert(lines, 1, Sk:Hex("accent") .. L["RANKS"] .. "|r") end
        if e.quests then
            -- se consigue con misiones: cuales, y la guia de clase que las lleva
            lines = { Sk:Hex("accent") .. L["QUESTS THAT GIVE IT"] .. "|r" }
            for _, qid in ipairs(e.quests) do
                local q = QR.Bridge and QR.Bridge:GetQuest(qid)
                local st = QR.Bridge and QR.Bridge:QuestStatus(qid)
                lines[#lines + 1] = (st == "done" and "|cff7f8a84" or "|cffffd166") .. (q and q.name or ("#" .. qid)) .. "|r"
            end
            e.guideKey = nil
            for _, g in ipairs(QR.classGuides) do
                for _, row in ipairs(g.quests) do
                    for _, qid in ipairs(e.quests) do if row[1] == qid then e.guideKey = g.key end end
                end
            end
            self:FillList(nil, lines, false)
            if e.status == "done" then self:SetLoad(false, L["Already learned"])
            elseif e.guideKey then self:SetLoad(true, L["Go to the quest"])
            else self:SetLoad(false, L["Class quest"]) end
            return
        end
        self:FillList(nil, lines, false)
        self:SetLoad(false, L["Learn it at your class trainer"])
        return
    end
    if e.kind == "profession" then
        local p = e.prof
        d.art:SetZone(Sk.key, nil, 1)
        d.bigIcon:Show()
        d.bigIcon:SetTexture(p.icon)
        d.bigIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        d.bigIcon:PaintBorder(true)
        d.name:ClearAllPoints()
        d.name:SetPoint("BOTTOMLEFT", d.bigIcon, "BOTTOMRIGHT", 16, 2)
        d.eyebrow:SetText(L["Profession guides"]:upper())
        d.name:SetText(L[p.key] .. " 1-300")
        local chips = {}
        if e.learned then chips[1] = string.format("|cff71d6a2" .. L["Skill %d/%d"] .. "|r", e.learned.rank or 0, e.learned.max or 0)
        else chips[1] = "|cff9a9f9c" .. L["Not learned"] .. "|r" end
        chips[2] = p.secondary and L["Secondary profession"] or L["Primary profession"]
        if p.gathering then chips[3] = L["Gathering"] end
        SetChips(d, chips)
        local pg = QR.professionGuides[p.id]
        if pg then
            d.desc:SetText(L["From 1 to 300 for WoW Forever: trainers, recipes, materials and where to get them. What you have already passed is greyed out."])
            local rank = e.learned and e.learned.rank or 0
            if pg.recipes and #pg.recipes > 0 then
                self.tabsFor = { field = "profTab",
                    { key = "steps", text = L["Step guide"] },
                    { key = "recipes", text = string.format(L["Recipes (%d)"], #pg.recipes) } }
            end
            if self.tabsFor and self.profTab == "recipes" then
                self:FillRecipes(pg, rank)
            else
                self:FillProfession(pg, rank)
            end
            -- (la guia existe: es de consulta, no se carga en la flecha; antes decia "Proximamente")
            self:SetLoad(false, L["Reference only"])
            return
        end
        d.desc:SetText(L["This guide is being prepared. It will take you from 1 to 300: trainers, materials, recipes and where to get everything."])
        local lines = {}
        local rank = e.learned and e.learned.rank or 0
        for _, rk in ipairs(RANKS) do
            local color = (rank >= rk[2] and "|cff7f8a84") or (rank >= rk[1] and "|cffffd166") or "|cffe6e9e6"
            lines[#lines + 1] = string.format("%s%d-%d  ·  %s|r  |cff9a9f9c(%s)|r", color, rk[1], rk[2], L[rk[3]],
                string.format(L["level %d"], rk[4]))
        end
        self:FillList(nil, lines, false)
        self:SetLoad(false, L["Coming soon"])
        return
    end
    -- proximamente
    d.art:SetZone(Sk.key, nil, 1)
    d.eyebrow:SetText(L[sec.title]:upper())
    d.name:SetText(e.text)
    SetChips(d, { L["Coming soon"] })
    d.desc:SetText(e.soonEvent and L["Added as each world event goes live in the game."] or L["These guides are coming later."])
    self:FillList(nil, nil, false)
    self:SetLoad(false, L["Coming soon"])
end

---------------------------------------------------------------------------
-- Pantalla de carga de una mazmorra en una textura de w x h (recorte centrado, imagen de 2:1)
---------------------------------------------------------------------------
function Browser:SetDungeonPhoto(tex, g, w, h)
    local id = g and g.instanceId
    if not (id and QR.DungeonArt and QR.DungeonArt[id]) then tex:Hide(); return false end
    tex:SetTexture(S().MEDIA .. "Dungeons\\" .. id .. ".blp")
    local frac = math.min(1, (2 * (h or 1)) / math.max(1, w or 1))   -- parte visible de la altura de la imagen
    local v0 = (1 - frac) * 0.45
    tex:SetTexCoord(0, 1, v0, v0 + frac)
    tex:Show()
    return true
end

---------------------------------------------------------------------------
-- Escuchar la zona (Spoken): el mp3 de su paquete; el boton vuelve a "Escuchar" al acabar o al cambiar de guia
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Guias de profesion: pasos (entrenar, aprender, comprar, reunir, fabricar...), farmeo y lista de la compra
---------------------------------------------------------------------------
local RANK_NAMES = { "Apprentice", "Journeyman", "Expert", "Artisan" }

local function MyFaction() return UnitFactionGroup("player") == "Horde" and "H" or "A" end

--- el entrenador / vendedor de tu faccion (o neutral: "AH", los goblins) mas cercano a ti. Antes los neutrales no
--- salian nunca (se comparaba "AH" con "A" / "H") y, fuera de su zona, salia el primero de la lista (un humano en
--- Ventormenta podia ver uno de Darnassus).
local function PickCandidate(list)
    if type(list) ~= "table" then return nil end
    local f = MyFaction()
    local px, py, pinst = QR.HBD and QR.HBD:GetPlayerWorldPosition()
    local best, bestD
    for _, c in ipairs(list) do
        if type(c) == "table" and (not c.faction or c.faction:find(f, 1, true)) then
            local d = 1e9
            if px and c.map and c.x and c.y then
                local wx, wy, inst = QR.HBD:GetWorldCoordinatesFromZone(c.x / 100, c.y / 100, c.map)
                if wx and inst == pinst then d = QR.HBD:GetWorldDistance(pinst, px, py, wx, wy) or 1e9
                elseif wx then d = 1e8 end   -- (otro continente: detras de los de este)
            end
            if not bestD or d < bestD then best, bestD = c, d end
        end
    end
    return best
end

--- ¿Este paso u objetivo es para tu personaje? (only = { factions = { ... }, races = { ... } }). Las guias traen
--- variantes por raza (reunir en Elwynn, en Dun Morogh, en Teldrassil...): antes solo se miraba la faccion y salian
--- todas, y la lista de la compra las sumaba. Si tu raza no sale en ninguna variante de la guia, no se esconde nada.
local function ForMe(only, guideRaces)
    if not only then return true end
    if only.factions then
        local me, ok = UnitFactionGroup("player"), false
        for _, x in ipairs(only.factions) do if x == me then ok = true end end
        if not ok then return false end
    end
    if only.races then
        local race = select(2, UnitRace("player"))
        if not (race and guideRaces and guideRaces[race]) then return true end
        for _, x in ipairs(only.races) do if x == race then return true end end
        return false
    end
    return true
end

--- razas que aparecen en las variantes de una guia (para ForMe)
local function GuideRaces(pg)
    if pg.racesSeen then return pg.racesSeen end
    local seen = {}
    for _, step in ipairs(pg.steps or {}) do
        for _, r in ipairs(step.only and step.only.races or {}) do seen[r] = true end
        for _, gl in ipairs(step.goals or {}) do
            for _, r in ipairs(gl.only and gl.only.races or {}) do seen[r] = true end
        end
    end
    pg.racesSeen = seen
    return seen
end

local function NpcName(id)
    local B = QR.Bridge
    local ok, npc = pcall(function() return B and B.QuestieDB and B.QuestieDB:GetNPC(id) end)
    return ok and npc and npc.name or ("#" .. id)
end

local function ObjectName(id)
    local B = QR.Bridge
    local ok, o = pcall(function() return B and B.QuestieDB and B.QuestieDB:GetObject(id) end)
    return ok and o and o.name or ("#" .. id)
end

local function MapName(map)
    local info = map and C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
    return info and info.name or "?"
end

local function AreaName(areaId)
    return MapName(QR.Bridge and QR.Bridge.UiMapOf and QR.Bridge:UiMapOf(areaId))
end

local function ItemText(id, count, size)
    local name, quality, icon = ItemData(id)
    local qc = quality and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[quality]
    size = size or 16
    local tag = icon and string.format("|T%s:%d:%d:0:0:64:64:5:59:5:59|t ", tostring(icon), size, size) or ""
    return tag .. (qc and qc.hex or "|cffffffff") .. (count and (count .. "x ") or "") .. (name or ("#" .. id)) .. "|r", name ~= nil
end

local function SpellText(id, size)
    local name, icon = SpellData(id)
    size = size or 16
    local tag = icon and string.format("|T%s:%d:%d:0:0:64:64:5:59:5:59|t ", tostring(icon), size, size) or ""
    return tag .. "|cff71d6a2" .. (name or ("#" .. id)) .. "|r", name ~= nil
end

--- el nivel de habilidad que deja hecho un paso (para atenuar lo que ya has pasado)
local function StepTarget(step, section)
    local t = 0
    for _, gl in ipairs(step.goals or {}) do
        t = math.max(t, gl.untilSkill or 0, (gl.t == "skill" and gl.level) or 0)
    end
    return t > 0 and t or (section and section.to) or 0
end

--- textos de un objetivo: linea principal, linea de detalle (quien / donde), objeto o hechizo para el tooltip
function Browser:GoalLines(gl, pg)
    local t, ok = gl.t, true
    local main, sub, tip
    if t == "train" then
        main = string.format(L["Train %s (skill up to %d)"], L[RANK_NAMES[gl.rank or 1] or "Apprentice"], gl.rankMax or 75)
        local c = PickCandidate(gl.candidates)
        if c then sub = string.format(L["Trainer: %s (%s)"], NpcName(c.npc), MapName(c.map)) end
    elseif t == "learn" then
        local s; s, ok = SpellText(gl.spell, 18)
        main = string.format(L["Learn the recipe %s"], s)
        tip = { kind = "spell", id = gl.spell }
        local c = PickCandidate(gl.candidates)
        if c then sub = string.format(L["Trainer: %s (%s)"], NpcName(c.npc), MapName(c.map)) end
    elseif t == "buy" then
        local s; s, ok = ItemText(gl.item, gl.count, 18)
        main = string.format(L["Buy %s"], s)
        tip = { kind = "item", id = gl.item }
        local c = PickCandidate(gl.candidates)
        if c then sub = string.format(L["Vendor: %s (%s)"], NpcName(c.npc), MapName(c.map)) end
    elseif t == "collect" then
        local s; s, ok = ItemText(gl.item, gl.count, 18)
        -- material que la guia de origen daba por hecho (lingotes, polvos, gemas...): cantidad aproximada y de donde sale
        main = string.format(gl.derived and L["Get about %s"] or L["Gather %s"], s)
        tip = { kind = "item", id = gl.item }
        local src = pg.farm and pg.farm[gl.item]
        if gl.how == "smelt" then
            sub = string.format(L["Smelt %s (Mining) or buy them at the auction house"], (ItemText(gl.ore)))
            src = nil
        elseif gl.how == "alloy" then
            sub = string.format(L["Smelt %s and %s (Mining) or buy them at the auction house"],
                (ItemText(gl.parts and gl.parts[1] or 0)), (ItemText(gl.parts and gl.parts[2] or 0)))
            src = nil
        elseif gl.how == "disenchant" then
            sub = L["Disenchant green items, or buy them at the auction house"]
            src = nil
        elseif gl.how == "smith" then
            sub = L["Made by a blacksmith (or bought at the auction house)"]
            src = nil
        elseif gl.how == "craft" then
            sub = string.format(L["Craft more: %s"], (SpellText(gl.spell)))
            src = nil
        end
        if src then
            local parts = {}
            for _, x in ipairs(src) do
                if x.t == "npc" then
                    parts[#parts + 1] = string.format("%s (%s, %d-%d)", NpcName(x.id), AreaName(x.zone), x.lvl[1], x.lvl[2])
                elseif x.t == "object" then
                    parts[#parts + 1] = string.format("%s (%s)", ObjectName(x.id), AreaName(x.zone))
                elseif x.t == "vendor" and (x.faction or "AH"):find(MyFaction()) then
                    parts[#parts + 1] = string.format(L["sold by %s (%s)"], NpcName(x.id), AreaName(x.zone))
                end
                if #parts >= 3 then break end
            end
            if #parts > 0 then sub = L["Comes from: "] .. table.concat(parts, ", ") end
        end
    elseif t == "craft" then
        local s; s, ok = ItemText(gl.item or 0, nil, 18)
        if not gl.item then s, ok = SpellText(gl.spell, 18) end
        if gl.untilSkill then
            main = string.format(L["Craft %s until %d"], s, gl.untilSkill)
            if gl.yellow or gl.grey then
                sub = string.format(L["Yellow at %d · grey at %d"], gl.yellow or 0, gl.grey or 0)
            end
        else
            main = string.format(L["Craft %dx %s"], gl.count or 1, s)
        end
        tip = gl.item and { kind = "item", id = gl.item } or { kind = "spell", id = gl.spell }
        if gl.reagents then
            local parts = {}
            for _, r in ipairs(gl.reagents) do parts[#parts + 1] = (ItemText(r.item, r.count)) end
            sub = (sub and (sub .. "  ·  ") or "") .. L["Each one: "] .. table.concat(parts, ", ")
        end
    elseif t == "skill" then
        main = string.format(L["Reach skill %d"], gl.level or 0)
    elseif t == "level" then
        main = string.format(L["Character level %d"], gl.level or 0)
    elseif t == "accept" or t == "turnin" or t == "complete" then
        local q = gl.quest and QR.Bridge and QR.Bridge:GetQuest(gl.quest)
        main = string.format(t == "accept" and L["Pick up the quest %s"] or t == "turnin" and L["Turn in %s"] or L["Complete %s"],
            "|cffffd166" .. (q and q.name or ("#" .. tostring(gl.quest))) .. "|r")
    elseif t == "goto" then
        return nil   -- las rutas de recoleccion se resumen por paso (ver FillProfession)
    else
        return nil
    end
    return main, sub, tip, ok
end

--- lista de la profesion en el panel de abajo: tramos, pasos, rutas de recoleccion y la lista de la compra
function Browser:FillProfession(pg, rank)
    local Sk, d = S(), self.frame.detail
    local keep = (self.stepsShown == pg.skillLine) and d.qscroll:GetVerticalScroll() or 0   -- al desplegar, no saltar
    self.stepsShown = pg.skillLine
    self:FillList(nil, nil, false)
    local width = W - DETAIL_X - 40 - BAR_W
    local y, n, missing = 0, 0, false
    local myFaction = UnitFactionGroup("player")
    local function Row(text, sub, tip, dim, header, key)
        n = n + 1
        local r = QuestRow(d, n)
        Sk:StyleText(r.text, header and "eyebrow" or "body", "ui")
        Size(r.text, header and 10.5 or 12)
        r.text:SetPoint("RIGHT", -10, 0)
        r.right:SetText("")
        local open = sub and key and self.stepOpen and self.stepOpen[key]
        local body = text
        if sub and not header then
            body = string.format("|T%s:12:12|t ", Sk:UIIcon(open and "ArrowDown" or "ArrowRight")) .. text
        end
        if open then body = body .. "\n      |cff9a9f9c" .. sub .. "|r" end
        r.text:SetWordWrap(open and true or false)
        r.text:SetText(body)
        r.text:SetAlpha(dim and 0.45 or 1)
        local h = header and (QROW_H + 10) or (open and math.max(QROW_H + 22, r.text:GetStringHeight() + 14)) or (QROW_H + 6)
        r.toggleKey = (sub and not header) and key or nil
        if header then r.bg:SetColorTexture(0, 0, 0, 0) else
            local cr, cg, cb = Sk:Color(n % 2 == 0 and "card" or "background")
            r.bg:SetColorTexture(cr, cg, cb, 1)
        end
        r.tip, r.questId, r.status, r.boss = nil, nil, nil, nil
        r.reward, r.lootBoss = tip, nil
        r.hl:SetShown(tip ~= nil or r.toggleKey ~= nil)
        r:SetSize(width, h)
        r:ClearAllPoints()
        r:SetPoint("TOPLEFT", 0, -(y + (header and 4 or 0)))
        r:Show()
        y = y + h + (header and 4 or 0)
    end
    local lastSection
    local need = {}   -- lista de la compra: lo que queda por comprar o reunir (tramos que aun no has pasado)
    local races = GuideRaces(pg)
    for si, step in ipairs(pg.steps or {}) do
        if ForMe(step.only, races) then
            local sec = pg.sections and pg.sections[step.section or 1]
            if step.section ~= lastSection and sec then
                lastSection = step.section
                local passed = rank >= sec.to
                Row(string.format("%s%s %d-%d|r", passed and "|cff7f8a84" or Sk:Hex("accent"),
                    L[RANK_NAMES[step.section or 1] or "Apprentice"]:upper(), sec.from, sec.to), nil, nil, false, true)
            end
            local dim = rank > 0 and rank >= StepTarget(step, sec)
            -- rutas de recoleccion: una linea por zona con los puntos de la ruta
            local zonesOf, order = {}, {}
            for _, gl in ipairs(step.goals or {}) do
                if gl.t == "goto" and gl.map then
                    if not zonesOf[gl.map] then zonesOf[gl.map] = 0; order[#order + 1] = gl.map end
                    zonesOf[gl.map] = zonesOf[gl.map] + 1
                end
            end
            for _, map in ipairs(order) do
                Row(string.format(L["Gathering route in %s (%d spots)"], "|cffffd166" .. MapName(map) .. "|r", zonesOf[map]), nil, nil, dim)
            end
            for gi, gl in ipairs(step.goals or {}) do
                local main, sub, tip, ok
                if ForMe(gl.only, races) then main, sub, tip, ok = self:GoalLines(gl, pg) end
                if main then
                    if ok == false then missing = true end
                    Row(main, sub, tip, dim, nil, pg.skillLine .. ":" .. si .. ":" .. gi)
                    if not dim and (gl.t == "buy" or gl.t == "collect") and gl.item then
                        need[gl.item] = (need[gl.item] or 0) + (gl.count or 0)
                    end
                end
            end
        end
    end
    -- lista de la compra
    local items = {}
    for id, c in pairs(need) do if c > 0 then items[#items + 1] = { id, c } end end
    table.sort(items, function(a, b) return a[1] < b[1] end)
    if #items > 0 then
        Row(string.format("%s%s|r  |cff9a9f9c·  %s|r", Sk:Hex("accent"), L["SHOPPING LIST"], L["what you still need from your current skill"]), nil, nil, false, true)
        for _, it in ipairs(items) do
            local s, ok = ItemText(it[1], it[2], 18)
            if not ok then missing = true end
            Row(s, nil, { kind = "item", id = it[1] }, false)
        end
    end
    for i = n + 1, #d.qrows do d.qrows[i]:Hide() end
    for i = 1, #d.lines do d.lines[i]:Hide() end
    d.qscroll.content:SetHeight(math.max(10, y))
    d.qscroll:SetVerticalScroll(math.min(keep, math.max(0, y - d.qscroll:GetHeight())))
    C_Timer.After(0, function() d.qscroll.bar:Sync() end)
    -- objetos y hechizos que el juego aun no tenia en memoria: se vuelve a pintar (unas pocas veces)
    local key = "prof" .. pg.skillLine
    if key ~= self.rewardKey then self.rewardKey, self.rewardTries = key, 0 end
    if missing and not self.rewardRetry and self.rewardTries < 6 then
        self.rewardRetry, self.rewardTries = true, self.rewardTries + 1
        C_Timer.After(0.8, function()
            Browser.rewardRetry = nil
            local e = Browser.selected
            if Browser.frame:IsShown() and e and e.kind == "profession" then Browser:PaintDetail() end
        end)
    end
end

---------------------------------------------------------------------------
-- Pestaña "Recetas" de una profesion: todas sus recetas por tramos, con sus niveles y de donde se aprenden
---------------------------------------------------------------------------
local SOURCE_TEXT = { trainer = "Trainer", vendor = "Vendor", drop = "Drop", quest = "Quest", start = "Starting recipe" }

local function KnowsSpell(id)
    local f = _G.IsPlayerSpell or _G.IsSpellKnown
    if not f then return false end
    local ok, known = pcall(f, id)
    return ok and known or false
end

--- niveles { naranja, amarillo, verde, gris } con sus colores; el que toca a tu habilidad, resaltado
local function SkillText(k, rank)
    if not (k and k[1]) then return "" end
    local cols = { "ff8040", "ffff00", "40bf40", "808080" }
    local parts = {}
    for i = 1, 4 do
        if k[i] then parts[#parts + 1] = "|cff" .. cols[i] .. k[i] .. "|r" end
    end
    return table.concat(parts, " ")
end

function Browser:FillRecipes(pg, rank)
    local Sk, d = S(), self.frame.detail
    local keep = (self.recipesShown == pg.skillLine) and d.qscroll:GetVerticalScroll() or 0
    self.recipesShown = pg.skillLine
    self:FillList(nil, nil, false)
    local width = W - DETAIL_X - 40 - BAR_W
    local y, n, missing, lastTier = 0, 0, false, nil
    for _, r in ipairs(pg.recipes) do
        local k = r.k or {}
        local tier = k[1] and math.min(4, math.floor(math.max(0, k[1] - 1) / 75) + 1) or 5
        if tier ~= lastTier then
            lastTier = tier
            n = n + 1
            local h = QuestRow(d, n)
            Sk:StyleText(h.text, "eyebrow", "ui")
            Size(h.text, 10.5)
            h.text:SetWordWrap(false)
            h.text:SetAlpha(1)
            h.text:SetPoint("RIGHT", -10, 0)
            h.text:SetText(Sk:Hex("accent") .. (tier <= 4 and string.format("%s %d-%d", L[RANK_NAMES[tier]]:upper(), (tier - 1) * 75 + (tier > 1 and 0 or 1), tier * 75)
                or L["No skill level known"]:upper()) .. "|r")
            h.right:SetText("")
            h.bg:SetColorTexture(0, 0, 0, 0)
            h.tip, h.questId, h.status, h.boss, h.reward, h.lootBoss = nil, nil, nil, nil, nil, nil
            h.hl:Hide()
            h:SetSize(width, QROW_H + 8)
            h:ClearAllPoints()
            h:SetPoint("TOPLEFT", 0, -(y + 4))
            h:Show()
            y = y + QROW_H + 12
        end
        n = n + 1
        local q = QuestRow(d, n)
        Sk:StyleText(q.text, "body", "ui")
        Sk:StyleText(q.right, "small", "ui")
        Size(q.text, 12)
        Size(q.right, 11.5)
        local name, ok
        if r.i and r.i > 0 then name, ok = ItemText(r.i, nil, 18) else name, ok = SpellText(r.s, 18) end
        if not ok then missing = true end
        local known = KnowsSpell(r.s)
        local mark = known and (Sk:IconTag("complete", 16) .. " ") or ""
        local open = self.recipeOpen and self.recipeOpen[r.s]
        local arrow = string.format("|T%s:12:12|t ", Sk:UIIcon(open and "ArrowDown" or "ArrowRight"))
        local body = arrow .. mark .. name
        if open then
            -- desplegada: materiales y de donde se aprende
            local mats = {}
            for _, m in ipairs(r.m or {}) do mats[#mats + 1] = (ItemText(m[1], m[2])) end
            local from = {}
            for w in (r.f or ""):gmatch("%S+") do if SOURCE_TEXT[w] then from[#from + 1] = L[SOURCE_TEXT[w]] end end
            local sub = table.concat(mats, ", ")
            if #from > 0 then sub = sub .. "  |cff9a9f9c·  " .. table.concat(from, ", ") .. "|r" end
            body = body .. "\n            |cff9a9f9c" .. sub .. "|r"
        end
        q.text:SetWordWrap(open and true or false)
        q.text:SetPoint("RIGHT", -110, 0)
        q.text:SetText(body)
        q.text:SetAlpha((k[1] and rank > 0 and rank < k[1]) and 0.55 or 1)   -- aun no puedes aprenderla
        q.right:SetText(SkillText(k, rank))
        local c1, c2, c3 = Sk:Color(n % 2 == 0 and "card" or "background")
        q.bg:SetColorTexture(c1, c2, c3, 1)
        q.tip, q.questId, q.status, q.boss, q.lootBoss = nil, nil, nil, nil, nil
        q.reward = (r.i and r.i > 0) and { kind = "item", id = r.i } or { kind = "spell", id = r.s }
        q.recipeSpell = r.s
        q.hl:Show()
        local h = open and (QROW_H + 22) or (QROW_H + 6)
        q:SetSize(width, h)
        q:ClearAllPoints()
        q:SetPoint("TOPLEFT", 0, -y)
        q:Show()
        y = y + h
    end
    d.bossRows = nil
    for i = n + 1, #d.qrows do d.qrows[i]:Hide() end
    for i = 1, #d.lines do d.lines[i]:Hide() end
    d.qscroll.content:SetHeight(math.max(10, y))
    d.qscroll:SetVerticalScroll(math.min(keep, math.max(0, y - d.qscroll:GetHeight())))
    C_Timer.After(0, function() d.qscroll.bar:Sync() end)
    local key = "rec" .. pg.skillLine
    if key ~= self.rewardKey then self.rewardKey, self.rewardTries = key, 0 end
    if missing and not self.rewardRetry and self.rewardTries < 6 then
        self.rewardRetry, self.rewardTries = true, self.rewardTries + 1
        C_Timer.After(0.8, function()
            Browser.rewardRetry = nil
            local e = Browser.selected
            if Browser.frame:IsShown() and e and e.kind == "profession" then Browser:PaintDetail() end
        end)
    end
end

--- nombre de un jefe en tu idioma (el de Spoken_Bosses si lo tiene; si no, en ingles)
local function BossName(inst, b)
    local data = _G.SpokenBosses
    local list = type(data) == "table" and data.maps and data.maps[inst]
    local loc = GetLocale and GetLocale()
    for _, x in ipairs(list or {}) do
        if x.key == b.key then return (loc and x[loc]) or x[1] or b.name end
    end
    return b.name
end

---------------------------------------------------------------------------
-- Filtro del botin: por clase (lo que puede llevar) y por tipo (tela, cuero, malla, placas, armas...)
---------------------------------------------------------------------------
local CLASS_ORDER = { "WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "SHAMAN", "MAGE", "WARLOCK", "DRUID" }
-- armadura mas pesada que puede llevar cada clase (1 tela, 2 cuero, 3 malla, 4 placas) y si lleva escudo
local ARMOR_MAX = { WARRIOR = 4, PALADIN = 4, HUNTER = 3, SHAMAN = 3, ROGUE = 2, DRUID = 2, PRIEST = 1, MAGE = 1, WARLOCK = 1 }
local SHIELD = { WARRIOR = true, PALADIN = true, SHAMAN = true }
-- reliquias: tratado (paladin), idolo (druida), totem (chaman)
local RELIC = { [7] = "PALADIN", [8] = "DRUID", [9] = "SHAMAN" }
-- armas que puede usar cada clase (subclases de arma del juego)
local WEAPONS = {
    WARRIOR = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 13, 15, 16, 18 }, PALADIN = { 0, 1, 4, 5, 6, 7, 8 },
    HUNTER = { 0, 1, 2, 3, 6, 7, 8, 10, 13, 15, 16, 18 }, ROGUE = { 2, 3, 4, 7, 13, 15, 16, 18 },
    PRIEST = { 4, 10, 15, 19 }, SHAMAN = { 0, 1, 4, 5, 10, 13, 15 }, MAGE = { 7, 10, 15, 19 },
    WARLOCK = { 7, 10, 15, 19 }, DRUID = { 4, 5, 10, 13, 15 },
}
local LOOT_TYPES = {
    { key = "CLOTH", text = "Cloth" }, { key = "LEATHER", text = "Leather" }, { key = "MAIL", text = "Mail" },
    { key = "PLATE", text = "Plate" }, { key = "SHIELD", text = "Shields" }, { key = "WEAPON", text = "Weapons" },
    { key = "JEWELRY", text = "Rings, necks and trinkets" }, { key = "RECIPE", text = "Recipes and plans" },
    { key = "OTHER", text = "Other items" },
}

local function ItemKind(id)
    local f = (C_Item and C_Item.GetItemInfoInstant) or _G.GetItemInfoInstant
    if not f then return nil end
    local ok, _, _, _, equipLoc, _, classID, subID = pcall(f, id)
    if not ok then return nil end
    return classID, subID, equipLoc
end

local function ClassName(cls)
    return (LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[cls]) or cls
end

function Browser:LootPasses(id)
    if not (self.lootClass or self.lootType) then return true end
    local classID, sub = ItemKind(id)
    if not classID then return true end
    local t = self.lootType
    if t then
        local kind = (classID == 4 and sub == 1 and "CLOTH") or (classID == 4 and sub == 2 and "LEATHER")
            or (classID == 4 and sub == 3 and "MAIL") or (classID == 4 and sub == 4 and "PLATE")
            or (classID == 4 and sub == 6 and "SHIELD") or (classID == 2 and "WEAPON")
            or (classID == 4 and "JEWELRY") or (classID == 9 and "RECIPE") or "OTHER"
        if kind ~= t then return false end
    end
    local cls = self.lootClass == "MINE" and select(2, UnitClass("player")) or self.lootClass
    if cls then
        if classID == 4 then
            if sub >= 1 and sub <= 4 then return sub <= (ARMOR_MAX[cls] or 1) end
            if sub == 6 then return SHIELD[cls] or false end
            if RELIC[sub] then return RELIC[sub] == cls end
            return true
        elseif classID == 2 then
            for _, w in ipairs(WEAPONS[cls] or {}) do if w == sub then return true end end
            return false
        end
        return t ~= nil   -- con solo el filtro de clase, fuera recetas y demas (no son equipo)
    end
    return true
end

function Browser:LootFilterText()
    local parts = {}
    if self.lootClass then parts[#parts + 1] = ClassName(self.lootClass == "MINE" and select(2, UnitClass("player")) or self.lootClass) end
    if self.lootType then
        for _, t in ipairs(LOOT_TYPES) do if t.key == self.lootType then parts[#parts + 1] = L[t.text] end end
    end
    return #parts > 0 and table.concat(parts, " · ") or L["Filter"]
end

function Browser:OpenLootFilter()
    local function set(field, v) return function() Browser[field] = v; QR.Menu:Close(); Browser:PaintDetail() end end
    local classes = { { text = L["All classes"], checked = self.lootClass == nil, func = set("lootClass", nil) },
                      { text = string.format(L["My class (%s)"], ClassName(select(2, UnitClass("player")))),
                        checked = self.lootClass == "MINE", func = set("lootClass", "MINE") }, QR.Menu.SPACER }
    for _, c in ipairs(CLASS_ORDER) do
        classes[#classes + 1] = { text = ClassName(c), checked = self.lootClass == c, func = set("lootClass", c) }
    end
    local types = { { text = L["All types"], checked = self.lootType == nil, func = set("lootType", nil) }, QR.Menu.SPACER }
    for _, t in ipairs(LOOT_TYPES) do
        types[#types + 1] = { text = L[t.text], checked = self.lootType == t.key, func = set("lootType", t.key) }
    end
    QR.Menu:Open({
        { text = L["Filter the loot"], header = true },
        { text = L["Class"], menu = function() return classes end },
        { text = L["Type"], menu = function() return types end },
        QR.Menu.SPACER,
        { text = L["Clear filter"], disabled = not (self.lootClass or self.lootType),
          func = function() Browser.lootClass, Browser.lootType = nil, nil; QR.Menu:Close(); Browser:PaintDetail() end },
    })
end

--- pestaña "Jefes y botin": cada jefe (con su audio de Spoken si lo hay) y, al desplegarlo, lo que suelta
function Browser:FillLoot(g, loot)
    local Sk, d = S(), self.frame.detail
    local keep = (self.lootShown == g.instanceId) and d.qscroll:GetVerticalScroll() or 0   -- al desplegar, no saltar
    self.lootShown = g.instanceId
    self:FillList(nil, nil, false)
    local width = W - DETAIL_X - 40 - BAR_W
    local audio = {}
    for _, b in ipairs(SpokenBosses(g.instanceId) or {}) do audio[b.key] = b end
    self.lootOpen = self.lootOpen or {}
    local y, n, missing, lastWing = 0, 0, false, nil
    local function Row()
        n = n + 1
        local r = QuestRow(d, n)
        r.text:SetWordWrap(false)
        r.text:SetAlpha(1)
        r.tip, r.questId, r.status, r.boss, r.reward, r.lootBoss = nil, nil, nil, nil, nil, nil
        r.right:SetText("")
        return r
    end
    for bi, b0 in ipairs(loot) do
        local b = { name = b0.name, key = b0.key, wing = b0.wing, loot = {} }
        for _, it in ipairs(b0.loot) do
            if self:LootPasses(it[1]) then b.loot[#b.loot + 1] = it end
        end
        if b.wing and b.wing ~= lastWing then
            lastWing = b.wing
            local h = Row()
            Sk:StyleText(h.text, "eyebrow", "ui")
            Size(h.text, 10.5)
            h.text:SetPoint("RIGHT", -10, 0)
            h.text:SetText(Sk:Hex("accent") .. b.wing:upper() .. "|r")
            h.bg:SetColorTexture(0, 0, 0, 0)
            h.hl:Hide()
            h:SetSize(width, QROW_H + 8)
            h:ClearAllPoints()
            h:SetPoint("TOPLEFT", 0, -(y + 4))
            h:Show()
            y = y + QROW_H + 12
        end
        local open = self.lootOpen[g.instanceId .. ":" .. b.key]
        local r = Row()
        Sk:StyleText(r.text, "subtitle", "ui")
        Sk:StyleText(r.right, "small", "ui")
        Size(r.text, 13)
        Size(r.right, 11)
        r.text:SetPoint("RIGHT", -100, 0)
        local arrow = string.format("|T%s:12:12|t ", Sk:UIIcon(open and "ArrowDown" or "ArrowRight"))
        r.text:SetText(arrow .. Sk:IconTag("dungeon", 16) .. " " .. BossName(g.instanceId, b)
            .. string.format("  |cff9a9f9c·  " .. L["%d items"] .. "|r", #b.loot))
        local cr, cg, cb = Sk:Color("card")
        r.bg:SetColorTexture(cr, cg, cb, 1)
        r.lootBoss = g.instanceId .. ":" .. b.key
        r.boss = audio[b.key]
        r.hl:Show()
        r:SetSize(width, QROW_H + 8)
        r:ClearAllPoints()
        r:SetPoint("TOPLEFT", 0, -(y + 2))
        r:Show()
        y = y + QROW_H + 10
        if open then
            -- con muchos objetos, en dos columnas
            local cols = #b.loot > 8 and 2 or 1
            local cw = cols == 2 and math.floor((width - 6) / 2) or width
            for i, it in ipairs(b.loot) do
                local col = (i - 1) % cols
                local q = Row()
                Sk:StyleText(q.text, "body", "ui")
                Sk:StyleText(q.right, "small", "ui")
                Size(q.text, 12)
                Size(q.right, 11)
                q.text:SetPoint("RIGHT", cols == 2 and -52 or -70, 0)
                local text, ok = ItemText(it[1])
                if not ok then missing = true end
                q.text:SetText((cols == 2 and "" or "    ") .. text)
                q.right:SetText(it[2] and string.format("|cff9a9f9c%s%%|r", it[2]) or "")
                local line = math.floor((i - 1) / cols)
                local c1, c2, c3 = Sk:Color(line % 2 == 1 and "card" or "background")
                q.bg:SetColorTexture(c1, c2, c3, 0.7)
                q.reward = { kind = "item", id = it[1] }
                q.hl:Show()
                q:SetSize(cw, QROW_H)
                q:ClearAllPoints()
                q:SetPoint("TOPLEFT", col * (cw + 6), -y)
                q:Show()
                if col == cols - 1 or i == #b.loot then y = y + QROW_H end
            end
            y = y + 4
        end
    end
    d.bossRows = next(audio) and true or nil
    self:PaintBossRows()
    for i = n + 1, #d.qrows do d.qrows[i]:Hide() end
    for i = 1, #d.lines do d.lines[i]:Hide() end
    d.qscroll.content:SetHeight(math.max(10, y))
    d.qscroll:SetVerticalScroll(math.min(keep, math.max(0, y - d.qscroll:GetHeight())))
    C_Timer.After(0, function() d.qscroll.bar:Sync() end)
    local key = "loot" .. g.instanceId
    if key ~= self.rewardKey then self.rewardKey, self.rewardTries = key, 0 end
    if missing and not self.rewardRetry and self.rewardTries < 6 then
        self.rewardRetry, self.rewardTries = true, self.rewardTries + 1
        C_Timer.After(0.8, function()
            Browser.rewardRetry = nil
            local e = Browser.selected
            if Browser.frame:IsShown() and e and e.guide and e.guide.instanceId == g.instanceId then Browser:PaintDetail() end
        end)
    end
end

--- fondo de una guia de clase: el mapa de su zona, recortado a la forma del banner y centrado en la cadena
local MAP_ASPECT = 1002 / 668   -- el mapa del juego (el BLP esta estirado a 1024x512)
--- banner de la clase (Media/Classes/<CLASE>.blp): a todo lo ancho, sin deformarlo (la imagen es 3:1 y el banner
--- mas apaisado: se ve la franja central)
function Browser:SetClassBanner(cls)
    -- version de la Horda si la hay (paladin no-muerto)
    if cls and QR.ClassBanners and UnitFactionGroup("player") == "Horde" and QR.ClassBanners[cls .. "_HORDE"] then
        cls = cls .. "_HORDE"
    end
    local aspect = cls and QR.ClassBanners and QR.ClassBanners[cls]
    if not aspect then return false end
    local d = self.frame.detail
    d.classMap:SetTexture("Interface\\AddOns\\QuestieRouter\\Media\\Classes\\" .. cls .. ".blp")
    local w, h = W - DETAIL_X - 16, ART_H
    local fh = math.min(1, aspect * h / w)
    local t = (1 - fh) / 2   -- centrada en vertical (el emblema de la derecha queda entero)
    d.classMap:SetTexCoord(0, 1, t, t + fh)
    d.classTint:SetColorTexture(0, 0, 0, 0.12)
    S():SetRounded(d.top, d.classMap)
    S():SetRounded(d.top, d.classTint)
    d.classMap:Show()
    d.classTint:Show()
    return true
end

function Browser:SetClassMap(g)
    local d = self.frame.detail
    local map = QR.Bridge and QR.Bridge.UiMapOf and QR.Bridge:UiMapOf(g.areaId)
    if not (map and QR.ZoneMaps and QR.ZoneMaps[map]) then return false end
    d.classMap:SetTexture("Interface\\AddOns\\QuestieRouter\\Media\\Maps\\" .. map .. ".blp")
    local w, h = W - DETAIL_X - 16, ART_H
    local fw = 0.62                            -- parte del ancho del mapa que se ve
    local fh = fw * MAP_ASPECT * h / w         -- la altura que le toca para no deformarlo
    local fx, fy = (g.focus and g.focus[1] or 50) / 100, (g.focus and g.focus[2] or 50) / 100
    local l = math.min(math.max(fx - fw / 2, 0), 1 - fw)
    local t = math.min(math.max(fy - fh / 2, 0), 1 - fh)
    d.classMap:SetTexCoord(l, l + fw, t, t + fh)
    d.classTint:SetColorTexture(0, 0, 0, 0.28)
    S():SetRounded(d.top, d.classMap)
    S():SetRounded(d.top, d.classTint)
    d.classMap:Show()
    d.classTint:Show()
    return true
end

--- texto de la derecha de cada jefe: Escuchar / Detener (se repinta con el sondeo del boton Escuchar)
function Browser:PaintBossRows()
    local d = self.frame and self.frame.detail
    if not d then return end
    for _, q in ipairs(d.qrows) do
        if q:IsShown() and q.boss then
            local on = BossPlaying(q.boss)
            q.right:SetText(on and ("|cff71d6a2" .. L["Stop"] .. "|r") or ("|cffd8c9a8" .. L["Listen"] .. "|r"))
        end
    end
end

function Browser:ToggleBoss(b)
    local SB, SP = _G.SpokenBossesAddon, _G.Spoken
    if not SB then return end
    if BossPlaying(b) then
        if SP and SP.Skip then SP:Skip() end
    else
        SB:PlayStory(b.map, b.key)
    end
    C_Timer.After(0.1, function() Browser:PaintBossRows() end)
end

--- ¿Suena (o esta en pausa) la zona elegida? Con Spoken, lo que diga su reproductor.
function Browser:IsListening()
    local SP = _G.SpokenPlaces
    if SP and SP.IsLoreAtHead and self.spokenMap then return SP:IsLoreAtHead(self.spokenMap, self.spokenKey) and true or false end
    return self.playing ~= nil
end

--- Escuchar / detener. Con Spoken, el audio va a su cola y a su reproductor: sale su ventana con el texto y los
--- controles, y sigue sonando aunque se cierre el menu o se cambie de pestaña (lo para el jugador desde alli).
function Browser:ToggleListen()
    local SP, map = _G.SpokenPlaces, self.spokenMap
    if SP and SP.PlayLore and map then
        if SP.IsLoreAtHead and SP:IsLoreAtHead(map, self.spokenKey) then
            if SP.StopLore then SP:StopLore() end
        else
            SP:PlayLore(map, self.spokenKey)
        end
        self.frame.detail.listen:Paint()
        return
    end
    -- sin el modulo de lugares de Spoken: el mp3 de su paquete directamente
    if self.playing then
        if StopSound and self.playing ~= true then StopSound(self.playing) end
        self.playing = nil
        self.frame.detail.listen:Paint()
        return
    end
    local z, pack = self.spoken, SpokenPack()
    if not (z and z.file and pack) then return end
    local ok, handle = PlaySoundFile("Interface\\AddOns\\" .. pack.addon .. "\\Sounds\\" .. z.file .. ".mp3", "Dialog")
    if not ok then return end
    self.playing = handle or true
    local mine = self.playing
    C_Timer.After((z.len or 60) + 0.5, function()
        if Browser.playing == mine then Browser.playing = nil; Browser.frame.detail.listen:Paint() end
    end)
    self.frame.detail.listen:Paint()
end

---------------------------------------------------------------------------
-- Mapa: la zona de la guia en el mapa del mundo (con OpenMap tambien: OpenMap trabaja sobre ese mismo mapa)
---------------------------------------------------------------------------
function Browser:MapFor(g)
    if not g then return nil end
    local map = QR.Bridge and QR.Bridge.UiMapOf and QR.Bridge:UiMapOf(g.areaId)
    -- mazmorra o zona sin mapa propio: el mapa de la zona de su ilustracion
    local info = map and C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
    local ZONE = Enum and Enum.UIMapType and Enum.UIMapType.Zone or 3
    if not info or (info.mapType and info.mapType > ZONE) then
        local key = S():KeyForGuide(g)
        local def = key and S().zones and S().zones[key]
        map = def and def.mapID or map
    end
    -- solo mapas del mundo (zona o continente): una mazmorra, una isla aparte o un mapa sin posicion en el mundo
    -- rompe OpenMap al cerrar el mapa (no tiene su rectangulo). Se sube por los padres hasta uno que si.
    local guard = 0
    while map and guard < 6 do
        info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
        local onWorld = info and (not info.mapType or info.mapType <= ZONE)
        if onWorld and C_Map.GetWorldPosFromMapPos and CreateVector2D then
            local ok, cont = pcall(C_Map.GetWorldPosFromMapPos, map, CreateVector2D(0.5, 0.5))
            onWorld = ok and cont ~= nil
        end
        if onWorld then return map end
        map = info and info.parentMapID ~= 0 and info.parentMapID or nil
        guard = guard + 1
    end
    return nil
end

--- ¿Este mapa esta en el mapa del mundo? (zona o continente con posicion; OpenMap no sabe dibujar los demas)
local function OnWorld(map)
    local info = map and C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
    local ZONE = Enum and Enum.UIMapType and Enum.UIMapType.Zone or 3
    if not info or (info.mapType and info.mapType > ZONE) then return false, info end
    if C_Map.GetWorldPosFromMapPos and CreateVector2D then
        local ok, cont = pcall(C_Map.GetWorldPosFromMapPos, map, CreateVector2D(0.5, 0.5))
        if not (ok and cont) then return false, info end
    end
    return true, info
end

--- donde ir para una mision: quien la da (o, si ya la llevas, quien la recoge): { uiMapId, x, y (0..1), name }
function Browser:QuestPoint(qid)
    local B = QR.Bridge
    if not (B and B.GetQuest and B.HBD) then return nil end
    local q = B:GetQuest(qid)
    if not q then return nil end
    local st = B:QuestStatus(qid)
    local holder = (st == "active" or st == "complete") and q.Finisher or q.Starts
    local ok, px, py, pinst = pcall(B.HBD.GetPlayerWorldPosition, B.HBD)
    if not ok then px, py, pinst = nil, nil, nil end
    local okp, p = pcall(B.NearestNpcOrObject, B, holder, px, py, pinst)
    return okp and p or nil
end

--- abre el mapa del mundo en el sitio de una mision y deja ahi una marca (la del juego, con su flecha en la brujula)
function Browser:ShowQuestOnMap(qid)
    local p = qid and self:QuestPoint(qid)
    local wm = _G.WorldMapFrame
    if not (p and p.uiMapId and wm) then return false end
    local map, x, y = p.uiMapId, p.x, p.y
    -- mazmorra o mapa aparte: el de la zona que lo contiene (con sus coordenadas pasadas a ese mapa)
    local guard = 0
    while map and not OnWorld(map) and guard < 6 do
        local _, info = OnWorld(map)
        local parent = info and info.parentMapID ~= 0 and info.parentMapID or nil
        if parent and QR.Bridge.HBD and QR.Bridge.HBD.TranslateZoneCoordinates then
            local nx, ny = QR.Bridge.HBD:TranslateZoneCoordinates(x, y, map, parent, true)
            if nx then x, y = nx, ny end
        end
        map, guard = parent, guard + 1
    end
    if not map then return false end
    if C_Map.SetUserWaypoint and UiMapPoint and (not C_Map.CanSetUserWaypointOnMap or C_Map.CanSetUserWaypointOnMap(map)) then
        pcall(C_Map.SetUserWaypoint, UiMapPoint.CreateFromCoordinates(map, x, y))
        if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then pcall(C_SuperTrack.SetSuperTrackedUserWaypoint, true) end
    end
    local q = QR.Bridge:GetQuest(qid)
    QR:Print(string.format(L["Marked on the map: %s (%s)"], (q and q.name or ("#" .. qid)) .. (p.name and (" · " .. p.name) or ""),
        (select(2, OnWorld(map)) or {}).name or "?"))
    self.frame:Hide()
    if not wm:IsShown() then
        if ToggleWorldMap then ToggleWorldMap() elseif ShowUIPanel then ShowUIPanel(wm) else wm:Show() end
    end
    if wm.SetMapID then wm:SetMapID(map) end
    return true
end

--- boton Mapa: la siguiente mision que hay que coger de la guia (la primera disponible; si no, la primera sin hacer;
--- si ya estan todas, la primera). Sin punto conocido, la zona de la guia.
function Browser:OpenMap()
    local e = self.selected
    local g = e and e.guide
    if not g then return end
    local rows = QR.Planner and QR.Planner.GetQuestRows and QR.Planner:GetQuestRows(g) or {}
    local pick
    for _, r in ipairs(rows) do if r.status == "available" then pick = r.questId break end end
    if not pick then for _, r in ipairs(rows) do if r.status ~= "done" then pick = r.questId break end end end
    if not pick and rows[1] then pick = rows[1].questId end
    if pick and self:ShowQuestOnMap(pick) then return end
    local map = self:MapFor(g)
    if not map then return end
    local wm = _G.WorldMapFrame
    if not wm then return end
    self.frame:Hide()
    if not wm:IsShown() then
        if ToggleWorldMap then ToggleWorldMap() elseif ShowUIPanel then ShowUIPanel(wm) else wm:Show() end
    end
    if wm.SetMapID then wm:SetMapID(map) end
end

---------------------------------------------------------------------------
-- Estado y acciones
---------------------------------------------------------------------------
function Browser:SectionInfo(key)
    if key == "OPTIONS" then return OPTIONS end
    for _, s in ipairs(SECTIONS) do if s.key == key then return s end end
    return SECTIONS[1]
end

function Browser:SelectSection(key)
    local f = self.frame
    -- una seccion desactivada (Speedrun, aun sin guias) no se abre: zonas
    for _, sec in ipairs(SECTIONS) do if sec.key == key and sec.disabled then key = "ZONES" end end
    self.section = key
    if key == "OPTIONS" then
        -- las opciones se crean la primera vez, dentro de su panel
        if not QR.Options.frame then QR.Options:Create(f.options.host) end
        f.detail:Hide()
        f.options:Show()
        QR.Options.onScroll = function() Browser:FollowOptionsScroll() end
        QR.Options:Refresh()
    else
        f.options:Hide()
        f.detail:Show()
    end
    self.entries = self:Entries(key)
    -- elegir: la guia activa si esta aqui; si no, la recomendada; si no, la primera seleccionable
    local pick
    for _, e in ipairs(self.entries) do if e.active then pick = e break end end
    if not pick then for _, e in ipairs(self.entries) do if e.suggested then pick = e break end end end
    if not pick then
        for _, e in ipairs(self.entries) do if e.kind ~= "header" and e.kind ~= "event" then pick = e break end end
    end
    self.selected = pick
    self.scrollToSelected = true
    self:Refresh()
end

function Browser:Select(e)
    if e.kind == "event" then
        self.collapsed = self.collapsed or {}
        self.collapsed[e.ev.key] = e.open and true or nil
        self.entries = self:Entries(self.section)
        self:PaintList()
        self:PaintChrome()
        self:QueueRepaint()
        return
    end
    self.selected = e
    if e.kind == "optsec" then
        QR.Options:ScrollToSection(e.index)
        self:PaintList()
        return
    end
    self:Refresh()
end

--- en Opciones, el indice marca la seccion que se esta viendo mientras se desplaza la lista
function Browser:FollowOptionsScroll()
    if self.section ~= "OPTIONS" or not (self.frame and self.frame:IsShown()) then return end
    local i = QR.Options:CurrentSection()
    if not i or (self.selected and self.selected.index == i) then return end
    for _, e in ipairs(self.entries or {}) do
        if e.index == i then self.selected = e break end
    end
    self:PaintList()
end

function Browser:LoadSelected()
    local e = self.selected
    if e and e.kind == "skill" and e.guideKey then
        local key = e.guideKey
        self.classTab = "quests"
        self:SelectSection("CLASS")
        for _, x in ipairs(self.entries) do
            if x.guide and x.guide.key == key then self.selected = x break end
        end
        self.scrollToSelected = true
        self:Refresh()
        return
    end
    if not (e and (e.kind == "guide" or e.kind == "evguide")) then return end
    QR.Planner:SetGuide(e.guide.key)
    if QR.GuideUI and QR.GuideUI.SetShown then QR.GuideUI:SetShown(true) end
    QR:Print(string.format(L["Active guide: %s"], e.event and L[e.guide.titleKey] or QR.GuideLabel(e.guide)))
    self.frame:Hide()
end

--- barra de secciones y cabecera de la lista
function Browser:PaintChrome()
    local Sk, f = S(), self.frame
    Sk:PaintCard(f.bg, "background", 0.98, "ui")
    Sk:PaintCard(f.rail, "header", 1, "ui")
    Sk:PaintCard(f.options.bg, "header", 0.98, "ui")
    local ar, ag, ab = Sk:TextAccent()
    for _, b in ipairs(f.tabs) do
        local on = b.section.key == self.section
        local off = b.section.disabled
        Sk:StyleText(b.label, "small", "ui")
        Size(b.label, 10.5)
        b.label:SetText(L[b.section.short])
        if off then
            b.label:SetTextColor(0.42, 0.43, 0.42)
            b.icon:SetVertexColor(0.36, 0.37, 0.36)
            b.hl:SetAlpha(0)   -- desactivado: sin resaltado al pasar el raton
        else
            b.hl:SetAlpha(1)
            b.label:SetTextColor(on and 1 or 0.74, on and 1 or 0.76, on and 1 or 0.74)
            if on then b.icon:SetVertexColor(ar, ag, ab) else b.icon:SetVertexColor(0.74, 0.76, 0.74) end
        end
        b.sel:SetColorTexture(ar, ag, ab, on and 0.12 or 0)
        b.bar:SetColorTexture(ar, ag, ab, on and 1 or 0)
    end
    local sec = self:SectionInfo(self.section)
    Sk:StyleText(f.eyebrow, "eyebrow", "ui")
    Sk:StyleText(f.title, "title", "ui")
    Sk:StyleText(f.sub, "small", "ui")
    Size(f.eyebrow, 10)
    Size(f.title, 18)
    Size(f.sub, 11)
    f.eyebrow:SetText("QUESTIEROUTER")
    f.eyebrow:SetTextColor(ar, ag, ab)
    f.title:SetText(L[sec.title])
    f.title:SetTextColor(1, 1, 1)
    local n = 0
    for _, e in ipairs(self.entries) do
        if e.kind == "guide" or e.kind == "profession" or e.kind == "evguide" then n = n + 1 end
        if e.kind == "event" and not e.open then n = n + #e.ev.sections end
    end
    f.sub:SetText(n > 0 and (L[sec.desc] .. "  ·  " .. string.format(L["%d guides"], n)) or L[sec.desc])
    f.sub:SetTextColor(0.74, 0.76, 0.74)
    -- pestañas de la lista: solo en Clase y si hay habilidades de la clase
    local tabs = self.section == "CLASS" and QR.ClassSkills ~= nil
    f.listTabs:SetShown(tabs)
    f.scroll:ClearAllPoints()
    f.scroll:SetPoint("TOPLEFT", 12, tabs and -132 or -100)
    f.scroll:SetPoint("BOTTOMRIGHT", -14 - BAR_W, 12)
    if tabs then
        f.listTabBtn[1].text:SetText(string.format(L["Quests (%d)"], #QR.classGuides))
        f.listTabBtn[2].text:SetText(L["Skills"])
        f.listTabBtn[1]:Paint(); f.listTabBtn[2]:Paint()
    end
end

--- filas de la lista
function Browser:PaintList()
    local f = self.frame
    local width = LIST_W - 26 - BAR_W
    local y, selY = 0, nil
    for i, e in ipairs(self.entries) do
        local row = self:GetRow(i)
        local indent = (e.kind == "evguide") and 14 or 0
        local h = self:PaintRow(row, e, width - indent)
        if e.kind == "evguide" and self.entries[i + 1] and self.entries[i + 1].kind ~= "evguide" then h = h + 6 end
        if SameEntry(e, self.selected) then selY = y end
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", indent, -y)
        row:Show()
        y = y + h
    end
    for i = #self.entries + 1, #f.rows do f.rows[i]:Hide() end
    f.scroll.content:SetHeight(math.max(10, y))
    if self.scrollToSelected then
        self.scrollToSelected = nil
        local max = math.max(0, y - f.scroll:GetHeight())
        f.scroll:SetVerticalScroll(math.min(max, math.max(0, (selY or 0) - ROW_GUIDE)))
    end
    f.scroll.bar:Sync()
end

function Browser:Refresh()
    self:PaintChrome()
    self:PaintList()
    if self.section ~= "OPTIONS" then self:PaintDetail() end
    self:QueueRepaint()
end

--- Repinta las miniaturas visibles. Las filas toman su tamaño en el siguiente fotograma: el primer pintado de
--- una miniatura nueva ve ancho 0 y no pinta (se quedaba el fondo en blanco hasta volver a abrir el menu).
function Browser:RepaintArt()
    local f = self.frame
    if not (f and f:IsShown()) then return end
    for _, row in ipairs(f.rows) do
        if row:IsShown() and row.banner:IsShown() then row.banner:Paint() end
    end
    if f.detail:IsShown() then f.detail.art:Paint() end
    -- opciones: la primera vez el panel aun no tiene ancho al colocarlas; se recolocan con su tamaño real
    if self.section == "OPTIONS" and QR.Options.frame then
        QR.Options:Refresh()
        self.entries = self:Entries("OPTIONS")
        self:PaintList()
    end
    f.scroll.bar:Sync()
    f.detail.qscroll.bar:Sync()
end

function Browser:QueueRepaint()
    C_Timer.After(0, function() Browser:RepaintArt() end)
    C_Timer.After(0.3, function() Browser:RepaintArt() end)
end

--- Cielos e ilustraciones de todas las zonas en memoria (como los iconos del addon, ver Skin.lua): asi las
--- tarjetas no salen vacias mientras se cargan las imagenes la primera vez
function Browser:PreloadArt()
    if self.preloaded or not QR.PreloadTexture then return end
    self.preloaded = true
    local Sk = S()
    for _, key in ipairs(Sk.zoneOrder or {}) do
        local k = type(key) == "table" and key.key or key
        QR:PreloadTexture(Sk:GetSky(k))
        QR:PreloadTexture((Sk:GetOrnament(k)))
    end
end

function Browser:Open(section)
    if not QR.ready then QR:WhenReady(function() Browser:Open(section) end) return end
    if not self.frame then self:Create() end
    self:PreloadArt()
    self.frame:Show()
    -- las miniaturas necesitan su tamaño real: pintar en el siguiente frame
    C_Timer.After(0, function() Browser:SelectSection(section or Browser.section or "ZONES") end)
end

function Browser:Toggle(section)
    if self.frame and self.frame:IsShown() then self.frame:Hide() else self:Open(section) end
end

-- precarga de las imagenes unos segundos despues de entrar (sin frenar la carga del juego)
QR:RegisterModule("Browser", function()
    C_Timer.After(8, function() Browser:PreloadArt() end)
    QR:On("SETTINGS_CHANGED", function()
        if Browser.frame and Browser.frame:IsShown() and Browser.section == "OPTIONS" then Browser:PaintChrome() end
    end)
end)

-- QuestieRouter: registro de guias por zona.
-- Los archivos Zones/<Faccion>/<Faccion>_<Zona>_<min>-<max>.lua los genera tools/zone_guides.py
-- y llaman a QR:RegisterZoneGuide. Este archivo se carga antes que ellos (ver .toc).

local _, QR = ...

QR.zoneGuides = {}      -- lista ordenada por nivel minimo
QR.dungeonGuides = {}   -- guias de mazmorra (Dungeons/, tools/dungeon_guides.py)
QR.zoneGuideByKey = {}  -- todas las guias (de zona y de mazmorra) por clave
QR.eventGuides = {}     -- secciones de los eventos activos (Guide/Events.lua)
QR.otherGuides = {}     -- otras guias: saco de dormir, libros de la biblioteca... (Others/Others.lua)
QR.classGuides = {}     -- cadenas de misiones de tu clase (Classes/, tools/class_guides.py)
QR.professionGuides = {} -- profesiones de 1 a 300 por skillLine (Professions/, tools/profession_guides.py)

-- Categorias de guias.
-- name y desc son claves de traduccion: se muestran con L[cat.name] / L[cat.desc].
QR.guideCategories = {
    { key = "ZONES", name = "Zone completion guides", desc = "Every quest in each zone, in order", guides = QR.zoneGuides },
    { key = "DUNGEONS", name = "Dungeon guides", desc = "Dungeon quests and routes", guides = QR.dungeonGuides },
    { key = "PROFESSIONS", name = "Profession guides", desc = "Level up professions", guides = {} },
    { key = "CLASS", name = "Class guides", desc = "Class quests, spells and trainers", guides = QR.classGuides },
    -- eventos del mundo (Guide/Events.lua): su menu lista los activos y, aparte, "Proximamente"
    { key = "EVENTS", name = "Event guides", desc = "World events, as they arrive in the game", guides = QR.eventGuides,
      menu = function() return QR.Events:MenuEntries() end },
    { key = "SPEEDRUN", name = "Speedrun guides", desc = "Level up as fast as possible", guides = {} },
    { key = "OTHER", name = "Other guides", desc = "Reputations, collectibles and more", guides = QR.otherGuides },
}

--- Nombre visible de una guia de zona (nombre de la zona en el idioma del cliente)
function QR.GuideLabel(g)
    -- guia de clase: el nombre de lo que consigues (la recompensa principal: una habilidad antes que un objeto), en
    -- el idioma del juego; sin recompensa conocida, el de la ultima mision de la cadena
    if g.class then
        if g.misc then return QR.L["More class quests"] end
        local name = QR.ClassRewardName and QR.ClassRewardName(g)
        if name then return (g.labelSuffix and (name .. g.labelSuffix)) or name end
        local q = QR.Bridge and QR.Bridge.GetQuest and QR.Bridge:GetQuest(g.titleQuest)
        name = (q and q.name) or g.zone or ("#" .. g.titleQuest)
        return (g.labelSuffix and (name .. g.labelSuffix)) or name
    end
    -- otras guias: titulo propio (Saco de dormir acogedor, Libros de la biblioteca...)
    if g.titleKey and not g.event then return QR.L[g.titleKey] end
    -- seccion de un evento: "Feria de la Luna Negra · Vales para todos los premios"
    if g.event then return QR.L[g.eventName] .. " · " .. QR.L[g.titleKey] end
    -- mazmorra: nombre de la instancia en el idioma del cliente
    if g.instanceId then
        local n = GetRealZoneText and g.instanceId > 0 and GetRealZoneText(g.instanceId)
        if type(n) == "string" and n ~= "" then return n end
        return g.zone
    end
    local map = QR.Bridge and QR.Bridge.UiMapOf and QR.Bridge:UiMapOf(g.areaId)
    local info = map and C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
    local name = info and info.name or g.zone
    -- zona de misiones JcJ (p. ej. Islas Lanza Negra): se avisa al final del nombre
    if g.pvp then name = name .. " (PvP)" end
    return name
end

local playerFaction = UnitFactionGroup("player")

function QR:RegisterZoneGuide(g, list)
    -- Solo guardamos las de nuestra faccion (las otras no sirven y ocupan memoria).
    if playerFaction and g.faction ~= playerFaction then return end

    g.order = {}   -- questId -> posicion en la lista
    g.info = {}    -- questId -> { level, reqLevel, later }
    for i, row in ipairs(g.quests) do
        g.order[row[1]] = i
        g.info[row[1]] = { level = row[2], reqLevel = row[3] }
    end
    for _, row in ipairs(g.later or {}) do
        g.info[row[1]] = { level = row[2], reqLevel = row[3], later = true }
    end

    table.insert(list or QR.zoneGuides, g)
    QR.zoneGuideByKey[g.key] = g
end

--- Guia de mazmorra: mismas misiones y planificador; ademas g.dungeon (entrada en Data/Dungeons.lua), a la que
--- lleva el planificador cuando lo que queda esta dentro de la mazmorra
function QR:RegisterDungeonGuide(g)
    self:RegisterZoneGuide(g, QR.dungeonGuides)
end

--- Guias de clase (Classes/<CLASE>.lua, solo se carga el de tu clase): se quitan las misiones de otras razas
--- (4.o campo de cada fila) y no se registran las que se quedan vacias (variantes de otra raza o zona de inicio)
local playerRaceBit
local function ForMyRace(races)
    if not races or races == 0 then return true end
    if not playerRaceBit then
        local id = select(3, UnitRace("player")) or 0
        playerRaceBit = id > 0 and 2 ^ (id - 1) or 0
    end
    if playerRaceBit == 0 then return true end
    -- sin libreria de bits: las mascaras pasan de 32 bits
    return math.floor(races / playerRaceBit) % 2 == 1
end

--- nombre de la recompensa principal de una guia de clase (la primera de g.rewards que no es reputacion)
function QR.ClassRewardName(g)
    for _, r in ipairs(g.rewards or {}) do
        if r[1] == "spell" then
            local name
            if C_Spell and C_Spell.GetSpellName then name = C_Spell.GetSpellName(r[2])
            elseif C_Spell and C_Spell.GetSpellInfo then local i = C_Spell.GetSpellInfo(r[2]); name = i and i.name
            elseif _G.GetSpellInfo then name = (_G.GetSpellInfo(r[2])) end
            return name
        elseif r[1] == "item" or r[1] == "choice" then
            if r[1] == "choice" then return nil end   -- a elegir: ninguno manda; el titulo es el de la mision
            local name = C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(r[2])
            if not name and C_Item and C_Item.RequestLoadItemDataByID then pcall(C_Item.RequestLoadItemDataByID, r[2]) end
            return name
        end
    end
end

function QR:RegisterClassGuide(g)
    local keep = {}
    for _, row in ipairs(g.quests) do
        if ForMyRace(row[4]) then keep[#keep + 1] = row end
    end
    if #keep == 0 then return end
    g.quests = keep
    local lo, hi
    for _, row in ipairs(keep) do
        lo = math.min(lo or row[2], row[2]); hi = math.max(hi or row[2], row[2])
    end
    g.minLevel, g.maxLevel = lo, hi
    self:RegisterZoneGuide(g, QR.classGuides)
end

--- Guia de profesion (Professions/<profesion>.lua): pasos de entrenar, aprender, comprar, reunir y fabricar
function QR:RegisterProfessionGuide(g)
    QR.professionGuides[g.skillLine] = g
end

--- Otras guias (Others/Others.lua): mismas misiones y planificador, con titulo y descripcion propios
function QR:RegisterOtherGuide(g)
    self:RegisterZoneGuide(g, QR.otherGuides)
end

local function SortGuides()
    for _, list in ipairs({ QR.zoneGuides, QR.dungeonGuides, QR.otherGuides, QR.classGuides }) do
        table.sort(list, function(a, b)
            if (a.misc and true or false) ~= (b.misc and true or false) then return not a.misc end   -- sueltas al final
            if a.minLevel ~= b.minLevel then return a.minLevel < b.minLevel end
            return a.key < b.key
        end)
    end
end

--- Guia recomendada: la de la zona actual que encaje con el nivel; si no, la mas cercana en nivel.
function QR:SuggestZoneGuide()
    local level = UnitLevel("player")
    local mapId = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    local best, bestScore
    for _, g in ipairs(QR.zoneGuides) do
        local score
        if level < g.minLevel then score = (g.minLevel - level) * 2
        elseif level > g.maxLevel then score = (level - g.maxLevel) * 3
        else score = 0 end
        if mapId and QR.Bridge.UiMapOf and QR.Bridge:UiMapOf(g.areaId) == mapId then score = score - 5 end
        if not bestScore or score < bestScore then best, bestScore = g, score end
    end
    return best
end

--- Las claves de las guias de zona eran "<Faccion>_<Zona>_<min>-<max>"; ahora son "<Faccion>_<Zona>" (el rango
--- sale del mapa del juego y puede cambiar sin romper la guia activa ni su historial). Se pasan las guardadas.
local function NewKey(old)
    if type(old) ~= "string" or QR.zoneGuideByKey[old] then return old end
    local base = old:match("^(.+)_%d+%-%d+$")
    return (base and QR.zoneGuideByKey[base]) and base or old
end

local function MigrateKeys()
    local c = QR.charDB
    if not c then return end
    c.activeGuide = NewKey(c.activeGuide)
    if type(c.history) == "table" then
        local moves = {}   -- (no se pueden añadir claves mientras se recorre la tabla)
        for k in pairs(c.history) do
            local nk = NewKey(k)
            if nk ~= k then moves[k] = nk end
        end
        for k, nk in pairs(moves) do
            if c.history[nk] == nil then c.history[nk] = c.history[k] end
            c.history[k] = nil
        end
    end
end

QR:RegisterModule("ZoneGuides", function() SortGuides(); MigrateKeys() end, true)

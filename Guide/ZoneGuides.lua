-- QuestieRouter: registro de guias por zona.
-- Los archivos Zones/<Faccion>/<Faccion>_<Zona>_<min>-<max>.lua los genera tools/zone_guides.py
-- y llaman a QR:RegisterZoneGuide. Este archivo se carga antes que ellos (ver .toc).

local _, QR = ...

QR.zoneGuides = {}      -- lista ordenada por nivel minimo
QR.dungeonGuides = {}   -- guias de mazmorra (Dungeons/, tools/dungeon_guides.py)
QR.zoneGuideByKey = {}  -- todas las guias (de zona y de mazmorra) por clave

-- Categorias de guias.
-- name y desc son claves de traduccion: se muestran con L[cat.name] / L[cat.desc].
QR.guideCategories = {
    { key = "ZONES", name = "Zone completion guides", desc = "Every quest in each zone, in order", guides = QR.zoneGuides },
    { key = "DUNGEONS", name = "Dungeon guides", desc = "Dungeon quests and routes", guides = QR.dungeonGuides },
    { key = "PROFESSIONS", name = "Profession guides", desc = "Level up professions", guides = {} },
    { key = "SPEEDRUN", name = "Speedrun guides", desc = "Level up as fast as possible", guides = {} },
}

--- Nombre visible de una guia de zona (nombre de la zona en el idioma del cliente)
function QR.GuideLabel(g)
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

local function SortGuides()
    for _, list in ipairs({ QR.zoneGuides, QR.dungeonGuides }) do
        table.sort(list, function(a, b)
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

QR:RegisterModule("ZoneGuides", function() SortGuides(); MigrateKeys() end)

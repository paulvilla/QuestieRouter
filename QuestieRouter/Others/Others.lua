-- QuestieRouter: "Otras guias" (seccion Otras del menu de guias).
-- Escritas a mano: solo los ID de las misiones y sus niveles (datos de QuestieDB); la ruta, el orden en el mapa y
-- el estado de cada mision los calcula el planificador como en las guias de zona.
--   { questId, nivelMision, nivelRequerido }
local _, QR = ...

-- Saco de dormir acogedor: una cadena de notas escondidas por los dos continentes. Cada faccion empieza en unos
-- Restos quemados distintos (Alianza: Paramos de Poniente; Horda: Los Baldios) y luego sigue la misma cadena.
local COZY = {
    { 79192, 24, 14 }, -- Stepping Stones (Sierra Espolon)
    { 79980, 24, 14 }, -- Scramble
    { 79974, 32, 14 }, -- Wet Job (Loch Modan)
    { 79975, 32, 14 }, -- Eagle's Fist (Los Humedales / Trabalomas)
    { 79976, 32, 14 }, -- This Must Be The Place (Tierras Altas de Arathi)
}

local function Cozy(faction, first, areaId, zone)
    local quests = { first }
    for _, q in ipairs(COZY) do quests[#quests + 1] = q end
    QR:RegisterOtherGuide({
        key = faction .. "_Other_CozySleepingBag",
        faction = faction,
        titleKey = "Cozy Sleeping Bag",
        descKey = "A trail of hidden notes across both continents leads to the Cozy Sleeping Bag, and along the way you get a 12-slot Old Toolbox.",
        zone = zone, areaId = areaId,
        minLevel = 14, maxLevel = 32,
        -- pasa por zonas disputadas (Sierra Espolon, Los Humedales, Trabalomas, Arathi): dificil por el JcJ
        pvp = true, group = true,
        quests = quests,
    })
end
Cozy("Alliance", { 79008, 22, 14 }, 40, "Westfall")
Cozy("Horde", { 79007, 22, 14 }, 17, "The Barrens")

-- Libros de la biblioteca: libros y pergaminos perdidos por el mundo; cada uno se entrega al bibliotecario de tu
-- faccion (Garion Wendell en Ventormenta, Owen Thadd en Entrañas). Al juntar varios se desbloquean las misiones
-- de recompensa (Amigo de la Biblioteca y Gran amigo de la Biblioteca).
local LIBRARY = {
    { 78124, 20, 1 }, { 78127, 20, 1 }, { 78142, 20, 1 }, { 78143, 20, 1 }, { 78145, 20, 1 }, { 78146, 20, 1 },
    { 78147, 20, 1 }, { 78148, 20, 1 }, { 78149, 20, 1 }, { 79091, 20, 1 }, { 79092, 20, 1 }, { 79093, 20, 1 },
    { 79094, 20, 1 }, { 79095, 20, 1 }, { 79097, 20, 1 },
    { 78150, 20, 1 },  -- Friend of the Library (recompensa)
    { 79535, 35, 1 }, { 79947, 35, 1 }, { 79948, 35, 1 }, { 79949, 35, 1 }, { 79950, 35, 1 }, { 79951, 35, 1 },
    { 79952, 35, 1 },
    { 79536, 35, 20 }, -- Greater Friend of the Library (recompensa)
    { 81947, 45, 1 }, { 81949, 45, 1 }, { 81952, 45, 1 }, { 81953, 45, 1 }, { 81954, 45, 1 }, { 81955, 45, 1 },
    { 81956, 45, 1 },
    { 82208, 45, 35 }, -- Greater Friend of the Library (recompensa)
    { 84396, 60, 1 }, { 84397, 60, 1 }, { 84398, 60, 1 }, { 84399, 60, 1 }, { 84402, 60, 1 },
}

local function Library(faction, areaId, zone)
    QR:RegisterOtherGuide({
        key = faction .. "_Other_LibraryBooks",
        faction = faction,
        titleKey = "Library Books",
        descKey = "Lost books and scrolls all over the world. Hand each one in to your faction's librarian for experience; collecting enough of them unlocks the library's reward quests.",
        zone = zone, areaId = areaId,
        minLevel = 15, maxLevel = 60,
        group = true,
        quests = LIBRARY,
    })
end
Library("Alliance", 1519, "Stormwind City")
Library("Horde", 1497, "Undercity")

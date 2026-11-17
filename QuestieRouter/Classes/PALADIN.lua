-- Generado por tools/class_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Guías de clase: PALADIN
local _, QR = ...
if select(2, UnitClass("player")) ~= "PALADIN" then return end

QR:RegisterClassGuide({
    key = "Alliance_Class_PALADIN_79940",
    faction = "Alliance",
    class = "PALADIN",
    titleQuest = 79940,
    minLevel = 40,
    maxLevel = 40,
    areaId = 405,
    zone = "Desolace",
    focus = { 52.7, 84.8 },   -- punto medio de la cadena en el mapa de la zona
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 79939, 40, 35, 4294967373 }, -- The Broken Hammer
        { 79940, 40, 35, 4294967373 }, -- A Lost Brother
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_PALADIN_79970",
    faction = "Alliance",
    class = "PALADIN",
    titleQuest = 79970,
    minLevel = 40,
    maxLevel = 40,
    areaId = 1519,
    zone = "Stormwind City",
    focus = { 48.5, 49.1 },   -- punto medio de la cadena en el mapa de la zona
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 79945, 40, 35, 4294967373 }, -- Orders from the Grand Crusader
        { 79946, 40, 35, 4294967373 }, -- A Brother In Need
        { 79963, 40, 35, 4294967373 }, -- By The Light's Grace
        { 79970, 40, 35, 4294967373 }, -- Aeonas the Vindicated
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_PALADIN_1788",
    faction = "Alliance",
    class = "PALADIN",
    titleQuest = 1788,
    minLevel = 12,
    maxLevel = 13,
    areaId = 1537,
    zone = "Ironforge",
    focus = { 25.1, 20.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 7328, 0 },
        { "item", 6866, 1790 },
        { "item", 6916, 1645 },
        { "item", 6775, 1641 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1641, 12, 12, 1 }, -- El Libro de la Divinidad
        { 1642, 12, 12, 1 }, -- El Libro de la Divinidad
        { 1643, 12, 12, 1 }, -- El Libro de la Divinidad
        { 1645, 12, 12, 4 }, -- El Libro de la Divinidad
        { 1646, 12, 12, 4 }, -- El Libro de la Divinidad
        { 1647, 12, 12, 4 }, -- El Libro de la Divinidad
        { 2997, 12, 12, 4 }, -- El Libro de la Divinidad
        { 2998, 12, 12, 1 }, -- Libro de la Divinidad
        { 2999, 12, 12, 4 }, -- El Libro de la Divinidad
        { 3000, 12, 12, 4 }, -- El Libro de la Divinidad
        { 3681, 12, 12, 1 }, -- Libro de la Divinidad
        { 1644, 13, 12, 1 }, -- El Libro de la Divinidad
        { 1648, 13, 12, 4 }, -- El Libro de la Divinidad
        { 1778, 13, 12, 4 }, -- El Libro de la Divinidad
        { 1779, 13, 12, 4 }, -- El Libro de la Divinidad
        { 1789, 12, 12, 4 }, -- El Símbolo de la Vida
        { 1780, 13, 12, 1 }, -- El Libro de la Divinidad
        { 1781, 13, 12, 1 }, -- El Libro de la Divinidad
        { 1790, 12, 12, 1 }, -- El Símbolo de la Vida
        { 1783, 13, 12, 4 }, -- El Libro de la Divinidad
        { 1784, 13, 12, 4 }, -- El Libro de la Divinidad
        { 1785, 13, 12, 4 }, -- El Libro de la Divinidad
        { 1786, 13, 12, 1 }, -- Libro de la Divinidad
        { 1787, 13, 12, 1 }, -- Libro de la Divinidad
        { 1788, 13, 12, 1 }, -- Libro de la Divinidad
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_PALADIN_1806",
    faction = "Alliance",
    class = "PALADIN",
    titleQuest = 1806,
    minLevel = 20,
    maxLevel = 25,
    areaId = 1519,
    zone = "Stormwind City",
    focus = { 50.5, 47.5 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 5502, 0 },
        { "item", 6953, 1806 },
        { "item", 9607, 1652 },
        { "item", 6993, 1655 },
        { "item", 7083, 1442 },
        { "item", 6776, 1794 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1649, 20, 20, 5 }, -- Libro del valor
        { 1793, 20, 20, 5 }, -- Libro del valor
        { 1794, 20, 20, 5 }, -- Libro del valor
        { 1442, 22, 20, 5 }, -- La búsqueda de la gema Kor
        { 1655, 22, 20, 5 }, -- Envío de minerales de Bailor
        { 1650, 23, 20, 5 }, -- Libro del valor
        { 1651, 25, 20, 5 }, -- Libro del valor
        { 1652, 25, 20, 5 }, -- Libro del valor
        { 1653, 21, 20, 5 }, -- La prueba de rectitud
        { 1654, 22, 20, 5 }, -- La prueba de rectitud
        { 1806, 22, 20, 5 }, -- La prueba de rectitud
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_PALADIN_1661",
    faction = "Alliance",
    class = "PALADIN",
    titleQuest = 1661,
    minLevel = 40,
    maxLevel = 40,
    areaId = 1519,
    zone = "Stormwind City",
    focus = { 50.5, 47.5 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 13819, 1661 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1661, 40, 40, 5 }, -- Libro de la nobleza
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_PALADIN_8418",
    faction = "Alliance",
    class = "PALADIN",
    titleQuest = 8418,
    minLevel = 52,
    maxLevel = 52,
    areaId = 28,
    zone = "Western Plaguelands",
    focus = { 45.8, 83.8 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20620, 8418 },
        { "choice", 20504, 8418 },
        { "choice", 20512, 8418 },
        { "choice", 20505, 8418 },
        { "rep", 529, 300 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8415, 52, 50, 5 }, -- Campamento del Orvallo
        { 8414, 52, 50, 5 }, -- Expulsión de los demonios
        { 8416, 52, 50, 5 }, -- Piedras inertes de la Plaga
        { 8418, 52, 50, 5 }, -- La forja de la piedra de poderío
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_PALADIN_78093",
    faction = "Alliance",
    class = "PALADIN",
    titleQuest = 78093,
    minLevel = 30,
    maxLevel = 30,
    areaId = 1519,
    zone = "Stormwind City",
    focus = { 42.8, 72.5 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 277205, 0 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 78088, 30, 22, 4294967373 }, -- A Strange Artifact
        { 78089, 30, 22, 4294967373 }, -- Advice From Stormwind
        { 78090, 30, 22, 5 }, -- A Second Opinion
        { 78091, 30, 22, 5 }, -- Earning Your Salt
        { 78092, 30, 22, 5 }, -- It Must Be Destroyed
        { 78093, 30, 22, 5 }, -- Return to Delgren
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_PALADIN_7509",
    faction = "Alliance",
    class = "PALADIN",
    titleQuest = 7509,
    minLevel = 60,
    maxLevel = 60,
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 18348, 7509 },
        { "rep", 809, 400 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 7507, 60, 60 }, -- Compendio de Nostro
        { 7508, 60, 60 }, -- Forjar Quel'Serrar
        { 7509, 60, 60 }, -- Forjar Quel'Serrar
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_PALADIN_8048",
    faction = "Alliance",
    class = "PALADIN",
    titleQuest = 8048,
    minLevel = 60,
    maxLevel = 60,
    areaId = 33,
    zone = "Stranglethorn Vale",
    focus = { 15.3, 14.4 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "rep", 270, 400 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8045, 60, 60, 4294967373 }, -- La Enseña del pagano.
        { 8046, 60, 60, 4294967373 }, -- La Enseña del pagano.
        { 8047, 60, 60, 4294967373 }, -- La Enseña del pagano.
        { 8048, 60, 60, 4294967373 }, -- La Enseña del héroe
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_PALADIN_7666",
    faction = "Alliance",
    class = "PALADIN",
    titleQuest = 7666,
    minLevel = 60,
    maxLevel = 60,
    areaId = 1519,
    zone = "Stormwind City",
    focus = { 50.9, 46.7 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 23214, 7647 },
        { "item", 18746, 7666 },
        { "rep", 72, 660 },
        { "rep", 47, 250 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 7638, 60, 60, 5 }, -- Lord Grisillo Quiebrasombras
        { 7637, 60, 60, 5 }, -- Énfasis en el sacrificio
        { 7639, 60, 60, 5 }, -- Mostrarse juicioso
        { 7640, 60, 60, 5 }, -- Exorcismo en Valle del Terror
        { 7641, 60, 60, 5 }, -- El trabajo de Grimand Elmore
        { 7642, 60, 60, 5 }, -- Recopilación de artículos
        { 7643, 60, 60, 5 }, -- El antiguo espíritu equino
        { 7644, 60, 60, 5 }, -- La gualdrapa de arcanita bendecida
        { 7646, 60, 60, 5 }, -- El cristal de adivinación
        { 7647, 60, 60, 5 }, -- Juzgar y redimir
        { 7648, 60, 60, 5 }, -- Un trabajo bien hecho
        { 7666, 60, 60, 5 }, -- El regreso a El Gran Osario
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_PALADIN_Misc",
    faction = "Alliance",
    class = "PALADIN",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 61.6, 49.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20700, 8376 },
        { "item", 20711, 8376 },
        { "item", 18775, 7645 },
        { "rep", 529, 1600 },
        { "rep", 910, 1000 },
        { "rep", 609, 400 },
        { "rep", 809, 200 },
        { "rep", 270, 100 },
        { "rep", 72, 60 },
        { "rep", 47, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 3101, 1, 1, 1 }, -- Una carta consagrada
        { 3107, 1, 1, 4 }, -- Runa consagrada
        { 4485, 40, 40, 5 }, -- Libro de la nobleza
        { 4486, 40, 40, 5 }, -- Libro de la nobleza
        { 96438, 40, 35, 4294967373 }, -- Battle at the Mannoroc Coven
        { 96449, 40, 35, 4294967373 }, -- Aeonas's Secret Refuge
        { 81762, 50, 45, 4294967373 }, -- Some Good News
        { 81764, 50, 45, 4294967373 }, -- The Mysterious Merchant
        { 81765, 50, 45, 4294967373 }, -- Elrick, Paladin of the Silver Hand
        { 81766, 50, 45, 4294967373 }, -- The Bloody Missive
        { 81790, 53, 45, 4294967373 }, -- Materials of Significance
        { 81944, 53, 45, 4294967373 }, -- A Newly Discovered Purpose...
        { 96476, 53, 45, 4294967373 }, -- In Search of Aeonas
        { 84318, 57, 54 }, -- Oi!
        { 84330, 59, 54, 4294967373 }, -- A Wee Bit O' Necromancy
        { 7501, 60, 54 }, -- La Luz y cómo alterarla
        { 7645, 60, 60, 5 }, -- Alimento para caballos enriquecido con maná
        { 7670, 60, 60, 4294967373 }, -- Lord Grisillo Quiebrasombras
        { 8185, 60, 58, 4294967373 }, -- Sigilo de Sincretista
        { 8376, 60, 58, 4294967373 }, -- Armamentos de guerra
        { 8627, 60, 60, 4294967373 }, -- La coraza del Vengador
        { 8628, 60, 60, 4294967373 }, -- La corona de vengador
        { 8629, 60, 60, 4294967373 }, -- Los leotardos de vengador
        { 8630, 60, 60, 4294967373 }, -- Los espaldares del Vengador
        { 8655, 60, 60, 4294967373 }, -- Las grebas de vengador
        { 8695, 60, 60, 4294967373 }, -- El manteo de justicia eterna
        { 8703, 60, 60, 4294967373 }, -- El anillo de justicia eterna
        { 8711, 60, 60, 4294967373 }, -- La espada de justicia eterna
        { 8908, 60, 58, 4294967373 }, -- Una propuesta seria
        { 8933, 60, 58, 4294967373 }, -- Una compensación justa
        { 8954, 60, 58, 4294967373 }, -- La despedida de Anthion
        { 9002, 60, 58, 4294967373 }, -- Guardar lo mejor para el final
        { 9043, 60, 60 }, -- La guerrera de redención
        { 9044, 60, 60 }, -- Las musleras de redención
        { 9045, 60, 60 }, -- La celada de redención
        { 9046, 60, 60 }, -- Las bufas de redención
        { 9047, 60, 60 }, -- Las botas de redención
        { 9048, 60, 60 }, -- Las manoplas de redención
        { 9049, 60, 60 }, -- La faja de redención
        { 9050, 60, 60 }, -- Los guardamuñecas de redención
        { 9234, 60, 60 }, -- Los guanteletes Deliriohelado
        { 9235, 60, 60 }, -- Los brazales Deliriohelado
        { 9236, 60, 60 }, -- La coraza Deliriohelado
        { 84150, 60, 58, 4294967373 }, -- An Earnest Proposition
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_PALADIN_95140",
    faction = "Horde",
    class = "PALADIN",
    titleQuest = 95140,
    minLevel = 22,
    maxLevel = 26,
    areaId = 130,
    zone = "Silverpine Forest",
    focus = { 51.0, 36.4 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 268484, 95126 },
        { "item", 267369, 95140 },
        { "item", 272448, 95042 },
        { "rep", 2787, 450 },
        { "rep", 68, 387.5 },
        { "rep", 76, 143.75 },
        { "rep", 67, 106.25 },
        { "rep", 81, 106.25 },
        { "rep", 530, 106.25 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 91858, 22, 18, 16 }, -- Incidente diplomático
        { 91859, 22, 18, 16 }, -- Una extraña pareja
        { 91860, 22, 18, 16 }, -- Un destino funesto
        { 91861, 22, 18, 16 }, -- En el castillo de Fenris
        { 91862, 22, 18, 16 }, -- Lumina Vientocantor
        { 96204, 22, 18, 16 }, -- La cólera de la Formavientos
        { 95034, 24, 18, 16 }, -- La deuda
        { 95036, 25, 20, 16 }, -- Una hoja tocada por la luna
        { 95042, 25, 20, 8589934770 }, -- En busca de la gema Kor
        { 95111, 25, 20, 16 }, -- Un talento infravalorado
        { 95125, 25, 20, 16 }, -- Obra maestra de Ott
        { 95126, 25, 20, 16 }, -- La hoja de plata lunar
        { 95140, 26, 20, 16 }, -- Viejo Ojofuego
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_PALADIN_95803",
    faction = "Horde",
    class = "PALADIN",
    titleQuest = 95803,
    minLevel = 1,
    maxLevel = 12,
    areaId = 85,
    zone = "Tirisfal Glades",
    focus = { 31.3, 51.2 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 7328, 0 },
        { "item", 246265, 91316 },
        { "choice", 246164, 91285 },
        { "choice", 246165, 91285 },
        { "rep", 68, 625 },
        { "rep", 67, 118.75 },
        { "rep", 76, 118.75 },
        { "rep", 81, 118.75 },
        { "rep", 530, 118.75 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 98601, 1, 1, 16 }, -- Una senda complicada
        { 90902, 2, 2, 16 }, -- Redescubriendo la Luz
        { 91208, 4, 4, 16 }, -- Momento de aceptación
        { 91209, 4, 4, 16 }, -- Proseguir tu entrenamiento
        { 91282, 11, 8, 16 }, -- Un segundo hogar
        { 91285, 11, 7, 16 }, -- Múrlocs a las puertas
        { 91294, 11, 8, 16 }, -- Una visita por el recinto
        { 91316, 11, 8, 16 }, -- Trabajos de reparación
        { 91317, 12, 9, 16 }, -- Los mancillados
        { 94427, 12, 12, 16 }, -- Una lección de divinidad
        { 94434, 12, 12, 16 }, -- Una lección de divinidad
        { 94435, 12, 12, 16 }, -- Una lección de divinidad
        { 94436, 12, 12, 16 }, -- Una lección de divinidad
        { 94438, 12, 12, 16 }, -- Una lección de divinidad
        { 94440, 12, 12, 16 }, -- Una lección de divinidad
        { 94441, 12, 12, 16 }, -- Una lección de divinidad
        { 95803, 12, 9, 16 }, -- Una muestra de buena fe
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_PALADIN_7509",
    faction = "Horde",
    class = "PALADIN",
    titleQuest = 7509,
    minLevel = 60,
    maxLevel = 60,
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 18348, 7509 },
        { "rep", 809, 400 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 7507, 60, 60 }, -- Compendio de Nostro
        { 7508, 60, 60 }, -- Forjar Quel'Serrar
        { 7509, 60, 60 }, -- Forjar Quel'Serrar
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_PALADIN_Misc",
    faction = "Horde",
    class = "PALADIN",
    misc = true,
    minLevel = 4,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 67.7, 50.6 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "rep", 529, 1600 },
        { "rep", 530, 350 },
        { "rep", 76, 300 },
        { "rep", 68, 260 },
        { "rep", 809, 200 },
        { "rep", 67, 50 },
        { "rep", 81, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 792, 4, 2, 8589934770 }, -- Familiares viles
        { 94971, 40, 40, 16 }, -- A Paladin's Steed
        { 97022, 40, 40, 16 }, -- Report to Danitha
        { 84318, 57, 54 }, -- Oi!
        { 99187, 58, 50, 8589934770 }, -- The Reliquary of Tyr
        { 7501, 60, 54 }, -- La Luz y cómo alterarla
        { 9043, 60, 60 }, -- La guerrera de redención
        { 9044, 60, 60 }, -- Las musleras de redención
        { 9045, 60, 60 }, -- La celada de redención
        { 9046, 60, 60 }, -- Las bufas de redención
        { 9047, 60, 60 }, -- Las botas de redención
        { 9048, 60, 60 }, -- Las manoplas de redención
        { 9049, 60, 60 }, -- La faja de redención
        { 9050, 60, 60 }, -- Los guardamuñecas de redención
        { 9234, 60, 60 }, -- Los guanteletes Deliriohelado
        { 9235, 60, 60 }, -- Los brazales Deliriohelado
        { 9236, 60, 60 }, -- La coraza Deliriohelado
        { 97174, 60, 60, 8589934770 }, -- A Worthy Endeavor
        { 97175, 60, 60, 8589934770 }, -- Due Sacrifice
        { 97177, 60, 60, 8589934770 }, -- Acts of Mercy
        { 97179, 60, 60, 8589934770 }, -- Collection of Goods
    },
})

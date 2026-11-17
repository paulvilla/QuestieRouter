-- Generado por tools/class_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Guías de clase: SHAMAN
local _, QR = ...
if select(2, UnitClass("player")) ~= "SHAMAN" then return end

QR:RegisterClassGuide({
    key = "Alliance_Class_SHAMAN_94468",
    faction = "Alliance",
    class = "SHAMAN",
    titleQuest = 94468,
    minLevel = 11,
    maxLevel = 14,
    areaId = 38,
    zone = "Loch Modan",
    focus = { 32.2, 66.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 3599, 0 },
        { "item", 5176, 94468 },
        { "item", 263412, 94468 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 94465, 11, 10, 4294967373 }, -- La llamada del fuego
        { 94466, 14, 10, 4 }, -- La llamada del fuego
        { 94473, 13, 10, 4294967373 }, -- Sapta de fuego
        { 94467, 14, 10, 4 }, -- La llamada del fuego
        { 94468, 14, 10, 4 }, -- La llamada del fuego
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_SHAMAN_96016",
    faction = "Alliance",
    class = "SHAMAN",
    titleQuest = 96016,
    minLevel = 30,
    maxLevel = 43,
    areaId = 45,
    zone = "Arathi Highlands",
    focus = { 59.8, 27.6 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 5178, 94789 },
        { "item", 280696, 96016 },
        { "choice", 280607, 96016 },
        { "choice", 280605, 96016 },
        { "choice", 280604, 96016 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 94789, 30, 30, 4294967373 }, -- Call of Air
        { 96264, 33, 30, 4294967373 }, -- Elemental Aid
        { 79358, 43, 30, 4294967373 }, -- Storm, Earth, and Fire
        { 96135, 40, 30, 4294967373 }, -- Heed My Call
        { 96016, 40, 30, 4294967373 }, -- The Tempest's Weapons
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_SHAMAN_94472",
    faction = "Alliance",
    class = "SHAMAN",
    titleQuest = 94472,
    minLevel = 4,
    maxLevel = 4,
    areaId = 1,
    zone = "Dun Morogh",
    focus = { 27.8, 65.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 8071, 0 },
        { "item", 5175, 94375 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 94373, 4, 4, 4294967373 }, -- La llamada de la tierra
        { 94374, 4, 4, 4294967373 }, -- La llamada de la tierra
        { 94375, 4, 4, 4294967373 }, -- La llamada de la tierra
        { 94472, 4, 4, 4294967373 }, -- La sapta de tierra
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_SHAMAN_94505",
    faction = "Alliance",
    class = "SHAMAN",
    titleQuest = 94505,
    minLevel = 20,
    maxLevel = 23,
    areaId = 11,
    zone = "Wetlands",
    focus = { 65.8, 76.5 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 5394, 0 },
        { "item", 5177, 94505 },
        { "item", 6637, 94501 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 94494, 20, 20, 4294967373 }, -- La llamada del agua
        { 94495, 22, 20, 4294967373 }, -- La llamada del agua
        { 94497, 22, 20, 4294967373 }, -- La llamada del agua
        { 94499, 22, 20, 4294967373 }, -- La llamada del agua
        { 94500, 23, 20, 4294967373 }, -- La llamada del agua
        { 94501, 23, 20, 4294967373 }, -- La llamada del agua
        { 94616, 20, 20, 4294967373 }, -- La sapta de agua
        { 94502, 23, 20, 4294967373 }, -- La llamada del agua
        { 94503, 23, 20, 68 }, -- La llamada del agua
        { 94505, 23, 20, 68 }, -- La llamada del agua
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_SHAMAN_Misc",
    faction = "Alliance",
    class = "SHAMAN",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 71.3, 49.5 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "rep", 529, 1600 },
        { "rep", 270, 450 },
        { "rep", 809, 200 },
        { "rep", 67, 150 },
        { "rep", 47, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 98581, 1, 1, 4 }, -- Runa arcaica
        { 96243, 4, 4, 68 }, -- Call of Earth
        { 94449, 10, 10, 4 }, -- La llamada del fuego
        { 7505, 60, 54 }, -- El choque de Escarcha y tú
        { 8056, 60, 60 }, -- Dechados de Poder: los Brazales de augur
        { 8074, 60, 60 }, -- Dechados de Poder: el Cinturón de augur
        { 8075, 60, 60 }, -- Dechados de Poder: el Camisote de augur
        { 9068, 60, 60 }, -- La túnica Fatalidad
        { 9069, 60, 60 }, -- Las grebas Fatalidad
        { 9070, 60, 60 }, -- La celada Fatalidad
        { 9071, 60, 60 }, -- Las hombreras Fatalidad
        { 9072, 60, 60 }, -- Las botas Fatalidad
        { 9073, 60, 60 }, -- Las manoplas Fatalidad
        { 9074, 60, 60 }, -- La faja Fatalidad
        { 9075, 60, 60 }, -- Las muñequeras Fatalidad
        { 9244, 60, 60 }, -- Los brazales de escamas heladas
        { 9245, 60, 60 }, -- Los guanteletes de escamas heladas
        { 9246, 60, 60 }, -- La coraza de escamas heladas
        { 97168, 60, 58, 4294967373 }, -- Material Assistance
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_SHAMAN_1103",
    faction = "Horde",
    class = "SHAMAN",
    titleQuest = 1103,
    minLevel = 20,
    maxLevel = 23,
    areaId = 17,
    zone = "The Barrens",
    focus = { 53.0, 63.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 5177, 96 },
        { "item", 6637, 972 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1530, 22, 20, 8589934770 }, -- La llamada del agua
        { 1535, 22, 20, 8589934770 }, -- La llamada del agua
        { 1536, 22, 20, 8589934770 }, -- La llamada del agua
        { 1534, 23, 20, 8589934770 }, -- La llamada del agua
        { 220, 23, 20, 8589934770 }, -- La llamada del agua
        { 972, 20, 20, 8589934770 }, -- La sapta de agua
        { 63, 23, 20, 8589934770 }, -- La llamada del agua
        { 100, 23, 20, 8589934770 }, -- La llamada del agua
        { 96, 23, 20, 8589934770 }, -- La llamada del agua
        { 1103, 23, 20, 8589934770 }, -- La llamada del agua
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_SHAMAN_79442",
    faction = "Horde",
    class = "SHAMAN",
    titleQuest = 79442,
    minLevel = 30,
    maxLevel = 43,
    areaId = 400,
    zone = "Thousand Needles",
    focus = { 47.6, 49.9 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 5178, 1532 },
        { "item", 280696, 79442 },
        { "item", 213086, 79442 },
        { "choice", 280607, 79442 },
        { "choice", 280605, 79442 },
        { "choice", 280604, 79442 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1531, 30, 30, 8589934770 }, -- La llamada del aire
        { 1532, 30, 30, 8589934770 }, -- La llamada del aire
        { 79360, 33, 30, 8589934770 }, -- Ayuda elemental
        { 79364, 33, 30, 8589934770 }, -- Ojos en el cielo
        { 79361, 43, 30, 162 }, -- Tormenta, tierra y fuego
        { 79366, 40, 30, 8589934770 }, -- Heed My Call
        { 79442, 40, 30, 162 }, -- The Tempest's Weapons
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_SHAMAN_1527",
    faction = "Horde",
    class = "SHAMAN",
    titleQuest = 1527,
    minLevel = 10,
    maxLevel = 13,
    areaId = 16593,
    zone = "Zephras Isle",
    focus = { 53.0, 84.3 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 3599, 0 },
        { "item", 5176, 1527 },
        { "item", 263412, 1527 },
        { "item", 6654, 1526 },
        { "item", 6636, 1464 },
        { "rep", 2778, 100 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 97243, 10, 10, 8589934592 }, -- La llamada del fuego
        { 97244, 10, 10, 8589934770 }, -- La llamada del fuego
        { 97245, 10, 10, 8589934770 }, -- La llamada del fuego
        { 97257, 10, 10, 8589934770 }, -- La llamada del fuego
        { 1524, 11, 10, 8589934770 }, -- La llamada del Fuego
        { 1525, 12, 10, 8589934770 }, -- La llamada del Fuego
        { 1464, 13, 10, 8589934770 }, -- La sapta de fuego
        { 1526, 13, 10, 8589934770 }, -- La llamada del Fuego
        { 1527, 13, 10, 8589934770 }, -- La llamada del Fuego
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_SHAMAN_7669",
    faction = "Horde",
    class = "SHAMAN",
    titleQuest = 7669,
    minLevel = 60,
    maxLevel = 60,
    areaId = 1637,
    zone = "Orgrimmar",
    focus = { 38.7, 35.9 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20134, 8258 },
        { "rep", 67, 350 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 7667, 60, 58, 8589934770 }, -- Asistencia material
        { 8258, 60, 60, 8589934770 }, -- La amenaza de Atracoscuro
        { 7669, 60, 58, 8589934770 }, -- El regreso a El Gran Osario
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_SHAMAN_8413",
    faction = "Horde",
    class = "SHAMAN",
    titleQuest = 8413,
    minLevel = 50,
    maxLevel = 52,
    areaId = 36,
    zone = "Alterac Mountains",
    focus = { 80.5, 66.9 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 20369, 8413 },
        { "choice", 20503, 8413 },
        { "choice", 20556, 8413 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8410, 50, 50, 8589934770 }, -- Maestría elemental
        { 8411, 50, 50, 8589934770 }, -- ominar los elementos
        { 8412, 52, 50, 8589934770 }, -- ótem de espíritu
        { 8413, 52, 50, 8589934770 }, -- Vudú
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_SHAMAN_92468",
    faction = "Horde",
    class = "SHAMAN",
    titleQuest = 92468,
    minLevel = 4,
    maxLevel = 4,
    areaId = 14,
    zone = "Durotar",
    focus = { 42.4, 69.2 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 8071, 0 },
        { "item", 5175, 1521 },
        { "item", 6635, 1462 },
        { "rep", 2778, 150 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1516, 4, 4, 8589934770 }, -- Clamor de Tierra
        { 1519, 4, 4, 8589934770 }, -- La llamada de la tierra
        { 1517, 4, 4, 8589934770 }, -- Clamor de Tierra
        { 1463, 4, 4, 8589934770 }, -- Sapta de tierra
        { 1518, 4, 4, 8589934770 }, -- Clamor de Tierra
        { 1520, 4, 4, 8589934770 }, -- La llamada de la tierra
        { 1462, 4, 4, 8589934770 }, -- Sapta de tierra
        { 1521, 4, 4, 8589934770 }, -- La llamada de la tierra
        { 92466, 4, 3, 8589934770 }, -- La llamada de la tierra
        { 92467, 4, 3, 8589934770 }, -- La llamada de la tierra
        { 92468, 4, 3, 8589934770 }, -- La llamada de la tierra
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_SHAMAN_8119",
    faction = "Horde",
    class = "SHAMAN",
    titleQuest = 8119,
    minLevel = 60,
    maxLevel = 60,
    areaId = 33,
    zone = "Stranglethorn Vale",
    focus = { 15.3, 16.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "rep", 270, 400 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8116, 60, 60, 8589934770 }, -- Visión de Voodress
        { 8117, 60, 60, 8589934770 }, -- Visión de Voodress
        { 8118, 60, 60, 8589934770 }, -- Visión de Voodress
        { 8119, 60, 60, 8589934770 }, -- Visión inmaculada de Voodress
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_SHAMAN_Misc",
    faction = "Horde",
    class = "SHAMAN",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 67.5, 46.3 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20701, 8380 },
        { "item", 20712, 8380 },
        { "rep", 529, 1600 },
        { "rep", 270, 450 },
        { "rep", 609, 400 },
        { "rep", 530, 200 },
        { "rep", 76, 200 },
        { "rep", 809, 200 },
        { "rep", 81, 50 },
        { "rep", 2778, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 3084, 1, 1, 128 }, -- Tablilla inscrita con runas
        { 3089, 1, 1, 2 }, -- Pergamino inscrito con runas
        { 3093, 1, 1, 32 }, -- La nota con runas
        { 92484, 2, 2, 8589934770 }, -- Uno con los elementos
        { 792, 4, 2, 8589934770 }, -- Familiares viles
        { 1522, 10, 10, 8589934770 }, -- La llamada del Fuego
        { 1523, 10, 10, 8589934770 }, -- La llamada del Fuego
        { 2983, 10, 10, 8589934770 }, -- La llamada del Fuego
        { 2984, 10, 10, 8589934770 }, -- La llamada del Fuego
        { 98517, 10, 10, 8589934592 }, -- Call of Fire
        { 1528, 20, 20, 8589934770 }, -- La llamada del agua
        { 1529, 20, 20, 8589934770 }, -- La llamada del agua
        { 2985, 20, 20, 8589934770 }, -- La llamada del agua
        { 2986, 20, 20, 8589934770 }, -- La llamada del agua
        { 79362, 25, 18, 162 }, -- Escudo de Grant
        { 79363, 27, 18, 162 }, -- Espada de Silvia
        { 79365, 40, 30, 34 }, -- With Wind Beneath Your Wings
        { 7505, 60, 54 }, -- El choque de Escarcha y tú
        { 8056, 60, 60 }, -- Dechados de Poder: los Brazales de augur
        { 8074, 60, 60 }, -- Dechados de Poder: el Cinturón de augur
        { 8075, 60, 60 }, -- Dechados de Poder: el Camisote de augur
        { 8380, 60, 58, 8589934770 }, -- Armamentos de guerra
        { 8690, 60, 60, 8589934770 }, -- La capa de la inminente tormenta
        { 8698, 60, 60, 8589934770 }, -- El anillo de la inminente tormenta
        { 8706, 60, 60, 8589934770 }, -- El martillo de la tormenta inminente
        { 8918, 60, 58, 8589934770 }, -- Una propuesta seria
        { 8942, 60, 58, 8589934770 }, -- Una compensación justa
        { 8957, 60, 58, 8589934770 }, -- La despedida de Anthion
        { 9011, 60, 58, 8589934770 }, -- Guardar lo mejor para el final
        { 9068, 60, 60 }, -- La túnica Fatalidad
        { 9069, 60, 60 }, -- Las grebas Fatalidad
        { 9070, 60, 60 }, -- La celada Fatalidad
        { 9071, 60, 60 }, -- Las hombreras Fatalidad
        { 9072, 60, 60 }, -- Las botas Fatalidad
        { 9073, 60, 60 }, -- Las manoplas Fatalidad
        { 9074, 60, 60 }, -- La faja Fatalidad
        { 9075, 60, 60 }, -- Las muñequeras Fatalidad
        { 9244, 60, 60 }, -- Los brazales de escamas heladas
        { 9245, 60, 60 }, -- Los guanteletes de escamas heladas
        { 9246, 60, 60 }, -- La coraza de escamas heladas
    },
})

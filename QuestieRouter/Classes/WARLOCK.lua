-- Generado por tools/class_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Guías de clase: WARLOCK
local _, QR = ...
if select(2, UnitClass("player")) ~= "WARLOCK" then return end

QR:RegisterClassGuide({
    key = "Alliance_Class_WARLOCK_9271",
    faction = "Alliance",
    class = "WARLOCK",
    titleQuest = 9271,
    minLevel = 60,
    maxLevel = 60,
    areaId = 440,
    zone = "Tanaris",
    focus = { 65.3, 50.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 22630, 9271 },
        { "rep", 910, 600 },
        { "rep", 529, 600 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 9250, 60, 60 }, -- Cuerpo de Atiesh
        { 9251, 60, 60 }, -- Atiesh, el gran báculo maligno
        { 9271, 60, 60 }, -- Atiesh, Greatstaff of the Guardian
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARLOCK_1599",
    faction = "Alliance",
    class = "WARLOCK",
    titleQuest = 1599,
    minLevel = 4,
    maxLevel = 4,
    areaId = 12,
    zone = "Elwynn Forest",
    focus = { 49.9, 42.6 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 688, 0 },
        { "rep", 72, 100 },
        { "rep", 47, 100 },
        { "rep", 54, 100 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1598, 4, 1, 1 }, -- El libro robado
        { 1599, 4, 1, 64 }, -- Novato
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARLOCK_65603",
    faction = "Alliance",
    class = "WARLOCK",
    titleQuest = 65603,
    minLevel = 20,
    maxLevel = 20,
    areaId = 1519,
    zone = "Stormwind City",
    focus = { 39.2, 85.2 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 712, 0 },
        { "spell", 713, 0 },
        { "item", 22243, 1739 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1716, 20, 20, 4294967373 }, -- Devoradora de almas
        { 1717, 20, 20, 4294967373 }, -- La invocación de Gakin
        { 1738, 20, 20, 4294967373 }, -- Duramen
        { 1739, 20, 20, 65 }, -- El vínculo
        { 65602, 20, 20, 4294967373 }, -- ¿Qué es el amor?
        { 65603, 20, 20, 65 }, -- El vínculo
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARLOCK_4786",
    faction = "Alliance",
    class = "WARLOCK",
    titleQuest = 4786,
    minLevel = 31,
    maxLevel = 38,
    areaId = 17,
    zone = "The Barrens",
    focus = { 62.5, 35.5 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 6900, 4786 },
        { "item", 12293, 4785 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1796, 31, 31 }, -- Los componentes para la toga de sangre dorada encantada
        { 4736, 31, 31, 4294967373 }, -- Buscando a Menara Nadiz
        { 4738, 31, 31, 4294967373 }, -- Buscando a Menara Nadiz
        { 4781, 34, 31 }, -- Los componentes para la toga de sangre dorada encantada
        { 4782, 34, 31 }, -- Los componentes para la toga de sangre dorada encantada
        { 4783, 37, 31 }, -- Los componentes para la toga de sangre dorada encantada
        { 4784, 37, 31 }, -- Los componentes para la toga de sangre dorada encantada
        { 4785, 37, 31 }, -- Hilo fino de oro
        { 4786, 38, 31 }, -- Toga terminada
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARLOCK_1715",
    faction = "Alliance",
    class = "WARLOCK",
    titleQuest = 1715,
    minLevel = 10,
    maxLevel = 10,
    areaId = 1519,
    zone = "Stormwind City",
    focus = { 39.2, 85.2 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 697, 0 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1685, 10, 10, 4294967373 }, -- La invocación de Gakin
        { 1688, 10, 10, 4294967373 }, -- Surena Caledon
        { 1689, 10, 10, 65 }, -- El vínculo
        { 1715, 10, 10, 4294967373 }, -- El Cordero Degollado
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARLOCK_1740",
    faction = "Alliance",
    class = "WARLOCK",
    titleQuest = 1740,
    minLevel = 25,
    maxLevel = 25,
    areaId = 17,
    zone = "The Barrens",
    focus = { 49.3, 57.2 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 6898, 1740 },
        { "choice", 15109, 1740 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1740, 25, 20 }, -- El orbe de Soran'ruk
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARLOCK_1795",
    faction = "Alliance",
    class = "WARLOCK",
    titleQuest = 1795,
    minLevel = 30,
    maxLevel = 30,
    areaId = 1537,
    zone = "Ironforge",
    focus = { 65.3, 9.3 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 691, 0 },
        { "item", 22244, 1795 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1758, 30, 30, 4294967373 }, -- El Libro del Conciliábulo
        { 1798, 30, 30, 4294967373 }, -- Buscando a Strahad
        { 1802, 30, 30, 4294967373 }, -- Libro del Conciliábulo
        { 1804, 30, 30, 4294967373 }, -- Libro del Conciliábulo
        { 1795, 30, 30, 211 }, -- El vínculo
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARLOCK_8422",
    faction = "Alliance",
    class = "WARLOCK",
    titleQuest = 8422,
    minLevel = 52,
    maxLevel = 52,
    areaId = 361,
    zone = "Felwood",
    focus = { 41.4, 45.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 20536, 8422 },
        { "choice", 20534, 8422 },
        { "choice", 20530, 8422 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8419, 52, 50 }, -- Pedido de un diablillo
        { 8420, 52, 50 }, -- Caliente y picante
        { 8421, 52, 50 }, -- La mercancía equivocada
        { 8422, 52, 50 }, -- Plumas de trol
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARLOCK_4975",
    faction = "Alliance",
    class = "WARLOCK",
    titleQuest = 4975,
    minLevel = 35,
    maxLevel = 40,
    areaId = 17,
    zone = "The Barrens",
    focus = { 62.5, 35.4 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 12642, 4961 },
        { "choice", 15108, 4964 },
        { "choice", 15106, 4964 },
        { "choice", 15107, 4975 },
        { "choice", 15105, 4975 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 4965, 35, 35, 4294967373 }, -- El conocimiento del orbe de Orahil
        { 4968, 35, 35, 4294967373 }, -- El conocimiento del orbe de Orahil
        { 1799, 40, 35, 12884902143 }, -- Los fragmentos del orbe de Orahil
        { 4962, 40, 35 }, -- Fragmento de can manáfago
        { 4961, 40, 35, 12884902143 }, -- La purificación del orbe de Orahil
        { 4963, 40, 35 }, -- Fragmento de infernal
        { 4976, 40, 35, 12884902143 }, -- Devolver el orbe purificado
        { 4964, 40, 35, 12884902143 }, -- El orbe completo de Dar'Orahil
        { 4975, 40, 35, 12884902143 }, -- El orbe completo de Noh'Orahil
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARLOCK_4490",
    faction = "Alliance",
    class = "WARLOCK",
    titleQuest = 4490,
    minLevel = 40,
    maxLevel = 40,
    areaId = 1537,
    zone = "Ironforge",
    focus = { 50.4, 5.7 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 5784, 4490 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 4487, 40, 40, 4294967373 }, -- Invoca un malignoecus
        { 4488, 40, 40, 4294967373 }, -- Invoca un malignoecus
        { 4490, 40, 40, 211 }, -- Invoca un malignoecus
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARLOCK_7631",
    faction = "Alliance",
    class = "WARLOCK",
    titleQuest = 7631,
    minLevel = 60,
    maxLevel = 60,
    areaId = 46,
    zone = "Burning Steppes",
    focus = { 12.6, 31.6 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 23161, 7631 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 7563, 60, 60 }, -- La ira de sangre
        { 7564, 60, 60 }, -- Ojosalvajes
        { 7623, 60, 60 }, -- Lord Pesadilla
        { 7624, 60, 60 }, -- Ulathek el Traidor
        { 7625, 60, 60 }, -- Polvo estelar xorothiano
        { 7626, 60, 60 }, -- La Campana de Dethmoora
        { 7627, 60, 60 }, -- Rueda de la Marcha Negra
        { 7628, 60, 60 }, -- La Vela del Apocalipsis
        { 7629, 60, 60 }, -- Entrega de diablillo
        { 7630, 60, 60 }, -- La arcanita
        { 7631, 60, 60, 211 }, -- Terrorecus de Xoroth
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARLOCK_397",
    faction = "Alliance",
    class = "WARLOCK",
    titleQuest = 397,
    minLevel = 30,
    maxLevel = 30,
    areaId = 1519,
    zone = "Stormwind City",
    focus = { 40.1, 85.3 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 3556, 397 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 397, 30, 25, 65 }, -- Nos has hecho un gran servicio
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARLOCK_7583",
    faction = "Alliance",
    class = "WARLOCK",
    titleQuest = 7583,
    minLevel = 60,
    maxLevel = 60,
    areaId = 4,
    zone = "Blasted Lands",
    focus = { 34.1, 50.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 18540, 7583 },
        { "item", 18602, 7583 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 7581, 60, 60 }, -- Las selladuras de la prisión
        { 7582, 60, 60 }, -- El revestimiento de la prisión
        { 7583, 60, 60, 211 }, -- Supresión
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARLOCK_8109",
    faction = "Alliance",
    class = "WARLOCK",
    titleQuest = 8109,
    minLevel = 60,
    maxLevel = 60,
    areaId = 33,
    zone = "Stranglethorn Vale",
    focus = { 15.3, 16.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "rep", 270, 400 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8106, 60, 60 }, -- Ocaso de Kezan
        { 8107, 60, 60 }, -- Ocaso de Kezan
        { 8108, 60, 60 }, -- Ocaso de Kezan
        { 8109, 60, 60 }, -- Mancha imparable de Kezan
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARLOCK_7603",
    faction = "Alliance",
    class = "WARLOCK",
    titleQuest = 7603,
    minLevel = 50,
    maxLevel = 55,
    areaId = 361,
    zone = "Felwood",
    focus = { 41.4, 45.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 1122, 7603 },
        { "item", 18762, 7603 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 7601, 50, 50 }, -- La orden de Niby
        { 7602, 55, 50 }, -- Esencia de energía vil pura
        { 7603, 55, 50, 211 }, -- El núcleo infernal de Kroshius
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARLOCK_Misc",
    faction = "Alliance",
    class = "WARLOCK",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 67.7, 45.8 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20705, 8381 },
        { "item", 20716, 8381 },
        { "rep", 529, 1600 },
        { "rep", 910, 1000 },
        { "rep", 270, 550 },
        { "rep", 609, 400 },
        { "rep", 809, 200 },
        { "rep", 72, 50 },
        { "rep", 54, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 3105, 1, 1, 1 }, -- Una carta impía
        { 3115, 1, 1, 64 }, -- Memorándum corrupto
        { 7502, 60, 54 }, -- Controlar las Sombras
        { 7562, 60, 60 }, -- Mor'zul Sangredoble
        { 8059, 60, 60 }, -- Dechados de Poder: los Brazaletes de endemoniado
        { 8076, 60, 60 }, -- Dechados de Poder: el Manto de endemoniado
        { 8077, 60, 60 }, -- Dechados de Poder: la Toga de endemoniado
        { 8190, 60, 58 }, -- Maleficio de mala suerte
        { 8381, 60, 58 }, -- Armamentos de guerra
        { 8660, 60, 60 }, -- Las botas de clamacondenas
        { 8661, 60, 60 }, -- Las togas clamacondenas
        { 8662, 60, 60 }, -- El aro de clamacondenas
        { 8663, 60, 60 }, -- Los pantalones de clamacondenas
        { 8664, 60, 60 }, -- El manto de clamacondenas
        { 8694, 60, 60 }, -- El sayo de los nombres prohibidos
        { 8702, 60, 60 }, -- El anillo de los nombres prohibidos
        { 8710, 60, 60 }, -- El kris de los nombres prohibidos
        { 8911, 60, 58, 4294967373 }, -- Una propuesta seria
        { 8936, 60, 58, 4294967373 }, -- Una compensación justa
        { 8958, 60, 58, 4294967373 }, -- La despedida de Anthion
        { 9005, 60, 58, 4294967373 }, -- Guardar lo mejor para el final
        { 9103, 60, 60 }, -- La toga corazón de la peste
        { 9104, 60, 60 }, -- Los leotardos corazón de la peste
        { 9105, 60, 60 }, -- El aro corazón de la peste
        { 9106, 60, 60 }, -- Las hombreras corazón de la peste
        { 9107, 60, 60 }, -- Los botines corazón de peste
        { 9108, 60, 60 }, -- Los guantes corazón de la peste
        { 9109, 60, 60 }, -- El cinturón corazón de la peste
        { 9110, 60, 60 }, -- Las ataduras corazón de la peste
        { 9238, 60, 60 }, -- Las muñequeras glaciales
        { 9239, 60, 60 }, -- Los guantes glaciales
        { 9240, 60, 60 }, -- El jubón glacial
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARLOCK_9271",
    faction = "Horde",
    class = "WARLOCK",
    titleQuest = 9271,
    minLevel = 60,
    maxLevel = 60,
    areaId = 440,
    zone = "Tanaris",
    focus = { 65.3, 50.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 22630, 9271 },
        { "rep", 910, 600 },
        { "rep", 529, 600 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 9250, 60, 60 }, -- Cuerpo de Atiesh
        { 9251, 60, 60 }, -- Atiesh, el gran báculo maligno
        { 9271, 60, 60 }, -- Atiesh, Greatstaff of the Guardian
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARLOCK_4490",
    faction = "Horde",
    class = "WARLOCK",
    titleQuest = 4490,
    minLevel = 40,
    maxLevel = 40,
    areaId = 1637,
    zone = "Orgrimmar",
    focus = { 48.5, 45.4 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 5784, 4490 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 3631, 40, 40, 8589934770 }, -- Invoca un malignoecus
        { 4489, 40, 40, 8589934770 }, -- Invoca un malignoecus
        { 4490, 40, 40, 211 }, -- Invoca un malignoecus
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARLOCK_65604",
    faction = "Horde",
    class = "WARLOCK",
    titleQuest = 65604,
    minLevel = 20,
    maxLevel = 27,
    areaId = 1637,
    zone = "Orgrimmar",
    focus = { 48.5, 48.3 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 712, 0 },
        { "spell", 713, 0 },
        { "item", 22243, 1513 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1472, 20, 20, 8589934770 }, -- Devoradora de almas
        { 1476, 20, 20, 8589934770 }, -- Corazones puros
        { 1474, 20, 20, 16 }, -- El vínculo
        { 1507, 20, 20, 8589934770 }, -- Devoradora de almas
        { 1508, 20, 20, 8589934770 }, -- Cazul, el ciego
        { 1509, 20, 20, 8589934770 }, -- Noticias de Dogran
        { 1510, 20, 20, 8589934770 }, -- Noticias de Dogran
        { 1511, 20, 20, 8589934770 }, -- Poción de Ken'zigla
        { 1515, 20, 20, 8589934770 }, -- El cautiverio de Dogran
        { 1512, 20, 20, 8589934770 }, -- Un regalo de amor
        { 1513, 20, 20, 130 }, -- El vínculo
        { 65593, 20, 20, 8589934770 }, -- Los corazones de los amantes
        { 65597, 20, 20, 16 }, -- El vínculo
        { 65601, 20, 20, 8589934770 }, -- El amor duele
        { 65610, 27, 20, 8589934770 }, -- Ojalá estuvieras aquí
        { 65604, 20, 20, 130 }, -- El vínculo
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARLOCK_4786",
    faction = "Horde",
    class = "WARLOCK",
    titleQuest = 4786,
    minLevel = 31,
    maxLevel = 38,
    areaId = 17,
    zone = "The Barrens",
    focus = { 62.5, 35.5 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 6900, 4786 },
        { "item", 12293, 4785 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1796, 31, 31 }, -- Los componentes para la toga de sangre dorada encantada
        { 4737, 31, 31, 8589934770 }, -- Buscando a Menara Nadiz
        { 4739, 31, 31, 8589934770 }, -- Buscando a Menara Nadiz
        { 4781, 34, 31 }, -- Los componentes para la toga de sangre dorada encantada
        { 4782, 34, 31 }, -- Los componentes para la toga de sangre dorada encantada
        { 4783, 37, 31 }, -- Los componentes para la toga de sangre dorada encantada
        { 4784, 37, 31 }, -- Los componentes para la toga de sangre dorada encantada
        { 4785, 37, 31 }, -- Hilo fino de oro
        { 4786, 38, 31 }, -- Toga terminada
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARLOCK_1740",
    faction = "Horde",
    class = "WARLOCK",
    titleQuest = 1740,
    minLevel = 25,
    maxLevel = 25,
    areaId = 17,
    zone = "The Barrens",
    focus = { 49.3, 57.2 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 6898, 1740 },
        { "choice", 15109, 1740 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1740, 25, 20 }, -- El orbe de Soran'ruk
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARLOCK_8422",
    faction = "Horde",
    class = "WARLOCK",
    titleQuest = 8422,
    minLevel = 52,
    maxLevel = 52,
    areaId = 361,
    zone = "Felwood",
    focus = { 41.4, 45.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 20536, 8422 },
        { "choice", 20534, 8422 },
        { "choice", 20530, 8422 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8419, 52, 50 }, -- Pedido de un diablillo
        { 8420, 52, 50 }, -- Caliente y picante
        { 8421, 52, 50 }, -- La mercancía equivocada
        { 8422, 52, 50 }, -- Plumas de trol
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARLOCK_1795",
    faction = "Horde",
    class = "WARLOCK",
    titleQuest = 1795,
    minLevel = 30,
    maxLevel = 30,
    areaId = 17,
    zone = "The Barrens",
    focus = { 62.6, 35.5 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 691, 0 },
        { "item", 22244, 1795 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1801, 30, 30, 8589934770 }, -- Libro del Conciliábulo
        { 1803, 30, 30, 8589934770 }, -- Libro del Conciliábulo
        { 1805, 30, 30, 8589934770 }, -- Libro del Conciliábulo
        { 1795, 30, 30, 211 }, -- El vínculo
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARLOCK_4975",
    faction = "Horde",
    class = "WARLOCK",
    titleQuest = 4975,
    minLevel = 35,
    maxLevel = 40,
    areaId = 17,
    zone = "The Barrens",
    focus = { 62.5, 35.4 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 12642, 4961 },
        { "choice", 15108, 4964 },
        { "choice", 15106, 4964 },
        { "choice", 15107, 4975 },
        { "choice", 15105, 4975 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 4967, 35, 35, 8589934770 }, -- El conocimiento del orbe de Orahil
        { 4969, 35, 35, 8589934770 }, -- El conocimiento del Orbe de Orahil
        { 1799, 40, 35, 12884902143 }, -- Los fragmentos del orbe de Orahil
        { 4962, 40, 35 }, -- Fragmento de can manáfago
        { 4961, 40, 35, 12884902143 }, -- La purificación del orbe de Orahil
        { 4963, 40, 35 }, -- Fragmento de infernal
        { 4976, 40, 35, 12884902143 }, -- Devolver el orbe purificado
        { 4964, 40, 35, 12884902143 }, -- El orbe completo de Dar'Orahil
        { 4975, 40, 35, 12884902143 }, -- El orbe completo de Noh'Orahil
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARLOCK_7631",
    faction = "Horde",
    class = "WARLOCK",
    titleQuest = 7631,
    minLevel = 60,
    maxLevel = 60,
    areaId = 46,
    zone = "Burning Steppes",
    focus = { 12.6, 31.6 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 23161, 7631 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 7563, 60, 60 }, -- La ira de sangre
        { 7564, 60, 60 }, -- Ojosalvajes
        { 7623, 60, 60 }, -- Lord Pesadilla
        { 7624, 60, 60 }, -- Ulathek el Traidor
        { 7625, 60, 60 }, -- Polvo estelar xorothiano
        { 7626, 60, 60 }, -- La Campana de Dethmoora
        { 7627, 60, 60 }, -- Rueda de la Marcha Negra
        { 7628, 60, 60 }, -- La Vela del Apocalipsis
        { 7629, 60, 60 }, -- Entrega de diablillo
        { 7630, 60, 60 }, -- La arcanita
        { 7631, 60, 60, 211 }, -- Terrorecus de Xoroth
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARLOCK_7583",
    faction = "Horde",
    class = "WARLOCK",
    titleQuest = 7583,
    minLevel = 60,
    maxLevel = 60,
    areaId = 4,
    zone = "Blasted Lands",
    focus = { 34.1, 50.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 18540, 7583 },
        { "item", 18602, 7583 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 7581, 60, 60 }, -- Las selladuras de la prisión
        { 7582, 60, 60 }, -- El revestimiento de la prisión
        { 7583, 60, 60, 211 }, -- Supresión
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARLOCK_8109",
    faction = "Horde",
    class = "WARLOCK",
    titleQuest = 8109,
    minLevel = 60,
    maxLevel = 60,
    areaId = 33,
    zone = "Stranglethorn Vale",
    focus = { 15.3, 16.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "rep", 270, 400 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8106, 60, 60 }, -- Ocaso de Kezan
        { 8107, 60, 60 }, -- Ocaso de Kezan
        { 8108, 60, 60 }, -- Ocaso de Kezan
        { 8109, 60, 60 }, -- Mancha imparable de Kezan
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARLOCK_7603",
    faction = "Horde",
    class = "WARLOCK",
    titleQuest = 7603,
    minLevel = 50,
    maxLevel = 55,
    areaId = 361,
    zone = "Felwood",
    focus = { 41.4, 45.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 1122, 7603 },
        { "item", 18762, 7603 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 7601, 50, 50 }, -- La orden de Niby
        { 7602, 55, 50 }, -- Esencia de energía vil pura
        { 7603, 55, 50, 211 }, -- El núcleo infernal de Kroshius
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARLOCK_3001",
    faction = "Horde",
    class = "WARLOCK",
    titleQuest = 3001,
    minLevel = 30,
    maxLevel = 30,
    areaId = 1637,
    zone = "Orgrimmar",
    focus = { 48.2, 45.3 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 691, 0 },
        { "item", 22244, 0 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 2996, 30, 30, 8589934770 }, -- Buscando a Strahad
        { 3001, 30, 30, 8589934770 }, -- Buscando a Strahad
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARLOCK_1499",
    faction = "Horde",
    class = "WARLOCK",
    titleQuest = 1499,
    minLevel = 3,
    maxLevel = 4,
    areaId = 14,
    zone = "Durotar",
    focus = { 42.6, 69.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 688, 0 },
        { "choice", 4925, 1499 },
        { "choice", 5778, 1499 },
        { "rep", 68, 75 },
        { "rep", 530, 10 },
        { "rep", 76, 10 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1470, 3, 1, 16 }, -- Descubrir el misterio
        { 1485, 4, 1, 130 }, -- Familiares viles
        { 1499, 4, 1, 146 }, -- Familiares viles
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARLOCK_1504",
    faction = "Horde",
    class = "WARLOCK",
    titleQuest = 1504,
    minLevel = 10,
    maxLevel = 11,
    areaId = 1497,
    zone = "Undercity",
    focus = { 85.1, 26.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 697, 0 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1473, 10, 10, 16 }, -- Criatura abisal
        { 1471, 10, 10, 16 }, -- El vínculo
        { 1478, 10, 10, 8589934770 }, -- Las invocaciones de Halgar
        { 1506, 10, 10, 8589934770 }, -- Las invocaciones de Gan'rul
        { 1501, 11, 10, 2 }, -- Criatura abisal
        { 1504, 11, 10, 130 }, -- El vínculo
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARLOCK_Misc",
    faction = "Horde",
    class = "WARLOCK",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 67.7, 45.8 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20705, 8381 },
        { "item", 20716, 8381 },
        { "rep", 529, 1600 },
        { "rep", 910, 1000 },
        { "rep", 270, 550 },
        { "rep", 609, 400 },
        { "rep", 809, 200 },
        { "rep", 76, 50 },
        { "rep", 68, 50 },
        { "rep", 530, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 3090, 1, 1, 2 }, -- Pergamino corrupto
        { 3099, 1, 1, 16 }, -- Un pergamino manchado
        { 98575, 1, 1, 128 }, -- Tainted Tablet
        { 7502, 60, 54 }, -- Controlar las Sombras
        { 7562, 60, 60 }, -- Mor'zul Sangredoble
        { 8059, 60, 60 }, -- Dechados de Poder: los Brazaletes de endemoniado
        { 8076, 60, 60 }, -- Dechados de Poder: el Manto de endemoniado
        { 8077, 60, 60 }, -- Dechados de Poder: la Toga de endemoniado
        { 8190, 60, 58 }, -- Maleficio de mala suerte
        { 8381, 60, 58 }, -- Armamentos de guerra
        { 8660, 60, 60 }, -- Las botas de clamacondenas
        { 8661, 60, 60 }, -- Las togas clamacondenas
        { 8662, 60, 60 }, -- El aro de clamacondenas
        { 8663, 60, 60 }, -- Los pantalones de clamacondenas
        { 8664, 60, 60 }, -- El manto de clamacondenas
        { 8694, 60, 60 }, -- El sayo de los nombres prohibidos
        { 8702, 60, 60 }, -- El anillo de los nombres prohibidos
        { 8710, 60, 60 }, -- El kris de los nombres prohibidos
        { 8919, 60, 58, 8589934770 }, -- Una propuesta seria
        { 8943, 60, 58, 8589934770 }, -- Una compensación justa
        { 9012, 60, 58, 8589934770 }, -- Guardar lo mejor para el final
        { 9021, 60, 58, 8589934770 }, -- La despedida de Anthion
        { 9103, 60, 60 }, -- La toga corazón de la peste
        { 9104, 60, 60 }, -- Los leotardos corazón de la peste
        { 9105, 60, 60 }, -- El aro corazón de la peste
        { 9106, 60, 60 }, -- Las hombreras corazón de la peste
        { 9107, 60, 60 }, -- Los botines corazón de peste
        { 9108, 60, 60 }, -- Los guantes corazón de la peste
        { 9109, 60, 60 }, -- El cinturón corazón de la peste
        { 9110, 60, 60 }, -- Las ataduras corazón de la peste
        { 9238, 60, 60 }, -- Las muñequeras glaciales
        { 9239, 60, 60 }, -- Los guantes glaciales
        { 9240, 60, 60 }, -- El jubón glacial
    },
})

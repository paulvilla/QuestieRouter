-- Generado por tools/class_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Guías de clase: WARRIOR
local _, QR = ...
if select(2, UnitClass("player")) ~= "WARRIOR" then return end

QR:RegisterClassGuide({
    key = "Alliance_Class_WARRIOR_1792",
    faction = "Alliance",
    class = "WARRIOR",
    titleQuest = 1792,
    minLevel = 30,
    maxLevel = 40,
    areaId = 36,
    zone = "Alterac Mountains",
    focus = { 80.5, 66.9 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 2458, 0 },
        { "choice", 6975, 1792 },
        { "choice", 6977, 1792 },
        { "choice", 6976, 1792 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1718, 30, 30 }, -- El isleño
        { 1719, 30, 30 }, -- La Reyerta
        { 1791, 30, 30 }, -- El Cazavientos
        { 1712, 40, 30 }, -- Cicloniano
        { 1713, 40, 30 }, -- La invocación
        { 1792, 40, 30 }, -- Arma torbellino
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARRIOR_1682",
    faction = "Alliance",
    class = "WARRIOR",
    titleQuest = 1682,
    minLevel = 10,
    maxLevel = 11,
    areaId = 1519,
    zone = "Stormwind City",
    focus = { 76.9, 52.9 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 71, 0 },
        { "item", 275290, 0 },
        { "choice", 6979, 1667 },
        { "choice", 6983, 1667 },
        { "choice", 6980, 1667 },
        { "choice", 6985, 1667 },
        { "choice", 6978, 1682 },
        { "choice", 6982, 1682 },
        { "choice", 6981, 1682 },
        { "choice", 6984, 1682 },
        { "choice", 6966, 1693 },
        { "choice", 6968, 1693 },
        { "choice", 6969, 1693 },
        { "choice", 6967, 1693 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1639, 10, 10, 4294967373 }, -- Bartleby, el borracho
        { 1683, 10, 10, 4294967373 }, -- Vorlus Pezuñavil
        { 1678, 11, 10, 4294967373 }, -- Vejrek
        { 1640, 10, 10, 4294967373 }, -- Vence a Bartleby
        { 1665, 10, 10, 4294967373 }, -- La jarra de Bartleby
        { 1666, 10, 10, 4294967373 }, -- El alguacil Haggard
        { 1667, 10, 10, 4294967373 }, -- Jack Dentomuerto
        { 1686, 10, 10, 4294967373 }, -- La sombra de Elura
        { 1692, 10, 10, 4294967373 }, -- Mathiel, el herrero
        { 1693, 10, 10, 4294967373 }, -- Armas de Elunita
        { 1680, 11, 10, 4294967373 }, -- Tormus Forjahonda
        { 1681, 11, 10, 4294967373 }, -- Complejo Vetaferro
        { 1682, 10, 10, 4294967373 }, -- Armas de hierro gris
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARRIOR_1711",
    faction = "Alliance",
    class = "WARRIOR",
    titleQuest = 1711,
    minLevel = 22,
    maxLevel = 30,
    areaId = 1519,
    zone = "Stormwind City",
    focus = { 63.2, 36.2 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 6972, 1782 },
        { "item", 6971, 1706 },
        { "item", 6973, 1711 },
        { "item", 6974, 1709 },
        { "item", 6970, 1702 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1699, 22, 20, 4294967373 }, -- El guantelete de Rethban
        { 1702, 22, 20, 4294967373 }, -- El forjador de escudos
        { 1701, 28, 20, 4294967373 }, -- Armadura de mallas endurecida con fuego
        { 1782, 28, 20, 4294967373 }, -- La armadura de Furen
        { 1700, 28, 20, 1 }, -- Grimand Elmore
        { 1703, 28, 20, 8 }, -- Mathiel
        { 1704, 28, 20, 68 }, -- Klockmort Palmalicate
        { 1705, 28, 20, 4294967373 }, -- Sangre ardiente
        { 1708, 29, 20, 4294967373 }, -- Coral férreo
        { 1706, 30, 20, 4294967373 }, -- La armadura de Grimand
        { 1709, 30, 20, 4294967373 }, -- La creación de Klockmort
        { 1710, 30, 20, 4294967373 }, -- Cáscaras asoladas
        { 1711, 30, 20, 4294967373 }, -- La armadura de Mathiel
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARRIOR_7508",
    faction = "Alliance",
    class = "WARRIOR",
    titleQuest = 7508,
    minLevel = 60,
    maxLevel = 60,
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 18348, 0 },
        { "rep", 809, 200 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 7507, 60, 60 }, -- Compendio de Nostro
        { 7508, 60, 60 }, -- Forjar Quel'Serrar
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARRIOR_8044",
    faction = "Alliance",
    class = "WARRIOR",
    titleQuest = 8044,
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
        { 8041, 60, 60 }, -- La fuerza del Monte Mugamba
        { 8042, 60, 60 }, -- La fuerza del Monte Mugamba
        { 8043, 60, 60 }, -- La fuerza del Monte Mugamba
        { 8044, 60, 60 }, -- La Ira de Mugamba
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARRIOR_8425",
    faction = "Alliance",
    class = "WARRIOR",
    titleQuest = 8425,
    minLevel = 52,
    maxLevel = 52,
    areaId = 8,
    zone = "Swamp of Sorrows",
    focus = { 34.3, 66.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 20521, 8425 },
        { "choice", 20130, 8425 },
        { "choice", 20517, 8425 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8423, 52, 50 }, -- Parentesco guerrero
        { 8424, 52, 50 }, -- La guerra contra los Sombra Jurada
        { 8425, 52, 50 }, -- Plumas Vudú
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_WARRIOR_Misc",
    faction = "Alliance",
    class = "WARRIOR",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 68.0, 45.8 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20699, 8316 },
        { "item", 20710, 8316 },
        { "item", 6851, 1714 },
        { "item", 275290, 94003 },
        { "rep", 529, 1600 },
        { "rep", 270, 450 },
        { "rep", 609, 400 },
        { "rep", 809, 200 },
        { "rep", 2778, 100 },
        { "rep", 2779, 100 },
        { "rep", 72, 50 },
        { "rep", 47, 50 },
        { "rep", 54, 50 },
        { "rep", 69, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 3100, 1, 1, 1 }, -- Una carta simple
        { 3106, 1, 1, 4 }, -- Runa simple
        { 3112, 1, 1, 64 }, -- Memorándum simple
        { 3116, 1, 1, 8 }, -- El sigilo simple
        { 92532, 2, 2 }, -- La senda del guerrero
        { 1638, 10, 10, 4294967373 }, -- Instrucción de guerrero
        { 1679, 10, 10, 4294967373 }, -- Muren Pico Tormenta
        { 1684, 10, 10, 4294967373 }, -- Elanaria
        { 94003, 10, 10, 12884901888 }, -- El baluarte Rompecielos
        { 1698, 20, 20, 4294967373 }, -- Yorus Cebadiz
        { 1714, 37, 30 }, -- Esencia del exilio
        { 8417, 50, 50 }, -- Un espíritu afligido
        { 7499, 60, 54 }, -- Códice de Defensa
        { 8058, 60, 60 }, -- Dechados de Poder: los Guardabrazos de vindicador
        { 8078, 60, 60 }, -- Dechados de Poder: el Cinturón de vindicador
        { 8079, 60, 60 }, -- Dechados de Poder: el Peto de vindicador
        { 8316, 60, 58 }, -- Armamentos de guerra
        { 8556, 60, 60 }, -- El anillo con sello de fuerza implacable
        { 8557, 60, 60 }, -- El mantón de fuerza implacable
        { 8558, 60, 60 }, -- La hoz de fuerza implacable
        { 8912, 60, 58, 4294967373 }, -- Una propuesta seria
        { 8937, 60, 58, 4294967373 }, -- Una compensación justa
        { 8959, 60, 58, 4294967373 }, -- La despedida de Anthion
        { 9006, 60, 58, 4294967373 }, -- Guardar lo mejor para el final
        { 9034, 60, 60 }, -- La coraza acorator
        { 9036, 60, 60 }, -- Los quijotes acorator
        { 9037, 60, 60 }, -- El casco acorator
        { 9038, 60, 60 }, -- Los espaldares acorator
        { 9039, 60, 60 }, -- Los escarpes acorator
        { 9040, 60, 60 }, -- Los guanteletes acorator
        { 9041, 60, 60 }, -- Los guardarrenes acorator
        { 9042, 60, 60 }, -- Los brazales acorator
        { 9234, 60, 60 }, -- Los guanteletes Deliriohelado
        { 9235, 60, 60 }, -- Los brazales Deliriohelado
        { 9236, 60, 60 }, -- La coraza Deliriohelado
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARRIOR_1792",
    faction = "Horde",
    class = "WARRIOR",
    titleQuest = 1792,
    minLevel = 30,
    maxLevel = 40,
    areaId = 36,
    zone = "Alterac Mountains",
    focus = { 80.5, 66.9 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 2458, 0 },
        { "choice", 6975, 1792 },
        { "choice", 6977, 1792 },
        { "choice", 6976, 1792 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1718, 30, 30 }, -- El isleño
        { 1719, 30, 30 }, -- La Reyerta
        { 1791, 30, 30 }, -- El Cazavientos
        { 1712, 40, 30 }, -- Cicloniano
        { 1713, 40, 30 }, -- La invocación
        { 1792, 40, 30 }, -- Arma torbellino
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARRIOR_1822",
    faction = "Horde",
    class = "WARRIOR",
    titleQuest = 1822,
    minLevel = 10,
    maxLevel = 11,
    areaId = 85,
    zone = "Tirisfal Glades",
    focus = { 60.0, 51.9 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 71, 0 },
        { "item", 275290, 0 },
        { "choice", 7326, 1503 },
        { "choice", 7328, 1503 },
        { "choice", 7327, 1503 },
        { "choice", 7329, 1503 },
        { "choice", 7115, 1822 },
        { "choice", 7117, 1822 },
        { "choice", 7116, 1822 },
        { "choice", 7118, 1822 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1498, 10, 10, 8589934770 }, -- Camino de defensa
        { 1819, 10, 10, 8589934770 }, -- Ulag, el cuchillero
        { 1502, 10, 10, 8589934770 }, -- Thun'grim Vistafuego
        { 1503, 10, 10, 8589934770 }, -- Acero fundido
        { 1820, 10, 10, 8589934770 }, -- Habla con Coleman
        { 1821, 11, 10, 8589934770 }, -- Reliquias Agamand
        { 1822, 11, 10, 8589934770 }, -- Arma reliquia
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARRIOR_1847",
    faction = "Horde",
    class = "WARRIOR",
    titleQuest = 1847,
    minLevel = 20,
    maxLevel = 30,
    areaId = 17,
    zone = "The Barrens",
    focus = { 53.6, 38.6 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 7133, 1848 },
        { "item", 7130, 1845 },
        { "item", 7129, 1843 },
        { "item", 7132, 1847 },
        { "item", 7120, 1824 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1824, 20, 20, 8589934770 }, -- Prueba en Tierra de Gigantes
        { 1825, 20, 20, 8589934770 }, -- Habla con Thun'grim
        { 1838, 30, 20, 8589934770 }, -- Armadura brutal
        { 1848, 30, 20, 8589934770 }, -- Camisote brutal
        { 1839, 30, 20, 8589934770 }, -- Ula'elek y los guanteletes brutales
        { 1840, 30, 20, 8589934770 }, -- Orm Pezuñapétrea y el yelmo brutal
        { 1841, 30, 20, 8589934770 }, -- Velora Noctis y las musleras brutal
        { 1842, 30, 20, 8589934770 }, -- Pezuñas de sátiro
        { 1843, 30, 20, 8589934770 }, -- Guanteletes brutales
        { 1844, 30, 20, 8589934770 }, -- Cuerno de quimera
        { 1845, 30, 20, 8589934770 }, -- Yelmo brutal
        { 1846, 30, 20, 8589934770 }, -- Tibias de Faucedraco
        { 1847, 30, 20, 8589934770 }, -- Musleras brutales
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARRIOR_7508",
    faction = "Horde",
    class = "WARRIOR",
    titleQuest = 7508,
    minLevel = 60,
    maxLevel = 60,
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 18348, 0 },
        { "rep", 809, 200 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 7507, 60, 60 }, -- Compendio de Nostro
        { 7508, 60, 60 }, -- Forjar Quel'Serrar
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARRIOR_8425",
    faction = "Horde",
    class = "WARRIOR",
    titleQuest = 8425,
    minLevel = 52,
    maxLevel = 52,
    areaId = 8,
    zone = "Swamp of Sorrows",
    focus = { 34.3, 66.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 20521, 8425 },
        { "choice", 20130, 8425 },
        { "choice", 20517, 8425 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8423, 52, 50 }, -- Parentesco guerrero
        { 8424, 52, 50 }, -- La guerra contra los Sombra Jurada
        { 8425, 52, 50 }, -- Plumas Vudú
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARRIOR_8044",
    faction = "Horde",
    class = "WARRIOR",
    titleQuest = 8044,
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
        { 8041, 60, 60 }, -- La fuerza del Monte Mugamba
        { 8042, 60, 60 }, -- La fuerza del Monte Mugamba
        { 8043, 60, 60 }, -- La fuerza del Monte Mugamba
        { 8044, 60, 60 }, -- La Ira de Mugamba
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_WARRIOR_Misc",
    faction = "Horde",
    class = "WARRIOR",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 68.0, 45.8 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20699, 8316 },
        { "item", 20710, 8316 },
        { "item", 6851, 1714 },
        { "item", 275290, 94003 },
        { "rep", 529, 1600 },
        { "rep", 270, 450 },
        { "rep", 609, 400 },
        { "rep", 76, 200 },
        { "rep", 530, 200 },
        { "rep", 809, 200 },
        { "rep", 2778, 100 },
        { "rep", 2779, 100 },
        { "rep", 81, 50 },
        { "rep", 68, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 2383, 1, 1, 2 }, -- Pergamino sencillo
        { 3065, 1, 1, 128 }, -- Tablilla sencilla
        { 3091, 1, 1, 32 }, -- La nota simple
        { 3095, 1, 1, 16 }, -- Un pergamino simple
        { 92532, 2, 2 }, -- La senda del guerrero
        { 792, 4, 2, 8589934770 }, -- Familiares viles
        { 1505, 10, 10, 8589934770 }, -- Uzzek, el veterano
        { 1818, 10, 10, 8589934770 }, -- Habla con Dillinger
        { 94003, 10, 10, 12884901888 }, -- El baluarte Rompecielos
        { 1823, 20, 20, 8589934770 }, -- Habla con Ruga
        { 1714, 37, 30 }, -- Esencia del exilio
        { 8417, 50, 50 }, -- Un espíritu afligido
        { 7499, 60, 54 }, -- Códice de Defensa
        { 8058, 60, 60 }, -- Dechados de Poder: los Guardabrazos de vindicador
        { 8078, 60, 60 }, -- Dechados de Poder: el Cinturón de vindicador
        { 8079, 60, 60 }, -- Dechados de Poder: el Peto de vindicador
        { 8316, 60, 58 }, -- Armamentos de guerra
        { 8556, 60, 60 }, -- El anillo con sello de fuerza implacable
        { 8557, 60, 60 }, -- El mantón de fuerza implacable
        { 8558, 60, 60 }, -- La hoz de fuerza implacable
        { 8920, 60, 58, 8589934770 }, -- Una propuesta seria
        { 8944, 60, 58, 8589934770 }, -- Una compensación justa
        { 9013, 60, 58, 8589934770 }, -- Guardar lo mejor para el final
        { 9022, 60, 58, 8589934770 }, -- La despedida de Anthion
        { 9034, 60, 60 }, -- La coraza acorator
        { 9036, 60, 60 }, -- Los quijotes acorator
        { 9037, 60, 60 }, -- El casco acorator
        { 9038, 60, 60 }, -- Los espaldares acorator
        { 9039, 60, 60 }, -- Los escarpes acorator
        { 9040, 60, 60 }, -- Los guanteletes acorator
        { 9041, 60, 60 }, -- Los guardarrenes acorator
        { 9042, 60, 60 }, -- Los brazales acorator
        { 9234, 60, 60 }, -- Los guanteletes Deliriohelado
        { 9235, 60, 60 }, -- Los brazales Deliriohelado
        { 9236, 60, 60 }, -- La coraza Deliriohelado
    },
})

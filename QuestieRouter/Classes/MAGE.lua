-- Generado por tools/class_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Guías de clase: MAGE
local _, QR = ...
if select(2, UnitClass("player")) ~= "MAGE" then return end

QR:RegisterClassGuide({
    key = "Alliance_Class_MAGE_1941",
    faction = "Alliance",
    class = "MAGE",
    titleQuest = 1941,
    minLevel = 15,
    maxLevel = 16,
    areaId = 1519,
    zone = "Stormwind City",
    focus = { 50.3, 85.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 7509, 1941 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1920, 16, 15, 4294967361 }, -- Investiga lo que pasa en El Ermitaño Azul
        { 1921, 15, 15, 65 }, -- Recolección de materiales
        { 1941, 15, 15, 65 }, -- Toga Tejemaná
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_MAGE_9364",
    faction = "Alliance",
    class = "MAGE",
    titleQuest = 9364,
    minLevel = 60,
    maxLevel = 60,
    areaId = 16,
    zone = "Azshara",
    focus = { 29.2, 40.2 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 28272, 0 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 9362, 60, 60 }, -- Señor de la Guerra Krellian
        { 9364, 60, 60 }, -- Magia fragmentada
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_MAGE_1942",
    faction = "Alliance",
    class = "MAGE",
    titleQuest = 1942,
    minLevel = 26,
    maxLevel = 28,
    areaId = 1519,
    zone = "Stormwind City",
    focus = { 49.8, 86.2 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 7511, 1942 },
        { "choice", 9516, 1942 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1938, 28, 26, 65 }, -- Tratado de Ur sobre la Magia de las Sombras
        { 1940, 26, 26, 65 }, -- Seda prístina de araña
        { 1942, 26, 26, 65 }, -- Prendas de nudo astral
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_MAGE_1952",
    faction = "Alliance",
    class = "MAGE",
    titleQuest = 1952,
    minLevel = 30,
    maxLevel = 40,
    areaId = 15,
    zone = "Dustwallow Marsh",
    focus = { 46.1, 57.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 7514, 1952 },
        { "choice", 11263, 1952 },
        { "choice", 7513, 1952 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1947, 38, 30 }, -- Viaje al pantano
        { 1949, 38, 30 }, -- Secretos escondidos
        { 1950, 30, 30 }, -- Santo y seña
        { 1948, 40, 30 }, -- Objetos de poder
        { 1951, 40, 30 }, -- Rituales de poder
        { 1952, 40, 30 }, -- Varitas de mago
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_MAGE_1958",
    faction = "Alliance",
    class = "MAGE",
    titleQuest = 1958,
    minLevel = 40,
    maxLevel = 40,
    areaId = 15,
    zone = "Dustwallow Marsh",
    focus = { 46.1, 57.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 7515, 1958 },
        { "choice", 9517, 1958 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1954, 40, 35 }, -- El orbe infernal
        { 1955, 40, 35 }, -- El exorcismo
        { 1956, 40, 35 }, -- Poder en Uldaman
        { 1957, 40, 35 }, -- Oleadas de maná
        { 1958, 40, 35 }, -- Poder celestial
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_MAGE_8104",
    faction = "Alliance",
    class = "MAGE",
    titleQuest = 8104,
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
        { 8101, 60, 60 }, -- El guijarro de Kajaro
        { 8102, 60, 60 }, -- El guijarro de Kajaro
        { 8103, 60, 60 }, -- El guijarro de Kajaro
        { 8104, 60, 60 }, -- La Joya de Kajaro
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_MAGE_9270",
    faction = "Alliance",
    class = "MAGE",
    titleQuest = 9270,
    minLevel = 60,
    maxLevel = 60,
    areaId = 440,
    zone = "Tanaris",
    focus = { 65.3, 50.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 22589, 9270 },
        { "rep", 910, 600 },
        { "rep", 529, 600 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 9250, 60, 60 }, -- Cuerpo de Atiesh
        { 9251, 60, 60 }, -- Atiesh, el gran báculo maligno
        { 9270, 60, 60 }, -- Atiesh, Greatstaff of the Guardian
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_MAGE_8253",
    faction = "Alliance",
    class = "MAGE",
    titleQuest = 8253,
    minLevel = 52,
    maxLevel = 52,
    areaId = 16,
    zone = "Azshara",
    focus = { 29.2, 40.2 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 20035, 8253 },
        { "choice", 20037, 8253 },
        { "choice", 20036, 8253 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8251, 52, 50 }, -- El polvo mágico
        { 8252, 52, 50 }, -- El coral de las sirenas
        { 8253, 52, 50 }, -- Destruye a Morphaz
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_MAGE_Misc",
    faction = "Alliance",
    class = "MAGE",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 67.8, 45.9 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20705, 8381 },
        { "item", 20716, 8381 },
        { "choice", 7507, 1880 },
        { "choice", 9514, 1880 },
        { "choice", 7508, 1861 },
        { "choice", 9513, 1861 },
        { "rep", 529, 1600 },
        { "rep", 270, 450 },
        { "rep", 609, 400 },
        { "rep", 809, 200 },
        { "rep", 2779, 100 },
        { "rep", 72, 50 },
        { "rep", 54, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 3104, 1, 1, 1 }, -- Una carta con glifos
        { 3114, 1, 1, 64 }, -- Memorándum con inscripciones
        { 92481, 2, 2, 4294967373 }, -- El estudio de lo Arcano
        { 1860, 10, 10, 65 }, -- Habla con Jennea
        { 1861, 10, 10, 4294967361 }, -- Lago Espejo
        { 1879, 10, 10, 65 }, -- Habla con Bink
        { 1880, 10, 10, 65 }, -- Trastónitor maguitronic
        { 93791, 10, 10, 4294967373 }, -- Hablar con Belann
        { 1919, 15, 15, 65 }, -- Preséntate ante Jennea
        { 97286, 20, 1 }, -- Acceso a la investigación
        { 1939, 26, 26, 65 }, -- Alto Hechicero Andromath
        { 1953, 40, 35 }, -- Regreso al pantano
        { 82084, 45, 42 }, -- A Lesson in Literacy
        { 8250, 52, 50 }, -- Pura magia
        { 7500, 60, 54 }, -- El libro de cocina del Arcanista
        { 8060, 60, 60 }, -- Dechados de Poder: los Brazaletes de ilusionista
        { 8068, 60, 60 }, -- Dechados de Poder: el Manto de ilusionista
        { 8069, 60, 60 }, -- Dechados de Poder: la Toga de ilusionista
        { 8381, 60, 58 }, -- Armamentos de guerra
        { 8691, 60, 60 }, -- El mantón de secretos oscuros
        { 8699, 60, 60 }, -- La sortija de secretos oscuros
        { 8707, 60, 60 }, -- La espada de secretos oscuros
        { 8907, 60, 58, 4294967373 }, -- Una propuesta seria
        { 8932, 60, 58, 4294967373 }, -- Una compensación justa
        { 8953, 60, 58, 4294967373 }, -- La despedida de Anthion
        { 9001, 60, 58, 4294967373 }, -- Guardar lo mejor para el final
        { 9095, 60, 60 }, -- La toga de Fuego de Escarcha
        { 9096, 60, 60 }, -- Los leotardos de Fuego de Escarcha
        { 9097, 60, 60 }, -- El aro de Fuego de Escarcha
        { 9098, 60, 60 }, -- Las hombreras de Fuego de Escarcha
        { 9099, 60, 60 }, -- Los botines de Fuego de Escarcha
        { 9100, 60, 60 }, -- Los guantes de Fuego de Escarcha
        { 9101, 60, 60 }, -- El cinturón de Fuego de Escarcha
        { 9102, 60, 60 }, -- Las ataduras de Fuego de Escarcha
        { 9238, 60, 60 }, -- Las muñequeras glaciales
        { 9239, 60, 60 }, -- Los guantes glaciales
        { 9240, 60, 60 }, -- El jubón glacial
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_MAGE_9364",
    faction = "Horde",
    class = "MAGE",
    titleQuest = 9364,
    minLevel = 60,
    maxLevel = 60,
    areaId = 16,
    zone = "Azshara",
    focus = { 29.2, 40.2 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 28272, 0 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 9362, 60, 60 }, -- Señor de la Guerra Krellian
        { 9364, 60, 60 }, -- Magia fragmentada
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_MAGE_1946",
    faction = "Horde",
    class = "MAGE",
    titleQuest = 1946,
    minLevel = 26,
    maxLevel = 26,
    areaId = 1637,
    zone = "Orgrimmar",
    focus = { 38.5, 86.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 7512, 1946 },
        { "choice", 9515, 1946 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1944, 26, 26, 144 }, -- Aguas de Xavian
        { 1945, 26, 26, 144 }, -- Hermanas sonrientes
        { 1946, 26, 26, 144 }, -- Prendas de encaje abisal
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_MAGE_1952",
    faction = "Horde",
    class = "MAGE",
    titleQuest = 1952,
    minLevel = 30,
    maxLevel = 40,
    areaId = 15,
    zone = "Dustwallow Marsh",
    focus = { 46.1, 57.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 7514, 1952 },
        { "choice", 11263, 1952 },
        { "choice", 7513, 1952 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1947, 38, 30 }, -- Viaje al pantano
        { 1949, 38, 30 }, -- Secretos escondidos
        { 1950, 30, 30 }, -- Santo y seña
        { 1948, 40, 30 }, -- Objetos de poder
        { 1951, 40, 30 }, -- Rituales de poder
        { 1952, 40, 30 }, -- Varitas de mago
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_MAGE_1958",
    faction = "Horde",
    class = "MAGE",
    titleQuest = 1958,
    minLevel = 40,
    maxLevel = 40,
    areaId = 15,
    zone = "Dustwallow Marsh",
    focus = { 46.1, 57.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 7515, 1958 },
        { "choice", 9517, 1958 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1954, 40, 35 }, -- El orbe infernal
        { 1955, 40, 35 }, -- El exorcismo
        { 1956, 40, 35 }, -- Poder en Uldaman
        { 1957, 40, 35 }, -- Oleadas de maná
        { 1958, 40, 35 }, -- Poder celestial
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_MAGE_1962",
    faction = "Horde",
    class = "MAGE",
    titleQuest = 1962,
    minLevel = 15,
    maxLevel = 16,
    areaId = 1497,
    zone = "Undercity",
    focus = { 80.3, 16.9 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 7510, 1962 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1960, 16, 15, 146 }, -- Investiga la tienda de alquimia
        { 1961, 15, 15, 146 }, -- Recolección de materiales
        { 1962, 15, 15, 144 }, -- Toga Fuegohechizo
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_MAGE_8104",
    faction = "Horde",
    class = "MAGE",
    titleQuest = 8104,
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
        { 8101, 60, 60 }, -- El guijarro de Kajaro
        { 8102, 60, 60 }, -- El guijarro de Kajaro
        { 8103, 60, 60 }, -- El guijarro de Kajaro
        { 8104, 60, 60 }, -- La Joya de Kajaro
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_MAGE_9270",
    faction = "Horde",
    class = "MAGE",
    titleQuest = 9270,
    minLevel = 60,
    maxLevel = 60,
    areaId = 440,
    zone = "Tanaris",
    focus = { 65.3, 50.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 22589, 9270 },
        { "rep", 910, 600 },
        { "rep", 529, 600 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 9250, 60, 60 }, -- Cuerpo de Atiesh
        { 9251, 60, 60 }, -- Atiesh, el gran báculo maligno
        { 9270, 60, 60 }, -- Atiesh, Greatstaff of the Guardian
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_MAGE_8253",
    faction = "Horde",
    class = "MAGE",
    titleQuest = 8253,
    minLevel = 52,
    maxLevel = 52,
    areaId = 16,
    zone = "Azshara",
    focus = { 29.2, 40.2 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 20035, 8253 },
        { "choice", 20037, 8253 },
        { "choice", 20036, 8253 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8251, 52, 50 }, -- El polvo mágico
        { 8252, 52, 50 }, -- El coral de las sirenas
        { 8253, 52, 50 }, -- Destruye a Morphaz
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_MAGE_Misc",
    faction = "Horde",
    class = "MAGE",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 67.8, 45.9 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20705, 8381 },
        { "item", 20716, 8381 },
        { "choice", 7508, 1884 },
        { "choice", 9513, 1884 },
        { "choice", 7507, 1882 },
        { "choice", 9514, 1882 },
        { "rep", 529, 1600 },
        { "rep", 270, 450 },
        { "rep", 609, 400 },
        { "rep", 530, 200 },
        { "rep", 76, 200 },
        { "rep", 809, 200 },
        { "rep", 68, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 3086, 1, 1, 128 }, -- Tablilla con glifos
        { 3098, 1, 1, 16 }, -- Un pergamino con glifos
        { 98576, 1, 1, 2 }, -- Glyphic Parchment
        { 792, 4, 2, 8589934770 }, -- Familiares viles
        { 1881, 10, 10, 144 }, -- Habla con Anastasia
        { 1882, 10, 10, 144 }, -- La Hacienda Balnir
        { 1883, 10, 10, 8589934770 }, -- Habla con Un'thuwa
        { 1884, 10, 10, 146 }, -- Montones de Ju-Ju
        { 1959, 15, 15, 144 }, -- Preséntate ante Anastasia
        { 97286, 20, 1 }, -- Acceso a la investigación
        { 1943, 26, 26, 144 }, -- Habla con Deino
        { 1953, 40, 35 }, -- Regreso al pantano
        { 82084, 45, 42 }, -- A Lesson in Literacy
        { 8250, 52, 50 }, -- Pura magia
        { 7500, 60, 54 }, -- El libro de cocina del Arcanista
        { 8060, 60, 60 }, -- Dechados de Poder: los Brazaletes de ilusionista
        { 8068, 60, 60 }, -- Dechados de Poder: el Manto de ilusionista
        { 8069, 60, 60 }, -- Dechados de Poder: la Toga de ilusionista
        { 8381, 60, 58 }, -- Armamentos de guerra
        { 8691, 60, 60 }, -- El mantón de secretos oscuros
        { 8699, 60, 60 }, -- La sortija de secretos oscuros
        { 8707, 60, 60 }, -- La espada de secretos oscuros
        { 8915, 60, 58, 8589934770 }, -- Una propuesta seria
        { 8939, 60, 58, 8589934770 }, -- Una compensación justa
        { 9014, 60, 58, 8589934770 }, -- Guardar lo mejor para el final
        { 9018, 60, 58, 8589934770 }, -- La despedida de Anthion
        { 9095, 60, 60 }, -- La toga de Fuego de Escarcha
        { 9096, 60, 60 }, -- Los leotardos de Fuego de Escarcha
        { 9097, 60, 60 }, -- El aro de Fuego de Escarcha
        { 9098, 60, 60 }, -- Las hombreras de Fuego de Escarcha
        { 9099, 60, 60 }, -- Los botines de Fuego de Escarcha
        { 9100, 60, 60 }, -- Los guantes de Fuego de Escarcha
        { 9101, 60, 60 }, -- El cinturón de Fuego de Escarcha
        { 9102, 60, 60 }, -- Las ataduras de Fuego de Escarcha
        { 9238, 60, 60 }, -- Las muñequeras glaciales
        { 9239, 60, 60 }, -- Los guantes glaciales
        { 9240, 60, 60 }, -- El jubón glacial
    },
})

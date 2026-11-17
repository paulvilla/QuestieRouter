-- Generado por tools/class_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Guías de clase: DRUID
local _, QR = ...
if select(2, UnitClass("player")) ~= "DRUID" then return end

QR:RegisterClassGuide({
    key = "Alliance_Class_DRUID_5061",
    faction = "Alliance",
    class = "DRUID",
    titleQuest = 5061,
    minLevel = 16,
    maxLevel = 16,
    areaId = 493,
    zone = "Moonglade",
    focus = { 49.6, 33.8 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 1066, 0 },
        { "item", 263411, 5061 },
        { "item", 16608, 5061 },
        { "rep", 609, 250 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 26, 16, 16, 8 }, -- Una lección que aprender
        { 29, 16, 16, 8 }, -- La prueba del lago
        { 272, 16, 16, 4294967304 }, -- La prueba del león marino
        { 5061, 16, 16, 8 }, -- Forma acuática
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_DRUID_94638",
    faction = "Alliance",
    class = "DRUID",
    titleQuest = 94638,
    minLevel = 10,
    maxLevel = 10,
    areaId = 1657,
    zone = "Darnassus",
    focus = { 35.4, 8.4 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 5487, 0 },
        { "rep", 609, 275 },
        { "rep", 2758, 100 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 5921, 10, 10, 8 }, -- Claro de la Luna
        { 5929, 10, 10, 8 }, -- Espíritu del gran oso
        { 5931, 10, 10, 8 }, -- El regreso a Darnassus
        { 6001, 10, 10, 8 }, -- Cuerpo y corazón
        { 94006, 10, 10, 12884901888 }, -- El gran espíritu de Ursera
        { 94638, 10, 10, 12884901888 }, -- Fuerza y misericordia
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_DRUID_9269",
    faction = "Alliance",
    class = "DRUID",
    titleQuest = 9269,
    minLevel = 60,
    maxLevel = 60,
    areaId = 440,
    zone = "Tanaris",
    focus = { 65.3, 50.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 22632, 9269 },
        { "rep", 910, 600 },
        { "rep", 529, 600 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 9250, 60, 60 }, -- Cuerpo de Atiesh
        { 9251, 60, 60 }, -- Atiesh, el gran báculo maligno
        { 9269, 60, 60 }, -- Atiesh, Greatstaff of the Guardian
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_DRUID_98397",
    faction = "Alliance",
    class = "DRUID",
    titleQuest = 98397,
    minLevel = 20,
    maxLevel = 20,
    areaId = 493,
    zone = "Moonglade",
    focus = { 57.3, 52.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 768, 0 },
        { "rep", 609, 175 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 98393, 20, 20, 4294967304 }, -- El gran espíritu felino
        { 98394, 20, 20, 8 }, -- El gran espíritu felino
        { 98396, 20, 20, 8 }, -- El gran espíritu felino
        { 98731, 20, 20, 8 }, -- Bendiciones del gran espíritu felino
        { 98397, 20, 20, 4294967304 }, -- A Darnassus
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_DRUID_8113",
    faction = "Alliance",
    class = "DRUID",
    titleQuest = 8113,
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
        { 8110, 60, 60 }, -- Algas de los Mares del Sur encantadas
        { 8111, 60, 60 }, -- Algas de los Mares del Sur encantadas
        { 8112, 60, 60 }, -- Algas de los Mares del Sur encantadas
        { 8113, 60, 60 }, -- Algas de los Mares del Sur encantadas prístinas
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_DRUID_9053",
    faction = "Alliance",
    class = "DRUID",
    titleQuest = 9053,
    minLevel = 52,
    maxLevel = 52,
    areaId = 490,
    zone = "Un'Goro Crater",
    focus = { 71.6, 76.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 13446, 9052 },
        { "choice", 22274, 9053 },
        { "choice", 22272, 9053 },
        { "choice", 22458, 9053 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 9052, 52, 50 }, -- Veneno de pétalo de sangre
        { 9051, 52, 50 }, -- Prueba de toxicidad
        { 9053, 52, 50 }, -- Un ingrediente mejor
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_DRUID_6125",
    faction = "Alliance",
    class = "DRUID",
    titleQuest = 6125,
    minLevel = 14,
    maxLevel = 14,
    areaId = 493,
    zone = "Moonglade",
    focus = { 56.2, 30.6 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 8946, 0 },
        { "item", 15866, 6124 },
        { "rep", 609, 335 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 6121, 14, 14, 4294967304 }, -- Nuevas lecciones
        { 6122, 14, 14, 4294967304 }, -- La fuente del envenenamiento
        { 6123, 14, 14, 4294967304 }, -- Reunir los ingredientes del remedio
        { 6124, 14, 14, 4294967304 }, -- Curar la dolencia
        { 6125, 14, 14, 8 }, -- Poder contra el veneno
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_DRUID_Misc",
    faction = "Alliance",
    class = "DRUID",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 67.6, 46.3 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20704, 8382 },
        { "item", 20714, 8382 },
        { "rep", 529, 1600 },
        { "rep", 609, 500 },
        { "rep", 270, 450 },
        { "rep", 809, 200 },
        { "rep", 2758, 100 },
        { "rep", 69, 50 },
        { "rep", 2778, 50 },
        { "rep", 2779, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 3120, 1, 1, 8 }, -- El sigilo verde
        { 92485, 2, 2 }, -- El estudio de la naturaleza
        { 5923, 10, 10, 8 }, -- Escucha la llamada
        { 5924, 10, 10, 8 }, -- Escucha la llamada
        { 5925, 10, 10, 8 }, -- Atendiendo a la llamada
        { 94912, 10, 10, 4294967296 }, -- Descendiente de la naturaleza
        { 94914, 10, 10, 4294967296 }, -- Claro de la Luna
        { 81924, 50, 40 }, -- Wisdom of the Guardians
        { 9063, 52, 50 }, -- Torwa Abrecaminos
        { 7506, 60, 54 }, -- El Sueño Esmeralda
        { 8057, 60, 60 }, -- Dechados de Poder: los Brazales de adivino
        { 8064, 60, 60 }, -- Dechados de Poder: el Cinturón de adivino
        { 8065, 60, 60 }, -- Dechados de Poder: la guerrera de haruspex
        { 8382, 60, 58 }, -- Armamentos de guerra
        { 8692, 60, 60 }, -- Capa de vida inagotable
        { 8700, 60, 60 }, -- La sortija de vida inagotable
        { 8708, 60, 60 }, -- La maza de vida inagotable
        { 8905, 60, 58, 4294967373 }, -- Una propuesta seria
        { 8926, 60, 58, 4294967373 }, -- Una compensación justa
        { 8951, 60, 58, 4294967373 }, -- La despedida de Anthion
        { 8999, 60, 58, 4294967373 }, -- Guardar lo mejor para el final
        { 9086, 60, 60 }, -- La guerrera Caminasueños
        { 9087, 60, 60 }, -- Las musleras Caminasueños
        { 9088, 60, 60 }, -- La celada Caminasueños
        { 9089, 60, 60 }, -- Las bufas Caminasueños
        { 9090, 60, 60 }, -- Las botas Caminasueños
        { 9091, 60, 60 }, -- Las manoplas Caminasueños
        { 9092, 60, 60 }, -- La faja Caminasueños
        { 9093, 60, 60 }, -- Los guardamuñecas Caminasueños
        { 9241, 60, 60 }, -- Los brazales polares
        { 9242, 60, 60 }, -- Los guantes polares
        { 9243, 60, 60 }, -- La guerrera polar
        { 84147, 60, 58, 4294967373 }, -- An Earnest Proposition
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_DRUID_31",
    faction = "Horde",
    class = "DRUID",
    titleQuest = 31,
    minLevel = 16,
    maxLevel = 16,
    areaId = 493,
    zone = "Moonglade",
    focus = { 49.6, 33.8 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 1066, 0 },
        { "item", 263411, 31 },
        { "item", 16608, 31 },
        { "rep", 609, 250 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 27, 16, 16, 32 }, -- Una lección que aprender
        { 28, 16, 16, 32 }, -- La prueba del lago
        { 30, 16, 16, 32 }, -- La prueba del león marino
        { 31, 16, 16, 32 }, -- Forma acuática
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_DRUID_94638",
    faction = "Horde",
    class = "DRUID",
    titleQuest = 94638,
    minLevel = 10,
    maxLevel = 10,
    areaId = 1638,
    zone = "Thunder Bluff",
    focus = { 76.5, 27.2 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 5487, 0 },
        { "rep", 609, 275 },
        { "rep", 2758, 100 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 5922, 10, 10, 32 }, -- Claro de la Luna
        { 5930, 10, 10, 32 }, -- Espíritu del gran oso
        { 5932, 10, 10, 32 }, -- Vuelve a Cima del Trueno
        { 6002, 10, 10, 32 }, -- Cuerpo y corazón
        { 94006, 10, 10, 12884901888 }, -- El gran espíritu de Ursera
        { 94638, 10, 10, 12884901888 }, -- Fuerza y misericordia
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_DRUID_9269",
    faction = "Horde",
    class = "DRUID",
    titleQuest = 9269,
    minLevel = 60,
    maxLevel = 60,
    areaId = 440,
    zone = "Tanaris",
    focus = { 65.3, 50.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 22632, 9269 },
        { "rep", 910, 600 },
        { "rep", 529, 600 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 9250, 60, 60 }, -- Cuerpo de Atiesh
        { 9251, 60, 60 }, -- Atiesh, el gran báculo maligno
        { 9269, 60, 60 }, -- Atiesh, Greatstaff of the Guardian
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_DRUID_98362",
    faction = "Horde",
    class = "DRUID",
    titleQuest = 98362,
    minLevel = 20,
    maxLevel = 20,
    areaId = 493,
    zone = "Moonglade",
    focus = { 57.3, 52.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 768, 0 },
        { "rep", 609, 175 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 98340, 20, 20, 8589934624 }, -- El gran espíritu felino
        { 98405, 20, 20, 32 }, -- El gran espíritu felino
        { 98342, 20, 20, 32 }, -- El gran espíritu felino
        { 98739, 20, 20, 32 }, -- Bendiciones del gran espíritu felino
        { 98362, 20, 20, 8589934624 }, -- Viaje a Cima del Trueno
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_DRUID_8113",
    faction = "Horde",
    class = "DRUID",
    titleQuest = 8113,
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
        { 8110, 60, 60 }, -- Algas de los Mares del Sur encantadas
        { 8111, 60, 60 }, -- Algas de los Mares del Sur encantadas
        { 8112, 60, 60 }, -- Algas de los Mares del Sur encantadas
        { 8113, 60, 60 }, -- Algas de los Mares del Sur encantadas prístinas
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_DRUID_9053",
    faction = "Horde",
    class = "DRUID",
    titleQuest = 9053,
    minLevel = 52,
    maxLevel = 52,
    areaId = 490,
    zone = "Un'Goro Crater",
    focus = { 71.6, 76.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 13446, 9052 },
        { "choice", 22274, 9053 },
        { "choice", 22272, 9053 },
        { "choice", 22458, 9053 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 9052, 52, 50 }, -- Veneno de pétalo de sangre
        { 9051, 52, 50 }, -- Prueba de toxicidad
        { 9053, 52, 50 }, -- Un ingrediente mejor
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_DRUID_6130",
    faction = "Horde",
    class = "DRUID",
    titleQuest = 6130,
    minLevel = 14,
    maxLevel = 14,
    areaId = 493,
    zone = "Moonglade",
    focus = { 56.2, 30.6 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 8946, 0 },
        { "item", 15866, 6129 },
        { "rep", 609, 335 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 6126, 14, 14, 32 }, -- Nuevas lecciones
        { 6127, 14, 14, 32 }, -- La fuente del envenenamiento
        { 6128, 14, 14, 32 }, -- Reunir los ingredientes del remedio
        { 6129, 14, 14, 32 }, -- Curar la dolencia
        { 6130, 14, 14, 32 }, -- Poder contra el veneno
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_DRUID_Misc",
    faction = "Horde",
    class = "DRUID",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 67.6, 46.3 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20704, 8382 },
        { "item", 20714, 8382 },
        { "rep", 529, 1600 },
        { "rep", 609, 500 },
        { "rep", 270, 450 },
        { "rep", 809, 200 },
        { "rep", 76, 150 },
        { "rep", 530, 150 },
        { "rep", 2758, 100 },
        { "rep", 81, 50 },
        { "rep", 2778, 50 },
        { "rep", 2779, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 3094, 1, 1, 32 }, -- La nota verde
        { 92485, 2, 2 }, -- El estudio de la naturaleza
        { 792, 4, 2, 8589934770 }, -- Familiares viles
        { 5926, 10, 10, 32 }, -- Escucha la llamada
        { 5927, 10, 10, 32 }, -- Escucha la llamada
        { 5928, 10, 10, 32 }, -- Escucha la llamada
        { 94911, 10, 10, 8589934592 }, -- Descendiente de la naturaleza
        { 94913, 10, 10, 8589934592 }, -- Claro de la Luna
        { 81924, 50, 40 }, -- Wisdom of the Guardians
        { 9063, 52, 50 }, -- Torwa Abrecaminos
        { 7506, 60, 54 }, -- El Sueño Esmeralda
        { 8057, 60, 60 }, -- Dechados de Poder: los Brazales de adivino
        { 8064, 60, 60 }, -- Dechados de Poder: el Cinturón de adivino
        { 8065, 60, 60 }, -- Dechados de Poder: la guerrera de haruspex
        { 8382, 60, 58 }, -- Armamentos de guerra
        { 8692, 60, 60 }, -- Capa de vida inagotable
        { 8700, 60, 60 }, -- La sortija de vida inagotable
        { 8708, 60, 60 }, -- La maza de vida inagotable
        { 8913, 60, 58, 8589934770 }, -- Una propuesta seria
        { 8927, 60, 58, 8589934770 }, -- Una compensación justa
        { 9007, 60, 58, 8589934770 }, -- Guardar lo mejor para el final
        { 9016, 60, 58, 8589934770 }, -- La despedida de Anthion
        { 9086, 60, 60 }, -- La guerrera Caminasueños
        { 9087, 60, 60 }, -- Las musleras Caminasueños
        { 9088, 60, 60 }, -- La celada Caminasueños
        { 9089, 60, 60 }, -- Las bufas Caminasueños
        { 9090, 60, 60 }, -- Las botas Caminasueños
        { 9091, 60, 60 }, -- Las manoplas Caminasueños
        { 9092, 60, 60 }, -- La faja Caminasueños
        { 9093, 60, 60 }, -- Los guardamuñecas Caminasueños
        { 9241, 60, 60 }, -- Los brazales polares
        { 9242, 60, 60 }, -- Los guantes polares
        { 9243, 60, 60 }, -- La guerrera polar
    },
})

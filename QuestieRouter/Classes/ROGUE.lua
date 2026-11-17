-- Generado por tools/class_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Guías de clase: ROGUE
local _, QR = ...
if select(2, UnitClass("player")) ~= "ROGUE" then return end

QR:RegisterClassGuide({
    key = "Alliance_Class_ROGUE_6701",
    faction = "Alliance",
    class = "ROGUE",
    titleQuest = 6701,
    minLevel = 24,
    maxLevel = 60,
    areaId = 36,
    zone = "Alterac Mountains",
    focus = { 84.2, 79.7 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "rep", 349, 500 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 6681, 24, 24 }, -- Mansión Ravenholdt
        { 96779, 24, 24 }, -- Syndicate Sabotage
        { 96781, 36, 24 }, -- Despejando incógnitas
        { 96782, 36, 24, 4294967373 }, -- Extracción encubierta
        { 96783, 36, 24 }, -- La entrada
        { 96784, 36, 24 }, -- Master of Disguise
        { 6701, 60, 24 }, -- Emblemas de la Hermandad
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_ROGUE_80411",
    faction = "Alliance",
    class = "ROGUE",
    titleQuest = 80411,
    minLevel = 50,
    maxLevel = 50,
    areaId = 36,
    zone = "Alterac Mountains",
    focus = { 84.5, 80.3 },   -- punto medio de la cadena en el mapa de la zona
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 80526, 50, 45 }, -- Fool Me Twice
        { 80411, 50, 45 }, -- The Talisman of Kazdor
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_ROGUE_2242",
    faction = "Alliance",
    class = "ROGUE",
    titleQuest = 2242,
    minLevel = 10,
    maxLevel = 10,
    areaId = 1,
    zone = "Dun Morogh",
    focus = { 36.4, 48.5 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 7298, 2242 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 2205, 10, 10, 4294967373 }, -- Busca el SI: 7
        { 2206, 10, 10, 4294967373 }, -- El robo
        { 2218, 10, 10, 4294967373 }, -- El camino hacia la salvación
        { 2238, 10, 10, 4294967373 }, -- Un simple subterfugio
        { 2239, 10, 10, 4294967373 }, -- El informe de Onin
        { 2241, 10, 10, 4294967373 }, -- Cuando cae la manzana
        { 2242, 10, 10, 4294967373 }, -- La llamada del destino
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_ROGUE_8236",
    faction = "Alliance",
    class = "ROGUE",
    titleQuest = 8236,
    minLevel = 52,
    maxLevel = 52,
    areaId = 16,
    zone = "Azshara",
    focus = { 29.2, 40.2 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 19984, 8236 },
        { "choice", 20255, 8236 },
        { "choice", 19982, 8236 },
        { "rep", 349, 360 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8233, 52, 50 }, -- Un pedido sencillo
        { 8234, 52, 50 }, -- Bolsa azur sellada
        { 8235, 52, 50 }, -- Los fragmentos codificados
        { 8236, 52, 50 }, -- La llave azur
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_ROGUE_2609",
    faction = "Alliance",
    class = "ROGUE",
    titleQuest = 2609,
    minLevel = 20,
    maxLevel = 24,
    areaId = 1519,
    zone = "Stormwind City",
    focus = { 79.2, 70.3 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 2842, 0 },
        { "item", 18160, 2359 },
        { "item", 8432, 2609 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 2360, 20, 20, 4294967373 }, -- Mathias y los Defias
        { 2359, 24, 20, 4294967373 }, -- La torre de Klaven
        { 2607, 20, 20, 4294967373 }, -- Toque de Zanzil
        { 2608, 20, 20, 4294967373 }, -- Toque de Zanzil
        { 2609, 20, 20, 4294967373 }, -- Toque de Zanzil
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_ROGUE_78676",
    faction = "Alliance",
    class = "ROGUE",
    titleQuest = 78676,
    minLevel = 23,
    maxLevel = 35,
    areaId = 130,
    zone = "Silverpine Forest",
    focus = { 47.1, 71.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 277246, 0 },
        { "item", 277210, 78307 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 78261, 23, 1 }, -- El Cuerno de Xelthos
        { 78307, 23, 1 }, -- El Cuerno de Xelthos
        { 78676, 35, 25 }, -- El ojo de Bhossca
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_ROGUE_8144",
    faction = "Alliance",
    class = "ROGUE",
    titleQuest = 8144,
    minLevel = 60,
    maxLevel = 60,
    areaId = 33,
    zone = "Stranglethorn Vale",
    focus = { 14.1, 13.7 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "rep", 270, 400 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8141, 60, 60 }, -- Talismán de las Sombras Zandalar
        { 8142, 60, 60 }, -- Talismán de las Sombras Zandalar
        { 8143, 60, 60 }, -- Talismán de la Sombras Zandalar
        { 8144, 60, 60 }, -- Talismán de dominio de las sombras de Zandalarian
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_ROGUE_2282",
    faction = "Alliance",
    class = "ROGUE",
    titleQuest = 2282,
    minLevel = 16,
    maxLevel = 20,
    areaId = 1519,
    zone = "Stormwind City",
    focus = { 78.3, 71.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 7907, 2282 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 2281, 16, 16, 4294967373 }, -- Cita en Crestagrana
        { 2282, 20, 16, 4294967373 }, -- Molino de Alther
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_ROGUE_Misc",
    faction = "Alliance",
    class = "ROGUE",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 67.7, 46.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20703, 8378 },
        { "item", 20715, 8378 },
        { "item", 277246, 78699 },
        { "item", 210186, 78270 },
        { "rep", 529, 1600 },
        { "rep", 270, 450 },
        { "rep", 609, 400 },
        { "rep", 809, 200 },
        { "rep", 72, 50 },
        { "rep", 47, 50 },
        { "rep", 54, 50 },
        { "rep", 69, 50 },
        { "rep", 2778, 50 },
        { "rep", 2779, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 3102, 1, 1, 1 }, -- Una carta cifrada
        { 3109, 1, 1, 4 }, -- Runa encriptada
        { 3113, 1, 1, 64 }, -- Memorándum encriptado
        { 3118, 1, 1, 8 }, -- El sigilo cifrado
        { 92483, 2, 2 }, -- Un hogar entre las sombras
        { 2259, 16, 16, 4294967373 }, -- Erion Sombrusurro
        { 2260, 16, 16, 4294967373 }, -- La orden de Erion
        { 2298, 16, 16, 4294967373 }, -- Una regia sacudida
        { 2299, 16, 16, 4294967373 }, -- ¡Ve a hablar con Hulfdan!
        { 2300, 16, 16, 4294967373 }, -- SI:7
        { 78270, 23, 1 }, -- Las ganzúas goblin
        { 78699, 35, 25 }, -- The Eye of Bhossca
        { 7498, 60, 54 }, -- Garona: un estudio acerca de la discreción y la traición
        { 8063, 60, 60 }, -- Dechados de Poder: los Brazales de sinconcierto
        { 8072, 60, 60 }, -- Dechados de Poder: el Manto de sinconcierto
        { 8073, 60, 60 }, -- Dechados de Poder: la guerrera de sinconcierto
        { 8378, 60, 58 }, -- Armamentos de guerra
        { 8693, 60, 60 }, -- La capa de las sombras ocultas
        { 8701, 60, 60 }, -- La sortija de las sombras ocultas
        { 8709, 60, 60 }, -- La daga de las sombras ocultas
        { 8910, 60, 58, 4294967373 }, -- Una propuesta seria
        { 8935, 60, 58, 4294967373 }, -- Una compensación justa
        { 8956, 60, 58, 4294967373 }, -- La despedida de Anthion
        { 9004, 60, 58, 4294967373 }, -- Guardar lo mejor para el final
        { 9077, 60, 60 }, -- La coraza Segahuesos
        { 9078, 60, 60 }, -- Los quijotes Segahuesos
        { 9079, 60, 60 }, -- El casco Segahuesos
        { 9080, 60, 60 }, -- Los espaldares Segahuesos
        { 9081, 60, 60 }, -- Los escarpes Segahuesos
        { 9082, 60, 60 }, -- Los guanteletes Segahuesos
        { 9083, 60, 60 }, -- Los guardarrenes Segahuesos
        { 9084, 60, 60 }, -- Los brazales Segahuesos
        { 9241, 60, 60 }, -- Los brazales polares
        { 9242, 60, 60 }, -- Los guantes polares
        { 9243, 60, 60 }, -- La guerrera polar
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_ROGUE_6701",
    faction = "Horde",
    class = "ROGUE",
    titleQuest = 6701,
    minLevel = 24,
    maxLevel = 60,
    areaId = 36,
    zone = "Alterac Mountains",
    focus = { 84.1, 79.5 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "rep", 349, 400 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 6681, 24, 24 }, -- Mansión Ravenholdt
        { 96779, 24, 24 }, -- Syndicate Sabotage
        { 96781, 36, 24 }, -- Despejando incógnitas
        { 96783, 36, 24 }, -- La entrada
        { 96784, 36, 24 }, -- Master of Disguise
        { 6701, 60, 24 }, -- Emblemas de la Hermandad
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_ROGUE_80411",
    faction = "Horde",
    class = "ROGUE",
    titleQuest = 80411,
    minLevel = 50,
    maxLevel = 50,
    areaId = 36,
    zone = "Alterac Mountains",
    focus = { 84.5, 80.3 },   -- punto medio de la cadena en el mapa de la zona
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 80526, 50, 45 }, -- Fool Me Twice
        { 80411, 50, 45 }, -- The Talisman of Kazdor
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_ROGUE_2480",
    faction = "Horde",
    class = "ROGUE",
    titleQuest = 2480,
    minLevel = 20,
    maxLevel = 26,
    areaId = 1637,
    zone = "Orgrimmar",
    focus = { 43.0, 53.7 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 2842, 0 },
        { "item", 18160, 0 },
        { "item", 8066, 2458 },
        { "item", 8095, 2480 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 2460, 20, 20, 8589934770 }, -- El saludo de los Mano Destrozada
        { 2458, 20, 20, 8589934770 }, -- Agente encubierto
        { 2479, 26, 20, 8589934770 }, -- La ayuda de Hinott
        { 2480, 20, 20, 8589934770 }, -- La ayuda de Hinott
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_ROGUE_8236",
    faction = "Horde",
    class = "ROGUE",
    titleQuest = 8236,
    minLevel = 52,
    maxLevel = 52,
    areaId = 16,
    zone = "Azshara",
    focus = { 29.2, 40.2 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 19984, 8236 },
        { "choice", 20255, 8236 },
        { "choice", 19982, 8236 },
        { "rep", 349, 360 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8233, 52, 50 }, -- Un pedido sencillo
        { 8234, 52, 50 }, -- Bolsa azur sellada
        { 8235, 52, 50 }, -- Los fragmentos codificados
        { 8236, 52, 50 }, -- La llave azur
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_ROGUE_1978",
    faction = "Horde",
    class = "ROGUE",
    titleQuest = 1978,
    minLevel = 13,
    maxLevel = 13,
    areaId = 1497,
    zone = "Undercity",
    focus = { 76.3, 70.9 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 7298, 1978 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1886, 13, 10, 16 }, -- Los Mortacechadores
        { 1898, 13, 10, 16 }, -- Los Mortacechadores
        { 1899, 13, 10, 16 }, -- Los Mortacechadores
        { 1963, 13, 10, 130 }, -- Mano Destrozada
        { 1858, 13, 10, 130 }, -- Mano Destrozada
        { 1978, 13, 10, 16 }, -- Los Mortacechadores
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_ROGUE_78676",
    faction = "Horde",
    class = "ROGUE",
    titleQuest = 78676,
    minLevel = 23,
    maxLevel = 35,
    areaId = 130,
    zone = "Silverpine Forest",
    focus = { 47.1, 71.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 277246, 0 },
        { "item", 277210, 78307 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 78261, 23, 1 }, -- El Cuerno de Xelthos
        { 78307, 23, 1 }, -- El Cuerno de Xelthos
        { 78676, 35, 25 }, -- El ojo de Bhossca
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_ROGUE_1999",
    faction = "Horde",
    class = "ROGUE",
    titleQuest = 1999,
    minLevel = 16,
    maxLevel = 20,
    areaId = 1497,
    zone = "Undercity",
    focus = { 83.5, 69.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 7676, 2381 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 1998, 16, 16, 16 }, -- Fenwick Thatros
        { 2379, 16, 16, 8589934770 }, -- Zando'zan
        { 2382, 16, 16, 8589934770 }, -- Desdio de Trinquete
        { 2381, 18, 16, 8589934770 }, -- Saquear a los saqueadores
        { 1999, 20, 16, 16 }, -- Herramientas de comercio
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_ROGUE_8144",
    faction = "Horde",
    class = "ROGUE",
    titleQuest = 8144,
    minLevel = 60,
    maxLevel = 60,
    areaId = 33,
    zone = "Stranglethorn Vale",
    focus = { 14.1, 13.7 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "rep", 270, 400 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8141, 60, 60 }, -- Talismán de las Sombras Zandalar
        { 8142, 60, 60 }, -- Talismán de las Sombras Zandalar
        { 8143, 60, 60 }, -- Talismán de la Sombras Zandalar
        { 8144, 60, 60 }, -- Talismán de dominio de las sombras de Zandalarian
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_ROGUE_Misc",
    faction = "Horde",
    class = "ROGUE",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 67.7, 46.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20703, 8378 },
        { "item", 20715, 8378 },
        { "item", 277246, 78699 },
        { "item", 210186, 78270 },
        { "rep", 529, 1600 },
        { "rep", 270, 450 },
        { "rep", 609, 400 },
        { "rep", 530, 200 },
        { "rep", 76, 200 },
        { "rep", 809, 200 },
        { "rep", 68, 50 },
        { "rep", 2778, 50 },
        { "rep", 2779, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 3083, 1, 1, 128 }, -- Tablilla encriptada
        { 3088, 1, 1, 2 }, -- Pergamino encriptado
        { 3096, 1, 1, 16 }, -- Un pergamino encriptado
        { 92483, 2, 2 }, -- Un hogar entre las sombras
        { 792, 4, 2, 8589934770 }, -- Familiares viles
        { 1859, 10, 10, 2 }, -- Therzok
        { 1885, 10, 10, 16 }, -- Mennet Carkad
        { 2378, 16, 16, 8589934770 }, -- Encuentra a los Mano Destrozada
        { 2380, 16, 16, 8589934770 }, -- Ve a Orgrimmar
        { 78270, 23, 1 }, -- Las ganzúas goblin
        { 78699, 35, 25 }, -- The Eye of Bhossca
        { 7498, 60, 54 }, -- Garona: un estudio acerca de la discreción y la traición
        { 8063, 60, 60 }, -- Dechados de Poder: los Brazales de sinconcierto
        { 8072, 60, 60 }, -- Dechados de Poder: el Manto de sinconcierto
        { 8073, 60, 60 }, -- Dechados de Poder: la guerrera de sinconcierto
        { 8378, 60, 58 }, -- Armamentos de guerra
        { 8693, 60, 60 }, -- La capa de las sombras ocultas
        { 8701, 60, 60 }, -- La sortija de las sombras ocultas
        { 8709, 60, 60 }, -- La daga de las sombras ocultas
        { 8917, 60, 58, 8589934770 }, -- Una propuesta seria
        { 8941, 60, 58, 8589934770 }, -- Una compensación justa
        { 9010, 60, 58, 8589934770 }, -- Guardar lo mejor para el final
        { 9020, 60, 58, 8589934770 }, -- La despedida de Anthion
        { 9077, 60, 60 }, -- La coraza Segahuesos
        { 9078, 60, 60 }, -- Los quijotes Segahuesos
        { 9079, 60, 60 }, -- El casco Segahuesos
        { 9080, 60, 60 }, -- Los espaldares Segahuesos
        { 9081, 60, 60 }, -- Los escarpes Segahuesos
        { 9082, 60, 60 }, -- Los guanteletes Segahuesos
        { 9083, 60, 60 }, -- Los guardarrenes Segahuesos
        { 9084, 60, 60 }, -- Los brazales Segahuesos
        { 9241, 60, 60 }, -- Los brazales polares
        { 9242, 60, 60 }, -- Los guantes polares
        { 9243, 60, 60 }, -- La guerrera polar
    },
})

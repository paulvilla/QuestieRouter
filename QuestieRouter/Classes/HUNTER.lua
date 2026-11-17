-- Generado por tools/class_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Guías de clase: HUNTER
local _, QR = ...
if select(2, UnitClass("player")) ~= "HUNTER" then return end

QR:RegisterClassGuide({
    key = "Alliance_Class_HUNTER_94050",
    faction = "Alliance",
    class = "HUNTER",
    titleQuest = 94050,
    minLevel = 10,
    maxLevel = 10,
    areaId = 141,
    zone = "Teldrassil",
    focus = { 56.7, 59.5 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 1515, 0 },
        { "spell", 5149, 0 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 6063, 10, 10, 8 }, -- Domesticar la bestia
        { 6064, 10, 10, 4 }, -- Domesticar la bestia
        { 6084, 10, 10, 4 }, -- Domesticar la bestia
        { 6085, 10, 10, 4 }, -- Domesticar la bestia
        { 6086, 10, 10, 4 }, -- Entrenar a la bestia
        { 94792, 10, 10, 4294967373 }, -- Domar a la bestia
        { 94863, 10, 10, 4294967373 }, -- Domar a la bestia
        { 94864, 10, 10, 4294967373 }, -- Domar a la bestia
        { 94793, 10, 10, 4294967373 }, -- Entrenar a la bestia
        { 94978, 10, 10, 12884901888 }, -- Domar a la bestia
        { 94979, 10, 10, 12884901888 }, -- Domar a la bestia
        { 94013, 10, 10, 12884901888 }, -- Domar a la bestia
        { 6101, 10, 10, 8 }, -- Domesticar la bestia
        { 6102, 10, 10, 8 }, -- Domesticar la bestia
        { 6103, 10, 10, 8 }, -- Domesticar la bestia
        { 94050, 10, 10, 12884901888 }, -- Entrenar a la bestia
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_HUNTER_8232",
    faction = "Alliance",
    class = "HUNTER",
    titleQuest = 8232,
    minLevel = 52,
    maxLevel = 52,
    areaId = 16,
    zone = "Azshara",
    focus = { 42.4, 42.6 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 20083, 8232 },
        { "choice", 19991, 8232 },
        { "choice", 19992, 8232 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8151, 52, 50 }, -- El talismán del cazador
        { 8153, 52, 50 }, -- Cuernos de corcel
        { 8231, 52, 50 }, -- Los vándalos marinos
        { 8232, 52, 50 }, -- El draco verde
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_HUNTER_8148",
    faction = "Alliance",
    class = "HUNTER",
    titleQuest = 8148,
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
        { 8145, 60, 60 }, -- Zarcillo de La Vorágine
        { 8146, 60, 60 }, -- Zarcillo de La Vorágine
        { 8147, 60, 60 }, -- Zarcillo de La Vorágine
        { 8148, 60, 60 }, -- Cólera de La Vorágine
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_HUNTER_Misc",
    faction = "Alliance",
    class = "HUNTER",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 67.8, 46.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20702, 8377 },
        { "item", 20713, 8377 },
        { "item", 18707, 7636 },
        { "item", 18724, 7635 },
        { "item", 18714, 7634 },
        { "item", 18473, 7503 },
        { "rep", 529, 1600 },
        { "rep", 270, 450 },
        { "rep", 609, 400 },
        { "rep", 809, 200 },
        { "rep", 47, 50 },
        { "rep", 69, 50 },
        { "rep", 72, 50 },
        { "rep", 2778, 50 },
        { "rep", 2779, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 3108, 1, 1, 4 }, -- Runa con grabados
        { 3117, 1, 1, 8 }, -- El sigilo con grabados
        { 92479, 1, 1, 1 }, -- Una carta garabateada
        { 92482, 2, 2 }, -- La senda del cazador
        { 6071, 10, 10, 8 }, -- El camino del cazador
        { 6073, 10, 10, 8 }, -- El camino del cazador
        { 6074, 10, 10, 4 }, -- El camino del cazador
        { 6075, 10, 10, 4 }, -- El camino del cazador
        { 6076, 10, 10, 4 }, -- El camino del cazador
        { 6721, 10, 10, 8 }, -- El camino del cazador
        { 6722, 10, 10, 8 }, -- El camino del cazador
        { 94007, 10, 10, 12884901888 }, -- Domar a la bestia
        { 78830, 40, 26 }, -- El terror de los cielos del desierto
        { 7503, 60, 54 }, -- La mayor raza de cazadores
        { 7633, 60, 60 }, -- Una presentación
        { 7634, 60, 60 }, -- Carcaj antiguo cosido con tendón
        { 7635, 60, 60 }, -- La cuerda adecuada
        { 7636, 60, 60 }, -- El báculo de los Ancestros
        { 8062, 60, 60 }, -- Dechados de Poder: los Brazales de depredador
        { 8066, 60, 60 }, -- Dechados de Poder: el Cinturón de predador
        { 8067, 60, 60 }, -- Dechados de Poder: el Manto de depredador
        { 8377, 60, 58 }, -- Armamentos de guerra
        { 8696, 60, 60 }, -- La capa de la senda oculta
        { 8704, 60, 60 }, -- El anillo con sello de la senda oculta
        { 8712, 60, 60 }, -- La guadaña de la Senda Oculta
        { 8906, 60, 58, 4294967373 }, -- Una propuesta seria
        { 8931, 60, 58, 4294967373 }, -- Una compensación justa
        { 8952, 60, 58, 4294967373 }, -- La despedida de Anthion
        { 9000, 60, 58, 4294967373 }, -- Guardar lo mejor para el final
        { 9054, 60, 60 }, -- La guerrera de acechacriptas
        { 9055, 60, 60 }, -- Las musleras de acechacriptas
        { 9056, 60, 60 }, -- La celada de acechacriptas
        { 9057, 60, 60 }, -- Las bufas de acechacriptas
        { 9058, 60, 60 }, -- Las botas de acechacriptas
        { 9059, 60, 60 }, -- Las manoplas de acechacriptas
        { 9060, 60, 60 }, -- La faja de acechacriptas
        { 9061, 60, 60 }, -- Los guardamuñecas de acechacriptas
        { 9244, 60, 60 }, -- Los brazales de escamas heladas
        { 9245, 60, 60 }, -- Los guanteletes de escamas heladas
        { 9246, 60, 60 }, -- La coraza de escamas heladas
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_HUNTER_94050",
    faction = "Horde",
    class = "HUNTER",
    titleQuest = 94050,
    minLevel = 10,
    maxLevel = 10,
    areaId = 16593,
    zone = "Zephras Isle",
    focus = { 59.6, 72.6 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 1515, 0 },
        { "spell", 5149, 0 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 94978, 10, 10, 12884901888 }, -- Domar a la bestia
        { 94979, 10, 10, 12884901888 }, -- Domar a la bestia
        { 94013, 10, 10, 12884901888 }, -- Domar a la bestia
        { 94050, 10, 10, 12884901888 }, -- Entrenar a la bestia
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_HUNTER_8232",
    faction = "Horde",
    class = "HUNTER",
    titleQuest = 8232,
    minLevel = 52,
    maxLevel = 52,
    areaId = 16,
    zone = "Azshara",
    focus = { 42.4, 42.6 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 20083, 8232 },
        { "choice", 19991, 8232 },
        { "choice", 19992, 8232 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8151, 52, 50 }, -- El talismán del cazador
        { 8153, 52, 50 }, -- Cuernos de corcel
        { 8231, 52, 50 }, -- Los vándalos marinos
        { 8232, 52, 50 }, -- El draco verde
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_HUNTER_6089",
    faction = "Horde",
    class = "HUNTER",
    titleQuest = 6089,
    minLevel = 10,
    maxLevel = 10,
    areaId = 215,
    zone = "Mulgore",
    focus = { 46.9, 59.6 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 1515, 0 },
        { "spell", 5149, 0 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 6061, 10, 10, 32 }, -- Domesticar la bestia
        { 6062, 10, 10, 130 }, -- Domesticar la bestia
        { 6083, 10, 10, 130 }, -- Domesticar la bestia
        { 6082, 10, 10, 130 }, -- Domesticar la bestia
        { 6081, 10, 10, 130 }, -- Entrenar a la bestia
        { 6087, 10, 10, 32 }, -- Domesticar la bestia
        { 6088, 10, 10, 32 }, -- Domesticar la bestia
        { 6089, 10, 10, 32 }, -- Entrenar a la bestia
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_HUNTER_8148",
    faction = "Horde",
    class = "HUNTER",
    titleQuest = 8148,
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
        { 8145, 60, 60 }, -- Zarcillo de La Vorágine
        { 8146, 60, 60 }, -- Zarcillo de La Vorágine
        { 8147, 60, 60 }, -- Zarcillo de La Vorágine
        { 8148, 60, 60 }, -- Cólera de La Vorágine
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_HUNTER_Misc",
    faction = "Horde",
    class = "HUNTER",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 67.8, 46.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20702, 8377 },
        { "item", 20713, 8377 },
        { "item", 18707, 7636 },
        { "item", 18724, 7635 },
        { "item", 18714, 7634 },
        { "item", 18473, 7503 },
        { "rep", 529, 1600 },
        { "rep", 270, 450 },
        { "rep", 609, 400 },
        { "rep", 530, 200 },
        { "rep", 76, 200 },
        { "rep", 809, 200 },
        { "rep", 81, 50 },
        { "rep", 2778, 50 },
        { "rep", 2779, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 3082, 1, 1, 128 }, -- Tablilla con grabados
        { 3087, 1, 1, 2 }, -- Pergamino con grabados
        { 3092, 1, 1, 32 }, -- La nota con grabados
        { 92482, 2, 2 }, -- La senda del cazador
        { 792, 4, 2, 8589934770 }, -- Familiares viles
        { 6065, 10, 10, 32 }, -- El camino del cazador
        { 6066, 10, 10, 32 }, -- El camino del cazador
        { 6067, 10, 10, 32 }, -- El camino del cazador
        { 6068, 10, 10, 130 }, -- El camino del cazador
        { 6069, 10, 10, 130 }, -- El camino del cazador
        { 6070, 10, 10, 130 }, -- El camino del cazador
        { 94007, 10, 10, 12884901888 }, -- Domar a la bestia
        { 78830, 40, 26 }, -- El terror de los cielos del desierto
        { 7503, 60, 54 }, -- La mayor raza de cazadores
        { 7633, 60, 60 }, -- Una presentación
        { 7634, 60, 60 }, -- Carcaj antiguo cosido con tendón
        { 7635, 60, 60 }, -- La cuerda adecuada
        { 7636, 60, 60 }, -- El báculo de los Ancestros
        { 8062, 60, 60 }, -- Dechados de Poder: los Brazales de depredador
        { 8066, 60, 60 }, -- Dechados de Poder: el Cinturón de predador
        { 8067, 60, 60 }, -- Dechados de Poder: el Manto de depredador
        { 8377, 60, 58 }, -- Armamentos de guerra
        { 8696, 60, 60 }, -- La capa de la senda oculta
        { 8704, 60, 60 }, -- El anillo con sello de la senda oculta
        { 8712, 60, 60 }, -- La guadaña de la Senda Oculta
        { 8914, 60, 58, 8589934770 }, -- Una propuesta seria
        { 8938, 60, 58, 8589934770 }, -- Una compensación justa
        { 9008, 60, 58, 8589934770 }, -- Guardar lo mejor para el final
        { 9017, 60, 58, 8589934770 }, -- La despedida de Anthion
        { 9054, 60, 60 }, -- La guerrera de acechacriptas
        { 9055, 60, 60 }, -- Las musleras de acechacriptas
        { 9056, 60, 60 }, -- La celada de acechacriptas
        { 9057, 60, 60 }, -- Las bufas de acechacriptas
        { 9058, 60, 60 }, -- Las botas de acechacriptas
        { 9059, 60, 60 }, -- Las manoplas de acechacriptas
        { 9060, 60, 60 }, -- La faja de acechacriptas
        { 9061, 60, 60 }, -- Los guardamuñecas de acechacriptas
        { 9244, 60, 60 }, -- Los brazales de escamas heladas
        { 9245, 60, 60 }, -- Los guanteletes de escamas heladas
        { 9246, 60, 60 }, -- La coraza de escamas heladas
    },
})

-- Generado por tools/class_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Guías de clase: PRIEST
local _, QR = ...
if select(2, UnitClass("player")) ~= "PRIEST" then return end

QR:RegisterClassGuide({
    key = "Alliance_Class_PRIEST_5627",
    faction = "Alliance",
    class = "PRIEST",
    titleQuest = 5627,
    minLevel = 10,
    maxLevel = 10,
    areaId = 1519,
    zone = "Stormwind City",
    focus = { 42.6, 53.9 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "spell", 10797, 0 },
        { "spell", 2651, 0 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 5628, 10, 10, 8 }, -- La vuelta a casa
        { 5629, 10, 10, 8 }, -- La vuelta a casa
        { 5630, 10, 10, 8 }, -- La vuelta a casa
        { 5631, 10, 10, 8 }, -- La vuelta a casa
        { 5632, 10, 10, 8 }, -- La vuelta a casa
        { 5633, 10, 10, 8 }, -- La vuelta a casa
        { 5627, 10, 10, 8 }, -- Estrellas de Elune
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_PRIEST_9257",
    faction = "Alliance",
    class = "PRIEST",
    titleQuest = 9257,
    minLevel = 60,
    maxLevel = 60,
    areaId = 440,
    zone = "Tanaris",
    focus = { 65.3, 50.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 22631, 9257 },
        { "rep", 910, 600 },
        { "rep", 529, 600 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 9250, 60, 60 }, -- Cuerpo de Atiesh
        { 9251, 60, 60 }, -- Atiesh, el gran báculo maligno
        { 9257, 60, 60 }, -- Atiesh, el gran báculo del guardián
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_PRIEST_8257",
    faction = "Alliance",
    class = "PRIEST",
    titleQuest = 8257,
    minLevel = 52,
    maxLevel = 52,
    areaId = 16,
    zone = "Azshara",
    focus = { 42.4, 42.6 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 19990, 8257 },
        { "choice", 20082, 8257 },
        { "choice", 20006, 8257 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8254, 52, 50 }, -- Ayuda a Cenarion
        { 8255, 52, 50 }, -- Los trotadores Pezuñamusgo
        { 8256, 52, 50 }, -- El icor de los no-muertos
        { 8257, 52, 50 }, -- La sangre de Morphaz
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_PRIEST_8052",
    faction = "Alliance",
    class = "PRIEST",
    titleQuest = 8052,
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
        { 8049, 60, 60 }, -- El ojo de Zuldazar
        { 8050, 60, 60 }, -- El ojo de Zuldazar
        { 8051, 60, 60 }, -- El ojo de Zuldazar
        { 8052, 60, 60 }, -- El ojo de Zuldazar que todo lo ve
    },
})

QR:RegisterClassGuide({
    key = "Alliance_Class_PRIEST_Misc",
    faction = "Alliance",
    class = "PRIEST",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 60.5, 41.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20707, 8379 },
        { "item", 20717, 8379 },
        { "item", 18659, 7622 },
        { "item", 16605, 5625 },
        { "item", 16604, 5621 },
        { "rep", 529, 1600 },
        { "rep", 270, 450 },
        { "rep", 609, 400 },
        { "rep", 809, 200 },
        { "rep", 72, 50 },
        { "rep", 47, 50 },
        { "rep", 69, 50 },
        { "rep", 54, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 3103, 1, 1, 1 }, -- Una carta sagrada
        { 3110, 1, 1, 4 }, -- Runa sagrada
        { 3119, 1, 1, 8 }, -- El sigilo sagrado
        { 98574, 1, 1, 64 }, -- Memorándum santificado
        { 5621, 5, 5, 8 }, -- Prendas de la luna
        { 5622, 5, 5, 8 }, -- Los caminos de Elune
        { 5623, 5, 5, 1 }, -- Al servicio de la Luz
        { 5624, 5, 5, 1 }, -- Las prendas de la Luz
        { 5625, 5, 5, 68 }, -- Las prendas de la Luz
        { 5626, 5, 5, 68 }, -- Al servicio de la Luz
        { 5634, 10, 10, 4 }, -- Oración desesperada
        { 5635, 10, 10, 4 }, -- Oración desesperada
        { 5636, 10, 10, 4 }, -- Oración desesperada
        { 5637, 10, 10, 4 }, -- Oración desesperada
        { 5638, 10, 10, 4 }, -- Oración desesperada
        { 5639, 10, 10, 4 }, -- Oración desesperada
        { 5640, 10, 10, 4 }, -- Oración desesperada
        { 94773, 10, 10, 1 }, -- Gracia divina
        { 94774, 10, 10, 1 }, -- Gracia divina
        { 94775, 10, 10, 1 }, -- Divine Grace
        { 94776, 10, 10, 1 }, -- Divine Grace
        { 94777, 10, 10, 1 }, -- Divine Grace
        { 94778, 10, 10, 1 }, -- Divine Grace
        { 94779, 10, 10, 1 }, -- Divine Grace
        { 94817, 10, 10, 64 }, -- Confounding Flash
        { 94821, 10, 10, 64 }, -- Confounding Flash
        { 94822, 10, 10, 64 }, -- Confounding Flash
        { 94823, 10, 10, 64 }, -- Confounding Flash
        { 94824, 10, 10, 64 }, -- Destello desconcertante
        { 94825, 10, 10, 64 }, -- Confounding Flash
        { 94826, 10, 10, 64 }, -- Confounding Flash
        { 5641, 20, 20, 4 }, -- Sin miedo
        { 5645, 20, 20, 4 }, -- Sin miedo
        { 5647, 20, 20, 4 }, -- Sin miedo
        { 5672, 20, 20, 8 }, -- Gracia de Elune
        { 5673, 20, 20, 8 }, -- Gracia de Elune
        { 5674, 20, 20, 8 }, -- La Gracia de Elune
        { 5675, 20, 20, 8 }, -- La Gracia de Elune
        { 5676, 20, 20, 1 }, -- La reacción Arcana
        { 5677, 20, 20, 1 }, -- La reacción Arcana
        { 5678, 20, 20, 1 }, -- Arcane Feedback
        { 94818, 20, 20, 64 }, -- Plan de contingencia
        { 94819, 20, 20, 64 }, -- Plan de contingencia
        { 94820, 20, 20, 64 }, -- Contingency Plan
        { 79731, 35, 1 }, -- The Troll Scroll
        { 7504, 60, 54 }, -- Sagrada Bologna: lo que la Luz nunca te dirá
        { 7621, 60, 60 }, -- Un aviso
        { 7622, 60, 60 }, -- Equilibrio de Luz y Sombras
        { 8061, 60, 60 }, -- Dechados de Poder: los Brazaletes de confesor
        { 8070, 60, 60 }, -- Dechados de Poder: las Ataduras de confesor
        { 8071, 60, 60 }, -- Dechados de Poder: el Manto de confesor
        { 8379, 60, 58 }, -- Armamentos de guerra
        { 8689, 60, 60 }, -- El sayo de infinita sabiduría
        { 8697, 60, 60 }, -- El anillo de infinitia sabiduría
        { 8705, 60, 60 }, -- El mazo de infinita sabiduría
        { 8909, 60, 58, 4294967373 }, -- Una propuesta seria
        { 8934, 60, 58, 4294967373 }, -- Una compensación justa
        { 8955, 60, 58, 4294967373 }, -- La despedida de Anthion
        { 9003, 60, 58, 4294967373 }, -- Guardar lo mejor para el final
        { 9111, 60, 60 }, -- La toga de fe
        { 9112, 60, 60 }, -- Los leotardos de fe
        { 9113, 60, 60 }, -- El aro de fe
        { 9114, 60, 60 }, -- Las hombreras de fe
        { 9115, 60, 60 }, -- Los botines de fe
        { 9116, 60, 60 }, -- Los guantes de fe
        { 9117, 60, 60 }, -- El cinturón de fe
        { 9118, 60, 60 }, -- Las ataduras de fe
        { 9238, 60, 60 }, -- Las muñequeras glaciales
        { 9239, 60, 60 }, -- Los guantes glaciales
        { 9240, 60, 60 }, -- El jubón glacial
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_PRIEST_9257",
    faction = "Horde",
    class = "PRIEST",
    titleQuest = 9257,
    minLevel = 60,
    maxLevel = 60,
    areaId = 440,
    zone = "Tanaris",
    focus = { 65.3, 50.0 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 22631, 9257 },
        { "rep", 910, 600 },
        { "rep", 529, 600 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 9250, 60, 60 }, -- Cuerpo de Atiesh
        { 9251, 60, 60 }, -- Atiesh, el gran báculo maligno
        { 9257, 60, 60 }, -- Atiesh, el gran báculo del guardián
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_PRIEST_8257",
    faction = "Horde",
    class = "PRIEST",
    titleQuest = 8257,
    minLevel = 52,
    maxLevel = 52,
    areaId = 16,
    zone = "Azshara",
    focus = { 42.4, 42.6 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "choice", 19990, 8257 },
        { "choice", 20082, 8257 },
        { "choice", 20006, 8257 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 8254, 52, 50 }, -- Ayuda a Cenarion
        { 8255, 52, 50 }, -- Los trotadores Pezuñamusgo
        { 8256, 52, 50 }, -- El icor de los no-muertos
        { 8257, 52, 50 }, -- La sangre de Morphaz
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_PRIEST_8052",
    faction = "Horde",
    class = "PRIEST",
    titleQuest = 8052,
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
        { 8049, 60, 60 }, -- El ojo de Zuldazar
        { 8050, 60, 60 }, -- El ojo de Zuldazar
        { 8051, 60, 60 }, -- El ojo de Zuldazar
        { 8052, 60, 60 }, -- El ojo de Zuldazar que todo lo ve
    },
})

QR:RegisterClassGuide({
    key = "Horde_Class_PRIEST_Misc",
    faction = "Horde",
    class = "PRIEST",
    misc = true,
    minLevel = 1,
    maxLevel = 60,
    areaId = 139,
    zone = "Eastern Plaguelands",
    focus = { 60.5, 41.1 },   -- punto medio de la cadena en el mapa de la zona
    -- recompensas en orden: { tipo (spell, item, choice, rep), id, mision que lo da (0: la cadena)
    --   o puntos de reputacion }; la primera que no es reputacion es la principal
    rewards = {
        { "item", 20707, 8379 },
        { "item", 20717, 8379 },
        { "item", 18659, 7622 },
        { "item", 16607, 5650 },
        { "item", 16606, 5648 },
        { "rep", 529, 1600 },
        { "rep", 270, 450 },
        { "rep", 609, 400 },
        { "rep", 530, 200 },
        { "rep", 809, 200 },
        { "rep", 76, 150 },
        { "rep", 68, 50 },
    },
    -- { questId, nivelMision, nivelRequerido, razas (si solo la pueden hacer algunas) }
    quests = {
        { 3085, 1, 1, 128 }, -- Tablilla Sagrada
        { 3097, 1, 1, 16 }, -- Un pergamino sagrado
        { 792, 4, 2, 8589934770 }, -- Familiares viles
        { 5648, 5, 5, 128 }, -- Prendas de espiritualidad
        { 5649, 5, 5, 128 }, -- Al servicio de la espiritualidad
        { 5650, 5, 5, 16 }, -- Las prendas de la Oscuridad
        { 5651, 5, 5, 16 }, -- Al servicio de la Oscuridad
        { 5652, 10, 10, 128 }, -- Maleficio de Debilidad
        { 5654, 10, 10, 128 }, -- Maleficio de Debilidad
        { 5655, 10, 10, 128 }, -- Maleficio de Debilidad
        { 5656, 10, 10, 128 }, -- Maleficio de Debilidad
        { 5657, 10, 10, 128 }, -- Maleficio de Debilidad
        { 5658, 10, 10, 16 }, -- Toque de debilidad
        { 5660, 10, 10, 16 }, -- Toque de debilidad
        { 5661, 10, 10, 16 }, -- Toque de debilidad
        { 5662, 10, 10, 16 }, -- Toque de debilidad
        { 5663, 10, 10, 16 }, -- Toque de debilidad
        { 5642, 20, 20, 128 }, -- Guardia de las Sombras
        { 5643, 20, 20, 128 }, -- Guardia de las Sombras
        { 5644, 20, 20, 16 }, -- Sacrificio oscuro
        { 5646, 20, 20, 16 }, -- Sacrificio oscuro
        { 5679, 20, 20, 16 }, -- Sacrificio oscuro
        { 5680, 20, 20, 128 }, -- Guardia de las Sombras
        { 79731, 35, 1 }, -- The Troll Scroll
        { 7504, 60, 54 }, -- Sagrada Bologna: lo que la Luz nunca te dirá
        { 7621, 60, 60 }, -- Un aviso
        { 7622, 60, 60 }, -- Equilibrio de Luz y Sombras
        { 8061, 60, 60 }, -- Dechados de Poder: los Brazaletes de confesor
        { 8070, 60, 60 }, -- Dechados de Poder: las Ataduras de confesor
        { 8071, 60, 60 }, -- Dechados de Poder: el Manto de confesor
        { 8379, 60, 58 }, -- Armamentos de guerra
        { 8689, 60, 60 }, -- El sayo de infinita sabiduría
        { 8697, 60, 60 }, -- El anillo de infinitia sabiduría
        { 8705, 60, 60 }, -- El mazo de infinita sabiduría
        { 8916, 60, 58, 8589934770 }, -- Una propuesta seria
        { 8940, 60, 58, 8589934770 }, -- Una compensación justa
        { 9009, 60, 58, 8589934770 }, -- Guardar lo mejor para el final
        { 9019, 60, 58, 8589934770 }, -- La despedida de Anthion
        { 9111, 60, 60 }, -- La toga de fe
        { 9112, 60, 60 }, -- Los leotardos de fe
        { 9113, 60, 60 }, -- El aro de fe
        { 9114, 60, 60 }, -- Las hombreras de fe
        { 9115, 60, 60 }, -- Los botines de fe
        { 9116, 60, 60 }, -- Los guantes de fe
        { 9117, 60, 60 }, -- El cinturón de fe
        { 9118, 60, 60 }, -- Las ataduras de fe
        { 9238, 60, 60 }, -- Las muñequeras glaciales
        { 9239, 60, 60 }, -- Los guantes glaciales
        { 9240, 60, 60 }, -- El jubón glacial
    },
})

-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Western Plaguelands · niveles 51-58 · 72 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_WesternPlaguelands",
    faction = "Alliance",
    zone = "Western Plaguelands",
    areaId = 28,
    minLevel = 51,
    maxLevel = 58,
    entry = { quest = 5092, areaId = 28, x = 42.7, y = 84.03 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 5092, 52, 50 }, -- Despejando el camino
        { 5066, 50, 50 }, -- Un llamamiento a las armas: las Tierras de la Peste
        { 5090, 50, 50 }, -- Un llamamiento a las armas: las Tierras de la Peste
        { 5091, 50, 50 }, -- Un llamamiento a las armas: las Tierras de la Peste
        { 5021, 52, 50 }, -- Más vale tarde que nunca
        { 5022, 52, 50 }, -- Más vale tarde que nunca
        { 5050, 52, 50 }, -- Talismán de la buena suerte
        { 5215, 53, 50 }, -- Las calderas de la Plaga
        { 5216, 53, 50 }, -- Objetivo: Campo de Piedra Mácula
        { 5217, 53, 50 }, -- El regreso al Campamento del Orvallo
        { 5218, 53, 50 }, -- El caldero del Campo de Piedra Mácula
        { 5051, 54, 50 }, -- Dos mitades hacen una
        { 4984, 54, 51 }, -- La naturaleza también sufre
        { 5224, 55, 50 }, -- El caldero de El Tormento
        { 5142, 55, 50 }, -- La pequeña Pamela
        { 5401, 55, 50 }, -- Comisión del Alba Argenta
        { 5402, 55, 50 }, -- Piedras de la Plaga del esbirro
        { 5403, 55, 50 }, -- Piedras de la Plaga del invasor
        { 5404, 55, 50 }, -- Piedras de la Plaga del corruptor
        { 92842, 55, 1 }, -- A Cousin Abroad
        { 5219, 55, 50 }, -- Objetivo: Llanto de Dalson
        { 5903, 55, 48 }, -- Una Peste en la Cruzada
        { 5904, 55, 48 }, -- Una Peste en la Cruzada
        { 5220, 55, 50 }, -- El regreso al Campamento del Orvallo
        { 5221, 55, 50 }, -- El caldero del Llanto de Dalson
        { 5058, 55, 52 }, -- El diario de la señorita Dalson
        { 5059, 55, 52 }, -- Encierro
        { 5060, 55, 52 }, -- Encierro
        { 6389, 55, 48 }, -- Una Peste en la Cruzada
        { 5222, 55, 50 }, -- Objetivo: El Tormento
        { 5223, 55, 50 }, -- El regreso al Campamento del Orvallo
        { 4985, 56, 51 }, -- La naturaleza también sufre
        { 4986, 56, 51 }, -- Rama de roble con inscripciones
        { 4971, 56, 53 }, -- Una cuestión de tiempo
        { 4972, 56, 53 }, -- Contar el tiempo
        { 4973, 56, 53 }, -- Contar el tiempo
        { 5153, 56, 50 }, -- Un extraño historiador
        { 5097, 56, 50 }, -- Todas las torres
        { 5533, 55, 55 }, -- Scholomance
        { 5154, 56, 50 }, -- Las Crónicas de Villa Darrow
        { 5210, 56, 50 }, -- Carlin, el hermano de Joseph
        { 6004, 56, 50 }, -- Negocios inconclusos
        { 6023, 57, 50 }, -- Negocios inconclusos
        { 5537, 57, 55 }, -- Fragmentos esqueléticos
        { 5538, 57, 55 }, -- Molde rima con... ¿oro?
        { 5225, 58, 50 }, -- Objetivo: Gangrena de Gahrron
        { 5226, 58, 50 }, -- El regreso al Campamento del Orvallo
        { 5227, 58, 50 }, -- El caldero de la Gangrena de Gahrron
        { 6025, 58, 50 }, -- Negocios inconclusos
        { 5237, 58, 50 }, -- ¡Misión cumplida!
        { 211, 60, 50 }, -- Ah, Andorhal
        { 5803, 60, 55 }, -- El escarabajo de Araj
        { 5505, 60, 55 }, -- La llave de Scholomance
        { 5507, 60, 55 }, -- Mantos del Alba
        { 5521, 60, 55 }, -- Manto del Alba cromático
        { 5343, 60, 52 }, -- La fortuna de la familia Barov
        { 5344, 60, 52 }, -- El último de los Barov
        { 5862, 60, 52 }, -- La Ilusión Escarlata
        { 5848, 60, 52 }, -- Del amor y la familia
        { 5382, 60, 55 }, -- Doctor Theolen Krastinov, el Carnicero
        { 5515, 60, 55 }, -- Bolsa de los horrores de Krastinov
        { 5384, 60, 55 }, -- Kirtonos el Heraldo
        { 5461, 60, 57 }, -- El humano, Ras Levescarcha
        { 5462, 60, 57 }, -- El moribundo, Ras Levescarcha
        { 5466, 60, 57 }, -- El Lich, Ras Levescarcha
        { 5721, 60, 55 }, -- La Batalla de Villa Darrow
        { 5164, 60, 57 }, -- Catálogo del Díscolo
        { 5166, 60, 57 }, -- Coraza del Vuelo Cromático
        { 5167, 60, 57 }, -- Quijotes del Desafiante cromático
        { 6184, 60, 56 }, -- Flint Sombramás
        { 6185, 60, 56 }, -- Las pestes del este
        { 6186, 60, 56 }, -- El regreso de Clamorinfecto
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

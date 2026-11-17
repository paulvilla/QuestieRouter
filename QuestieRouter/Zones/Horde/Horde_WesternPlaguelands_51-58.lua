-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Western Plaguelands · niveles 51-58 · 48 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_WesternPlaguelands",
    faction = "Horde",
    zone = "Western Plaguelands",
    areaId = 28,
    minLevel = 51,
    maxLevel = 58,
    entry = { quest = 5230, areaId = 28, x = 37.25, y = 56.78 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 5230, 53, 50 }, -- El regreso a El Baluarte
        { 5021, 52, 50 }, -- Más vale tarde que nunca
        { 5023, 52, 50 }, -- Más vale tarde que nunca
        { 5050, 52, 50 }, -- Talismán de la buena suerte
        { 5218, 53, 50 }, -- El caldero del Campo de Piedra Mácula
        { 5051, 54, 50 }, -- Dos mitades hacen una
        { 4984, 54, 51 }, -- La naturaleza también sufre
        { 5224, 55, 50 }, -- El caldero de El Tormento
        { 5234, 55, 50 }, -- El regreso a El Baluarte
        { 5142, 55, 50 }, -- La pequeña Pamela
        { 5401, 55, 50 }, -- Comisión del Alba Argenta
        { 5402, 55, 50 }, -- Piedras de la Plaga del esbirro
        { 5403, 55, 50 }, -- Piedras de la Plaga del invasor
        { 5404, 55, 50 }, -- Piedras de la Plaga del corruptor
        { 92842, 55, 1 }, -- A Cousin Abroad
        { 5221, 55, 50 }, -- El caldero del Llanto de Dalson
        { 5232, 55, 50 }, -- El regreso a El Baluarte
        { 5058, 55, 52 }, -- El diario de la señorita Dalson
        { 5059, 55, 52 }, -- Encierro
        { 5060, 55, 52 }, -- Encierro
        { 6390, 55, 48 }, -- Una Peste en la Cruzada
        { 6004, 56, 50 }, -- Negocios inconclusos
        { 4985, 56, 51 }, -- La naturaleza también sufre
        { 4987, 56, 51 }, -- Rama de roble con inscripciones
        { 4971, 56, 53 }, -- Una cuestión de tiempo
        { 4972, 56, 53 }, -- Contar el tiempo
        { 4973, 56, 53 }, -- Contar el tiempo
        { 5153, 56, 50 }, -- Un extraño historiador
        { 5154, 56, 50 }, -- Las Crónicas de Villa Darrow
        { 5210, 56, 50 }, -- Carlin, el hermano de Joseph
        { 6023, 57, 50 }, -- Negocios inconclusos
        { 6025, 58, 50 }, -- Negocios inconclusos
        { 5227, 58, 50 }, -- El caldero de la Gangrena de Gahrron
        { 5236, 58, 50 }, -- El regreso a El Baluarte
        { 5382, 60, 55 }, -- Doctor Theolen Krastinov, el Carnicero
        { 5515, 60, 55 }, -- Bolsa de los horrores de Krastinov
        { 5384, 60, 55 }, -- Kirtonos el Heraldo
        { 5461, 60, 57 }, -- El humano, Ras Levescarcha
        { 5462, 60, 57 }, -- El moribundo, Ras Levescarcha
        { 5466, 60, 57 }, -- El Lich, Ras Levescarcha
        { 5848, 60, 52 }, -- Del amor y la familia
        { 5862, 60, 52 }, -- La Ilusión Escarlata
        { 6569, 60, 55 }, -- Ilusiones oculares
        { 6570, 60, 55 }, -- Brasaliza
        { 5721, 60, 55 }, -- La Batalla de Villa Darrow
        { 5164, 60, 57 }, -- Catálogo del Díscolo
        { 5166, 60, 57 }, -- Coraza del Vuelo Cromático
        { 5167, 60, 57 }, -- Quijotes del Desafiante cromático
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

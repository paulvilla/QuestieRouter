-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Swamp of Sorrows · niveles 35-45 · 19 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_SwampOfSorrows",
    faction = "Horde",
    zone = "Swamp of Sorrows",
    areaId = 8,
    minLevel = 35,
    maxLevel = 45,
    entry = { quest = 698, areaId = 8, x = 44.7, y = 57.21 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 698, 40, 35 }, -- Falta de suministros
        { 93663, 35, 30 }, -- Perdido en tránsito
        { 1418, 35, 30 }, -- Neeka Marca de Sangre
        { 93176, 35, 25 }, -- Amiguitos por doquier
        { 93429, 35, 30 }, -- Sangre de mi sangre
        { 1389, 35, 30 }, -- Cristales draenetistas
        { 93430, 35, 30 }, -- Recuperar el cebo
        { 93464, 38, 30 }, -- El mago visitante
        { 1393, 38, 30 }, -- La huida de Galen
        { 1392, 39, 29 }, -- Noboru el Garrote
        { 699, 42, 35 }, -- Falta de suministros
        { 1424, 43, 38 }, -- Charca de Lágrimas
        { 625, 43, 35 }, -- El enigma de Cortello
        { 1430, 44, 35 }, -- Carne fresca
        { 1429, 44, 38 }, -- El exiliado Atal'ai
        { 1422, 45, 35 }, -- La amenaza marítima
        { 1426, 43, 35 }, -- La amenaza marítima
        { 1427, 43, 35 }, -- La amenaza marítima
        { 1428, 45, 35 }, -- La amenaza continua
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 1445, 50, 38 }, -- El Templo de Atal'Hakkar
        { 2621, 50, 45 }, -- El deshonrado
        { 2622, 50, 45 }, -- Las órdenes perdidas
        { 2784, 50, 45 }, -- Pérdida de honor
        { 2623, 55, 45 }, -- El Hablador del pantano
        { 3374, 55, 48 }, -- La esencia de Eranikus
        { 3512, 55, 48 }, -- Como diría  Eranikus…
        { 93679, 55, 1 }, -- Visiones de otro
        { 93684, 55, 1 }, -- El Encontrado
        { 2681, 57, 45 }, -- Las piedras que nos vinculan
        { 2701, 57, 45 }, -- Los héroes de los antiguos
        { 2702, 57, 45 }, -- Los héroes de los antiguos
        { 2801, 57, 45 }, -- Una historia triste
        { 2721, 58, 45 }, -- Kirith
        { 2744, 60, 45 }, -- El cazademonios
        { 3627, 60, 45 }, -- Juntar pedazos del amuleto
        { 3628, 60, 45 }, -- Eres Rakh'likh, demonio
    },
})

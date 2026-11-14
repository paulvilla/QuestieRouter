-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Swamp of Sorrows · niveles 35-45 · 15 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_SwampOfSorrows",
    faction = "Alliance",
    zone = "Swamp of Sorrows",
    areaId = 8,
    minLevel = 35,
    maxLevel = 45,
    entry = { quest = 1396, areaId = 8, x = 26.74, y = 59.83 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 1396, 37, 30 }, -- Contra la fauna feroz
        { 93585, 34, 30 }, -- This Light of Mine
        { 93176, 35, 25 }, -- Amiguitos por doquier
        { 1421, 35, 30 }, -- La caravana perdida
        { 93429, 35, 30 }, -- Sangre de mi sangre
        { 1389, 35, 30 }, -- Cristales draenetistas
        { 93430, 35, 30 }, -- Recuperar el cebo
        { 93464, 38, 30 }, -- El mago visitante
        { 1393, 38, 30 }, -- La huida de Galen
        { 1392, 39, 29 }, -- Noboru el Garrote
        { 1423, 40, 30 }, -- Los suministros perdidos
        { 1398, 42, 30 }, -- Madera a la deriva
        { 94929, 38, 36 }, -- Deliver the Second Shipment
        { 1425, 42, 30 }, -- Envío de suministros
        { 625, 43, 35 }, -- El enigma de Cortello
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
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

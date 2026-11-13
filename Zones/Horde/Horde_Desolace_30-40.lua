-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Desolace · niveles 30-40 · 57 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_Desolace",
    faction = "Horde",
    zone = "Desolace",
    areaId = 405,
    minLevel = 30,
    maxLevel = 40,
    entry = { quest = 5741, areaId = 405, x = 38.88, y = 27.16 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 5741, 33, 30 }, -- El Cetro de la Luz
        { 1432, 30, 30 }, -- Las relaciones de la Alianza
        { 5763, 31, 28 }, -- La caza en Tuercespina
        { 1433, 33, 30 }, -- Las relaciones de la Alianza
        { 1434, 33, 25 }, -- La contaminación del sátiro
        { 1435, 33, 25 }, -- Los espíritus ardientes
        { 1436, 33, 30 }, -- Las relaciones de la Alianza
        { 1367, 33, 30 }, -- La alianza con los Magram
        { 1368, 33, 30 }, -- La alianza con los Gelkis
        { 1369, 33, 30 }, -- Lágrimas rotas
        { 1480, 33, 25 }, -- El corruptor
        { 1481, 33, 25 }, -- El corruptor
        { 5561, 34, 30 }, -- El rodeo kodo
        { 1365, 35, 30 }, -- Khan Dez'hepah
        { 1366, 31, 30 }, -- Colección de orejas
        { 1482, 35, 25 }, -- El corruptor
        { 1484, 35, 25 }, -- El corruptor
        { 5821, 35, 30 }, -- El guardaespaldas
        { 1371, 35, 30 }, -- Un cacharro para Warug
        { 1370, 35, 30 }, -- ¡A robar provisiones!
        { 6142, 35, 31 }, -- Almejas
        { 92754, 35, 30 }, -- A New Need for Shadow Protection
        { 92755, 35, 30 }, -- Mysterious Mysticism
        { 92814, 35, 30 }, -- I Need a Tailor
        { 92817, 35, 30 }, -- Leather Technique
        { 92818, 35, 30 }, -- Big, No, MASSIVE Iron Axes
        { 6143, 36, 32 }, -- Otros pescados para freír
        { 6161, 36, 30 }, -- La búsqueda del tesoro de Masatormento
        { 5386, 37, 32 }, -- La pesca del día
        { 1375, 37, 30 }, -- Khan Shaka
        { 1373, 37, 30 }, -- Ongeku
        { 1374, 37, 30 }, -- Khan Jehn
        { 93034, 38, 30 }, -- Valley of Bones
        { 5943, 38, 32 }, -- La caravana Gizelton
        { 5381, 38, 32 }, -- La Mano de Iruxos
        { 5581, 38, 32 }, -- Los portales de la Legión
        { 6027, 38, 30 }, -- El Libro de los Ancestros
        { 93044, 38, 30 }, -- A Cleansing Cry
        { 5501, 39, 33 }, -- Colección de kodos
        { 6134, 39, 34 }, -- La caza de ectoplamas
        { 6132, 39, 34 }, -- ¡Sácame de aquí!
        { 79229, 40, 1 }, -- Highway Robbery
        { 1488, 40, 25 }, -- El corruptor
        { 93225, 40, 30 }, -- Carved Centaur Totems
        { 92743, 40, 30 }, -- A Conqueror's Crown
        { 93465, 40, 30 }, -- Notes on Draenethyst
        { 93678, 40, 30 }, -- Abridged Notes on Draenethyst
        { 1381, 42, 30 }, -- Khan Hratha
        { 1380, 42, 30 }, -- Khan Hratha
        { 93196, 42, 30 }, -- Khan Jehn
        { 94872, 45, 30 }, -- Buying Friendship: Magram
        { 94873, 45, 30 }, -- Buying Friendship: Gelkis
        { 7028, 47, 41 }, -- Los males de Maraudón
        { 7029, 47, 41 }, -- La corrupción de Lenguavil
        { 7067, 48, 39 }, -- Las instrucciones del Paria
        { 7044, 49, 41 }, -- Leyendas de Maraudón
        { 7064, 51, 45 }, -- Corrupción de la tierra y de la semilla
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 6567, 60, 55 }, -- El Campeón de la Horda
        { 6568, 60, 55 }, -- El testamento de Rexxar
        { 6602, 60, 55 }, -- La sangre de dragón negro campeón
        { 92811, 60, 1 }, -- Economic Warfare
    },
})

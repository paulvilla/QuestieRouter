-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Desolace · niveles 30-40 · 61 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_Desolace",
    faction = "Alliance",
    zone = "Desolace",
    areaId = 405,
    minLevel = 30,
    maxLevel = 40,
    entry = { quest = 1437, areaId = 405, x = 66.44, y = 11.82 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 1437, 33, 30 }, -- Buscando a Vahlarriel
        { 1387, 31, 30 }, -- Colección de orejas
        { 1465, 33, 30 }, -- Buscando a Vahlarriel
        { 1438, 33, 30 }, -- Buscando a Vahlarriel
        { 1439, 33, 30 }, -- Buscando a Tyranis
        { 1440, 33, 30 }, -- Vuelve con Vahlarriel
        { 5741, 33, 30 }, -- El Cetro de la Luz
        { 1369, 33, 30 }, -- Lágrimas rotas
        { 1453, 33, 30 }, -- Los negocios de los Reivindicadores en Desolace
        { 1458, 33, 30 }, -- Componentes para Reivindicadores y Cía.
        { 97284, 33, 30 }, -- Vahlarriel's Vengeance
        { 5561, 34, 30 }, -- El rodeo kodo
        { 1371, 35, 30 }, -- Un cacharro para Warug
        { 5821, 35, 30 }, -- El guardaespaldas
        { 1382, 35, 30 }, -- Extraña alianza
        { 1384, 32, 30 }, -- Asalta a los Kolkar
        { 1370, 35, 30 }, -- ¡A robar provisiones!
        { 1385, 35, 30 }, -- Políticas brutales
        { 1386, 32, 30 }, -- Ataca a los Kolkar
        { 1459, 35, 30 }, -- Componentes para Reivindicadores y Cía.
        { 92754, 35, 30 }, -- A New Need for Shadow Protection
        { 92755, 35, 30 }, -- Mysterious Mysticism
        { 92814, 35, 30 }, -- I Need a Tailor
        { 92817, 35, 30 }, -- Leather Technique
        { 92818, 35, 30 }, -- Big, No, MASSIVE Iron Axes
        { 6161, 36, 30 }, -- La búsqueda del tesoro de Masatormento
        { 1373, 37, 30 }, -- Ongeku
        { 1374, 37, 30 }, -- Khan Jehn
        { 1375, 37, 30 }, -- Khan Shaka
        { 5943, 38, 32 }, -- La caravana Gizelton
        { 93034, 38, 30 }, -- Valley of Bones
        { 6027, 38, 30 }, -- El Libro de los Ancestros
        { 93044, 38, 30 }, -- A Cleansing Cry
        { 5501, 39, 33 }, -- Colección de kodos
        { 6134, 39, 34 }, -- La caza de ectoplamas
        { 6132, 39, 34 }, -- ¡Sácame de aquí!
        { 1454, 39, 30 }, -- El naufragio de Karnitol
        { 261, 39, 34 }, -- El sendero Escarlata
        { 1455, 39, 30 }, -- El naufragio de Karnitol
        { 1456, 39, 30 }, -- El naufragio de Karnitol
        { 1457, 39, 30 }, -- El naufragio de Karnitol
        { 6141, 39, 34 }, -- Hermano Antón
        { 1052, 40, 34 }, -- El sendero Escarlata
        { 1466, 40, 30 }, -- Componentes para Reivindicadores y Cía.
        { 1467, 40, 30 }, -- Componentes para Reivindicadores y Cía.
        { 93224, 40, 30 }, -- Carved Centaur Totems
        { 79229, 40, 1 }, -- Highway Robbery
        { 92743, 40, 30 }, -- A Conqueror's Crown
        { 92841, 40, 30 }, -- Valley of Bones
        { 93465, 40, 30 }, -- Notes on Draenethyst
        { 93678, 40, 30 }, -- Abridged Notes on Draenethyst
        { 1381, 42, 30 }, -- Khan Hratha
        { 1380, 42, 30 }, -- Khan Hratha
        { 93196, 42, 30 }, -- Khan Jehn
        { 93227, 45, 30 }, -- Buying Friendship: Gelkis
        { 93226, 45, 30 }, -- Buying Friendship: Magram
        { 7041, 47, 41 }, -- La corrupción de Lenguavil
        { 7028, 47, 41 }, -- Los males de Maraudón
        { 7067, 48, 39 }, -- Las instrucciones del Paria
        { 7044, 49, 41 }, -- Leyendas de Maraudón
        { 7065, 51, 45 }, -- Corrupción de la tierra y de la semilla
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 92811, 60, 1 }, -- Economic Warfare
    },
})

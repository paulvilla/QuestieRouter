-- Generado por tools/zone_borders.py (pasos a pie entre zonas: geografia del juego). No editar a mano.
local _, QR = ...
QR.BorderData = {
    -- { mapA, xA, yA, mapB, xB, yB, tipo }  (x, y en 0..1; tipo: tunnel | bridge | elevator | path | gate)
    crossings = {
        { 1440, 0.1902, 0.1830, 1439, 0.3755, 0.9626, nil }, -- Ashenvale / Darkshore
        { 1440, 0.2919, 0.1500, 1439, 0.4312, 0.9363, nil }, -- Ashenvale / Darkshore
        { 1440, 0.4229, 0.7106, 1442, 0.7823, 0.4270, "tunnel" }, -- Ashenvale / Stonetalon Mountains
        { 1440, 0.5575, 0.2928, 1448, 0.5482, 0.9117, nil }, -- Ashenvale / Felwood
        { 1440, 0.6862, 0.8648, 1413, 0.4816, 0.0432, nil }, -- Ashenvale / The Barrens
        { 1440, 0.9474, 0.4777, 1447, 0.1056, 0.7509, "bridge" }, -- Ashenvale / Azshara
        { 1457, 0.8626, 0.3556, 1438, 0.3616, 0.5439, nil }, -- Darnassus / Teldrassil
        { 1443, 0.4093, 0.9068, 1444, 0.4555, 0.0309, nil }, -- Desolace / Feralas
        { 1443, 0.5338, 0.0568, 1442, 0.3018, 0.7595, nil }, -- Desolace / Stonetalon Mountains
        { 1411, 0.4553, 0.1212, 1454, 0.5252, 0.8477, "gate" }, -- Durotar / Orgrimmar
        { 1445, 0.2880, 0.4715, 1413, 0.4963, 0.7841, nil }, -- Dustwallow Marsh / The Barrens
        { 1448, 0.6511, 0.0803, 1448, 0.6540, 0.0702, "tunnel" }, -- Felwood / Felwood
        { 1450, 0.3573, 0.7246, 1450, 0.3545, 0.7424, "tunnel" }, -- Moonglade / Moonglade
        { 1452, 0.2791, 0.3445, 1448, 0.6794, 0.0515, "tunnel" }, -- Winterspring / Felwood
        { 1412, 0.6443, 0.6367, 1413, 0.4192, 0.5862, nil }, -- Mulgore / The Barrens
        { 1449, 0.2931, 0.2236, 1451, 0.8404, 0.1393, "path" }, -- Un'Goro Crater / Silithus
        { 1442, 0.8338, 0.9772, 1413, 0.3572, 0.2750, nil }, -- Stonetalon Mountains / The Barrens
        { 1413, 0.4455, 0.8657, 1441, 0.3225, 0.2217, "elevator" }, -- The Barrens / Thousand Needles
        { 1441, 0.7419, 0.9334, 1446, 0.5075, 0.2413, "path" }, -- Thousand Needles / Tanaris
        { 1446, 0.2705, 0.5684, 1449, 0.7161, 0.7744, "path" }, -- Tanaris / Un'Goro Crater
        { 1429, 0.3249, 0.5006, 1453, 0.7333, 0.9069, "gate" }, -- Elwynn Forest / Stormwind City
        { 1431, 0.4491, 0.7981, 1434, 0.3930, 0.0562, "path" }, -- Duskwood / Stranglethorn Vale
        { 1431, 0.8861, 0.4102, 1430, 0.3565, 0.3560, nil }, -- Duskwood / Deadwind Pass
        { 1430, 0.5911, 0.4116, 1435, 0.1037, 0.5022, "path" }, -- Deadwind Pass / Swamp of Sorrows
        { 1435, 0.3564, 0.6207, 1419, 0.5201, 0.0781, nil }, -- Swamp of Sorrows / Blasted Lands
        { 1429, 0.9214, 0.7278, 1433, 0.0431, 0.7186, nil }, -- Elwynn Forest / Redridge Mountains
        { 1433, 0.0188, 0.8962, 1431, 0.9378, 0.1137, "bridge" }, -- Redridge Mountains / Duskwood
        { 1433, 0.4151, 0.0847, 1428, 0.7830, 0.7760, nil }, -- Redridge Mountains / Burning Steppes
        { 1433, 0.4404, 0.1101, 2548, 0.1709, 0.6813, nil }, -- Redridge Mountains / Riverglades
        { 2548, 0.3210, 0.3065, 1418, 0.5454, 0.8862, nil }, -- Riverglades / Badlands
        { 2548, 0.2537, 0.7221, 1433, 0.6722, 0.2101, "path" }, -- Riverglades / Redridge Mountains
        { 1433, 0.9715, 0.6667, 1435, 0.6762, 0.1073, "path" }, -- Redridge Mountains / Swamp of Sorrows
        { 1427, 0.6954, 0.5429, 1418, 0.0418, 0.6156, "path" }, -- Searing Gorge / Badlands
        { 1428, 0.2943, 0.3870, 1427, 0.3599, 1.1196, "path" }, -- Burning Steppes / Searing Gorge
        { 1418, 0.4925, 0.0742, 1432, 0.4683, 0.7775, nil }, -- Badlands / Loch Modan
        { 1426, 0.8015, 0.5259, 1432, 0.2234, 0.7001, "tunnel" }, -- Dun Morogh / Loch Modan
        { 1426, 0.8438, 0.3104, 1432, 0.1914, 0.1729, "tunnel" }, -- Dun Morogh / Loch Modan
        { 1432, 0.2557, 0.1029, 1437, 0.5388, 0.7033, "tunnel" }, -- Loch Modan / Wetlands
        { 1437, 0.5108, 0.1170, 1417, 0.4546, 0.8918, "bridge" }, -- Wetlands / Arathi Highlands
        { 1417, 0.2036, 0.2978, 1424, 0.8216, 0.5708, nil }, -- Arathi Highlands / Hillsbrad Foothills
        { 1424, 0.8439, 0.3227, 1425, 0.1122, 0.5119, "path" }, -- Hillsbrad Foothills / The Hinterlands
        { 1425, 0.2072, 0.4795, 1422, 0.6528, 0.8679, "path" }, -- The Hinterlands / Western Plaguelands
        { 1416, 0.7991, 0.4263, 1422, 0.4404, 0.8638, "path" }, -- Alterac Mountains / Western Plaguelands
        { 1421, 0.6580, 0.7945, 1424, 0.1413, 0.4620, nil }, -- Silverpine Forest / Hillsbrad Foothills
        { 1420, 0.5488, 0.7260, 1421, 0.6603, 0.0765, nil }, -- Tirisfal Glades / Silverpine Forest
        { 1420, 0.8450, 0.7039, 1422, 0.2899, 0.5748, nil }, -- Tirisfal Glades / Western Plaguelands
        { 1426, 0.5340, 0.3500, 1455, 0.1616, 0.8458, "gate" }, -- Dun Morogh / Ironforge
        { 1420, 0.6187, 0.6501, 1458, 0.6622, 0.0189, "gate" }, -- Tirisfal Glades / Undercity
        { 1420, 0.1528, 0.3086, 1458, 0.1481, 0.3528, "tunnel" }, -- Tirisfal Glades / Undercity
    },
    -- fronteras abiertas: se pueden cruzar por cualquier sitio
    open = {
        { 1429, 1436 }, -- Elwynn Forest / Westfall
        { 1429, 1431 }, -- Elwynn Forest / Duskwood
        { 1436, 1431 }, -- Westfall / Duskwood
        { 1422, 1423 }, -- Western Plaguelands / Eastern Plaguelands
        { 1424, 1416 }, -- Hillsbrad Foothills / Alterac Mountains
        { 1411, 1413 }, -- Durotar / The Barrens
        { 1444, 1441 }, -- Feralas / Thousand Needles
    },
    -- tranvia y portales: { mapA, xA, yA, mapB, xB, yB, tipo, faccion, solo ida }
    links = {
        { 1438, 0.5591, 0.8964, 1457, 0.3006, 0.4144, "portal", "A", false }, -- Teldrassil / Darnassus
        { 1453, 0.6036, 0.1247, 1455, 0.7290, 0.5027, "tram", "A", false }, -- Stormwind City / Ironforge
        { 1416, 0.1521, 0.5600, 1416, 0.1463, 0.5782, "portal", nil, false }, -- Alterac Mountains / Alterac Mountains
        { 1416, 0.1808, 0.7187, 1416, 0.1806, 0.7203, "door", nil, false }, -- Alterac Mountains / Alterac Mountains
    },
}

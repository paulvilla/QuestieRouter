-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Wetlands · niveles 20-30 · 78 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_Wetlands",
    faction = "Alliance",
    zone = "Wetlands",
    areaId = 11,
    minLevel = 20,
    maxLevel = 30,
    entry = { quest = 484, areaId = 11, x = 8.55, y = 55.74 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 484, 22, 18 }, -- Piel de crocolisco joven
        { 274, 18, 16 }, -- Se aproxima una oscura amenaza
        { 942, 20, 15 }, -- El prospector despistado
        { 276, 21, 20 }, -- Patas sucias
        { 469, 21, 18 }, -- Entrega cotidiana
        { 463, 21, 20 }, -- El Guardaverde
        { 98282, 22, 20 }, -- Los peligros de la alquimia
        { 98197, 22, 18 }, -- Botín de guerra
        { 279, 22, 20 }, -- Zarpas de las profundidades
        { 277, 23, 20 }, -- No al fuego
        { 294, 24, 22 }, -- La venganza de Ormer
        { 305, 24, 21 }, -- La búsqueda del equipo de excavación
        { 470, 24, 19 }, -- Abriéndose paso entre los mocos
        { 943, 24, 15 }, -- El prospector despistado
        { 306, 24, 21 }, -- La búsqueda del equipo de excavación
        { 472, 25, 25 }, -- La caída de Dun Modr
        { 281, 25, 20 }, -- Recuperación de bienes
        { 284, 25, 20 }, -- La búsqueda continúa
        { 285, 25, 20 }, -- Inspecciona más casuchas
        { 286, 25, 20 }, -- Devuelve la Estatuilla
        { 98189, 25, 20 }, -- Devolver la Estatuilla
        { 98190, 25, 20 }, -- Un amigo de la familia
        { 471, 26, 18 }, -- Deberes de aprendiz
        { 275, 26, 20 }, -- Ampollas en la tierra
        { 295, 27, 22 }, -- La venganza de Ormer
        { 299, 27, 22 }, -- Desvelando el pasado
        { 288, 27, 22 }, -- La Tercera Flota
        { 98072, 27, 1 }, -- Crocos del cielo
        { 98815, 28, 24 }, -- Pellejos de las Tierras Altas
        { 473, 28, 23 }, -- Preséntate ante el capitán Puñorrecio
        { 464, 28, 23 }, -- Estandartes de batalla
        { 98221, 28, 23 }, -- Desde las cenizas
        { 98240, 29, 19 }, -- Entrega de caja carmesí
        { 289, 29, 22 }, -- La tripulación maldita
        { 296, 29, 22 }, -- La venganza de Ormer
        { 98245, 29, 21 }, -- Agujas de tajobuche
        { 98246, 29, 21 }, -- Tiempos difíciles
        { 270, 29, 20 }, -- La flota maldita
        { 321, 29, 20 }, -- Hierro Forjaluz
        { 526, 29, 20 }, -- Lingotes Forjaluz
        { 324, 29, 20 }, -- Los lingotes perdidos
        { 322, 29, 20 }, -- Brazo bendito
        { 290, 30, 22 }, -- Purga de la maldición
        { 1132, 30, 30 }, -- Fiora Orejona
        { 292, 30, 22 }, -- El ojo de Paleth
        { 303, 30, 22 }, -- La guerra contra los Hierro Negro
        { 378, 27, 22 }, -- La furia mora en las profundidades
        { 98283, 30, 22 }, -- Carnicería
        { 98293, 30, 22 }, -- Desarme forzado
        { 98291, 30, 22 }, -- Muerte a los Faucedraco
        { 293, 30, 22 }, -- Limpieza del ojo
        { 95647, 31, 24 }, -- Perdido en la espesura
        { 465, 31, 23 }, -- La estrategia de Nek'rosh
        { 98216, 31, 23 }, -- Comprender el presente
        { 98824, 31, 24 }, -- Prisma prehistórico
        { 98223, 31, 23 }, -- Viejas costumbres
        { 95646, 31, 24 }, -- Horrores en las Tierras Altas
        { 631, 31, 28 }, -- El puente Thandol
        { 88756, 31, 27 }, -- Un encargo explosivo
        { 632, 31, 28 }, -- El puente Thandol
        { 633, 31, 28 }, -- El puente Thandol
        { 634, 31, 28 }, -- Petición a la Alianza
        { 474, 32, 23 }, -- Derrota a Nek'rosh
        { 98230, 29, 22 }, -- Esta era su tierra
        { 98310, 32, 24 }, -- La forja del futuro
        { 98313, 32, 24 }, -- Un estudio más exhaustivo
        { 87318, 33, 28 }, -- Hearts of the Lost
        { 88757, 33, 28 }, -- Accessories of the Lost
        { 88758, 33, 28 }, -- Sentiments of the Lost
        { 1248, 33, 28 }, -- El diplomático desaparecido
        { 1249, 33, 28 }, -- El diplomático desaparecido
        { 1250, 33, 28 }, -- El diplomático desaparecido
        { 1264, 33, 28 }, -- El diplomático desaparecido
        { 98297, 34, 24 }, -- Detener el ciclo
        { 98300, 34, 24 }, -- Mensaje a Forjaz
        { 304, 34, 26 }, -- Una misión hedionda
        { 1302, 35, 30 }, -- James Hyal
        { 1301, 35, 30 }, -- James Hyal
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 97171, 40, 40 }, -- Your First Horse
        { 98166, 40, 40 }, -- Your First Horse
    },
})

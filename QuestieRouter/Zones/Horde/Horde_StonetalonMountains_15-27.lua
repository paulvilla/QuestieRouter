-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Stonetalon Mountains · niveles 15-27 · 29 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_StonetalonMountains",
    faction = "Horde",
    zone = "Stonetalon Mountains",
    areaId = 406,
    minLevel = 15,
    maxLevel = 27,
    entry = { quest = 6523, areaId = 406, x = 73.48, y = 85.59 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 6523, 18, 12 }, -- Proteje a Kaya
        { 6421, 18, 14 }, -- Barranco del Alud
        { 6461, 19, 13 }, -- Chupasangres
        { 6542, 19, 17 }, -- Preséntate ante Kadrak
        { 6481, 20, 14 }, -- El despertar del terráneo
        { 1093, 21, 16 }, -- Súper Leñadora 6000
        { 1094, 21, 16 }, -- Más instrucciones
        { 6284, 21, 15 }, -- Aracnofobia
        { 6562, 22, 17 }, -- Problemas en las profundidades
        { 1090, 22, 17 }, -- Órdenes de Gerenzo
        { 1092, 22, 17 }, -- Órdenes de Gerenzo
        { 6301, 23, 17 }, -- El ciclo del renacimiento
        { 1086, 23, 13 }, -- El minipuerto
        { 79980, 24, 14 }, -- Revolver
        { 6381, 25, 17 }, -- Nueva vida
        { 1087, 25, 20 }, -- El legado de Cenarius
        { 6393, 25, 19 }, -- Guerra elemental
        { 6282, 26, 18 }, -- La ameneza de la arpías
        { 6283, 26, 18 }, -- El linaje Furia Sangrienta
        { 86576, 26, 18 }, -- Los dijes Furia sangrienta
        { 1058, 26, 20 }, -- Magia del bosque de Jin'Zil
        { 1096, 27, 16 }, -- Gerenzo Silbillave
        { 5881, 28, 23 }, -- La sustitución
        { 1088, 29, 20 }, -- Ordanus
        { 1089, 29, 20 }, -- El Cubil
        { 1154, 30, 25 }, -- Prueba de conocimiento
        { 6627, 30, 25 }, -- Prueba de conocimiento
        { 1159, 30, 25 }, -- Prueba de conocimiento
        { 79974, 32, 14 }, -- Un trabajo sucio
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 97446, 40, 40 }, -- Your First Riding Kodo
    },
})

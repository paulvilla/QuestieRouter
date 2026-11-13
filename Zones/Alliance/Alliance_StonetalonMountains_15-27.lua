-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Stonetalon Mountains · niveles 15-27 · 23 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_StonetalonMountains",
    faction = "Alliance",
    zone = "Stonetalon Mountains",
    areaId = 406,
    minLevel = 15,
    maxLevel = 27,
    entry = { quest = 1085, areaId = 406, x = 59.9, y = 66.85 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 1085, 21, 17 }, -- Estar de guardia en Espolón
        { 1071, 21, 17 }, -- Una tregua para el gnomo
        { 1072, 21, 17 }, -- Un viejo colega
        { 1075, 21, 17 }, -- Un pergamino de Mauren
        { 1093, 21, 16 }, -- Súper Leñadora 6000
        { 1094, 21, 16 }, -- Más instrucciones
        { 1074, 21, 17 }, -- Ineptitud + Productos químicos = Diversión
        { 1077, 21, 17 }, -- Entrega especial para Gaxim
        { 1079, 22, 17 }, -- Operaciones secretas: plan A
        { 1080, 22, 17 }, -- Operaciones secretas: plan B
        { 1091, 22, 17 }, -- Noticias para Kaela
        { 1090, 22, 17 }, -- Órdenes de Gerenzo
        { 1092, 22, 17 }, -- Órdenes de Gerenzo
        { 78270, 23, 1 }, -- Goblin Lockpicks
        { 86574, 24, 20 }, -- Stonetalon Supply Run
        { 79980, 24, 14 }, -- Scramble
        { 1083, 26, 20 }, -- Los espíritus enfurecidos
        { 1096, 27, 16 }, -- Gerenzo Silbillave
        { 1057, 27, 20 }, -- La reconquista de La Vega Carbonizada
        { 1059, 27, 20 }, -- La reconquista de La Vega Carbonizada
        { 1084, 28, 22 }, -- Los antárboles corruptos
        { 1082, 22, 17 }, -- Noticias para Centinela Thenysil
        { 2931, 28, 25 }, -- Trabajar para Funditubo
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 79974, 32, 14 }, -- Wet Job
    },
})

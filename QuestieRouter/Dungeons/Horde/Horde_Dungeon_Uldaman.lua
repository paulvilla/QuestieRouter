-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Uldaman · niveles 35-40 · 22 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Horde_Dungeon_Uldaman",
    faction = "Horde",
    zone = "Uldaman",
    dungeon = "Uldaman",
    instanceId = 70,
    areaId = 1517,
    minLevel = 35,
    maxLevel = 40,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 2418, 36, 30 }, -- Las piedras de energía
        { 2258, 39, 36 }, -- Componentes de Tierras Inhóspitas
        { 709, 40, 30 }, -- La solución a la maldición
        { 728, 40, 30 }, -- Ir a Entrañas a buscar el "Compendio" de Yagyin
        { 2283, 41, 37 }, -- La recuperación del collar
        { 2284, 41, 37 }, -- La recuperación del collar, 2ª parte
        { 2202, 42, 36 }, -- Componentes de Uldaman
        { 2318, 42, 37 }, -- La traducción del diario
        { 2338, 42, 37 }, -- La traducción del diario
        { 2342, 43, 33 }, -- Los tesoros reclamados
        { 736, 44, 30 }, -- La Estrella, la Mano y el Corazón
        { 2339, 44, 37 }, -- Encuentra las gemas y la fuente de poder
        { 2340, 44, 37 }, -- Entregar las gemas
        { 2341, 44, 40 }, -- La recuperación del collar, 3ª parte
        { 2278, 47, 40 }, -- Los discos de platino
        { 2280, 47, 40 }, -- Los discos de platino
        { 2440, 47, 40 }, -- Los discos de platino
        { 2965, 50, 45 }, -- Presagios de Uldum
        { 2966, 50, 45 }, -- A ver qué pasa
        { 2954, 50, 45 }, -- El guardapiedras
        { 2967, 50, 45 }, -- El regreso a Cima del Trueno
        { 2968, 50, 45 }, -- Una tarea futura
    },
})

-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Maraudon · niveles 42-47 · 9 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Horde_Dungeon_Maraudon",
    faction = "Horde",
    zone = "Maraudon",
    dungeon = "Maraudon",
    instanceId = 349,
    areaId = 2100,
    minLevel = 42,
    maxLevel = 47,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 7068, 42, 39 }, -- Fragmentos Oscuros
        { 7028, 47, 41 }, -- Los males de Maraudón
        { 7029, 47, 41 }, -- La corrupción de Lenguavil
        { 7067, 48, 39 }, -- Las instrucciones del Paria
        { 7044, 49, 41 }, -- Leyendas de Maraudón
        { 7046, 49, 41 }, -- El cetro de Celebras
        { 7064, 51, 45 }, -- Corrupción de la tierra y de la semilla
        { 7066, 51, 45 }, -- La semilla de la vida
        { 96776, 51, 43 }, -- An'she's Radiance
    },
})

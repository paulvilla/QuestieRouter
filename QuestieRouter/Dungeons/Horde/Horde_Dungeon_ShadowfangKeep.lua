-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Shadowfang Keep · niveles 18-23 · 3 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Horde_Dungeon_ShadowfangKeep",
    faction = "Horde",
    zone = "Shadowfang Keep",
    dungeon = "Shadowfang Keep",
    instanceId = 33,
    areaId = 209,
    minLevel = 18,
    maxLevel = 23,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 1098, 25, 18 }, -- Mortacechadores en Colmillo Oscuro
        { 1013, 26, 16 }, -- El Libro de Ur
        { 1014, 27, 18 }, -- Arugal debe morir
    },
})

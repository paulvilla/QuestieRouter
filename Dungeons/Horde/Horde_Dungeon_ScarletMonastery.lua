-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Scarlet Monastery - Graveyard · niveles 30-35 · 5 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Horde_Dungeon_ScarletMonastery",
    faction = "Horde",
    zone = "Scarlet Monastery",
    dungeon = "Scarlet Monastery - Graveyard",
    instanceId = 189,
    areaId = 796,
    minLevel = 30,
    maxLevel = 35,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 1051, 33, 25 }, -- La venganza de Vorrel
        { 1113, 33, 30 }, -- Corazones de fervor
        { 1160, 36, 25 }, -- Prueba de conocimiento
        { 1049, 38, 28 }, -- El Compendio de los Caídos
        { 1048, 42, 33 }, -- En el Monasterio Escarlata
    },
})

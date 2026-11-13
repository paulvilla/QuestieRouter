-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Scarlet Monastery - Graveyard · niveles 30-35 · 5 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Alliance_Dungeon_ScarletMonastery",
    faction = "Alliance",
    zone = "Scarlet Monastery",
    dungeon = "Scarlet Monastery - Graveyard",
    instanceId = 189,
    areaId = 796,
    minLevel = 30,
    maxLevel = 35,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 1050, 38, 28 }, -- Mitología de los Titanes
        { 96800, 38, 30 }, -- Past Due
        { 261, 39, 34 }, -- El sendero Escarlata
        { 1052, 40, 34 }, -- El sendero Escarlata
        { 1053, 40, 34 }, -- En el nombre de la Luz
    },
})

-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · City of Dalaran · niveles 28-33 · 5 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Alliance_Dungeon_CityOfDalaran",
    faction = "Alliance",
    zone = "City of Dalaran",
    dungeon = "City of Dalaran",
    instanceId = 2959,
    areaId = 16544,
    minLevel = 28,
    maxLevel = 33,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 92432, 33, 30 }, -- An Alarming Request
        { 92456, 33, 24 }, -- A Green Sample
        { 92489, 33, 24 }, -- Power Overwhelming
        { 92457, 33, 24 }, -- Starving Arcane
        { 92458, 33, 24 }, -- Heart of Disruption
    },
})

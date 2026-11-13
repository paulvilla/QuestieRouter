-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · City of Dalaran · niveles 28-33 · 8 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Horde_Dungeon_CityOfDalaran",
    faction = "Horde",
    zone = "City of Dalaran",
    dungeon = "City of Dalaran",
    instanceId = 2959,
    areaId = 16544,
    minLevel = 28,
    maxLevel = 33,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 96984, 33, 24 }, -- Heart of Disruption
        { 96986, 33, 24 }, -- The Grave Knight
        { 97287, 33, 24 }, -- Shrewd Negotiations
        { 96987, 33, 24 }, -- Opportunistic Education
        { 96988, 33, 24 }, -- Source of Power
        { 557, 34, 30 }, -- Brazales de vínculo
        { 92434, 34, 30 }, -- Blood in the Streets
        { 545, 35, 30 }, -- Las patrullas de Dalaran
    },
})

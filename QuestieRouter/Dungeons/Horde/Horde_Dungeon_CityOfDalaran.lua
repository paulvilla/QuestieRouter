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
        { 557, 33, 30 }, -- Brazales de vínculo
        { 97287, 33, 24 }, -- Negociaciones astutas
        { 96986, 33, 24 }, -- El Caballero de la Tumba
        { 96987, 33, 24 }, -- Educación oportunista
        { 96988, 33, 24 }, -- Fuente de poder
        { 545, 35, 30 }, -- Las patrullas de Dalaran
        { 92434, 34, 30 }, -- Sangre en las calles
        { 96984, 33, 24 }, -- El corazón de la perturbación
    },
})

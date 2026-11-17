-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Blackfathom Deeps · niveles 22-27 · 9 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Horde_Dungeon_BlackfathomDeeps",
    faction = "Horde",
    zone = "Blackfathom Deeps",
    dungeon = "Blackfathom Deeps",
    instanceId = 48,
    areaId = 719,
    minLevel = 22,
    maxLevel = 27,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 6562, 22, 17 }, -- Problemas en las profundidades
        { 6563, 22, 17 }, -- La esencia de Aku'Mai
        { 6564, 22, 17 }, -- Lealtad a los dioses antiguos
        { 1198, 24, 18 }, -- Buscando a Thaelrid
        { 78917, 25, 25 }, -- The Heart of the Void
        { 6565, 26, 17 }, -- Lealtad a los dioses antiguos
        { 6921, 27, 21 }, -- Entre ruinas
        { 6561, 27, 18 }, -- La vileza de Brazanegra
        { 6922, 30, 21 }, -- Barón Aquanis
    },
})

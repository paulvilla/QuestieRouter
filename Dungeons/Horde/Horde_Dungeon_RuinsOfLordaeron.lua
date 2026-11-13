-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Ruins of Lordaeron · niveles 15-20 · 10 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Horde_Dungeon_RuinsOfLordaeron",
    faction = "Horde",
    zone = "Ruins of Lordaeron",
    dungeon = "Ruins of Lordaeron",
    instanceId = 2999,
    areaId = 16611,
    minLevel = 15,
    maxLevel = 20,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 97288, 21, 15 }, -- Unending Torment
        { 97289, 21, 15 }, -- Unending Torment
        { 97290, 21, 15 }, -- Unending Torment
        { 97291, 21, 15 }, -- Unending Torment
        { 97292, 21, 15 }, -- Unending Torment
        { 95216, 22, 15 }, -- The New Plague
        { 92421, 22, 15 }, -- Justicia de la Luz
        { 92401, 22, 15 }, -- Una petición aterradora
        { 92422, 22, 15 }, -- La cólera de Rath'mael
        { 95204, 22, 15 }, -- Crest of Lordaeron
    },
})

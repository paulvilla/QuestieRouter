-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Excavation Site: Wetlands · niveles 24-29 · 5 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Horde_Dungeon_ExcavationSite",
    faction = "Horde",
    zone = "Excavation Site: Wetlands",
    dungeon = "Excavation Site: Wetlands",
    instanceId = 2998,
    areaId = 16732,
    minLevel = 24,
    maxLevel = 29,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 95663, 31, 24 }, -- Dragonmaw Rumors
        { 95664, 31, 24 }, -- Elder Knowledge
        { 95682, 31, 24 }, -- Open the Maw
        { 95697, 31, 24 }, -- Changing Tastes
        { 98823, 31, 24 }, -- Earthen Echo
    },
})

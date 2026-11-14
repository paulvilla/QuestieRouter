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
        { 95663, 31, 24 }, -- Rumores de los Faucedraco
        { 95664, 31, 24 }, -- Sabiduría ancestral
        { 95682, 31, 24 }, -- Abre las Fauces
        { 95697, 31, 24 }, -- Cambio de paladar
        { 98823, 31, 24 }, -- Eco terráneo
    },
})

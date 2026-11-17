-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Excavation Site: Wetlands · niveles 24-29 · 13 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Alliance_Dungeon_ExcavationSite",
    faction = "Alliance",
    zone = "Excavation Site: Wetlands",
    dungeon = "Excavation Site: Wetlands",
    instanceId = 2998,
    areaId = 16732,
    minLevel = 24,
    maxLevel = 29,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 276, 21, 20 }, -- Patas sucias
        { 484, 22, 18 }, -- Piel de crocolisco joven
        { 277, 23, 20 }, -- No al fuego
        { 275, 26, 20 }, -- Ampollas en la tierra
        { 98815, 28, 24 }, -- Pellejos de las Tierras Altas
        { 95647, 31, 24 }, -- Perdido en la espesura
        { 95646, 31, 24 }, -- Horrores en las Tierras Altas
        { 95737, 31, 24 }, -- En busca de Caitlin
        { 95772, 31, 24 }, -- En busca de Filosón
        { 95795, 31, 24 }, -- Muerte en el pantano
        { 95809, 31, 24 }, -- Tejido en el corazón
        { 95810, 31, 24 }, -- Transporte de reliquia perdida
        { 98824, 31, 24 }, -- Prisma prehistórico
    },
})

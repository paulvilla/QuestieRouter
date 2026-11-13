-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Ruins of Lordaeron · niveles 15-20 · 5 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Alliance_Dungeon_RuinsOfLordaeron",
    faction = "Alliance",
    zone = "Ruins of Lordaeron",
    dungeon = "Ruins of Lordaeron",
    instanceId = 2999,
    areaId = 16611,
    minLevel = 15,
    maxLevel = 20,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 95250, 21, 15 }, -- Abominable Creatures
        { 92415, 22, 15 }, -- Recuerda el amor que te tengo
        { 95161, 22, 15 }, -- Remember That I Love You
        { 95189, 22, 15 }, -- El blasón de Lordaeron
        { 95195, 22, 15 }, -- La insignia ensangrentada
    },
})

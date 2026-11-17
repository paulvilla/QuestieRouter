-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · The Hall of Thanes · niveles 13-18 · 7 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Alliance_Dungeon_HallOfThanes",
    faction = "Alliance",
    zone = "The Hall of Thanes",
    dungeon = "The Hall of Thanes",
    instanceId = 3065,
    areaId = 16919,
    minLevel = 13,
    maxLevel = 18,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 96392, 13, 9 }, -- La vigilancia de Farsen
        { 96391, 15, 9 }, -- Mapa subterráneo
        { 96394, 15, 10 }, -- Los muertos sin descanso
        { 96403, 15, 10 }, -- Reliquias importantes
        { 96395, 15, 1 }, -- Un agravio antiguo
        { 96393, 16, 9 }, -- Incursión en la Antigua Forjaz
        { 98423, 16, 9 }, -- El tratado de entendimiento
    },
})

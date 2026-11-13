-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Ragefire Chasm · niveles 13-18 · 10 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Horde_Dungeon_RagefireChasm",
    faction = "Horde",
    zone = "Ragefire Chasm",
    dungeon = "Ragefire Chasm",
    instanceId = 389,
    areaId = 2437,
    minLevel = 13,
    maxLevel = 18,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 5726, 12, 9 }, -- Enemigos ocultos
        { 5727, 12, 9 }, -- Enemigos ocultos
        { 5723, 15, 9 }, -- Midiendo fuerzas con el enemigo
        { 5722, 16, 9 }, -- Buscando la cartera perdida
        { 5724, 16, 9 }, -- La vuelta de la cartera perdida
        { 5725, 16, 9 }, -- Poder destructivo
        { 5728, 16, 9 }, -- Enemigos ocultos
        { 5729, 15, 9 }, -- Enemigos ocultos
        { 5730, 16, 9 }, -- Enemigos ocultos
        { 5761, 16, 9 }, -- Matar a la bestia
    },
})

-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Blackfathom Deeps · niveles 22-27 · 7 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Alliance_Dungeon_BlackfathomDeeps",
    faction = "Alliance",
    zone = "Blackfathom Deeps",
    dungeon = "Blackfathom Deeps",
    instanceId = 48,
    areaId = 719,
    minLevel = 22,
    maxLevel = 27,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 971, 23, 18 }, -- El conocimiento de las profundidades
        { 1198, 24, 18 }, -- Buscando a Thaelrid
        { 1275, 24, 18 }, -- Investigaciones acerca de la corrupción
        { 3765, 24, 18 }, -- Lejana corrupción
        { 1199, 25, 20 }, -- Cascada del Crepúsculo
        { 78916, 25, 25 }, -- The Heart of the Void
        { 1200, 27, 18 }, -- La vileza de Brazanegra
    },
})

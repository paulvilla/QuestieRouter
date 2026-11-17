-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Razorfen Kraul · niveles 24-29 · 5 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Alliance_Dungeon_RazorfenKraul",
    faction = "Alliance",
    zone = "Razorfen Kraul",
    dungeon = "Razorfen Kraul",
    instanceId = 47,
    areaId = 1717,
    minLevel = 24,
    maxLevel = 29,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 1221, 26, 20 }, -- Los tubérculos hojazul
        { 1142, 30, 25 }, -- Decaída mortal
        { 1144, 30, 23 }, -- Willix el Importador
        { 1100, 34, 29 }, -- El diario de Henrig Soliceja
        { 1101, 34, 29 }, -- La bruja del Horado
    },
})

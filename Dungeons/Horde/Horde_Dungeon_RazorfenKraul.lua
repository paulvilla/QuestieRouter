-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Razorfen Kraul · niveles 24-29 · 5 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Horde_Dungeon_RazorfenKraul",
    faction = "Horde",
    zone = "Razorfen Kraul",
    dungeon = "Razorfen Kraul",
    instanceId = 47,
    areaId = 1717,
    minLevel = 24,
    maxLevel = 29,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 1221, 26, 20 }, -- Los tubérculos hojazul
        { 1144, 30, 23 }, -- Willix el Importador
        { 1109, 33, 30 }, -- Guano del Horado
        { 1102, 34, 29 }, -- Un destino vengador
        { 6522, 36, 28 }, -- Una alianza nefasta
    },
})

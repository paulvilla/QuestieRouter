-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Razorfen Downs · niveles 34-39 · 5 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Alliance_Dungeon_RazorfenDowns",
    faction = "Alliance",
    zone = "Razorfen Downs",
    dungeon = "Razorfen Downs",
    instanceId = 129,
    areaId = 722,
    minLevel = 34,
    maxLevel = 39,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 6626, 35, 28 }, -- Un anfitrión del mal
        { 3523, 37, 32 }, -- La plaga de la Zahúrda
        { 3525, 37, 32 }, -- Extinguir el ídolo
        { 96773, 41, 34 }, -- El ojo del Gélido
        { 3636, 42, 39 }, -- Trae la Luz
    },
})

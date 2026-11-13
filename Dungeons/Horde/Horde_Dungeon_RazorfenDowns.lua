-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Razorfen Downs · niveles 34-39 · 6 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Horde_Dungeon_RazorfenDowns",
    faction = "Horde",
    zone = "Razorfen Downs",
    dungeon = "Razorfen Downs",
    instanceId = 129,
    areaId = 722,
    minLevel = 34,
    maxLevel = 39,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 6626, 35, 28 }, -- Un anfitrión del mal
        { 6522, 36, 28 }, -- Una alianza nefasta
        { 6521, 36, 28 }, -- Una alianza nefasta
        { 3523, 37, 32 }, -- La plaga de la Zahúrda
        { 3525, 37, 32 }, -- Extinguir el ídolo
        { 3341, 42, 37 }, -- Acaba con la amenaza
    },
})

-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Wailing Caverns · niveles 17-22 · 5 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Alliance_Dungeon_WailingCaverns",
    faction = "Alliance",
    zone = "Wailing Caverns",
    dungeon = "Wailing Caverns",
    instanceId = 43,
    areaId = 718,
    minLevel = 17,
    maxLevel = 22,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 1486, 17, 13 }, -- Pellejo de los descarriados
        { 1491, 18, 13 }, -- Las bebidas astutas
        { 959, 18, 14 }, -- ¡A por la botella!
        { 1487, 21, 15 }, -- Erradicación de descarriados
        { 6981, 26, 15 }, -- El fragmento brillante
    },
})

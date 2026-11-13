-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Wailing Caverns · niveles 17-22 · 13 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Horde_Dungeon_WailingCaverns",
    faction = "Horde",
    zone = "Wailing Caverns",
    dungeon = "Wailing Caverns",
    instanceId = 43,
    areaId = 718,
    minLevel = 17,
    maxLevel = 22,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 870, 13, 10 }, -- Las Charcas del Olvido
        { 877, 16, 10 }, -- El Oasis Estancado
        { 880, 16, 10 }, -- Fuentes de vida
        { 1489, 16, 12 }, -- Hamuul Runatótem
        { 1490, 16, 12 }, -- Nara Bravacrín
        { 1486, 17, 13 }, -- Pellejo de los descarriados
        { 1491, 18, 13 }, -- Las bebidas astutas
        { 959, 18, 14 }, -- ¡A por la botella!
        { 962, 18, 14 }, -- Repitilia
        { 1487, 21, 15 }, -- Erradicación de descarriados
        { 914, 22, 11 }, -- Líderes del Colmillo
        { 6981, 26, 15 }, -- El fragmento brillante
        { 3369, 25, 15 }, -- En las pesadillas
    },
})

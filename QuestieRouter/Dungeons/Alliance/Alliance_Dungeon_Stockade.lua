-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Stormwind Stockade · niveles 23-28 · 15 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Alliance_Dungeon_Stockade",
    faction = "Alliance",
    zone = "Stormwind Stockade",
    dungeon = "Stormwind Stockade",
    instanceId = 34,
    areaId = 717,
    minLevel = 23,
    maxLevel = 28,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 386, 25, 22 }, -- Lo que sucece alrededor…
        { 377, 26, 22 }, -- Crimen y castigo
        { 387, 26, 22 }, -- Detener el motín
        { 388, 26, 22 }, -- El color de la sangre
        { 378, 27, 22 }, -- La furia mora en las profundidades
        { 391, 29, 16 }, -- El motín de las Mazmorras
        { 392, 29, 16 }, -- Extraño visitante
        { 393, 29, 16 }, -- Sombras del pasado
        { 350, 31, 16 }, -- Mira por un viejo amigo
        { 2745, 31, 16 }, -- Infíltrate en el castillo
        { 2746, 31, 16 }, -- Objetos importantes
        { 434, 31, 16 }, -- El ataque
        { 394, 31, 16 }, -- La cabeza de la bestia
        { 395, 31, 16 }, -- El fin de la Hermandad
        { 396, 31, 16 }, -- Una audiencia con el Rey
    },
})

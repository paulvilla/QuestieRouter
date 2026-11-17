-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Scholomance · niveles 57-60 · 12 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Alliance_Dungeon_Scholomance",
    faction = "Alliance",
    zone = "Scholomance",
    dungeon = "Scholomance",
    instanceId = 289,
    areaId = 2057,
    minLevel = 57,
    maxLevel = 60,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 5529, 58, 55 }, -- Crías de dragón apestadas
        { 5582, 58, 55 }, -- Escama sana de dragón
        { 5531, 60, 57 }, -- Betina Bigglezink
        { 4771, 60, 57 }, -- Gambito del Alba
        { 5343, 60, 52 }, -- La fortuna de la familia Barov
        { 5382, 60, 55 }, -- Doctor Theolen Krastinov, el Carnicero
        { 5515, 60, 55 }, -- Bolsa de los horrores de Krastinov
        { 5384, 60, 55 }, -- Kirtonos el Heraldo
        { 5461, 60, 57 }, -- El humano, Ras Levescarcha
        { 5466, 60, 57 }, -- El Lich, Ras Levescarcha
        { 8969, 60, 58 }, -- La parte izquierda del amuleto de Lord Valthalak
        { 8992, 60, 58 }, -- La parte derecha del amuleto de Lord Valthalak
    },
})

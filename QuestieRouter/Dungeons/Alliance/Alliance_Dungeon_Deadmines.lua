-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Deadmines · niveles 16-21 · 14 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Alliance_Dungeon_Deadmines",
    faction = "Alliance",
    zone = "Deadmines",
    dungeon = "Deadmines",
    instanceId = 36,
    areaId = 1581,
    minLevel = 16,
    maxLevel = 21,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 65, 18, 14 }, -- La hermandad de los Defias
        { 92753, 18, 9 }, -- Destrucción en las Minas de la Muerte
        { 132, 18, 14 }, -- La hermandad de los Defias
        { 135, 18, 14 }, -- La hermandad de los Defias
        { 141, 18, 14 }, -- La hermandad de los Defias
        { 168, 18, 14 }, -- La recolección de Tarjetas del Sindicato Minero
        { 142, 18, 14 }, -- La hermandad de los Defias
        { 155, 18, 14 }, -- La hermandad de los Defias
        { 214, 17, 14 }, -- Pañuelos rojos de seda
        { 167, 20, 15 }, -- Oh, hermano...
        { 2040, 20, 15 }, -- Asalto subterráneo
        { 166, 22, 14 }, -- La hermandad de los Defias
        { 373, 22, 16 }, -- La carta sin enviar
        { 389, 22, 16 }, -- Bazil Thredd
    },
})

-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Zul'Farrak · niveles 42-47 · 10 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Horde_Dungeon_ZulFarrak",
    faction = "Horde",
    zone = "Zul'Farrak",
    dungeon = "Zul'Farrak",
    instanceId = 209,
    areaId = 978,
    minLevel = 42,
    maxLevel = 47,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 3520, 44, 40 }, -- Los espíritus de los estriadores
        { 2865, 45, 40 }, -- Caparazones de escarabajo
        { 3042, 45, 40 }, -- Temple trol
        { 2864, 45, 40 }, -- Tran'rek
        { 2936, 45, 40 }, -- Diosa araña
        { 2846, 46, 40 }, -- Tiara de la Profundidad
        { 2861, 46, 40 }, -- La tarea de Tabetha
        { 2768, 47, 40 }, -- Cetro Divinomático
        { 3527, 47, 40 }, -- La profecía de Mosh'aru
        { 2770, 50, 40 }, -- Gahz'rilla
    },
})

-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Zul'Farrak · niveles 42-47 · 15 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Alliance_Dungeon_ZulFarrak",
    faction = "Alliance",
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
        { 2988, 45, 40 }, -- Las jaulas de Secacorteza
        { 2846, 46, 40 }, -- Tiara de la Profundidad
        { 2861, 46, 40 }, -- La tarea de Tabetha
        { 2768, 47, 40 }, -- Cetro Divinomático
        { 3527, 47, 40 }, -- La profecía de Mosh'aru
        { 2989, 48, 40 }, -- El Altar de Zul
        { 2990, 47, 40 }, -- Thadius Sombramacabra
        { 2991, 47, 40 }, -- Medallón de Nekrum
        { 2992, 47, 40 }, -- El ritual de adivinación
        { 2993, 47, 40 }, -- Vuelve a las Tierras del Interior
        { 2770, 50, 40 }, -- Gahz'rilla
    },
})

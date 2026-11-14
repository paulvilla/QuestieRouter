-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Gnomeregan · niveles 25-30 · 10 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Horde_Dungeon_Gnomeregan",
    faction = "Horde",
    zone = "Gnomeregan",
    dungeon = "Gnomeregan",
    instanceId = 90,
    areaId = 133,
    minLevel = 25,
    maxLevel = 30,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 2904, 30, 24 }, -- Un buen lío
        { 2951, 30, 25 }, -- ¡El Destellamatic 5200!
        { 2952, 30, 25 }, -- ¡El Destellamatic 5200!
        { 2953, 30, 25 }, -- El Destellamatic en acción
        { 2945, 34, 28 }, -- Un anillo sucio
        { 2949, 34, 28 }, -- La devolución del anillo
        { 2841, 35, 25 }, -- Las guerras de la plataforma
        { 2950, 35, 28 }, -- Nogg mejora el anillo
        { 2842, 35, 20 }, -- Scooty, ingeniero jefe
        { 2843, 35, 20 }, -- ¡Gnomer-yaaaaa!
    },
})

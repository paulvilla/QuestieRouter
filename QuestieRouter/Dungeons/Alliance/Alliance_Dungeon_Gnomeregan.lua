-- Generado por tools/dungeon_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Gnomeregan · niveles 25-30 · 18 misiones
local _, QR = ...
QR:RegisterDungeonGuide({
    key = "Alliance_Dungeon_Gnomeregan",
    faction = "Alliance",
    zone = "Gnomeregan",
    dungeon = "Gnomeregan",
    instanceId = 90,
    areaId = 133,
    minLevel = 25,
    maxLevel = 30,
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 2922, 26, 20 }, -- ¡Salva el cerebro de Techrobot!
        { 2923, 26, 20 }, -- Maestro manitas Sobrechispa
        { 2926, 27, 20 }, -- Gnogaine
        { 2927, 27, 20 }, -- Al día siguiente
        { 2931, 28, 25 }, -- Trabajar para Funditubo
        { 2904, 30, 24 }, -- Un buen lío
        { 2924, 30, 24 }, -- Esencias artificiales
        { 2930, 30, 25 }, -- Rescatar los datos
        { 2925, 30, 24 }, -- Klockmort Palmalicate
        { 2928, 30, 20 }, -- Gyrodrillmatic Excavationators
        { 2951, 30, 25 }, -- ¡El Destellamatic 5200!
        { 2952, 30, 25 }, -- ¡El Destellamatic 5200!
        { 2953, 30, 25 }, -- El Destellamatic en acción
        { 2962, 30, 20 }, -- Necesitamos más material verdoso
        { 2945, 34, 28 }, -- Un anillo sucio
        { 2947, 34, 28 }, -- La devolución del anillo
        { 2929, 35, 25 }, -- La gran traición
        { 2948, 35, 28 }, -- Mejora gnómica
    },
})

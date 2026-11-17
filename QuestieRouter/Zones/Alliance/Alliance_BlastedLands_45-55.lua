-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Blasted Lands · niveles 45-55 · 26 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_BlastedLands",
    faction = "Alliance",
    zone = "Blasted Lands",
    areaId = 4,
    minLevel = 45,
    maxLevel = 55,
    entry = { quest = 2585, areaId = 4, x = 50.55, y = 14.2 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 2585, 50, 45 }, -- El golpe decisivo
        { 2991, 47, 40 }, -- Medallón de Nekrum
        { 2992, 47, 40 }, -- El ritual de adivinación
        { 2993, 47, 40 }, -- Vuelve a las Tierras del Interior
        { 2601, 50, 45 }, -- El bocado de basilisco
        { 2602, 50, 45 }, -- La mente infalible
        { 2603, 50, 45 }, -- El vigor del buitre
        { 2604, 50, 45 }, -- Dominación espiritual
        { 2581, 50, 45 }, -- Papadas de hiena risita
        { 2582, 50, 45 }, -- La cólera de las edades
        { 2583, 50, 45 }, -- La vitalidad del jabalí
        { 2584, 50, 45 }, -- El espíritu del jabalí
        { 2586, 50, 45 }, -- La sal del Scorpok
        { 87295, 52, 1 }, -- Deflective Surface
        { 81917, 54, 45 }, -- Chains That Bind
        { 81919, 54, 45 }, -- Brought to Heel
        { 96811, 54, 45 }, -- Escaping the Shadows
        { 4128, 55, 50 }, -- Ragnar Cebatruenos
        { 91882, 55, 1 }, -- The Grand Alliance
        { 2521, 55, 45 }, -- Al servicio de Kum'isha
        { 2522, 55, 45 }, -- Los esfuerzos de Kum'isha
        { 3501, 55, 45 }, -- Todo cuenta en grandes cantidades
        { 3502, 55, 45 }, -- Un trasto de Draenei…
        { 93685, 55, 1 }, -- Al servicio de Kum'isha
        { 2783, 57, 50 }, -- Peleas mezquinas
        { 2743, 60, 45 }, -- La cubierta de la Oscuridad
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

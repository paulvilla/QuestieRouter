-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Moonglade · niveles 55-60 · 9 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_Moonglade",
    faction = "Horde",
    zone = "Moonglade",
    areaId = 493,
    minLevel = 55,
    maxLevel = 60,
    entry = { quest = 1124, areaId = 493, x = 51.69, y = 45.1 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 1124, 55, 54 }, -- Páramo
        { 1123, 55, 54 }, -- Rabine Saturna
        { 6845, 57, 54 }, -- El descubrimiento de los secretos del pasado
        { 1185, 57, 54 }, -- Debajo de la quitina había…
        { 8735, 60, 60 }, -- Corrupción de Pesadilla
        { 8736, 60, 60 }, -- La Pesadilla se manifiesta
        { 8741, 60, 60 }, -- El regreso del Campeón
        { 5527, 60, 56 }, -- Un relicario de pureza
        { 5526, 60, 56 }, -- Fragmentos de gangrevid
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

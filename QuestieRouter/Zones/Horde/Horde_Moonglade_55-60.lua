-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Moonglade · niveles 55-60 · 23 misiones
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
        { 95568, 56, 1 }, -- Seeds for a New Season
        { 93747, 56, 1 }, -- Violence Into Verdure
        { 95569, 56, 1 }, -- Hope for Hatchlings
        { 93759, 56, 1 }, -- The Bounty of Nature
        { 95611, 56, 1 }, -- Rites of Respect
        { 90487, 56, 1 }, -- Ancient Allies
        { 96796, 56, 1 }, -- Woods Workshop
        { 90647, 57, 1 }, -- The Staff of the Mountain
        { 6845, 57, 54 }, -- El descubrimiento de los secretos del pasado
        { 1185, 57, 54 }, -- Debajo de la quitina había…
        { 92612, 58, 1 }, -- Aid from Moonglade
        { 96209, 58, 1 }, -- The Ancient, Orokai
        { 95006, 58, 1 }, -- Stolen Power
        { 93773, 58, 1 }, -- The Pact
        { 92171, 58, 1 }, -- Taking to New Heights
        { 96930, 58, 1 }, -- The Capricious Corvid
        { 5527, 60, 56 }, -- Un relicario de pureza
        { 5526, 60, 56 }, -- Fragmentos de gangrevid
        { 8735, 60, 60 }, -- Corrupción de Pesadilla
        { 8736, 60, 60 }, -- La Pesadilla se manifiesta
        { 8741, 60, 60 }, -- El regreso del Campeón
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

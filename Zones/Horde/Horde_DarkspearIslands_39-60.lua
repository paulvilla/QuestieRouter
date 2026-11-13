-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Darkspear Islands · niveles 39-60 · 10 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_DarkspearIslands",
    faction = "Horde",
    zone = "Darkspear Islands",
    areaId = 16606,
    minLevel = 39,
    maxLevel = 60,
    pvp = true,
    entry = { quest = 98887, areaId = 17, x = 46.71, y = 8.68 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 98887, 39, 30 }, -- Conflict at Darkspear Islands
        { 98888, 39, 30 }, -- Conflict at Darkspear Islands
        { 98906, 39, 30 }, -- The Battle for Darkspear Islands!
        { 98910, 39, 30 }, -- Darkspear's Basic Care Package
        { 98913, 39, 30 }, -- Theramore Basic Care Package
        { 98889, 49, 40 }, -- Conflict at Darkspear Islands
        { 98907, 49, 40 }, -- The Battle for Darkspear Islands!
        { 98891, 59, 50 }, -- Conflict at Darkspear Islands
        { 98893, 60, 60 }, -- Conflict at Darkspear Islands
        { 98908, 60, 50 }, -- The Battle for Darkspear Islands!
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

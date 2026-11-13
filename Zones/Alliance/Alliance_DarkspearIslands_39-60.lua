-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Darkspear Islands · niveles 39-60 · 10 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_DarkspearIslands",
    faction = "Alliance",
    zone = "Darkspear Islands",
    areaId = 16606,
    minLevel = 39,
    maxLevel = 60,
    pvp = true,
    entry = { quest = 98895, areaId = 36, x = 39.29, y = 82.33 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 98895, 39, 30 }, -- Darkspear Islands Clash
        { 98896, 39, 30 }, -- Darkspear Islands Clash
        { 98903, 39, 30 }, -- The Battle for Darkspear Islands!
        { 98910, 39, 30 }, -- Darkspear's Basic Care Package
        { 98913, 39, 30 }, -- Theramore Basic Care Package
        { 98897, 49, 40 }, -- Darkspear Islands Clash
        { 98904, 49, 40 }, -- The Battle for Darkspear Islands!
        { 98899, 59, 50 }, -- Darkspear Islands Clash
        { 98901, 60, 60 }, -- Darkspear Islands Clash
        { 98905, 60, 50 }, -- The Battle for Darkspear Islands!
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

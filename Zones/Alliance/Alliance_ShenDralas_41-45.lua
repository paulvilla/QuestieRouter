-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Shen'dralas · niveles 41-45 · 14 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_ShenDralas",
    faction = "Alliance",
    zone = "Shen'dralas",
    areaId = 16651,
    minLevel = 41,
    maxLevel = 45,
    entry = { quest = 96010, areaId = 16651, x = 35.17, y = 46.61 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 92914, 43, 1 }, -- Pilones extraños
        { 96010, 41, 1 }, -- Fragmentos de los pilones
        { 96018, 43, 1 }, -- Activar los pilones
        { 93016, 43, 1 }, -- A Brief History Lesson
        { 93394, 43, 1 }, -- Meeting the Magister
        { 93450, 42, 1 }, -- Phantasmal Problems
        { 93546, 42, 1 }, -- Spectral Iron Ore
        { 96060, 42, 1 }, -- Tempered Expectations
        { 99257, 43, 1 }, -- A Heart of Crystal
        { 99258, 43, 1 }, -- Mana Mania
        { 93341, 43, 1 }, -- Forlorn Gardens
        { 93362, 43, 1 }, -- What They've Done to My Peonies
        { 93594, 43, 1 }, -- Word of the Woods
        { 93601, 45, 1 }, -- Passing the Blame
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 93404, 49, 1 }, -- Rot and Regret
    },
})

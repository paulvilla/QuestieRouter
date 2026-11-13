-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · The Hinterlands · niveles 40-50 · 17 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_TheHinterlands",
    faction = "Alliance",
    zone = "The Hinterlands",
    areaId = 47,
    minLevel = 40,
    maxLevel = 50,
    entry = { quest = 1450, areaId = 47, x = 11.81, y = 46.76 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 1449, 43, 38 }, -- A las Tierras del Interior
        { 1450, 43, 38 }, -- Maestro de grifos Garracha
        { 1451, 43, 38 }, -- Rapsodio Machacacanillas
        { 1452, 43, 38 }, -- El cubata de Kalimdor de Rapsodio
        { 1469, 43, 38 }, -- El relato de Rapsodio
        { 2880, 45, 40 }, -- Los collares de trols
        { 2881, 45, 40 }, -- Los collares de trols
        { 2988, 45, 40 }, -- Las jaulas de Secacorteza
        { 4297, 47, 38 }, -- Comida para el bebé
        { 4298, 48, 37 }, -- El amor parental
        { 2877, 48, 40 }, -- La limpieza de Roca Oculta
        { 2989, 48, 40 }, -- El Altar de Zul
        { 2990, 47, 40 }, -- Thadius Sombramacabra
        { 485, 48, 43 }, -- ¡Encuentra a OOX-09/HL!
        { 836, 48, 43 }, -- ¡Rescata a OOX-09/HL!
        { 2994, 51, 40 }, -- Salvar a Picoafilado
        { 1446, 53, 38 }, -- El profeta Jammal'an
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

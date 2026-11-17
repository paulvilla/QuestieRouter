-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Alterac Mountains · niveles 30-40 · 30 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_AlteracMountains",
    faction = "Alliance",
    zone = "Alterac Mountains",
    areaId = 36,
    minLevel = 30,
    maxLevel = 40,
    entry = { quest = 8395, areaId = 36, x = 39.29, y = 82.33 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 8395, 59, 50 }, -- Reclamo por la Cuenca de Arathi
        { 8397, 59, 50 }, -- Reclamo por la Cuenca de Arathi
        { 8402, 59, 50 }, -- Lucha por Garganta Grito de Guerra
        { 8407, 59, 50 }, -- Lucha por Garganta Grito de Guerra
        { 8375, 60, 51 }, -- ¡Recuerda el Valle de Alterac!
        { 8383, 60, 51 }, -- ¡Recuerda el Valle de Alterac!
        { 8396, 60, 60 }, -- Reclamo por la Cuenca de Arathi
        { 8398, 60, 60 }, -- Reclamo por la Cuenca de Arathi
        { 8403, 60, 60 }, -- Lucha por Garganta Grito de Guerra
        { 8408, 60, 60 }, -- Lucha por Garganta Grito de Guerra
        { 7162, 60, 51 }, -- Terreno de pruebas
        { 7168, 60, 51 }, -- Ascender y darse a conocer
        { 7169, 60, 51 }, -- Honorable con la guardia
        { 7170, 60, 51 }, -- Ganarse una reverencia
        { 7171, 60, 51 }, -- Héroes legendarios
        { 7172, 60, 51 }, -- El ojo del orden
        { 7141, 60, 51 }, -- La batalla de Alterac
        { 8271, 60, 51 }, -- Héroe de Pico Tormenta
        { 7081, 60, 51 }, -- Los cementerios del Valle de Alterac
        { 7102, 60, 51 }, -- Las torres y los búnkeres
        { 7122, 60, 51 }, -- Conquistar una mina
        { 96603, 60, 48 }, -- Unstable Magic
        { 99191, 60, 12 }, -- Un donativo de lana
        { 99192, 60, 26 }, -- Un donativo de seda
        { 99193, 60, 40 }, -- A Donation of Mageweave
        { 99194, 60, 50 }, -- A Donation of Runecloth
        { 99195, 60, 50 }, -- Additional Runecloth
        { 7261, 60, 51 }, -- El imperativo soberano
        { 8371, 60, 51 }, -- Esfuerzos concertados
        { 8385, 60, 51 }, -- Esfuerzos concertados
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

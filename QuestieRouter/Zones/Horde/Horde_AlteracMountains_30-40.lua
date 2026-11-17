-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Alterac Mountains · niveles 30-40 · 12 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_AlteracMountains",
    faction = "Horde",
    zone = "Alterac Mountains",
    areaId = 36,
    minLevel = 30,
    maxLevel = 40,
    entry = { quest = 7082, areaId = 36, x = 65.55, y = 55.13 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 7082, 60, 51 }, -- Los cementerios de Alterac
        { 7101, 60, 51 }, -- Las torres y los búnkeres
        { 7124, 60, 51 }, -- Conquistar una mina
        { 7161, 60, 51 }, -- Terreno de pruebas
        { 7163, 60, 51 }, -- Ascender y darse a conocer
        { 7164, 60, 51 }, -- Honorable con el clan
        { 7165, 60, 51 }, -- Ganarse una reverencia
        { 7166, 60, 51 }, -- Héroes legendarios
        { 7167, 60, 51 }, -- El ojo del orden
        { 7142, 60, 51 }, -- La batalla por Alterac
        { 8272, 60, 51 }, -- Héroe de los Lobo Gélido
        { 7241, 60, 51 }, -- En defensa de Lobo Gélido
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

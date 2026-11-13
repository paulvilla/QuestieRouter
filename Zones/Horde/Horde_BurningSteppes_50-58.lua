-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Burning Steppes · niveles 50-58 · 23 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_BurningSteppes",
    faction = "Horde",
    zone = "Burning Steppes",
    areaId = 46,
    minLevel = 50,
    maxLevel = 58,
    entry = { quest = 4726, areaId = 46, x = 65.24, y = 24 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 4726, 52, 50 }, -- Esencia de cría
        { 4296, 50, 50 }, -- La tablilla de los Siete
        { 3801, 52, 48 }, -- El legado de los Hierro Negro
        { 3802, 52, 48 }, -- El legado de los Hierro Negro
        { 4136, 53, 48 }, -- Ribbly Llavenrosca
        { 3822, 53, 48 }, -- Krom'Grul
        { 4022, 54, 52 }, -- Un sabor a llamarada
        { 4023, 54, 52 }, -- Un sabor a llamarada
        { 4808, 54, 50 }, -- Felnok Acerovera
        { 4123, 55, 50 }, -- El Corazón de la Montaña
        { 4463, 55, 50 }, -- Tratado sobre Reflexión
        { 4481, 55, 50 }, -- Tratado de constitución
        { 4482, 55, 50 }, -- Tratado de tenacidad
        { 4483, 55, 50 }, -- Tratado sobre Resistencia
        { 4484, 55, 50 }, -- Tratado de voracidad
        { 4121, 58, 52 }, -- ¡Estás en un aprieto!
        { 4024, 58, 52 }, -- Un sabor a llamarada
        { 4729, 59, 55 }, -- Las mascotas exóticas de Kibler
        { 4862, 59, 55 }, -- Bestia amaestrada
        { 4866, 60, 55 }, -- La leche de la madre
        { 4734, 60, 57 }, -- Un huevo congelado
        { 4735, 60, 57 }, -- La colecta de huevos
        { 5522, 60, 57 }, -- Leonid Barthalomew
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

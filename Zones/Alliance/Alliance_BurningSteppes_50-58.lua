-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Burning Steppes · niveles 50-58 · 40 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_BurningSteppes",
    faction = "Alliance",
    zone = "Burning Steppes",
    areaId = 46,
    minLevel = 50,
    maxLevel = 58,
    entry = { quest = 3823, areaId = 46, x = 84.56, y = 68.68 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 3823, 52, 48 }, -- El exterminio de los Ardentrañas
        { 4296, 50, 50 }, -- La tablilla de los Siete
        { 4726, 52, 50 }, -- Esencia de cría
        { 3801, 52, 48 }, -- El legado de los Hierro Negro
        { 3802, 52, 48 }, -- El legado de los Hierro Negro
        { 4262, 52, 48 }, -- Gran maestro Pyron
        { 3824, 53, 48 }, -- Gor'tesh, el Señor bruto
        { 3825, 53, 48 }, -- Una cabeza ogro empalada = FIESTA
        { 4136, 53, 48 }, -- Ribbly Llavenrosca
        { 4808, 54, 50 }, -- Felnok Acerovera
        { 4022, 54, 52 }, -- Un sabor a llamarada
        { 4023, 54, 52 }, -- Un sabor a llamarada
        { 4182, 54, 48 }, -- La amenaza de los dragonantes
        { 4183, 54, 48 }, -- Los verdaderos maestros
        { 4224, 54, 48 }, -- Los verdaderos maestros
        { 4241, 54, 48 }, -- El alguacil Windsor
        { 3701, 54, 50 }, -- Las humeantes Ruinas de Thaurissan
        { 4123, 55, 50 }, -- El Corazón de la Montaña
        { 4463, 55, 50 }, -- Tratado sobre Reflexión
        { 4481, 55, 50 }, -- Tratado de constitución
        { 4482, 55, 50 }, -- Tratado de tenacidad
        { 4483, 55, 50 }, -- Tratado sobre Resistencia
        { 4484, 55, 50 }, -- Tratado de voracidad
        { 4283, 56, 50 }, -- ¡CINCUENTA! ¡SÍ!
        { 4286, 56, 50 }, -- Buena mercancía
        { 4263, 56, 48 }, -- ¡Incendius!
        { 4024, 58, 52 }, -- Un sabor a llamarada
        { 4729, 59, 55 }, -- Las mascotas exóticas de Kibler
        { 4862, 59, 55 }, -- Bestia amaestrada
        { 4701, 59, 55 }, -- Acaba con el origen de la amenaza
        { 4764, 60, 57 }, -- El Broche de Equipasino
        { 4765, 60, 57 }, -- Entrega a Crestabuena
        { 5081, 60, 55 }, -- La misión de Maxwell
        { 5102, 60, 55 }, -- Muerte al general Drakkisath
        { 6402, 60, 50 }, -- Tienes un cita en Ventormenta
        { 4734, 60, 57 }, -- Un huevo congelado
        { 4735, 60, 57 }, -- La colecta de huevos
        { 5522, 60, 57 }, -- Leonid Barthalomew
        { 4866, 60, 55 }, -- La leche de la madre
        { 4766, 60, 57 }, -- Mayara Alasol
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

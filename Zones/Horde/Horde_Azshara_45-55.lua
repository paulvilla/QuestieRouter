-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Azshara · niveles 45-55 · 33 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_Azshara",
    faction = "Horde",
    zone = "Azshara",
    areaId = 16,
    minLevel = 45,
    maxLevel = 55,
    entry = { quest = 3505, areaId = 16, x = 22.26, y = 51.48 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 3517, 52, 45 }, -- El robo de conocimientos
        { 3518, 52, 45 }, -- Entrega a Magatha
        { 3541, 52, 45 }, -- Entrega a Jes'rimon
        { 3542, 52, 45 }, -- Entrega a Andron Gant
        { 3561, 52, 45 }, -- Entrega al archimago Xylem
        { 3565, 52, 45 }, -- El pago de Xylem a Jediga
        { 3562, 52, 45 }, -- El pago de Magatha a Jediga
        { 3563, 52, 45 }, -- El pago de Jes'rimon a Jediga
        { 3564, 52, 45 }, -- El pago de Andron a Jediga
        { 3504, 53, 44 }, -- Traición
        { 3505, 53, 44 }, -- Traición
        { 3601, 53, 47 }, -- ¡Kim'jael, claro!
        { 5534, 53, 47 }, -- El equipamiento "perdido" de Kim'jael
        { 3421, 55, 45 }, -- El viaje de vuelta
        { 3503, 55, 45 }, -- Encuentro con el maestro
        { 3506, 56, 44 }, -- Traición
        { 3507, 56, 44 }, -- Traición
        { 6804, 56, 55 }, -- Agua envenenada
        { 6805, 57, 55 }, -- Sirocosos y reptarenas
        { 3141, 57, 45 }, -- Loramus
        { 3382, 57, 48 }, -- Un equipo bajo el fuego enemigo
        { 3508, 58, 45 }, -- Romper el amuleto
        { 3509, 58, 45 }, -- El nombre de la bestia
        { 3510, 58, 45 }, -- El nombre de la bestia
        { 3511, 58, 45 }, -- El nombre de la bestia
        { 3602, 58, 45 }, -- Azsharita
        { 3621, 58, 45 }, -- La formación de Felbane
        { 8575, 60, 60 }, -- El libro de contabilidad mágico de Azuregos
        { 6821, 60, 56 }, -- Ojo de brasadivino
        { 6822, 60, 57 }, -- El Núcleo de Magma
        { 6823, 60, 60 }, -- Agente de Hydraxis
        { 6824, 60, 60 }, -- Las manos de los enemigos
        { 7486, 60, 60 }, -- Una recompensa de héroe
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

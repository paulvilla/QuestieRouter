-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Azshara · niveles 45-55 · 22 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_Azshara",
    faction = "Alliance",
    zone = "Azshara",
    areaId = 16,
    minLevel = 45,
    maxLevel = 55,
    entry = { quest = 3601, areaId = 16, x = 53.45, y = 21.82 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 3601, 53, 47 }, -- ¡Kim'jael, claro!
        { 3449, 52, 45 }, -- Runas arcanas
        { 3461, 52, 45 }, -- Vuelve con Tymor
        { 5534, 53, 47 }, -- El equipamiento "perdido" de Kim'jael
        { 3421, 55, 45 }, -- El viaje de vuelta
        { 3503, 55, 45 }, -- Encuentro con el maestro
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

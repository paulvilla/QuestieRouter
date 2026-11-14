-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Azshara · niveles 45-55 · 43 misiones
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
        { 88857, 47, 45 }, -- Saving a Sentinel
        { 5535, 47, 45 }, -- Agitación espiritual
        { 5536, 47, 45 }, -- Una tierra llena de odio
        { 98096, 47, 1 }, -- Sisters In Duty
        { 88807, 48, 45 }, -- Slay the Spitelash
        { 89001, 48, 45 }, -- Home on the Range
        { 89013, 48, 45 }, -- Gettin' Buzzed
        { 89228, 48, 45 }, -- Winter Frontier Fishery
        { 88821, 51, 47 }, -- Making Contact
        { 88809, 52, 45 }, -- Preserving Eldarath
        { 3449, 52, 45 }, -- Runas arcanas
        { 3461, 52, 45 }, -- Vuelve con Tymor
        { 86746, 53, 1 }, -- The Legashi Threat
        { 5534, 53, 47 }, -- El equipamiento "perdido" de Kim'jael
        { 90813, 53, 50 }, -- Pay Dirt!
        { 89470, 55, 47 }, -- Ill Tidings
        { 3503, 55, 45 }, -- Encuentro con el maestro
        { 3421, 55, 45 }, -- El viaje de vuelta
        { 88812, 55, 47 }, -- Reclaiming Ravencrest
        { 88813, 55, 47 }, -- The Head of the Serpent
        { 92345, 55, 45 }, -- Beneath Nordrassil
        { 91877, 55, 1 }, -- Demon Hunter's Hunter
        { 6804, 56, 55 }, -- Agua envenenada
        { 89015, 56, 50 }, -- Deadliest Catch
        { 3382, 57, 48 }, -- Un equipo bajo el fuego enemigo
        { 3141, 57, 45 }, -- Loramus
        { 6805, 57, 55 }, -- Sirocosos y reptarenas
        { 3508, 58, 45 }, -- Romper el amuleto
        { 3509, 58, 45 }, -- El nombre de la bestia
        { 3510, 58, 45 }, -- El nombre de la bestia
        { 3511, 58, 45 }, -- El nombre de la bestia
        { 3602, 58, 45 }, -- Azsharita
        { 3621, 58, 45 }, -- La formación de Felbane
        { 92069, 58, 1 }, -- Claws That Rend, Tusks that Gore
        { 97327, 60, 1 }, -- Blackmaw Pouches
        { 94316, 60, 1 }, -- Craftsman's Writ: Potion of Demonslaying
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

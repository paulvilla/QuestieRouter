-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Azshara · niveles 45-55 · 54 misiones
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
        { 5535, 47, 45 }, -- Agitación espiritual
        { 5536, 47, 45 }, -- Una tierra llena de odio
        { 91488, 48, 45 }, -- Home on the Range
        { 91608, 48, 45 }, -- Gettin' Buzzed
        { 91610, 48, 45 }, -- Winter Frontier Fishery
        { 91568, 51, 45 }, -- Long Walks on the Beach
        { 3517, 52, 45 }, -- El robo de conocimientos
        { 3518, 52, 45 }, -- Entrega a Magatha
        { 3541, 52, 45 }, -- Entrega a Jes'rimon
        { 3542, 52, 45 }, -- Entrega a Andron Gant
        { 3561, 52, 45 }, -- Entrega al archimago Xylem
        { 3565, 52, 45 }, -- El pago de Xylem a Jediga
        { 3562, 52, 45 }, -- El pago de Magatha a Jediga
        { 91737, 52, 44 }, -- Remote Contact
        { 3563, 52, 45 }, -- El pago de Jes'rimon a Jediga
        { 91735, 52, 44 }, -- Contacto remoto
        { 3564, 52, 45 }, -- El pago de Andron a Jediga
        { 91734, 52, 44 }, -- Remote Contact
        { 3504, 53, 44 }, -- Traición
        { 3505, 53, 44 }, -- Traición
        { 91569, 53, 45 }, -- Blue Gold
        { 86746, 53, 1 }, -- The Legashi Threat
        { 3601, 53, 47 }, -- ¡Kim'jael, claro!
        { 5534, 53, 47 }, -- El equipamiento "perdido" de Kim'jael
        { 91607, 53, 50 }, -- Pay Dirt!
        { 91685, 54, 45 }, -- Ley of the Land
        { 91547, 55, 44 }, -- Sin'dorei Tome of Summoning
        { 92346, 55, 45 }, -- Beneath Nordrassil
        { 91531, 55, 44 }, -- Revenge Exacted
        { 3503, 55, 45 }, -- Encuentro con el maestro
        { 3421, 55, 45 }, -- El viaje de vuelta
        { 91877, 55, 1 }, -- Demon Hunter's Hunter
        { 6804, 56, 55 }, -- Agua envenenada
        { 3506, 56, 44 }, -- Traición
        { 3507, 56, 44 }, -- Traición
        { 91611, 56, 50 }, -- Deadliest Catch
        { 3141, 57, 45 }, -- Loramus
        { 6805, 57, 55 }, -- Sirocosos y reptarenas
        { 3382, 57, 48 }, -- Un equipo bajo el fuego enemigo
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

-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Wetlands · niveles 20-30 · 78 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_Wetlands",
    faction = "Alliance",
    zone = "Wetlands",
    areaId = 11,
    minLevel = 20,
    maxLevel = 30,
    entry = { quest = 484, areaId = 11, x = 8.55, y = 55.74 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 484, 22, 18 }, -- Piel de crocolisco joven
        { 274, 18, 16 }, -- Se aproxima una oscura amenaza
        { 942, 20, 15 }, -- El prospector despistado
        { 276, 21, 20 }, -- Patas sucias
        { 469, 21, 18 }, -- Entrega cotidiana
        { 463, 21, 20 }, -- El Guardaverde
        { 98282, 22, 20 }, -- Alchemical Hazards
        { 98197, 22, 18 }, -- Spoils of War
        { 279, 22, 20 }, -- Zarpas de las profundidades
        { 277, 23, 20 }, -- No al fuego
        { 294, 24, 22 }, -- La venganza de Ormer
        { 305, 24, 21 }, -- La búsqueda del equipo de excavación
        { 470, 24, 19 }, -- Abriéndose paso entre los mocos
        { 943, 24, 15 }, -- El prospector despistado
        { 306, 24, 21 }, -- La búsqueda del equipo de excavación
        { 472, 25, 25 }, -- La caída de Dun Modr
        { 98190, 25, 20 }, -- A Friend of the Family
        { 281, 25, 20 }, -- Recuperación de bienes
        { 98189, 25, 20 }, -- Return the Statuette
        { 284, 25, 20 }, -- La búsqueda continúa
        { 285, 25, 20 }, -- Inspecciona más casuchas
        { 286, 25, 20 }, -- Devuelve la Estatuilla
        { 471, 26, 18 }, -- Deberes de aprendiz
        { 275, 26, 20 }, -- Ampollas en la tierra
        { 295, 27, 22 }, -- La venganza de Ormer
        { 299, 27, 22 }, -- Desvelando el pasado
        { 288, 27, 22 }, -- La Tercera Flota
        { 98072, 27, 1 }, -- Crocs of the Sky
        { 98815, 28, 24 }, -- Highland Hides
        { 473, 28, 23 }, -- Preséntate ante el capitán Puñorrecio
        { 464, 28, 23 }, -- Estandartes de batalla
        { 98221, 28, 23 }, -- From the Ashes
        { 98230, 29, 22 }, -- This Land Was Their Land
        { 98240, 29, 19 }, -- Crimson Crate Delivery
        { 289, 29, 22 }, -- La tripulación maldita
        { 296, 29, 22 }, -- La venganza de Ormer
        { 98245, 29, 21 }, -- Razormaw Needling
        { 98246, 29, 21 }, -- Trying Times
        { 270, 29, 20 }, -- La flota maldita
        { 321, 29, 20 }, -- Hierro Forjaluz
        { 526, 29, 20 }, -- Lingotes Forjaluz
        { 324, 29, 20 }, -- Los lingotes perdidos
        { 322, 29, 20 }, -- Brazo bendito
        { 290, 30, 22 }, -- Purga de la maldición
        { 1132, 30, 30 }, -- Fiora Orejona
        { 292, 30, 22 }, -- El ojo de Paleth
        { 303, 30, 25 }, -- La guerra contra los Hierro Negro
        { 378, 27, 22 }, -- La furia mora en las profundidades
        { 98283, 30, 22 }, -- Carnage
        { 98293, 30, 22 }, -- Forced Disarmament
        { 98291, 30, 22 }, -- Death to the Dragonmaw
        { 293, 30, 22 }, -- Limpieza del ojo
        { 95647, 31, 24 }, -- Lost in the Thicket Things
        { 465, 31, 23 }, -- La estrategia de Nek'rosh
        { 98216, 31, 23 }, -- Understanding Our Present
        { 98824, 31, 24 }, -- Prehistoric Prism
        { 98223, 31, 23 }, -- Old Habits
        { 95646, 31, 24 }, -- Horrors in the Highland
        { 631, 31, 28 }, -- El puente Thandol
        { 632, 31, 28 }, -- El puente Thandol
        { 633, 31, 28 }, -- El puente Thandol
        { 634, 31, 28 }, -- Petición a la Alianza
        { 88756, 32, 27 }, -- Bring Back a Bang
        { 474, 32, 23 }, -- Derrota a Nek'rosh
        { 98310, 32, 24 }, -- Gleaning Our Future
        { 98313, 32, 24 }, -- For Further Study
        { 87318, 33, 28 }, -- Hearts of the Lost
        { 88757, 33, 28 }, -- Accessories of the Lost
        { 88758, 33, 28 }, -- Sentiments of the Lost
        { 1248, 33, 28 }, -- El diplomático desaparecido
        { 1249, 33, 28 }, -- El diplomático desaparecido
        { 1250, 33, 28 }, -- El diplomático desaparecido
        { 1264, 33, 28 }, -- El diplomático desaparecido
        { 98297, 34, 24 }, -- Stopping the Cycle
        { 98300, 34, 24 }, -- Word to Ironforge
        { 304, 34, 26 }, -- Una misión hedionda
        { 1302, 35, 30 }, -- James Hyal
        { 1301, 35, 30 }, -- James Hyal
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

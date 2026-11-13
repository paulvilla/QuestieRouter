-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Tirisfal Glades · niveles 1-10 · 68 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_TirisfalGlades",
    faction = "Horde",
    zone = "Tirisfal Glades",
    areaId = 85,
    minLevel = 1,
    maxLevel = 10,
    entry = { quest = 96895, areaId = 85, x = 61.5, y = 53.5 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 96895, 12, 10 }, -- El emisario Argenta
        { 363, 1, 1 }, -- Desvelo brutal
        { 364, 2, 1 }, -- Los autómatas
        { 376, 2, 2 }, -- Los Malditos
        { 3901, 3, 1 }, -- Sacudir esqueletos
        { 3902, 3, 2 }, -- Hurgar en Camposanto
        { 380, 4, 2 }, -- Hoya Nocturácnidas
        { 381, 4, 2 }, -- La Cruzada Escarlata
        { 98389, 4, 2 }, -- Una luz en la oscuridad
        { 6395, 5, 3 }, -- El último deseo de Marla
        { 382, 5, 2 }, -- El mensajero rojo
        { 383, 5, 2 }, -- Información decisiva
        { 8, 5, 1 }, -- Un trato de pícaro
        { 590, 5, 1 }, -- Un trato de pícaro
        { 5481, 5, 5 }, -- La tarea de Gordo
        { 404, 6, 4 }, -- Una tarea pútrida
        { 367, 6, 6 }, -- Una nueva Peste
        { 99134, 6, 4 }, -- Disciplina
        { 99141, 6, 4 }, -- Paciencia
        { 5482, 6, 5 }, -- Apocalíseas
        { 86784, 7, 4 }, -- Palos y huesos
        { 365, 7, 4 }, -- Campos de pena
        { 99144, 7, 5 }, -- En busca de refugio
        { 407, 7, 4 }, -- Campos de pena
        { 361, 7, 4 }, -- Una carta sin entregar
        { 427, 8, 5 }, -- En guerra con la Cruzada Escarlata
        { 374, 7, 5 }, -- Prueba de la muerte
        { 375, 8, 7 }, -- El frío de la muerte
        { 358, 8, 4 }, -- Profanadores
        { 405, 8, 5 }, -- El exánime pródigo
        { 426, 8, 6 }, -- La invasión de los molinos
        { 357, 8, 5 }, -- La identidad del exánime
        { 366, 8, 5 }, -- Devuelve el libro
        { 359, 9, 6 }, -- Las obligaciones de los Renegados
        { 370, 9, 5 }, -- En guerra con la Cruzada Escarlata
        { 368, 9, 6 }, -- Una nueva Peste
        { 360, 9, 6 }, -- Regresa junto al magistrado
        { 362, 10, 7 }, -- Los molinos fantasma
        { 371, 10, 5 }, -- En guerra con la Cruzada Escarlata
        { 398, 10, 6 }, -- Se busca: Ojo de gusano
        { 95314, 10, 7 }, -- El elixir verde de Sombravalle
        { 445, 10, 9 }, -- Entrega a Bosque de Argénteos
        { 410, 10, 5 }, -- Sombra durmiente
        { 431, 10, 5 }, -- Velas de señalización
        { 6322, 10, 10 }, -- Michael Garrett
        { 354, 11, 7 }, -- Muertes en la familia
        { 355, 10, 7 }, -- Habla con Sevren
        { 369, 11, 6 }, -- Una nueva Peste
        { 492, 11, 6 }, -- Una nueva Peste
        { 99142, 11, 5 }, -- Tumbalíseas
        { 97558, 11, 6 }, -- Pieles para los Renegados
        { 356, 11, 6 }, -- Patrulla de la retaguardia
        { 96897, 12, 10 }, -- El Culto de los Malditos
        { 96898, 12, 10 }, -- Remanentes de guerra
        { 96899, 12, 10 }, -- Fortaleza de Bandarion
        { 372, 12, 5 }, -- En guerra con la Cruzada Escarlata
        { 409, 12, 5 }, -- Prueba de lealtad
        { 411, 12, 5 }, -- El regreso del exánime pródigo
        { 96896, 12, 10 }, -- Una causa justa
        { 98545, 12, 10 }, -- La carta de Leonid
        { 99152, 12, 7 }, -- Arriba y abajo
        { 99153, 12, 7 }, -- No lo dejes escapar
        { 408, 13, 7 }, -- La Cripta de la Familia
        { 99156, 13, 6 }, -- Patrulla de la retaguardia
        { 95328, 13, 7 }, -- Residuo de horror susurrante
        { 441, 16, 10 }, -- Raleigh y Entrañas
        { 5725, 16, 9 }, -- Poder destructivo
        { 97891, 16, 9 }, -- Veloz corredor de pociones
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 530, 20, 10 }, -- La venganza de un esposo
        { 78124, 20, 1 }, -- Nar'thalas Almanac
        { 78127, 20, 1 }, -- The Dalaran Digest
        { 78142, 20, 1 }, -- Encantamientos y embelesamientos
        { 78143, 20, 1 }, -- Secrets of the Dreamers
        { 78145, 20, 1 }, -- Arcanic Systems Manual
        { 78146, 20, 1 }, -- Goaz Scrolls
        { 78147, 20, 1 }, -- Crimes Against Anatomy
        { 78149, 20, 1 }, -- Fury of the Land
        { 78150, 20, 1 }, -- Friend of the Library
        { 79091, 20, 1 }, -- Archimago Antonidas: Autobiografía completa
        { 79093, 20, 1 }, -- Rumi de Gnomeregan: Obras completas
        { 79094, 20, 1 }, -- The Lessons of Ta'zo
        { 79096, 20, 1 }, -- Ataeric: sobre curiosidades Arcanas
        { 79097, 20, 1 }, -- Baxtan: Sobre la magia destructiva
        { 97289, 21, 15 }, -- Unending Torment
        { 97290, 21, 15 }, -- Unending Torment
        { 97291, 21, 15 }, -- Unending Torment
        { 97292, 21, 15 }, -- Unending Torment
        { 92421, 22, 15 }, -- Justicia de la Luz
        { 92422, 22, 15 }, -- La cólera de Rath'mael
        { 95216, 22, 15 }, -- The New Plague
        { 1013, 26, 16 }, -- El Libro de Ur
        { 6628, 30, 25 }, -- Prueba de conocimiento
        { 1109, 33, 30 }, -- Guano del Horado
        { 1113, 33, 30 }, -- Corazones de fervor
        { 96988, 33, 24 }, -- Source of Power
        { 97985, 33, 25 }, -- Thundering Hearts
        { 79949, 35, 1 }, -- A Web of Lies: Debunking Myths and Legends
        { 79950, 35, 1 }, -- Demons and You
        { 79951, 35, 1 }, -- Mummies: A Guide to the Unsavory Undead
        { 79952, 35, 1 }, -- RwlRwlRwlRwl!
        { 79953, 35, 1 }, -- A Ludite's Guide to Caring for Your Demonic Pet
        { 1160, 36, 25 }, -- Prueba de conocimiento
        { 1164, 36, 27 }, -- Robar a un ladrón…
        { 6521, 36, 28 }, -- Una alianza nefasta
        { 3341, 42, 37 }, -- Acaba con la amenaza
        { 2342, 43, 33 }, -- Los tesoros reclamados
        { 736, 44, 30 }, -- La Estrella, la Mano y el Corazón
        { 232, 45, 38 }, -- Una recado para la boticaria Zinge
        { 238, 45, 38 }, -- Una recado para la boticaria Zinge
        { 81947, 45, 1 }, -- Sanguine Sorcery
        { 81949, 45, 1 }, -- Legends of the Tidesages
        { 81951, 45, 1 }, -- The Liminal and the Arcane
        { 81952, 45, 1 }, -- Everyday Etiquette
        { 81953, 45, 1 }, -- Stonewrought Design
        { 81954, 45, 1 }, -- Venomous Journeys
        { 8273, 47, 42 }, -- La gratitud Oran
        { 5093, 50, 50 }, -- Un llamamiento a las armas: las Tierras de la Peste
        { 5094, 50, 50 }, -- Un llamamiento a las armas: las Tierras de la Peste
        { 5095, 50, 50 }, -- Un llamamiento a las armas: las Tierras de la Peste
        { 3568, 52, 45 }, -- La filtración de la Corrupción
        { 3569, 52, 45 }, -- La filtración de la corrupción
        { 3570, 52, 45 }, -- La filtración de la Corrupción
        { 4293, 52, 48 }, -- Muestras de babosa...
        { 4561, 52, 48 }, -- Pruebas de impureza: Cráter de Un'Goro
        { 4661, 52, 48 }, -- Pruebas de Corrupción: Frondavil
        { 5049, 52, 50 }, -- La depre de Jeremiah
        { 5096, 53, 50 }, -- Distracción Escarlata
        { 5228, 53, 50 }, -- Los calderos de la Plaga
        { 5229, 53, 50 }, -- Objetivo: Campo de Piedra Mácula
        { 838, 55, 55 }, -- Scholomance
        { 4642, 55, 48 }, -- Fusión de influencias
        { 5231, 55, 50 }, -- Objetivo: Lamento de Dalson
        { 5233, 55, 50 }, -- Objetivo: El Tormento
        { 5405, 55, 50 }, -- Comisión de El Alba Argenta
        { 5406, 55, 50 }, -- Piedras de la Plaga del corruptor
        { 5407, 55, 50 }, -- Piedras de la Plaga del invasor
        { 5408, 55, 50 }, -- Piedras de la Plaga del esbirro
        { 5901, 55, 48 }, -- Una Peste en la Cruzada
        { 5902, 55, 48 }, -- Una Peste en la Cruzada
        { 4294, 56, 48 }, -- ... y unos mocos
        { 5098, 56, 50 }, -- Todas las atalayas
        { 964, 57, 55 }, -- Fragmentos esqueléticos
        { 5514, 57, 55 }, -- Molde rima con... ¿oro?
        { 5235, 58, 50 }, -- Objetivo: Gangrena de Gahrron
        { 5238, 58, 50 }, -- ¡Misión cumplida!
        { 105, 60, 50 }, -- Ah, Andorhal
        { 5341, 60, 52 }, -- La fortuna de la familia Barov
        { 5342, 60, 52 }, -- El último de los Barov
        { 5504, 60, 55 }, -- Mantos del Alba
        { 5511, 60, 55 }, -- La llave de Scholomance
        { 5524, 60, 55 }, -- Manto del Alba cromático
        { 5804, 60, 55 }, -- El escarabeo de Araj
        { 7813, 60, 12 }, -- Un donativo de lana
        { 7814, 60, 26 }, -- Un donativo de seda
        { 7817, 60, 40 }, -- Un donativo de tejido mágico
        { 7818, 60, 50 }, -- Un donativo de paño rúnico
        { 7819, 60, 50 }, -- Un donativo extra de paño rúnico
    },
})

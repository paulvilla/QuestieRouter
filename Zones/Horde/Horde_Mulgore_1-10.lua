-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Mulgore · niveles 1-10 · 53 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_Mulgore",
    faction = "Horde",
    zone = "Mulgore",
    areaId = 215,
    minLevel = 1,
    maxLevel = 10,
    entry = { quest = 747, areaId = 215, x = 44.47, y = 77.5 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 747, 2, 1 }, -- Empieza la caza
        { 752, 2, 1 }, -- Una humilde contribución
        { 750, 3, 1 }, -- La caza sigue
        { 753, 3, 1 }, -- Una humilde contribución
        { 755, 3, 1 }, -- Ritos de la Madre Tierra
        { 780, 4, 1 }, -- Los jabaguerreros
        { 757, 4, 1 }, -- Rito de la fuerza
        { 95805, 4, 1 }, -- La gracia de An'she y Mu'sha
        { 1656, 5, 1 }, -- Una tarea por terminar
        { 3376, 5, 3 }, -- La cabeza de Cornapunta
        { 763, 5, 1 }, -- Ritos de la Madre Tierra
        { 748, 5, 4 }, -- Pozos envenenados
        { 96130, 5, 4 }, -- Chakuyak
        { 761, 6, 4 }, -- La caza de los aguilones
        { 754, 6, 4 }, -- La purificación de Pezuña Invernal
        { 99108, 6, 4 }, -- Combate de práctica
        { 767, 6, 3 }, -- Rito de la Visión
        { 756, 7, 4 }, -- El tótem de Tronacuerno
        { 771, 7, 3 }, -- Rito de la Visión
        { 772, 7, 3 }, -- Rito de la Visión
        { 99411, 7, 5 }, -- ¡Kyle ha desaparecido!
        { 766, 8, 5 }, -- Mazzranache
        { 745, 8, 1 }, -- Compartir la tierra
        { 746, 8, 6 }, -- Una excavación de los enanos
        { 758, 8, 4 }, -- La purificación de Tronacuerno
        { 743, 8, 5 }, -- Las Viento Furioso son un peligro
        { 749, 8, 5 }, -- La caravana devastada
        { 751, 8, 5 }, -- La caravana devastada
        { 98430, 8, 1 }, -- Los caminantes
        { 99079, 9, 4 }, -- Caminante Malah
        { 99081, 9, 4 }, -- Noticias aciagas
        { 99101, 9, 4 }, -- Nuestro viejo enemigo
        { 861, 10, 10 }, -- Los hábitos del cazador
        { 759, 10, 4 }, -- El tótem de Bravacrín
        { 760, 10, 4 }, -- La purificación de Bravacrín
        { 98435, 10, 4 }, -- Informe de Astatrueno
        { 764, 10, 5 }, -- Los Ventura y Cía.
        { 773, 10, 3 }, -- Rito de la Sabiduría
        { 833, 10, 7 }, -- Cementerio sagrado
        { 775, 10, 3 }, -- Viaja a Cima del Trueno
        { 6363, 10, 10 }, -- Tal, maestro de jinetes del viento
        { 97485, 10, 3 }, -- Tradiciones de la cima
        { 76156, 10, 4 }, -- Al acecho con la Madre Tierra
        { 98424, 10, 5 }, -- Las notas de Saltatuercas
        { 76160, 11, 4 }, -- Al acecho con la Madre Tierra
        { 76240, 11, 4 }, -- Al acecho con la Madre Tierra
        { 744, 11, 7 }, -- Preparación para la ceremonia
        { 99080, 11, 4 }, -- Hay que expulsarlos
        { 99082, 11, 4 }, -- El Gran jefe
        { 765, 12, 5 }, -- Supervisor Fizsprocket
        { 98427, 12, 5 }, -- Cese de operaciones
        { 770, 12, 6 }, -- La capa del demonio marcado
        { 95350, 13, 7 }, -- La bienvenida a Azeroth
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 776, 14, 3 }, -- Ritos de la Madre Tierra
        { 264, 15, 12 }, -- Hasta que la muerte nos separe
        { 1490, 16, 12 }, -- Nara Bravacrín
        { 962, 18, 14 }, -- Repitilia
        { 1064, 18, 13 }, -- La ayuda de los Renegados
        { 914, 22, 11 }, -- Líderes del Colmillo
        { 1195, 25, 20 }, -- La llama Sagrada
        { 97538, 26, 20 }, -- Pigmentos para pinturas
        { 96241, 29, 23 }, -- Un veneno extraordinario
        { 96259, 29, 23 }, -- Defender a los muertos
        { 96260, 29, 23 }, -- Más fuerte que el acero
        { 1131, 30, 20 }, -- Metaleador
        { 96261, 30, 23 }, -- La madre de linaje
        { 96294, 30, 23 }, -- Una verdad más oscura
        { 98823, 31, 24 }, -- Eco terráneo
        { 1102, 34, 29 }, -- Un destino vengador
        { 1136, 37, 26 }, -- Faucehielo
        { 1049, 38, 28 }, -- El Compendio de los Caídos
        { 96774, 40, 30 }, -- Un antiguo ídolo Gurubashi
        { 96982, 40, 40 }, -- Your First Riding Kodo
        { 97204, 40, 40 }, -- Learning to Ride
        { 97196, 41, 34 }, -- El ojo del Gélido
        { 1205, 45, 35 }, -- Lodomuerto
        { 96775, 46, 42 }, -- Zum'rah's Head
        { 2440, 47, 40 }, -- Los discos de platino
        { 2965, 50, 45 }, -- Presagios de Uldum
        { 2966, 50, 45 }, -- A ver qué pasa
        { 2968, 50, 45 }, -- Una tarea futura
        { 3761, 50, 47 }, -- Tierra de Un'Goro
        { 3762, 50, 47 }, -- Ayuda al archidruida Tótem de Runa
        { 3782, 50, 47 }, -- Investigar la mañagrana
        { 3784, 50, 47 }, -- Ayuda al archidruida Runatótem
        { 3786, 50, 47 }, -- Investigar la mañagrana
        { 97378, 50, 1 }, -- Mirrorscale
        { 96776, 51, 43 }, -- An'she's Radiance
        { 1000, 55, 54 }, -- La nueva frontera
        { 1004, 55, 54 }, -- La nueva frontera
        { 1018, 55, 54 }, -- La nueva frontera
        { 3804, 55, 47 }, -- Mañagrana para Cima del Trueno
        { 92343, 55, 45 }, -- Get to the Roots of It
        { 97197, 55, 46 }, -- Fragment of the Firelands
        { 97198, 59, 52 }, -- Blackmaw Magic
        { 7820, 60, 12 }, -- Un donativo de lana
        { 7821, 60, 26 }, -- Un donativo de seda
        { 7822, 60, 40 }, -- Un donativo de tejido mágico
        { 7823, 60, 50 }, -- Un donativo de paño rúnico
        { 7825, 60, 50 }, -- Un donativo extra de paño rúnico
        { 95928, 60, 55 }, -- Crystalline Elements
        { 98477, 60, 48 }, -- Unstable Magic
        { 99196, 60, 12 }, -- Un donativo de lana
        { 99197, 60, 26 }, -- Un donativo de seda
        { 99198, 60, 40 }, -- A Donation of Mageweave
    },
})

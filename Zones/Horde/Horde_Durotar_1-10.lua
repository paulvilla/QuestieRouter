-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Durotar · niveles 1-10 · 54 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_Durotar",
    faction = "Horde",
    zone = "Durotar",
    areaId = 14,
    minLevel = 1,
    maxLevel = 10,
    entry = { quest = 4641, areaId = 14, x = 43.29, y = 68.53 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 4641, 1, 1 }, -- Tu lugar en el mundo
        { 788, 2, 1 }, -- Dientes afilados
        { 97279, 2, 1 }, -- Armas extraviadas
        { 789, 3, 1 }, -- Aguijón de escórpido
        { 4402, 3, 1 }, -- Sorpresa de manzanas de cactus de Galgar
        { 792, 4, 2 }, -- Familiares viles  [clase]
        { 5441, 4, 3 }, -- Peones vagos
        { 6394, 4, 3 }, -- Pico de Thazz'ril
        { 794, 5, 1 }, -- El medallón del Filo Ardiente
        { 805, 5, 1 }, -- Preséntate en el poblado Sen'jin
        { 790, 5, 1 }, -- Sarkoth
        { 804, 5, 1 }, -- Sarkoth
        { 2161, 5, 1 }, -- Un cargamento de peón
        { 96821, 6, 1 }, -- Pies, para qué os quiero
        { 96825, 6, 3 }, -- La fruta que devuelve el mordisco
        { 784, 7, 3 }, -- Vencer a los traidores
        { 96822, 7, 3 }, -- Por honor
        { 791, 7, 4 }, -- Asume tu responsabilidad
        { 818, 7, 5 }, -- Un espíritu responsable
        { 823, 7, 4 }, -- Informa a Orgnil
        { 830, 7, 1 }, -- Las órdenes del almirante
        { 831, 7, 1 }, -- Las órdenes del almirante
        { 825, 8, 3 }, -- Los restos del naufragio…
        { 815, 8, 6 }, -- Romper huevos
        { 817, 8, 5 }, -- Presa práctica
        { 786, 8, 5 }, -- Frustrar la los planes kolkar
        { 99123, 8, 4 }, -- Perdida en las sombras
        { 96876, 8, 5 }, -- Bolsa perdida de Ukor
        { 97223, 9, 5 }, -- Matriarca Garrasangre
        { 808, 9, 4 }, -- La calavera de Minshina
        { 97225, 9, 4 }, -- Ídolos loa olvidados
        { 99048, 9, 9 }, -- La Mano desaparecida
        { 99049, 9, 9 }, -- La amenaza de las profundidades
        { 834, 9, 7 }, -- Las arpías Viento Seco
        { 812, 9, 7 }, -- Se necesita un remedio
        { 813, 9, 7 }, -- En busca del antídoto
        { 6385, 10, 10 }, -- Doras, maestro de jinetes del viento
        { 826, 10, 4 }, -- Zalazane
        { 837, 10, 6 }, -- Invasión
        { 99051, 11, 8 }, -- La amenaza de las profundidades
        { 99052, 11, 8 }, -- La amenaza de las profundidades
        { 816, 11, 8 }, -- Perdido, pero no olvidado
        { 835, 11, 7 }, -- Asegurar las rutas
        { 97281, 11, 7 }, -- Una tormenta inminente
        { 97282, 10, 6 }, -- Potencial tormentoso
        { 806, 12, 4 }, -- Oscuras tormentas
        { 828, 12, 4 }, -- Margoz
        { 840, 12, 10 }, -- Nuevo recluta de la Horda
        { 827, 12, 4 }, -- Roca del Cráneo
        { 829, 12, 4 }, -- Neeru Hojafuego
        { 832, 12, 4 }, -- Sombras Ardientes
        { 5726, 12, 9 }, -- Enemigos ocultos
        { 5727, 12, 9 }, -- Enemigos ocultos
        { 96877, 12, 6 }, -- Pezuña de Halikor
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 93739, 13, 7 }, -- Explorar la Horda
        { 5729, 15, 9 }, -- Enemigos ocultos
        { 97242, 15, 9 }, -- El popurrí de Yelmak
        { 97246, 15, 5 }, -- A plato puesto
        { 97249, 15, 5 }, -- Comida favorita
        { 97275, 15, 9 }, -- Elaboración a fuego lento
        { 97326, 15, 5 }, -- Descanso rocoso
        { 5730, 16, 9 }, -- Enemigos ocultos
        { 5761, 16, 9 }, -- Matar a la bestia
        { 3924, 19, 10 }, -- El manual de churumbele
        { 1431, 30, 30 }, -- Las relaciones de la Alianza
        { 95697, 31, 24 }, -- Cambio de paladar
        { 2841, 35, 25 }, -- Las guerras de la plataforma
        { 2950, 35, 28 }, -- Nogg mejora el anillo
        { 7541, 40, 30 }, -- Un servicio para la Horda
        { 96989, 40, 40 }, -- Your First Riding Raptor
        { 96994, 40, 40 }, -- Your First Riding Wolf
        { 97194, 40, 40 }, -- Learning to Ride
        { 97200, 40, 40 }, -- Learning to Ride
        { 2283, 41, 37 }, -- La recuperación del collar
        { 7068, 42, 39 }, -- Fragmentos Oscuros
        { 2936, 45, 40 }, -- Diosa araña
        { 649, 48, 42 }, -- Recupera el calimocho
        { 4300, 52, 48 }, -- Armas con filo de hueso
        { 96376, 53, 48 }, -- State Secrets
        { 4002, 54, 48 }, -- Los Reinos del Este
        { 4511, 54, 50 }, -- La calma que precede a la tormenta
        { 2937, 55, 40 }, -- Invocar a Shadra
        { 4974, 60, 55 }, -- ¡Por la Horda!
        { 6566, 60, 55 }, -- Lo que trae el viento
        { 7341, 60, 52 }, -- Un trato justo
        { 7490, 60, 60 }, -- Victoria para la Horda
        { 7491, 60, 60 }, -- Para que todos lo vean
        { 7783, 60, 60 }, -- Señor de Roca Negra
        { 7784, 60, 60 }, -- Señor de Roca Negra
        { 7824, 60, 50 }, -- Un donativo de paño rúnico
        { 7826, 60, 12 }, -- Un donativo de lana
        { 7827, 60, 26 }, -- Un donativo de seda
        { 7831, 60, 40 }, -- Un donativo de paño mágico
        { 7832, 60, 50 }, -- Un donativo extra de paño rúnico
        { 7833, 60, 12 }, -- Un donativo de lana
        { 7834, 60, 26 }, -- Un donativo de seda
        { 7835, 60, 40 }, -- Un donativo de tejido mágico
        { 7836, 60, 50 }, -- Un donativo de paño rúnico
        { 7837, 60, 50 }, -- Un donativo extra de paño rúnico
        { 8913, 60, 58 }, -- Una propuesta seria
        { 8914, 60, 58 }, -- Una propuesta seria
        { 8915, 60, 58 }, -- Una propuesta seria
        { 8916, 60, 58 }, -- Una propuesta seria
        { 8917, 60, 58 }, -- Una propuesta seria
        { 8918, 60, 58 }, -- Una propuesta seria
        { 8919, 60, 58 }, -- Una propuesta seria
        { 8920, 60, 58 }, -- Una propuesta seria
        { 8927, 60, 58 }, -- Una compensación justa
        { 8938, 60, 58 }, -- Una compensación justa
        { 8939, 60, 58 }, -- Una compensación justa
        { 8940, 60, 58 }, -- Una compensación justa
        { 8941, 60, 58 }, -- Una compensación justa
        { 8942, 60, 58 }, -- Una compensación justa
        { 8943, 60, 58 }, -- Una compensación justa
        { 8944, 60, 58 }, -- Una compensación justa
        { 9007, 60, 58 }, -- Guardar lo mejor para el final
        { 9008, 60, 58 }, -- Guardar lo mejor para el final
        { 9009, 60, 58 }, -- Guardar lo mejor para el final
        { 9010, 60, 58 }, -- Guardar lo mejor para el final
        { 9011, 60, 58 }, -- Guardar lo mejor para el final
        { 9012, 60, 58 }, -- Guardar lo mejor para el final
        { 9013, 60, 58 }, -- Guardar lo mejor para el final
        { 9014, 60, 58 }, -- Guardar lo mejor para el final
        { 84155, 60, 58 }, -- An Earnest Proposition
        { 84156, 60, 58 }, -- An Earnest Proposition
        { 84157, 60, 58 }, -- An Earnest Proposition
        { 84158, 60, 58 }, -- An Earnest Proposition
        { 84159, 60, 58 }, -- An Earnest Proposition
        { 84160, 60, 58 }, -- An Earnest Proposition
        { 84161, 60, 58 }, -- An Earnest Proposition
        { 84162, 60, 58 }, -- An Earnest Proposition
        { 97411, 60, 58 }, -- An Earnest Proposition
    },
})

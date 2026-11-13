-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · The Barrens · niveles 10-25 · 144 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_TheBarrens",
    faction = "Horde",
    zone = "The Barrens",
    areaId = 17,
    minLevel = 10,
    maxLevel = 25,
    entry = { quest = 842, areaId = 17, x = 62.26, y = 19.38 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 842, 12, 10 }, -- Servicio militar en El Cruce
        { 6365, 10, 10 }, -- Entrega de carne a Orgrimmar
        { 6384, 10, 10 }, -- Un viaje a Orgrimmar
        { 6361, 10, 10 }, -- Un fardo de pieles
        { 6362, 10, 10 }, -- Un viaje a Cima del Trueno
        { 860, 10, 10 }, -- Sergra Espinoscura
        { 6364, 10, 10 }, -- Volver junto a Jahan
        { 886, 10, 10 }, -- El oasis de Los Baldíos
        { 6386, 10, 10 }, -- El regreso a El Cruce
        { 1492, 11, 9 }, -- Vertipeluca, el maestro de muelles
        { 871, 12, 9 }, -- Acabar con los ataques de los Crines de Acero
        { 844, 12, 10 }, -- La amenaza de los zancudos de llanura
        { 854, 12, 9 }, -- Viaja a El Cruce
        { 870, 13, 10 }, -- Las Charcas del Olvido
        { 845, 13, 10 }, -- El astacebra
        { 869, 13, 9 }, -- Los raptores ladrones
        { 809, 13, 4 }, -- Ak'Zeloth
        { 98024, 13, 7 }, -- Viaje a El Cruce
        { 855, 14, 9 }, -- Los brazales de centauro
        { 5041, 14, 9 }, -- Suministros para El Cruce
        { 887, 14, 9 }, -- Los filibusteros del Mar del Sur
        { 890, 14, 9 }, -- El envío perdido
        { 894, 14, 10 }, -- El churumbele
        { 892, 14, 9 }, -- El envío perdido
        { 924, 14, 9 }, -- La Semilla del Demonio
        { 926, 14, 1 }, -- La piedra de energía con imperfecciones
        { 900, 14, 10 }, -- El churumbele
        { 901, 14, 10 }, -- El churumbele
        { 848, 15, 10 }, -- Esporas de hongos
        { 853, 15, 10 }, -- Boticaria Zamah
        { 872, 15, 9 }, -- El fin de las hostilidades
        { 867, 15, 12 }, -- Arpías saqueadoras
        { 903, 15, 10 }, -- Merodeadores de los Baldíos
        { 97253, 15, 9 }, -- Volver con piezas de una pieza
        { 819, 15, 11 }, -- El barril vacío de Chen
        { 821, 15, 11 }, -- El barril vacío de Chen
        { 1358, 15, 10 }, -- Muestra para Helbrim
        { 850, 16, 11 }, -- Los jefes de Kolkar
        { 875, 16, 12 }, -- Las tenientes arpías
        { 881, 16, 10 }, -- Echeyakee
        { 877, 16, 10 }, -- El Oasis Estancado
        { 880, 16, 10 }, -- Fuentes de vida
        { 3301, 15, 10 }, -- Mura Runatótem
        { 1489, 16, 12 }, -- Hamuul Runatótem
        { 888, 16, 9 }, -- El botín robado
        { 895, 16, 11 }, -- SE BUSCA: Barón Longavera
        { 902, 16, 10 }, -- El churumbele
        { 3921, 14, 10 }, -- Wenikee Tuercasmil
        { 3922, 15, 10 }, -- Engranajes
        { 905, 17, 10 }, -- La ira de los segadores
        { 1486, 17, 13 }, -- Pellejo de los descarriados
        { 1061, 17, 13 }, -- Los espíritus del Espolón
        { 851, 18, 11 }, -- Verog el Derviche
        { 3281, 18, 9 }, -- La plata robada
        { 3261, 18, 10 }, -- Jorn Visioceleste
        { 865, 18, 13 }, -- Los cuernos de raptor
        { 1491, 18, 13 }, -- Las bebidas astutas
        { 959, 18, 14 }, -- ¡A por la botella!
        { 896, 18, 13 }, -- La fortuna de un minero
        { 6401, 18, 12 }, -- Kaya está viva
        { 6548, 18, 12 }, -- Venga mi aldea
        { 6629, 18, 12 }, -- Mata a Grundig Nube Negra
        { 95508, 18, 14 }, -- Huéspedes no deseados
        { 95621, 18, 14 }, -- Problemas en el valle
        { 95494, 18, 14 }, -- Orgullo herido y pieles de león
        { 95495, 18, 14 }, -- El peletero ermitaño
        { 95507, 18, 14 }, -- Las presas de Vrang
        { 3923, 18, 10 }, -- Rilli Gapegajoso
        { 858, 18, 13 }, -- La llave de contacto
        { 863, 18, 13 }, -- La fuga
        { 6543, 19, 17 }, -- Los informes Grito de Guerra
        { 8368, 19, 10 }, -- La batalla por Garganta Grito de Guerra
        { 8389, 19, 10 }, -- La batalla por Garganta Grito de Guerra
        { 852, 19, 11 }, -- Hezrul Marcasangre
        { 6541, 19, 17 }, -- Preséntate ante Kadrak
        { 1062, 19, 13 }, -- Los invasores goblin
        { 1063, 18, 13 }, -- La vieja bruja
        { 882, 19, 10 }, -- Ishamuhale
        { 907, 18, 10 }, -- La rabia de los truenagartos
        { 913, 20, 10 }, -- El chillido del halcón trueno
        { 6382, 20, 20 }, -- La Caza de Vallefresno
        { 898, 20, 13 }, -- Escapar del fuerte
        { 891, 20, 13 }, -- Las armas del Fuerte del Norte
        { 1069, 20, 15 }, -- Huevos de arañas musgondo
        { 92706, 20, 15 }, -- SE BUSCA: Bruuz
        { 899, 20, 14 }, -- Consumido por el odio
        { 4921, 20, 14 }, -- Perdida en la batalla
        { 95774, 20, 14 }, -- Se llama Olgra
        { 876, 20, 12 }, -- Serena Sangrepluma
        { 1060, 20, 15 }, -- Una carta para Jin'Zil
        { 4021, 20, 11 }, -- ¡Contraataca!
        { 97003, 21, 15 }, -- Chol'aruk el Devorador
        { 1487, 21, 15 }, -- Erradicación de descarriados
        { 1483, 21, 16 }, -- Ziz Fizziks
        { 878, 21, 14 }, -- Tribus en guerra
        { 5052, 21, 14 }, -- Fragmentos ensangrentados de Agamaggan
        { 889, 20, 14 }, -- El espíritu del viento
        { 5042, 20, 14 }, -- La fuerza de Agamaggan
        { 5043, 20, 14 }, -- La agilidad de Agamaggan
        { 5044, 20, 14 }, -- La sabiduría de Agamaggan
        { 5045, 20, 14 }, -- Fortaleza de espíritu
        { 5046, 20, 14 }, -- Cerropiel
        { 79007, 22, 14 }, -- ... and that note you found
        { 868, 22, 17 }, -- ¡A cazar huevos!
        { 883, 22, 10 }, -- Lakota'mani
        { 1068, 23, 13 }, -- Las sierras XT:4 y XT:9
        { 97250, 23, 18 }, -- Culpa incorrecta, corregida
        { 843, 23, 17 }, -- La reclamación de Gann
        { 79192, 24, 14 }, -- Stepping Stones
        { 893, 24, 17 }, -- Una selección de armas
        { 822, 24, 11 }, -- El barril vacío de Chen
        { 884, 24, 10 }, -- Owatanka
        { 897, 24, 10 }, -- El Cosechador
        { 3369, 25, 15 }, -- En las pesadillas
        { 879, 25, 17 }, -- Traidores
        { 906, 25, 17 }, -- Traidores
        { 885, 25, 10 }, -- Washte Pawne
        { 3513, 25, 15 }, -- El pergamino rúnico
        { 846, 26, 17 }, -- La venganza de Gann
        { 849, 26, 17 }, -- La venganza de Gann
        { 1221, 26, 20 }, -- Los tubérculos hojazul
        { 1095, 27, 16 }, -- Más instrucciones
        { 874, 27, 9 }, -- Mahren Visioceleste
        { 873, 27, 10 }, -- Isha Awak
        { 1153, 29, 25 }, -- Una nueva muestra de mineral
        { 8370, 29, 20 }, -- La conquista de la Cuenca de Arathi
        { 8390, 29, 20 }, -- La conquista de la Cuenca de Arathi
        { 8426, 29, 20 }, -- La batalla por Garganta Grito de Guerra
        { 8431, 29, 20 }, -- La batalla por Garganta Grito de Guerra
        { 3514, 29, 15 }, -- La presencia de la Horda
        { 1130, 30, 20 }, -- Melor Pezuñapétrea
        { 857, 30, 22 }, -- La Lágrima de las Lunas
        { 1362, 32, 30 }, -- Los Kolkar de Desolace
        { 1361, 32, 30 }, -- Regthar Portamorta
        { 1145, 33, 29 }, -- El enjambre crece
        { 7866, 34, 25 }, -- Paquete de curación elemental de escolta
        { 1184, 35, 28 }, -- Pedazos del enjambre
        { 6626, 35, 28 }, -- Un anfitrión del mal
        { 1112, 36, 30 }, -- Las piezas de Kravel
        { 1180, 37, 29 }, -- Patrocinio goblin
        { 8427, 39, 30 }, -- La batalla por Garganta Grito de Guerra
        { 8432, 39, 30 }, -- La batalla por Garganta Grito de Guerra
        { 8436, 39, 30 }, -- La conquista de la Cuenca de Arathi
        { 8440, 39, 30 }, -- La conquista de la Cuenca de Arathi
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 7867, 44, 35 }, -- Paquete de curación normal de escolta
        { 8428, 49, 40 }, -- La batalla por Garganta Grito de Guerra
        { 8433, 49, 40 }, -- La batalla por Garganta Grito de Guerra
        { 8437, 49, 40 }, -- La conquista de la Cuenca de Arathi
        { 8441, 49, 40 }, -- La conquista de la Cuenca de Arathi
        { 4146, 52, 47 }, -- Combustible de irradior
        { 5159, 54, 48 }, -- El agua purificada vuelve a Frondavil
        { 4502, 55, 49 }, -- Actividad volcánica
        { 8429, 59, 50 }, -- La batalla por Garganta Grito de Guerra
        { 8434, 59, 50 }, -- La batalla por Garganta Grito de Guerra
        { 8438, 59, 50 }, -- La conquista de la Cuenca de Arathi
        { 8442, 59, 50 }, -- La conquista de la Cuenca de Arathi
        { 7868, 60, 45 }, -- Paquete de curación avanzado de escolta
        { 8367, 60, 51 }, -- Por Gran Honor
        { 8369, 60, 51 }, -- Invasores del Valle de Alterac
        { 8387, 60, 51 }, -- Invasores del Valle de Alterac
        { 8388, 60, 51 }, -- Cuestión de honor
        { 8430, 60, 60 }, -- La batalla por Garganta Grito de Guerra
        { 8435, 60, 60 }, -- La batalla por Garganta Grito de Guerra
        { 8439, 60, 60 }, -- La conquista de la Cuenca de Arathi
        { 8443, 60, 60 }, -- La conquista de la Cuenca de Arathi
        { 9267, 60, 15 }, -- Curar viejas heridas
        { 91899, 60, 1 }, -- Un cajón sellado
        { 91900, 60, 1 }, -- A Sealed Crate
        { 91901, 60, 1 }, -- A Sealed Crate
        { 91904, 60, 1 }, -- A Sealed Crate
        { 91905, 60, 1 }, -- A Sealed Crate
        { 95819, 60, 1 }, -- Sign Me Up!
        { 96339, 60, 1 }, -- Legacy Reward: Replica Ironforge Air Rifle
        { 96383, 60, 1 }, -- Legacy Reward: Spectral Bear Cub
    },
})

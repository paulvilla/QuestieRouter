-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Dun Morogh · niveles 1-10 · 63 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_DunMorogh",
    faction = "Alliance",
    zone = "Dun Morogh",
    areaId = 1,
    minLevel = 1,
    maxLevel = 10,
    entry = { quest = 96408, areaId = 1, x = 50.44, y = 49.09 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 96408, 13, 9 }, -- Un visitante en Dun Morogh
        { 403, 1, 1 }, -- El barril de Cebatruenos custodiado
        { 179, 1, 1 }, -- Los enanos modistos
        { 170, 2, 1 }, -- Una nueva amenaza
        { 97263, 2, 1 }, -- Ha llegado tu paquete
        { 183, 3, 1 }, -- Cazador de jabalíes
        { 3361, 3, 3 }, -- Las penurias de un refugiado
        { 233, 3, 1 }, -- Entrega de correo en el Valle de Crestanevada
        { 182, 4, 1 }, -- La cueva de los trols
        { 234, 4, 1 }, -- Entrega de correo en el Valle de Crestanevada
        { 218, 5, 1 }, -- El diario robado
        { 282, 5, 1 }, -- Las observaciones de Senir
        { 3364, 5, 4 }, -- Entrega una infusión de albaza hirviendo
        { 420, 5, 1 }, -- Las observaciones de Senir
        { 2160, 5, 1 }, -- Suministros para Tannok
        { 3365, 5, 4 }, -- Devuelve la taza
        { 400, 5, 2 }, -- Herramientas para Brasacerada
        { 5541, 6, 5 }, -- Municiones para Estruendo
        { 317, 6, 2 }, -- Los suministros del reactor a vapor
        { 310, 6, 2 }, -- Cerveza rivales
        { 97277, 6, 4 }, -- Grund y Gozwin
        { 98321, 7, 4 }, -- Envío de Fuegosílex
        { 308, 7, 1 }, -- Distraer a Jarven
        { 311, 7, 2 }, -- Vuleve con Marleth
        { 313, 7, 4 }, -- El Cubil Pardo
        { 318, 7, 2 }, -- La tajada
        { 99158, 8, 5 }, -- El alba en las montañas
        { 98322, 8, 4 }, -- Asegurar la montaña
        { 98319, 8, 4 }, -- Asegurar la montaña
        { 98323, 8, 4 }, -- Asegurar la montaña
        { 319, 8, 2 }, -- Un favor a cambio de un barril de tajada
        { 320, 8, 2 }, -- Vuelve con Bramiz
        { 99159, 8, 5 }, -- En busca de calor
        { 99160, 8, 5 }, -- Cólera escarchada
        { 99161, 8, 5 }, -- Cólera escarchada
        { 99162, 8, 5 }, -- Frío traicionero
        { 287, 9, 7 }, -- Poblado Peloescarcha
        { 98326, 9, 5 }, -- Aúllaescarcha
        { 315, 9, 5 }, -- La cerveza perfecta
        { 432, 9, 5 }, -- ¡Malditos troggs!
        { 95212, 10, 7 }, -- La calidad nunca es «sen-silla»
        { 415, 10, 8 }, -- La nueva bebida de Rejold
        { 412, 10, 7 }, -- Operación Recombobulador
        { 6722, 10, 10 }, -- El camino del cazador  [clase]
        { 291, 10, 1 }, -- Los informes
        { 413, 10, 8 }, -- Cerveza negra Brillante
        { 419, 10, 8 }, -- El piloto perdido
        { 414, 10, 8 }, -- Cerveza negra para Kadrell
        { 6388, 10, 10 }, -- Gryth Thurden
        { 95041, 10, 7 }, -- Acaparadores de datos
        { 95213, 10, 7 }, -- Pólvora robada
        { 95214, 10, 7 }, -- Pólvora robada
        { 433, 11, 6 }, -- El servidor público
        { 417, 11, 8 }, -- Vengar al piloto
        { 314, 12, 6 }, -- La protección del rebaño
        { 312, 12, 7 }, -- La reserva robada de Tundra MacGrann
        { 96392, 13, 9 }, -- La vigilancia de Farsen
        { 96390, 13, 9 }, -- Arráncalos de raíz
        { 93963, 13, 7 }, -- Explorar la Alianza
        { 96391, 15, 9 }, -- Mapa subterráneo
        { 96403, 15, 10 }, -- Reliquias importantes
        { 96393, 16, 9 }, -- Incursión en la Antigua Forjaz
        { 98423, 16, 9 }, -- El tratado de entendimiento
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 1073, 21, 17 }, -- Ineptitud + Productos químicos = Diversión
        { 466, 22, 20 }, -- Búsqueda de incendicita
        { 971, 23, 18 }, -- El conocimiento de las profundidades
        { 2922, 26, 20 }, -- ¡Salva el cerebro de Techrobot!
        { 2923, 26, 20 }, -- Maestro manitas Sobrechispa
        { 2926, 27, 20 }, -- Gnogaine
        { 2927, 27, 20 }, -- Al día siguiente
        { 637, 30, 25 }, -- La carta de Sully Balloo
        { 683, 30, 25 }, -- Un favor a Sara Balloo
        { 686, 30, 25 }, -- Un homenaje real
        { 2924, 30, 24 }, -- Esencias artificiales
        { 2925, 30, 24 }, -- Klockmort Palmalicate
        { 2930, 30, 25 }, -- Rescatar los datos
        { 2962, 30, 20 }, -- Necesitamos más material verdoso
        { 689, 31, 25 }, -- Un homenaje real
        { 700, 31, 25 }, -- Un homenaje real
        { 2948, 35, 28 }, -- Mejora gnómica
        { 1050, 38, 28 }, -- Mitología de los Titanes
        { 725, 40, 35 }, -- Avertir de la amenaza
        { 726, 40, 35 }, -- Avertir de la amenaza
        { 97017, 40, 40 }, -- Tu primer carnero de montar
        { 97018, 40, 40 }, -- Lecciones de monta
        { 97046, 40, 40 }, -- Your First Mechanostrider
        { 97188, 40, 40 }, -- Learning to Ride
        { 2199, 41, 37 }, -- Esa información tiene un precio
        { 3375, 42, 37 }, -- Otra ampolla
        { 1360, 43, 33 }, -- Los tesoros reclamados
        { 735, 44, 30 }, -- La Estrella, la Mano y el Corazón
        { 762, 44, 35 }, -- Un embajador de mal
        { 2361, 44, 37 }, -- Restaurar el collar
        { 1139, 45, 35 }, -- Las tablillas perdidas de Voluntad
        { 2439, 47, 40 }, -- Los discos de platino
        { 2946, 50, 45 }, -- A ver qué pasa
        { 2963, 50, 45 }, -- Presagios de Uldum
        { 2964, 50, 45 }, -- Un tarea futura
        { 3448, 52, 45 }, -- Encargarse de la investigación
        { 3450, 52, 45 }, -- Un simple envío
        { 3451, 52, 45 }, -- Una señal para el envío
        { 3483, 52, 45 }, -- Una señal para el envío
        { 4512, 52, 48 }, -- Un largo camino para unas babosas
        { 3702, 54, 50 }, -- Las ruinas humeantes de Thaurissan
        { 4513, 54, 48 }, -- Un largo camino para unas babosas
        { 4126, 55, 50 }, -- Hurley Negrálito
        { 7342, 60, 52 }, -- Las flechas no valen para nada
        { 7802, 60, 12 }, -- Un donativo de lana
        { 7803, 60, 26 }, -- Un donativo de seda
        { 7804, 60, 40 }, -- Un donativo de paño mágico
        { 7805, 60, 50 }, -- Un donativo de paño rúnico
        { 7806, 60, 50 }, -- Un donativo extra de paño rúnico
        { 7807, 60, 12 }, -- Un donativo de lana
        { 7808, 60, 26 }, -- Un donativo de seda
        { 7809, 60, 40 }, -- Un donativo de paño mágico
        { 7811, 60, 50 }, -- Un donativo de paño rúnico
        { 7812, 60, 50 }, -- Un donativo extra de paño rúnico
        { 8905, 60, 58 }, -- Una propuesta seria
        { 8906, 60, 58 }, -- Una propuesta seria
        { 8907, 60, 58 }, -- Una propuesta seria
        { 8908, 60, 58 }, -- Una propuesta seria
        { 8909, 60, 58 }, -- Una propuesta seria
        { 8910, 60, 58 }, -- Una propuesta seria
        { 8911, 60, 58 }, -- Una propuesta seria
        { 8912, 60, 58 }, -- Una propuesta seria
        { 8926, 60, 58 }, -- Una compensación justa
        { 8931, 60, 58 }, -- Una compensación justa
        { 8932, 60, 58 }, -- Una compensación justa
        { 8933, 60, 58 }, -- Una compensación justa
        { 8934, 60, 58 }, -- Una compensación justa
        { 8935, 60, 58 }, -- Una compensación justa
        { 8936, 60, 58 }, -- Una compensación justa
        { 8937, 60, 58 }, -- Una compensación justa
        { 8999, 60, 58 }, -- Guardar lo mejor para el final
        { 9000, 60, 58 }, -- Guardar lo mejor para el final
        { 9001, 60, 58 }, -- Guardar lo mejor para el final
        { 9002, 60, 58 }, -- Guardar lo mejor para el final
        { 9003, 60, 58 }, -- Guardar lo mejor para el final
        { 9004, 60, 58 }, -- Guardar lo mejor para el final
        { 9005, 60, 58 }, -- Guardar lo mejor para el final
        { 9006, 60, 58 }, -- Guardar lo mejor para el final
        { 84147, 60, 58 }, -- An Earnest Proposition
        { 84148, 60, 58 }, -- An Earnest Proposition
        { 84149, 60, 58 }, -- An Earnest Proposition
        { 84150, 60, 58 }, -- An Earnest Proposition
        { 84154, 60, 58 }, -- An Earnest Proposition
        { 95817, 60, 1 }, -- Rotgath Stonebeard
        { 95924, 60, 55 }, -- Panic at the Digsite
        { 95925, 60, 55 }, -- Mapping the Way Forward
        { 97447, 60, 58 }, -- An Earnest Proposition
        { 99207, 60, 60 }, -- Swift as the Wind
        { 99209, 60, 60 }, -- Swift as the Wind
    },
})

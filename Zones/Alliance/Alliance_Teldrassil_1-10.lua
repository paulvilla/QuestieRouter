-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Teldrassil · niveles 1-10 · 68 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_Teldrassil",
    faction = "Alliance",
    zone = "Teldrassil",
    areaId = 141,
    minLevel = 1,
    maxLevel = 10,
    entry = { quest = 456, areaId = 141, x = 58.69, y = 44.27 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 456, 2, 1 }, -- El equilibrio de la naturaleza
        { 458, 1, 1 }, -- La protectora de los bosques
        { 457, 3, 1 }, -- El equilibrio de la naturaleza
        { 459, 3, 1 }, -- La protectora de los bosques
        { 97977, 3, 1 }, -- La llamada de la naturaleza
        { 916, 4, 3 }, -- El veneno de la Tejemadera
        { 4495, 4, 2 }, -- Un buen amigo
        { 3519, 4, 2 }, -- Un amigo en apuros
        { 3521, 4, 2 }, -- En antídoto de Iverron
        { 3522, 4, 2 }, -- En antídoto de Iverron
        { 917, 5, 1 }, -- Huevo de Tejemadera
        { 920, 5, 1 }, -- Las invocaciones de Tenaron
        { 921, 5, 1 }, -- La corona de la Tierra
        { 928, 5, 1 }, -- La corona de la Tierra
        { 2159, 5, 1 }, -- Envío desde Dolanaar
        { 488, 5, 4 }, -- Las apuestas de Zenn
        { 997, 5, 4 }, -- Las tierras de Denalan
        { 929, 5, 1 }, -- La corona de la Tierra
        { 97236, 5, 1 }, -- Colmillo de Githyiss
        { 475, 6, 4 }, -- Una brisa problemática
        { 2438, 6, 1 }, -- EL cazasueños esmeralda
        { 476, 6, 4 }, -- Corrupción en Tuercepinos
        { 489, 7, 4 }, -- ¡Búsqueda de redención!
        { 87288, 7, 4 }, -- Los pelambres de sable de la noche suaves
        { 918, 7, 4 }, -- Semillas de Brezomadera
        { 919, 7, 4 }, -- Brotes de Brezomadera
        { 922, 7, 4 }, -- Rellian Verdeguja
        { 932, 8, 4 }, -- Odio enraizado
        { 2459, 8, 1 }, -- Ferocitas el Comesueños
        { 487, 8, 5 }, -- El camino a Darnassus
        { 2541, 8, 3 }, -- El druida durmiente
        { 490, 8, 5 }, -- Recompensa: Fúrbolg Tuercepino
        { 99047, 9, 4 }, -- Aún con vida
        { 483, 9, 4 }, -- Las Reliquias del Despertar
        { 99046, 9, 4 }, -- La mensajera perdida
        { 933, 9, 1 }, -- La corona de la Tierra
        { 923, 9, 4 }, -- Los tumores
        { 2498, 9, 4 }, -- El regreso a Denalan
        { 2499, 9, 4 }, -- Roblegüello
        { 98391, 10, 5 }, -- La Hermandad de Elune
        { 99050, 10, 4 }, -- El Gran Árbol provee
        { 99073, 10, 4 }, -- Aliviar el sufrimiento
        { 99053, 10, 4 }, -- Fuga de Ban'ethil
        { 2561, 10, 3 }, -- El druida de la garra
        { 930, 10, 4 }, -- El fruto resplandeciente
        { 6341, 10, 10 }, -- La prodigalidad de Teldrassil
        { 6342, 10, 10 }, -- Vuela a Auberdine
        { 931, 10, 4 }, -- Flora luminosa
        { 2399, 10, 4 }, -- Flora en brote
        { 2519, 10, 5 }, -- El templo de la Luna
        { 6344, 10, 10 }, -- Nessa Cantosombrío
        { 6721, 10, 10 }, -- El camino del cazador  [clase]
        { 935, 11, 1 }, -- La corona de la Tierra
        { 7383, 11, 1 }, -- La corona de la Tierra
        { 937, 11, 6 }, -- El claro encantado
        { 98046, 11, 1 }, -- La corona de la Tierra
        { 98065, 11, 1 }, -- La corona de la Tierra
        { 98067, 11, 1 }, -- Ojos de los centinelas
        { 2518, 12, 5 }, -- Las lagrimas de la Luna
        { 2520, 12, 5 }, -- El Sacrificio de Sathrah
        { 486, 12, 4 }, -- Ursal el Violento
        { 98403, 12, 4 }, -- Odio enraizado
        { 98392, 12, 6 }, -- Oscuridad en el claro
        { 98398, 12, 6 }, -- El Árbol del Oráculo
        { 940, 11, 6 }, -- Teldrassil
        { 938, 12, 7 }, -- Niebla
        { 927, 12, 5 }, -- El corazón musgoso
        { 941, 12, 9 }, -- Plantar el corazón
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 1199, 25, 20 }, -- Cascada del Crepúsculo
        { 1038, 30, 25 }, -- Las pertenencias de Velinde
        { 95511, 40, 40 }, -- Your First Feline Friend
        { 97074, 40, 40 }, -- Learning to Ride
        { 2940, 47, 42 }, -- Feralas: una historia
        { 3661, 47, 42 }, -- ¿Creados por Elune?
        { 2941, 48, 42 }, -- El préstamo
        { 2943, 48, 42 }, -- Vuelva con Troyas
        { 3763, 50, 47 }, -- Ayuda al archidruida Corzocelada
        { 3764, 50, 47 }, -- La tierra de Un'Goro
        { 3781, 50, 47 }, -- Investigar la mañagrana
        { 3785, 50, 47 }, -- Investigar la mañagrana
        { 3789, 50, 47 }, -- Ayuda al archidruida Corzocelada
        { 3790, 50, 47 }, -- Ayuda al archidruida Corzocelada
        { 4510, 54, 50 }, -- La calma que precede a la tormenta
        { 978, 55, 52 }, -- Lechúcico Lunadón
        { 1015, 55, 54 }, -- La nueva frontera
        { 1019, 55, 54 }, -- La nueva frontera
        { 1047, 55, 54 }, -- La nueva frontera
        { 3803, 55, 47 }, -- Mañagrana para Darnassus
        { 6761, 55, 54 }, -- La nueva frontera
        { 92344, 55, 45 }, -- Get to the Roots of It
        { 5250, 56, 53 }, -- Estrella Fugaz
        { 979, 57, 52 }, -- Encuentra a Ranshalla
        { 4902, 57, 52 }, -- Lechúcico de Elune
        { 7792, 60, 12 }, -- Un donativo de lana
        { 7798, 60, 26 }, -- Un donativo de seda
        { 7799, 60, 40 }, -- Un donativo de paño mágico
        { 7800, 60, 50 }, -- Un donativo de paño rúnico
        { 7801, 60, 50 }, -- Un donativo extra de paño rúnico
        { 8734, 60, 60 }, -- Tyrande y Rémulos
        { 99205, 60, 60 }, -- Swift as the Wind
    },
})

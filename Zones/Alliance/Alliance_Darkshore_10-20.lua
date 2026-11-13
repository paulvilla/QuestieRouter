-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Darkshore · niveles 10-20 · 74 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_Darkshore",
    faction = "Alliance",
    zone = "Darkshore",
    areaId = 148,
    minLevel = 10,
    maxLevel = 20,
    entry = { quest = 3524, areaId = 148, x = 36.62, y = 45.59 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 3524, 13, 11 }, -- Varado
        { 6343, 10, 10 }, -- Vuelve con Nessa
        { 983, 10, 7 }, -- La caja mecánica 827
        { 1001, 12, 7 }, -- La caja mecánica 411
        { 954, 12, 7 }, -- Bashal'Aran
        { 958, 12, 9 }, -- Las herramientas de los altonatos
        { 955, 12, 7 }, -- Bashal'Aran
        { 953, 12, 9 }, -- La caída de Ameth'Aran
        { 98025, 13, 10 }, -- SE BUSCA: Jai'vhanel
        { 956, 13, 7 }, -- Bashal'Aran
        { 957, 13, 7 }, -- Bashal'Aran
        { 1002, 14, 7 }, -- La caja mecánica 323
        { 984, 14, 10 }, -- La extensión de la amenaza
        { 985, 14, 10 }, -- La extensión de la amenaza
        { 2118, 14, 10 }, -- Tierras infestadas
        { 4811, 14, 12 }, -- El cristal rojo
        { 4812, 14, 12 }, -- Agua en cascada
        { 1141, 14, 10 }, -- La familia y la caña de pescar
        { 4681, 14, 11 }, -- Varado
        { 4723, 13, 11 }, -- Criatura marina varada
        { 4722, 13, 11 }, -- Tortuga marina varada
        { 4728, 14, 12 }, -- Criatura marina varada
        { 4813, 14, 12 }, -- Los fragmentos del interior
        { 730, 14, 14 }, -- ¿Problemas en Costa Oscura?
        { 4725, 15, 12 }, -- Tortuga marina varada
        { 4727, 15, 12 }, -- Tortuga marina varada
        { 4761, 15, 11 }, -- Thundris Tejevientos
        { 4762, 15, 11 }, -- El Río Fonroca
        { 5713, 15, 10 }, -- Un tiro. Un muerto.
        { 4730, 16, 12 }, -- Criatura marina varada
        { 963, 16, 11 }, -- Un amor eterno
        { 2138, 16, 10 }, -- La limpieza de la infección
        { 1003, 16, 7 }, -- La caja mecánica 525
        { 97914, 17, 13 }, -- Expansión de horizontes
        { 982, 17, 13 }, -- Profundo océano, mar inmenso
        { 947, 17, 12 }, -- La cueva de los champiñones
        { 948, 17, 12 }, -- Onus
        { 1138, 17, 15 }, -- Rico marisco
        { 944, 17, 12 }, -- El Glaive del Maestro
        { 98042, 17, 12 }, -- It's All Fun and Games Until...
        { 949, 17, 12 }, -- El campamento del Azote del Ocaso
        { 950, 17, 12 }, -- Vuelve con Onus
        { 952, 17, 6 }, -- El Páramo de los Ancestros
        { 97894, 17, 13 }, -- Asuntos en Auberdine
        { 97926, 17, 13 }, -- A duras penas
        { 945, 18, 10 }, -- La fuga de Therylune
        { 4740, 18, 15 }, -- SE BUSCA: ¡Viscoso!
        { 2139, 18, 10 }, -- La esperanza de Tharnariun
        { 965, 18, 13 }, -- La torre de Althalaxx
        { 4763, 18, 15 }, -- La corrupción de los Bosque Negro
        { 966, 18, 13 }, -- La torre de Althalaxx
        { 967, 18, 13 }, -- La torre de Althalaxx
        { 4731, 19, 13 }, -- Tortuga marina varada
        { 4732, 19, 13 }, -- Tortuga marina varada
        { 4733, 19, 13 }, -- Criatura marina varada
        { 951, 20, 12 }, -- Las reliquias de Mathystra
        { 98013, 20, 12 }, -- Swelling Forces
        { 5321, 20, 17 }, -- El despertar
        { 87760, 20, 15 }, -- Holy Diver
        { 986, 20, 10 }, -- El maestro perdido
        { 993, 20, 10 }, -- El maestro perdido
        { 729, 20, 15 }, -- El prospector despistado
        { 2098, 20, 14 }, -- La búsqueda de Gyromast
        { 2078, 20, 14 }, -- La venganza de Gyromast
        { 995, 20, 10 }, -- Escaparse furtivamente
        { 731, 20, 15 }, -- El prospector despistado
        { 741, 20, 15 }, -- El prospector despistado
        { 968, 20, 10 }, -- Los Poderes Subyacentes
        { 98461, 21, 18 }, -- Amor no correspondido
        { 98028, 21, 17 }, -- Baron Marinous
        { 994, 22, 10 }, -- Escaparse por la fuerza
        { 990, 19, 15 }, -- El camino de Vallefresno
        { 1275, 24, 18 }, -- Investigaciones acerca de la corrupción
        { 3765, 24, 18 }, -- Lejana corrupción
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 981, 31, 13 }, -- La torre de Althalaxx
        { 1143, 31, 13 }, -- La torre de Althalaxx
    },
})

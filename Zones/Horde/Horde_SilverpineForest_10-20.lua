-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Silverpine Forest · niveles 10-20 · 52 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_SilverpineForest",
    faction = "Horde",
    zone = "Silverpine Forest",
    areaId = 130,
    minLevel = 10,
    maxLevel = 20,
    entry = { quest = 435, areaId = 130, x = 56.18, y = 9.18 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 435, 11, 10 }, -- Escolta a Erland
        { 6321, 10, 10 }, -- Suministros para El Sepulcro
        { 6323, 10, 10 }, -- Vuela a Entrañas
        { 6324, 10, 10 }, -- Vuelve con Podrig
        { 429, 11, 10 }, -- Corazones salvajes
        { 449, 11, 10 }, -- El informe de los Mortacechadores
        { 91920, 11, 10 }, -- Ojos salvajes
        { 430, 11, 10 }, -- Vuelve con Quinn
        { 91921, 11, 10 }, -- Vuelve con Quinn (de nuevo)
        { 447, 12, 9 }, -- Una fórmula mortal
        { 428, 12, 10 }, -- Los Mortacechadores desaparecidos
        { 3221, 12, 10 }, -- Habla con Renferrel
        { 421, 12, 12 }, -- Demuestra tu valía
        { 422, 11, 9 }, -- La locura de Arugal
        { 425, 12, 10 }, -- Ivar el Hediondo
        { 423, 14, 9 }, -- La locura de Arugal
        { 477, 14, 10 }, -- Pasa la frontera
        { 437, 14, 10 }, -- El Campo Muerto
        { 478, 14, 10 }, -- Mapas y runas
        { 481, 14, 10 }, -- El análisis de Dalar
        { 482, 14, 10 }, -- Las intenciones de los Dalaran
        { 424, 15, 9 }, -- La locura de Arugal
        { 99, 15, 9 }, -- La locura de Arugal
        { 1359, 15, 10 }, -- Una entrega de Zinge
        { 452, 15, 12 }, -- La emboscada de Aldea Piroleña
        { 450, 15, 9 }, -- Una fórmula mortal
        { 438, 16, 10 }, -- El Viejo Embarcadero
        { 479, 16, 10 }, -- Las investigaciones de Molino Ámbar
        { 98298, 16, 9 }, -- Arugal's Folly
        { 439, 16, 10 }, -- Pistas de Putrepellejos
        { 440, 16, 10 }, -- El anillo grabado
        { 443, 17, 10 }, -- Icor de Putrepellejo
        { 444, 17, 10 }, -- El origen de los Putrepellejos
        { 446, 16, 10 }, -- Thule Corvozarpa
        { 448, 16, 10 }, -- Preséntate ante Hadrec
        { 460, 17, 12 }, -- Descansar en piezas
        { 451, 18, 9 }, -- Una fórmula mortal
        { 461, 18, 12 }, -- El nicho oculto
        { 491, 18, 12 }, -- Una varita para Bethor
        { 98299, 20, 9 }, -- Stop the Spread
        { 95981, 20, 10 }, -- Vigilar los caminos
        { 493, 20, 19 }, -- Viaja a Laderas de Trabalomas
        { 516, 21, 16 }, -- El Desafío de Beren
        { 480, 22, 10 }, -- El Tejedor
        { 92401, 22, 15 }, -- Una petición aterradora
        { 78261, 23, 1 }, -- The Horn of Xelthos
        { 95883, 23, 20 }, -- The Tortured Soul
        { 95885, 23, 20 }, -- The Offering of Blood
        { 95884, 23, 20 }, -- The Offering Stone
        { 442, 24, 10 }, -- Asalto a la Isla de Fenris
        { 1098, 25, 18 }, -- Mortacechadores en Colmillo Oscuro
        { 1014, 27, 18 }, -- Arugal debe morir
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 8578, 60, 60 }, -- ¿Unas gafas? ¡Sin problemas!
    },
})

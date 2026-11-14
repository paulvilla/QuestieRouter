-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Ashenvale · niveles 18-30 · 44 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_Ashenvale",
    faction = "Alliance",
    zone = "Ashenvale",
    areaId = 331,
    minLevel = 18,
    maxLevel = 30,
    entry = { quest = 970, areaId = 331, x = 26.2, y = 38.7 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 970, 21, 13 }, -- La torre de Althalaxx
        { 1056, 18, 18 }, -- Viaje a Cima del Espolón
        { 991, 19, 18 }, -- La limpieza de Raene
        { 1008, 19, 14 }, -- La Ensenada de Zoram
        { 1010, 20, 20 }, -- Cabello de Bathran
        { 1020, 20, 20 }, -- El remedio de Orendil
        { 1007, 20, 19 }, -- La antigua estatuilla
        { 1023, 21, 18 }, -- La limpieza de Raene
        { 1134, 21, 18 }, -- Alaorgullo del Esploón
        { 1070, 21, 17 }, -- Estar de guardia en Espolón
        { 1024, 21, 18 }, -- La limpieza de Raene
        { 1033, 22, 20 }, -- Lágrima de Elune
        { 1034, 23, 20 }, -- Las ruinas del Polvo Estelar
        { 1025, 24, 18 }, -- Una defensa agresiva
        { 973, 24, 13 }, -- La torre de Althalaxx
        { 976, 24, 19 }, -- Suministros a Auberdine
        { 1016, 24, 20 }, -- Brazales elementales
        { 1017, 25, 20 }, -- Mago invocador
        { 1054, 25, 18 }, -- Matanza selectiva
        { 1009, 25, 20 }, -- Ruuzel
        { 98027, 26, 22 }, -- El collar de media luna resplandeciente
        { 1026, 27, 18 }, -- La limpieza de Raene
        { 1027, 28, 18 }, -- La limpieza de Raene
        { 1028, 28, 18 }, -- La limpieza de Raene
        { 1055, 28, 18 }, -- La limpieza de Raene
        { 1029, 28, 18 }, -- La limpieza de Raene
        { 1030, 28, 18 }, -- La limpieza de Raene
        { 1081, 28, 17 }, -- El recibimiento de Tyrande
        { 1140, 28, 13 }, -- La torre de Althalaxx
        { 1167, 28, 13 }, -- La torre de Althalaxx
        { 98417, 28, 23 }, -- La senda de la venganza
        { 1011, 29, 24 }, -- Los males de los Renegados
        { 4581, 29, 24 }, -- Kayneth Ventoleve
        { 1035, 30, 20 }, -- Lago Cielo Estrellado
        { 1022, 30, 25 }, -- La Vega del Aullido
        { 1037, 30, 25 }, -- Velinde Cantoestelar
        { 86757, 30, 27 }, -- Trabas al avance orco
        { 98418, 30, 23 }, -- Furia compartida
        { 95737, 31, 24 }, -- En busca de Caitlin
        { 1021, 32, 26 }, -- ¡Vil sátiro! ¡Dríade en peligro!
        { 1031, 32, 26 }, -- La Rama de Cenarius
        { 1012, 32, 24 }, -- Druidas dementes
        { 1032, 32, 26 }, -- ¡Muerte a los sátiros!
        { 7863, 34, 25 }, -- Paquete de curación elemental de sentinela
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 7864, 44, 35 }, -- Paquete de curación normal de sentinela
        { 7865, 60, 45 }, -- Paquete de curación avanzado de sentinela
    },
})

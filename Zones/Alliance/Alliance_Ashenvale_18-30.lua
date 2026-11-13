-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Ashenvale · niveles 18-30 · 50 misiones
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
        { 8289, 15, 10 }, -- Talismanes del mérito
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
        { 78132, 25, 15 }, -- Dragonslayer's Helm
        { 78133, 25, 15 }, -- Dragonslayer's Shield
        { 78134, 25, 15 }, -- Dragonslayer's Lance
        { 1054, 25, 18 }, -- Matanza selectiva
        { 1009, 25, 20 }, -- Ruuzel
        { 7921, 25, 20 }, -- Talismanes del mérito
        { 98027, 26, 25 }, -- Gleaming Crescent Necklace
        { 1026, 27, 18 }, -- La limpieza de Raene
        { 1027, 28, 18 }, -- La limpieza de Raene
        { 1028, 28, 18 }, -- La limpieza de Raene
        { 1055, 28, 18 }, -- La limpieza de Raene
        { 1029, 28, 18 }, -- La limpieza de Raene
        { 1030, 28, 18 }, -- La limpieza de Raene
        { 1081, 28, 17 }, -- El recibimiento de Tyrande
        { 1140, 28, 13 }, -- La Torre de Althalaxx
        { 1167, 28, 13 }, -- La torre de Althalaxx
        { 4581, 29, 24 }, -- Kayneth Ventoleve
        { 1011, 29, 24 }, -- Los males de los Renegados
        { 98417, 30, 23 }, -- Vengeful Trail
        { 98418, 30, 23 }, -- Shared Fury
        { 86757, 30, 27 }, -- Slowing the Orc Advance
        { 1035, 30, 20 }, -- Lago Cielo Estrellado
        { 1022, 30, 25 }, -- La Vega del Aullido
        { 1037, 30, 25 }, -- Velinde Cantoestelar
        { 95737, 31, 24 }, -- Seeking Caitlin
        { 1021, 32, 26 }, -- ¡Vil sátiro! ¡Dríade en peligro!
        { 1031, 32, 26 }, -- La Rama de Cenario
        { 1012, 32, 24 }, -- Druidas dementes
        { 1032, 32, 26 }, -- ¡Muerte a los sátiros!
        { 7863, 34, 25 }, -- Paquete de curación elemental de sentinela
        { 7887, 35, 30 }, -- Talismanes del mérito
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 7864, 44, 35 }, -- Paquete de curación normal de sentinela
        { 7888, 45, 40 }, -- Talismanes del mérito
        { 7886, 55, 50 }, -- Talismanes del mérito
        { 7865, 60, 45 }, -- Paquete de curación avanzado de sentinela
    },
})

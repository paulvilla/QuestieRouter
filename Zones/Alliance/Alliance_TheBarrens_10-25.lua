-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · The Barrens · niveles 10-25 · 27 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_TheBarrens",
    faction = "Alliance",
    zone = "The Barrens",
    areaId = 17,
    minLevel = 10,
    maxLevel = 25,
    entry = { quest = 959, areaId = 17, x = 63.09, y = 37.61 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 959, 18, 14 }, -- ¡A por la botella!
        { 894, 14, 10 }, -- El churumbele
        { 887, 14, 9 }, -- Los filibusteros del Mar del Sur
        { 890, 14, 9 }, -- El envío perdido
        { 892, 14, 9 }, -- El envío perdido
        { 900, 14, 10 }, -- El churumbele
        { 901, 14, 10 }, -- El churumbele
        { 97253, 15, 9 }, -- Volver con piezas de una pieza
        { 888, 16, 9 }, -- El botín robado
        { 895, 16, 11 }, -- SE BUSCA: Barón Longavera
        { 902, 16, 10 }, -- El churumbele
        { 1486, 17, 13 }, -- Pellejo de los descarriados
        { 865, 18, 13 }, -- Los cuernos de raptor
        { 1491, 18, 13 }, -- Las bebidas astutas
        { 896, 18, 13 }, -- La fortuna de un minero
        { 858, 18, 13 }, -- La llave de contacto
        { 863, 18, 13 }, -- La fuga
        { 1069, 20, 15 }, -- Huevos de arañas musgondo
        { 1483, 21, 16 }, -- Ziz Fizziks
        { 97005, 21, 15 }, -- Chol'aruk el Devorador
        { 1487, 21, 15 }, -- Erradicación de descarriados
        { 79192, 24, 14 }, -- Peldaños
        { 3370, 25, 15 }, -- En las pesadillas
        { 1221, 26, 20 }, -- Los tubérculos hojazul
        { 1095, 27, 16 }, -- Más instrucciones
        { 1039, 30, 25 }, -- El puerto de Los Baldíos
        { 1040, 30, 25 }, -- Pasaje a Bahía del Botín
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 6626, 35, 28 }, -- Un anfitrión del mal
        { 1112, 36, 30 }, -- Las piezas de Kravel
        { 1180, 37, 29 }, -- Apoyo al goblin
        { 5159, 54, 48 }, -- El agua purificada vuelve a Frondavil
        { 4502, 55, 49 }, -- Actividad volcánica
        { 9267, 60, 15 }, -- Curar viejas heridas
    },
})

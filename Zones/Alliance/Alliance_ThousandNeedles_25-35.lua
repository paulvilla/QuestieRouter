-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Thousand Needles · niveles 25-35 · 17 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_ThousandNeedles",
    faction = "Alliance",
    zone = "Thousand Needles",
    areaId = 400,
    minLevel = 25,
    maxLevel = 35,
    entry = { quest = 1110, areaId = 400, x = 77.79, y = 77.27 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 1110, 31, 28 }, -- Piezas de coches cohete
        { 1104, 30, 28 }, -- Veneno de escórpidos salados
        { 1105, 30, 28 }, -- Caparazones endurecidos
        { 1176, 30, 29 }, -- Menos peso
        { 1179, 30, 28 }, -- Los hermanos Pernolatón
        { 5762, 31, 28 }, -- Hemet Decautela
        { 98156, 31, 27 }, -- Packaged Pristine Pelts
        { 1175, 33, 28 }, -- Un bache en la carretera
        { 1100, 34, 29 }, -- El diario de Henrig Soliceja
        { 1107, 35, 28 }, -- Aletas dorsales escamadas
        { 1106, 35, 26 }, -- Martek el Exiliado
        { 79947, 35, 1 }, -- Geomancy: The Stone-Cold Truth
        { 1111, 36, 30 }, -- Maestro de los muelles Vertipeluca
        { 1114, 36, 30 }, -- Un envío para los gnomos
        { 1115, 36, 30 }, -- Rumores
        { 1178, 37, 29 }, -- Patrocinio goblin
        { 1186, 37, 29 }, -- El piloto nº18
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 1187, 41, 29 }, -- Los ajustes de Razzeric'
        { 1188, 41, 29 }, -- La seguridad primero
        { 1190, 41, 29 }, -- Mantener la velocidad
        { 1191, 41, 29 }, -- La distracción de Zamek
        { 1194, 41, 29 }, -- Los esquemas de Rizzle
        { 1192, 42, 29 }, -- Mineral de indurio
        { 1118, 43, 35 }, -- De vuelta a Bahía del Botín
        { 1120, 44, 35 }, -- Emborrachar a los gnomos
        { 1121, 44, 35 }, -- Emborrachar a los goblin
        { 1122, 44, 35 }, -- Volver a informar a Pinchabujas,
        { 2769, 46, 40 }, -- Los hermanos Pernolatón
        { 3842, 47, 38 }, -- Una corta incubación
        { 3843, 47, 38 }, -- Un nuevo miembro en la familia
        { 2770, 50, 40 }, -- Gahz'rilla
    },
})

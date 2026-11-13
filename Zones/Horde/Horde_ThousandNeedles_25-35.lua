-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Thousand Needles · niveles 25-35 · 41 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_ThousandNeedles",
    faction = "Horde",
    zone = "Thousand Needles",
    areaId = 400,
    minLevel = 25,
    maxLevel = 35,
    entry = { quest = 4542, areaId = 400, x = 32.24, y = 22.17 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 4542, 25, 23 }, -- Mensaje para el Poblado Viento Libre
        { 4841, 25, 23 }, -- Apaciguar al centauro
        { 4821, 26, 24 }, -- Un huevo extraño
        { 4865, 26, 24 }, -- Venganza
        { 1149, 26, 25 }, -- Prueba de fe
        { 5062, 27, 24 }, -- El fuego Sagrado
        { 5064, 28, 24 }, -- Espiando a los Tótem Siniestro
        { 4881, 28, 23 }, -- Complot de asesinato
        { 4966, 28, 23 }, -- Defensa de Kanati Nube Gris
        { 5088, 28, 24 }, -- Arikara
        { 1196, 29, 20 }, -- La llama Sagrada
        { 1197, 29, 20 }, -- La llama Sagrada
        { 5147, 29, 25 }, -- Se busca: Arnak Tótem Siniestro
        { 4767, 29, 25 }, -- Jinete del viento
        { 4904, 29, 25 }, -- Al fin libre
        { 4770, 29, 25 }, -- De vuelta casa
        { 5151, 30, 24 }, -- Hipercondensador
        { 1150, 30, 25 }, -- Prueba de resistencia
        { 1151, 30, 25 }, -- Prueba de fuerza
        { 1152, 30, 25 }, -- Prueba de conocimiento
        { 1104, 30, 28 }, -- Veneno de escórpidos salados
        { 1105, 30, 28 }, -- Caparazones endurecidos
        { 1176, 30, 29 }, -- Menos peso
        { 1110, 31, 28 }, -- Piezas de coches cohete
        { 5762, 31, 28 }, -- Hemet Decautela
        { 98069, 31, 27 }, -- Stolen Freewind Supplies
        { 98070, 31, 27 }, -- Stop the Screeching
        { 1175, 33, 28 }, -- Un bache en la carretera
        { 1146, 33, 29 }, -- El enjambre crece
        { 1106, 35, 26 }, -- Martek el Exiliado
        { 1107, 35, 28 }, -- Aletas dorsales escamadas
        { 1147, 35, 29 }, -- El enjambre crece
        { 5361, 35, 32 }, -- Árbol genealógico
        { 79947, 35, 1 }, -- Geomancy: The Stone-Cold Truth
        { 1148, 35, 28 }, -- Pedazos del enjambre
        { 1111, 36, 30 }, -- Maestro de los muelles Vertipeluca
        { 1114, 36, 30 }, -- Un envío para los gnomos
        { 1115, 36, 30 }, -- Rumores
        { 1394, 36, 25 }, -- La recta final
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
        { 2770, 50, 40 }, -- Gahz'rilla
    },
})

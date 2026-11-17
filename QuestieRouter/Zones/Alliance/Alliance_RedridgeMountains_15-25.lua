-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Redridge Mountains · niveles 15-25 · 40 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_RedridgeMountains",
    faction = "Alliance",
    zone = "Redridge Mountains",
    areaId = 44,
    minLevel = 15,
    maxLevel = 25,
    entry = { quest = 244, areaId = 44, x = 10.37, y = 71.26 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 244, 16, 11 }, -- Gnolls invasores
        { 120, 14, 14 }, -- Mensajero a Páramos de Poniente
        { 121, 14, 14 }, -- Mensajero a Páramos de Poniente
        { 143, 14, 14 }, -- Mensajero a Páramos de Poniente
        { 1097, 15, 9 }, -- La tarea de Elmore
        { 129, 15, 12 }, -- Una comida gratis
        { 116, 15, 12 }, -- Tiempos de sequía
        { 3741, 15, 12 }, -- El collar de Hilary
        { 130, 15, 12 }, -- Una visita al herborista
        { 131, 15, 12 }, -- Un ramo de narcisos
        { 125, 16, 15 }, -- Las herramientas perdidas
        { 246, 17, 11 }, -- Evaluar la amenaza
        { 98407, 17, 11 }, -- Demostración de fuerza
        { 118, 18, 14 }, -- El precio de unas herraduras
        { 122, 18, 14 }, -- Escamas de barriga
        { 145, 18, 18 }, -- Mensajero a Villa Oscura
        { 132, 18, 14 }, -- La hermandad de los Defias
        { 92, 18, 15 }, -- Estofado de Crestagrana
        { 150, 20, 20 }, -- Cazadores furtivos
        { 124, 20, 15 }, -- El aullido de los gnolls
        { 89, 20, 15 }, -- La reconstrucción del puente
        { 98386, 21, 15 }, -- El Molino de Alther
        { 20, 21, 18 }, -- La amenaza de los Roca Negra
        { 98387, 21, 18 }, -- Bloqueo Roca Negra
        { 127, 21, 16 }, -- Pescado a la venta
        { 248, 22, 20 }, -- Ver más allá
        { 115, 23, 18 }, -- Magia de las Sombras
        { 91, 23, 17 }, -- Ley de Salomón
        { 178, 23, 15 }, -- Theocritus recupera el colgante
        { 347, 24, 20 }, -- Mineral de Rethban
        { 34, 24, 18 }, -- Una visita poco grata
        { 386, 25, 22 }, -- Lo que sucece alrededor…
        { 95999, 25, 16 }, -- SE BUSCA: Incinerador Gar'im
        { 126, 25, 15 }, -- El aullido de las colinas
        { 19, 25, 18 }, -- Tharil'zun
        { 128, 25, 20 }, -- La recompensa de Roca Negra
        { 219, 25, 19 }, -- Desaparecido en combate
        { 169, 26, 15 }, -- SE BUSCA: Gath'Ilzogg
        { 180, 26, 15 }, -- SE BUSCA: Teniente Fangore
        { 249, 27, 20 }, -- Morganth
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 95772, 31, 24 }, -- En busca de Filosón
        { 4184, 54, 48 }, -- Los verdaderos maestros
        { 4186, 54, 48 }, -- Los verdaderos maestros
        { 4223, 54, 48 }, -- Los verdaderos maestros
        { 95816, 60, 1 }, -- Sign Me Up!
        { 98247, 60, 10 }, -- Etiqueta de envíos
    },
})

-- QuestieRouter: caminos dentro de cada zona. GENERADO por tools/roads/build_roads_lua.py: no editar a mano.
--
-- Salen de la imagen del mapa del mundo de cada zona (archivos del juego, via wow.tools.local): montañas,
-- carreteras y veredas -> ruta mas barata entre los puntos importantes (cruces, maestros de vuelo, muelles).
-- En las zonas con caminos, ir campo a traves cuesta mas que seguir el camino (ver Guide/Router.lua).
-- Cada camino es una linea de puntos (x, y en 0..1, como las coordenadas del mapa / 100) de una zona.
-- Se pueden añadir caminos propios en el juego con /qr road (se guardan aparte, en QuestieRouterDB.customRoads).
--
--   { uiMapID, { x1, y1, x2, y2, ... } }
local _, QR = ...
QR.RoadData = {
}

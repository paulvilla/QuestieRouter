-- QuestieRouter: textos de las herramientas de diagnostico (/qr perf), en todos los idiomas.
-- Se cargan despues de los archivos de cada idioma y se añaden a sus tablas (QR:ExtendLocale).
local _, QR = ...

QR:ExtendLocale("enUS", {
    ["measure how long the map lines take for 10 s (open the world map and zoom)"] = true,
    ["Measuring the map lines for %d s: open the world map and zoom in and out."] = true,
    ["Map lines: the world map was not open while measuring."] = true,
    ["Map lines: %d frames, %.3f ms average, %.3f ms max per frame, %d route lines."] = true,
})

QR:ExtendLocale("esES", {
    ["measure how long the map lines take for 10 s (open the world map and zoom)"] = "mide durante 10 s lo que tardan las líneas del mapa (abre el mapa del mundo y haz zoom)",
    ["Measuring the map lines for %d s: open the world map and zoom in and out."] = "Midiendo las líneas del mapa durante %d s: abre el mapa del mundo y acerca y aleja el zoom.",
    ["Map lines: the world map was not open while measuring."] = "Líneas del mapa: el mapa del mundo no estaba abierto mientras se medía.",
    ["Map lines: %d frames, %.3f ms average, %.3f ms max per frame, %d route lines."] = "Líneas del mapa: %d fotogramas, %.3f ms de media y %.3f ms como máximo por fotograma, %d líneas de ruta.",
})

QR:ExtendLocale("frFR", {
    ["measure how long the map lines take for 10 s (open the world map and zoom)"] = "mesure pendant 10 s le temps des lignes de la carte (ouvrez la carte du monde et zoomez)",
    ["Measuring the map lines for %d s: open the world map and zoom in and out."] = "Mesure des lignes de la carte pendant %d s : ouvrez la carte du monde et zoomez puis dézoomez.",
    ["Map lines: the world map was not open while measuring."] = "Lignes de la carte : la carte du monde n'était pas ouverte pendant la mesure.",
    ["Map lines: %d frames, %.3f ms average, %.3f ms max per frame, %d route lines."] = "Lignes de la carte : %d images, %.3f ms en moyenne, %.3f ms au maximum par image, %d lignes d'itinéraire.",
})

QR:ExtendLocale("deDE", {
    ["measure how long the map lines take for 10 s (open the world map and zoom)"] = "misst 10 s lang, wie lange die Kartenlinien brauchen (Weltkarte öffnen und zoomen)",
    ["Measuring the map lines for %d s: open the world map and zoom in and out."] = "Messe die Kartenlinien %d s lang: Öffne die Weltkarte und zoome hinein und hinaus.",
    ["Map lines: the world map was not open while measuring."] = "Kartenlinien: Die Weltkarte war während der Messung nicht geöffnet.",
    ["Map lines: %d frames, %.3f ms average, %.3f ms max per frame, %d route lines."] = "Kartenlinien: %d Frames, %.3f ms im Schnitt, %.3f ms höchstens pro Frame, %d Routenlinien.",
})

QR:ExtendLocale("ruRU", {
    ["measure how long the map lines take for 10 s (open the world map and zoom)"] = "замерить за 10 с время линий на карте (откройте карту мира и меняйте масштаб)",
    ["Measuring the map lines for %d s: open the world map and zoom in and out."] = "Замер линий на карте %d с: откройте карту мира и приближайте и отдаляйте её.",
    ["Map lines: the world map was not open while measuring."] = "Линии на карте: карта мира не была открыта во время замера.",
    ["Map lines: %d frames, %.3f ms average, %.3f ms max per frame, %d route lines."] = "Линии на карте: кадров %d, в среднем %.3f мс, максимум %.3f мс на кадр, линий маршрута: %d.",
})

-- Opciones > Estado: estado de los addons de rutas a pie (QuestieRouter_Nav y los mapas de cada continente)
local STATUS_KEYS = {
    "STATUS", "Walking routes engine", "Eastern Kingdoms walking maps", "Kalimdor walking maps",
    "Active and working", "Active (loads when a route is needed)", "Active (loads on that continent)",
    "Not installed", "Disabled", "Enabled: reload the interface to use it", "The routes engine is disabled",
    "Out of date: tick \"Load out of date AddOns\"", "Cannot load: %s", "The routes engine failed to load",
    "Loaded with errors (/console scriptErrors 1 and /reload)", "Loaded, but its maps failed to load",
    "Enable", "Reload",
}
local enStatus = {}
for _, k in ipairs(STATUS_KEYS) do enStatus[k] = true end
QR:ExtendLocale("enUS", enStatus)

QR:ExtendLocale("esES", {
    ["STATUS"] = "ESTADO",
    ["Walking routes engine"] = "Motor de rutas a pie",
    ["Eastern Kingdoms walking maps"] = "Mapas a pie de los Reinos del Este",
    ["Kalimdor walking maps"] = "Mapas a pie de Kalimdor",
    ["Active and working"] = "Activo y funcionando",
    ["Active (loads when a route is needed)"] = "Activo (se carga al calcular una ruta)",
    ["Active (loads on that continent)"] = "Activo (se carga al llegar a ese continente)",
    ["Not installed"] = "No instalado",
    ["Disabled"] = "Desactivado",
    ["Enabled: reload the interface to use it"] = "Activado: recarga la interfaz para usarlo",
    ["The routes engine is disabled"] = "El motor de rutas está desactivado",
    ["Out of date: tick \"Load out of date AddOns\""] = "Desactualizado: marca \"Cargar addons desactualizados\"",
    ["Cannot load: %s"] = "No se puede cargar: %s",
    ["The routes engine failed to load"] = "El motor de rutas no se pudo cargar",
    ["Loaded with errors (/console scriptErrors 1 and /reload)"] = "Cargado con errores (/console scriptErrors 1 y /reload)",
    ["Loaded, but its maps failed to load"] = "Cargado, pero sus mapas no se pudieron leer",
    ["Enable"] = "Activar",
    ["Reload"] = "Recargar",
})

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

-- /qr perf: cada parte medida por separado
QR:ExtendLocale("enUS", {
    ["  %s: %d calls, %.3f ms average, %.3f ms max, %.2f ms/s, %.1f KB/s"] = true,
    ["World map: player line"] = true, ["Minimap"] = true, ["Arrow"] = true,
    ["Target refresh"] = true, ["Guide planner"] = true, ["Travel planner"] = true,
})
QR:ExtendLocale("esES", {
    ["  %s: %d calls, %.3f ms average, %.3f ms max, %.2f ms/s, %.1f KB/s"] = "  %s: %d llamadas, %.3f ms de media, %.3f ms como máximo, %.2f ms/s, %.1f KB/s",
    ["World map: player line"] = "Mapa del mundo: línea del jugador", ["Minimap"] = "Minimapa", ["Arrow"] = "Flecha",
    ["Target refresh"] = "Refresco del destino", ["Guide planner"] = "Planificador de la guía",
    ["Travel planner"] = "Planificador de viajes",
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

-- Opciones > Instalacion: boton que abre el asistente de instalacion
QR:ExtendLocale("enUS", { ["SETUP"] = true, ["Open the QuestieRouter installer"] = true })
QR:ExtendLocale("esES", { ["SETUP"] = "INSTALACIÓN", ["Open the QuestieRouter installer"] = "Abrir el instalador de QuestieRouter" })
QR:ExtendLocale("deDE", { ["SETUP"] = "EINRICHTUNG", ["Open the QuestieRouter installer"] = "QuestieRouter-Einrichtung öffnen" })
QR:ExtendLocale("frFR", { ["SETUP"] = "INSTALLATION", ["Open the QuestieRouter installer"] = "Ouvrir l'installateur de QuestieRouter" })
QR:ExtendLocale("ruRU", { ["SETUP"] = "УСТАНОВКА", ["Open the QuestieRouter installer"] = "Открыть установщик QuestieRouter" })

-- Guias de clase: falta una mision anterior de la cadena (fuera de la guia) que aun no se puede coger
QR:ExtendLocale("enUS", { ["First you need an earlier quest of the chain: %s"] = true })
QR:ExtendLocale("esES", { ["First you need an earlier quest of the chain: %s"] = "Antes falta una misión anterior de la cadena: %s" })

-- Misiones que se pueden coger pero cuyo NPC no esta en la base de datos de Questie (misiones nuevas de WoW Forever)
QR:ExtendLocale("enUS", {
    ["Questie doesn't know who gives this quest"] = true,
    ["Next: %s. Questie doesn't know who gives it, so I can't take you there."] = true,
})
QR:ExtendLocale("esES", {
    ["Questie doesn't know who gives this quest"] = "Questie no sabe quién da esta misión",
    ["Next: %s. Questie doesn't know who gives it, so I can't take you there."] = "Siguiente: %s. Questie no sabe quién la da, así que no puedo llevarte.",
})

-- Planificador: objetivos sin punto en el mapa y misiones que empiezan con un objeto
QR:ExtendLocale("enUS", {
    ["Starts from an item"] = true,
    ["Do: %s (no point on the map for this objective)."] = true,
    ["Next: %s. It starts from an item you have to find or loot."] = true,
})
QR:ExtendLocale("esES", {
    ["Starts from an item"] = "Empieza con un objeto",
    ["Do: %s (no point on the map for this objective)."] = "Haz: %s (este objetivo no tiene punto en el mapa).",
    ["Next: %s. It starts from an item you have to find or loot."] = "Siguiente: %s. Empieza con un objeto que tienes que encontrar o conseguir.",
})

-- Guias de profesiones: materiales que la guia de origen daba por hechos (lingotes, polvos, gemas, varas)
QR:ExtendLocale("enUS", {
    ["Get about %s"] = true,
    ["Smelt %s (Mining) or buy them at the auction house"] = true,
    ["Smelt %s and %s (Mining) or buy them at the auction house"] = true,
    ["Disenchant green items, or buy them at the auction house"] = true,
    ["Made by a blacksmith (or bought at the auction house)"] = true,
    ["Craft more: %s"] = true,
})
QR:ExtendLocale("esES", {
    ["Get about %s"] = "Consigue unos %s",
    ["Smelt %s (Mining) or buy them at the auction house"] = "Funde %s (Minería) o cómpralos en la casa de subastas",
    ["Smelt %s and %s (Mining) or buy them at the auction house"] = "Funde %s y %s (Minería) o cómpralos en la casa de subastas",
    ["Disenchant green items, or buy them at the auction house"] = "Desencanta objetos verdes, o cómpralos en la casa de subastas",
    ["Made by a blacksmith (or bought at the auction house)"] = "Lo fabrica un herrero (o se compra en la casa de subastas)",
    ["Craft more: %s"] = "Fabrica más: %s",
})

-- Guias de profesiones: se consultan en el menu, no se cargan en la flecha
QR:ExtendLocale("enUS", { ["Reference only"] = true })
QR:ExtendLocale("esES", { ["Reference only"] = "Solo de consulta" })

-- Flecha: coger misiones de un NPC (una o varias)
QR:ExtendLocale("enUS", {
    ["%sPick up quests|r from %s%s|r"] = true,
    ["%sPick up the quest|r from %s%s|r"] = true,
})
QR:ExtendLocale("esES", {
    ["%sPick up quests|r from %s%s|r"] = "%sCoger misiones|r de %s%s|r",
    ["%sPick up the quest|r from %s%s|r"] = "%sCoger misión|r de %s%s|r",
})

-- Misiones que el NPC no ofrece y registro de observaciones (/qr obs)
QR:ExtendLocale("enUS", {
    ["The NPC doesn't offer it"] = true,
    ["The NPC didn't offer it when you talked to them (level %d)"] = true,
    ["No observations recorded yet."] = true,
    ["Observations (format %d): %d rows, %d sessions, %d characters."] = true,
    ["Quests the NPC didn't offer: %d · offered later: %d"] = true,
    ["missing"] = true,
    ["found"] = true,
})
QR:ExtendLocale("esES", {
    ["The NPC doesn't offer it"] = "No la ofrece el NPC",
    ["The NPC didn't offer it when you talked to them (level %d)"] = "El NPC no la ofrecía cuando hablaste con él (nivel %d)",
    ["No observations recorded yet."] = "Aún no hay observaciones apuntadas.",
    ["Observations (format %d): %d rows, %d sessions, %d characters."] = "Observaciones (formato %d): %d filas, %d sesiones, %d personajes.",
    ["Quests the NPC didn't offer: %d · offered later: %d"] = "Misiones que el NPC no ofrecía: %d · ofrecidas después: %d",
    ["missing"] = "no la ofrece",
    ["found"] = "la ofrece",
})
QR:ExtendLocale("enUS", { ["level"] = true })
QR:ExtendLocale("esES", { ["level"] = "nivel" })

-- Notas en los pasos de las guias de clase (clic derecho en un paso)
QR:ExtendLocale("enUS", {
    ["Add a note..."] = true,
    ["Note for step %d"] = true,
    ["Position: %s (%.1f, %.1f)"] = true,
    ["Note saved. It will go with your export."] = true,
    ["Notes written: %d"] = true,
    ["note"] = true,
    ["Save"] = true,
    ["Cancel"] = true,
})
QR:ExtendLocale("esES", {
    ["Add a note..."] = "Añadir nota...",
    ["Note for step %d"] = "Nota del paso %d",
    ["Position: %s (%.1f, %.1f)"] = "Posición: %s (%.1f, %.1f)",
    ["Note saved. It will go with your export."] = "Nota guardada. Irá en tu exportación.",
    ["Notes written: %d"] = "Notas escritas: %d",
    ["note"] = "nota",
    ["Save"] = "Guardar",
    ["Cancel"] = "Cancelar",
})
QR:ExtendLocale("enUS", { ["Note for this quest"] = true })
QR:ExtendLocale("esES", { ["Note for this quest"] = "Nota de esta misión" })

-- Ventana de la nota: tipo y texto de ayuda; menu de los pasos hechos
QR:ExtendLocale("enUS", {
    ["Type:"] = true,
    ["Error"] = true,
    ["Tip for the quest"] = true,
    ["Describe an error in the guide or the quest, or a tip that helps to do it. This is not a personal note: it goes with your export so the guides can be fixed for everyone."] = true,
    ["Choose whether it is an error or a tip for the quest."] = true,
    ["Step %d (done)"] = true,
})
QR:ExtendLocale("esES", {
    ["Type:"] = "Tipo:",
    ["Error"] = "Error",
    ["Tip for the quest"] = "Consejo para la misión",
    ["Describe an error in the guide or the quest, or a tip that helps to do it. This is not a personal note: it goes with your export so the guides can be fixed for everyone."] = "Describe un error de la guía o de la misión, o un consejo que ayude a hacerla. No es una nota personal: va con tu exportación para que las guías se arreglen para todos.",
    ["Choose whether it is an error or a tip for the quest."] = "Elige si es un error o un consejo para la misión.",
    ["Step %d (done)"] = "Paso %d (hecho)",
})

-- Puntos añadidos a mano (Alt + clic izquierdo en el mapa del mundo)
QR:ExtendLocale("enUS", {
    ["Manual waypoint"] = true,
    ["Waypoint added: %s (%.1f, %.1f). It goes first."] = true,
    ["That spot can't be used as a waypoint (no world position)."] = true,
    ["You reached the manual waypoint."] = true,
    ["%d more manual waypoints after this one"] = true,
    ["Then the guide continues"] = true,
    ["Remove this waypoint"] = true,
    ["Remove all manual waypoints"] = true,
    ["Waypoint added: %s (%.1f, %.1f). The guide route continues from it."] = true,
    ["on the way"] = true,
    ["Waypoint removed."] = true,
    ["Then the guide continues from here"] = true,
})
QR:ExtendLocale("esES", {
    ["Manual waypoint"] = "Punto añadido a mano",
    ["Waypoint added: %s (%.1f, %.1f). It goes first."] = "Punto añadido: %s (%.1f, %.1f). Va el primero.",
    ["That spot can't be used as a waypoint (no world position)."] = "Ese sitio no sirve como punto (no tiene posición en el mundo).",
    ["You reached the manual waypoint."] = "Has llegado al punto añadido a mano.",
    ["%d more manual waypoints after this one"] = "%d puntos añadidos a mano más después de este",
    ["Then the guide continues"] = "Después sigue la guía",
    ["Remove this waypoint"] = "Quitar este punto",
    ["Remove all manual waypoints"] = "Quitar todos los puntos",
    ["Waypoint added: %s (%.1f, %.1f). The guide route continues from it."] = "Punto añadido: %s (%.1f, %.1f). La ruta de la guía sigue desde él.",
    ["on the way"] = "de paso",
    ["Waypoint removed."] = "Punto quitado.",
    ["Then the guide continues from here"] = "Después la guía sigue desde aquí",
})

-- Banner y aviso final de las guias que no son de zona
QR:ExtendLocale("enUS", {
    ["QUESTIEROUTER  /  CLASS GUIDE"] = true,
    ["QUESTIEROUTER  /  DUNGEON GUIDE"] = true,
    ["QUESTIEROUTER  /  OTHER GUIDES"] = true,
    ["Guide complete. Choose the next guide."] = true,
})
QR:ExtendLocale("esES", {
    ["QUESTIEROUTER  /  CLASS GUIDE"] = "QUESTIEROUTER  /  GUÍA DE CLASE",
    ["QUESTIEROUTER  /  DUNGEON GUIDE"] = "QUESTIEROUTER  /  GUÍA DE MAZMORRA",
    ["QUESTIEROUTER  /  OTHER GUIDES"] = "QUESTIEROUTER  /  OTRAS GUÍAS",
    ["Guide complete. Choose the next guide."] = "Guía completada. Elige la siguiente guía.",
})

-- /qr obs reset
QR:ExtendLocale("enUS", {
    ["Delete all recorded observations and notes? This can't be undone."] = true,
    ["Observations deleted."] = true,
})
QR:ExtendLocale("esES", {
    ["Delete all recorded observations and notes? This can't be undone."] = "¿Borrar todas las observaciones y notas apuntadas? No se puede deshacer.",
    ["Observations deleted."] = "Observaciones borradas.",
})

-- Boton del minimapa: clic izquierdo menu, clic derecho activar / desactivar, Mayus + clic opciones
QR:ExtendLocale("enUS", {
    ["|cffffd166Click|r: menu"] = true,
    ["|cffffd166Right-click|r: disable QuestieRouter"] = true,
    ["|cffffd166Right-click|r: enable QuestieRouter"] = true,
})
QR:ExtendLocale("esES", {
    ["|cffffd166Click|r: menu"] = "|cffffd166Clic|r: menú",
    ["|cffffd166Right-click|r: disable QuestieRouter"] = "|cffffd166Clic derecho|r: desactivar QuestieRouter",
    ["|cffffd166Right-click|r: enable QuestieRouter"] = "|cffffd166Clic derecho|r: activar QuestieRouter",
})

-- /qr wp
QR:ExtendLocale("enUS", {
    ["Manual waypoints: %d · world map hooked: %s · Shift + left click on the world map adds one (only it), Alt + left click adds one on the way (the guide route continues from it)."] = true,
    ["yes"] = true,
    ["no (open the world map once)"] = true,
})
QR:ExtendLocale("esES", {
    ["Manual waypoints: %d · world map hooked: %s · Shift + left click on the world map adds one (only it), Alt + left click adds one on the way (the guide route continues from it)."] = "Puntos añadidos a mano: %d · mapa del mundo enganchado: %s · Mayús + clic izquierdo en el mapa añade uno (solo él), Alt + clic izquierdo añade uno de paso (la ruta de la guía sigue desde él).",
    ["yes"] = "sí",
    ["no (open the world map once)"] = "no (abre el mapa una vez)",
})

-- Instalador, paso 3: iconos de las misiones en Questie
QR:ExtendLocale("enUS", {
    ["Questie quest icons"] = true,
    ["Choose how Questie shows quest objectives on the map and the minimap. You can change it later in Questie's options (Icons)."] = true,
    ["A different icon for each kind of objective: kill, loot, talk..."] = true,
    ["The game's own quest areas and markers. Questie does not draw objectives."] = true,
    ["Small dots with one color per quest: clean, and easy to tell which quest each one is for."] = true,
    ["pfQuest (Recommended)"] = true,
    ["Questie's icon options were not found: this step does nothing."] = true,
})
QR:ExtendLocale("esES", {
    ["Questie quest icons"] = "Iconos de las misiones en Questie",
    ["Choose how Questie shows quest objectives on the map and the minimap. You can change it later in Questie's options (Icons)."] = "Elige cómo muestra Questie los objetivos de las misiones en el mapa y el minimapa. Puedes cambiarlo luego en las opciones de Questie (Iconos).",
    ["A different icon for each kind of objective: kill, loot, talk..."] = "Un icono distinto para cada tipo de objetivo: matar, recoger, hablar...",
    ["The game's own quest areas and markers. Questie does not draw objectives."] = "Las zonas y marcadores de misión del propio juego. Questie no dibuja los objetivos.",
    ["Small dots with one color per quest: clean, and easy to tell which quest each one is for."] = "Puntos pequeños con un color por misión: limpio y se ve fácil de qué misión es cada uno.",
    ["pfQuest (Recommended)"] = "pfQuest (Recomendado)",
    ["Questie's icon options were not found: this step does nothing."] = "No se encuentran las opciones de iconos de Questie: este paso no hace nada.",
})
QR:ExtendLocale("deDE", { ["Questie quest icons"] = "Questsymbole in Questie", ["pfQuest (Recommended)"] = "pfQuest (Empfohlen)" })
QR:ExtendLocale("frFR", { ["Questie quest icons"] = "Icônes de quêtes de Questie", ["pfQuest (Recommended)"] = "pfQuest (Conseillé)" })
QR:ExtendLocale("ruRU", { ["Questie quest icons"] = "Значки заданий Questie", ["pfQuest (Recommended)"] = "pfQuest (Рекомендуется)" })

# QuestieRouter

Extensión de Questie: cuando enfocas una misión en el tracker de Questie (botón de foco), muestra

- una **flecha estilo TomTom** con nombre del objetivo y distancia,
- una **línea en el minimapa** del jugador hacia el objetivo (el icono flota en el borde si está lejos),
- una **línea en el mapa del mundo** del jugador al objetivo.

Si la misión está completa, el destino pasa a ser el NPC/objeto de entrega.

## Uso

1. Coge misiones como siempre.
2. En el tracker de Questie pulsa el botón de foco de la misión que quieres hacer.
3. Sigue la flecha. `/qr info` muestra el destino actual; `/qr help` lista los comandos.

## Guías por zona (`/qr guide`)

Archivos en `Zones/<Facción>/<Facción>_<Zona>_<min>-<max>.lua` (p. ej. `Alliance_ElwynnForest_1-12.lua`),
**generados** con `python tools/zone_guides.py` a partir de QuestieDB. La misión de entrada de cada zona
está fijada en `tools/data/zone_entries.json`.
Eliges una zona en la ventana y el addon te va llevando a coger, hacer y entregar todas sus misiones.

- **Zona de una misión** = donde está quien la da (las de Northshire caen en Elwynn).
- **Rango de niveles** = bloque principal de niveles (se corta por huecos de ≥4 niveles). Lo que se coge
  aquí pero es mucho más alto (p. ej. la cadena de Stalvan, nivel 28, en Elwynn) va a `later`.
- **Orden de la lista** = primero la misión de entrada a la zona, luego por nivel y, dentro del mismo nivel,
  por cercanía del NPC que la da a la misión anterior (y por ID si empatan), respetando siempre los requisitos previos.
- **Orden real (planificador, `Planner.lua`)**, recalculado en vivo:
  1. *Hub*: cualquier coger/entregar a <120 yd → el más cercano (vacía el hub antes de irte).
  2. *Campo*: el objetivo más cercano; si de camino hay un coger/entregar a <35 % de esa distancia, primero ese.
  3. Entregar lo que quede.
  4. *Siguiente hub*: la misión disponible con menor posición en la lista (de nivel bajo a alto).
  5. Si no queda nada: te dice a qué nivel se desbloquea la siguiente, o que la zona está terminada.
- No propone objetivos de misiones más de 3 niveles por encima, ni recoger con el registro lleno.
- Mayús+clic en una misión de la lista = saltarla.

## Guías de mazmorras

Archivos en `Dungeons/<Facción>/<Facción>_Dungeon_<Mazmorra>.lua`, **generados** con `python tools/dungeon_guides.py`:
una guía por mazmorra con sus misiones (las del área de la mazmorra en QuestieDB más la lista de
`tools/data/dungeon_quests.json`). Usan el mismo planificador que las de zona: te lleva a coger las misiones por el
mundo y, cuando lo que queda está dentro (objetivos, entregas o NPCs de dentro), a la **entrada** de la mazmorra
(`Data/Dungeons.lua`). Dentro de la instancia no hay flecha (el juego no da coordenadas); la lista de pasos dice
qué hacer, marcado «(dentro de …)».

## Apariencia (estilo "Round - Minimal" de Fusion)

Ventana sin marco, solo tarjetas redondeadas, en este orden:

1. **Tarjeta activa**: qué hacer ahora, con los nombres en color (enemigos en rojo, objetos en azul,
   NPC en verde), contadores (`Alimaña kóbold: 3/10`), «Te faltan 7 de 10», distancia y número de paso.
2. **Banner de la zona**: cielo panorámico que avanza con la hora del juego (día → atardecer → noche),
   estrellas de noche, luna en Tanaris, niebla al amanecer en zonas brumosas, ilustración de la zona,
   nombre de la zona, niveles, misiones hechas y reloj. Botones (zona, opciones, bloquear, cerrar)
   que aparecen al pasar el ratón.
3. **Pasos**: los últimos hechos (atenuados), el actual (resaltado, con barra de color) y los próximos.
   Los próximos salen de simular el planificador: coger por NPC → hacer por misión → entregar por NPC.
4. **Pie**: recuento y pestañas *Pasos* / *Misiones*.

**Sin guía elegida** la ventana muestra el banner de tu zona («Bienvenido a QuestieRouter / Elige una guía:»)
y las categorías: *Guías para completar zonas* (las únicas con contenido por ahora), *Speedrun*, *Mazmorras*
y *Profesiones* (próximamente). Al entrar en una categoría aparecen sus guías y una tarjeta «Atrás»;
al elegir una guía desaparece la navegación. **Clic derecho en la imagen** abre el menú: *Guías disponibles*
(con submenús; las zonas agrupadas por tramos de nivel), *Opciones…*, *Skin*, *Flecha*, *Lista de misiones*,
*Bloquear ventana*, *Reiniciar historial*, *Salir de la guía* y *Cerrar*.

**Flecha**: por defecto la «Brújula de arco»; en Opciones hay un desplegable con la vista previa de todas (HD de Fusion, RX, RX redonda, RX 3D prisma y bloque, y el paquete).
Debajo muestra la misión, lo que falta (`Alimaña kóbold 3/10`, o a quién coger/entregar) y la distancia;
dentro del área del objetivo (≤50 yd) cambia la distancia por «En la zona».

La **skin cambia según la zona** en la que estás (paleta y arte, con fundido de 2,5 s); también puede
seguir la zona de la guía o una zona fija. Sin guía elegida sale el selector «¿Qué zona quieres completar?»
con la ilustración de cada zona. `/qr options` abre las opciones gráficas: modo de skin, esquinas,
transparencias, alto del banner, estrellas/niebla/reloj, vista previa de la hora, fuente y tamaños,
ancho/alto, pasos hechos visibles y la flecha (18 estilos HD + clásica, color de zona, verde/rojo o materiales).

El material gráfico lo generan los scripts de `tools/media/` y `tools/icon/` (ver `Media/CREDITS.md`); la copia del anterior está en `backups/Media_2026-11-09/`.

## Rutas

- `/qr dungeon <nombre>`: ruta hasta la entrada de una mazmorra (`/qr dungeon stop` la quita).
- `/qr road add [x y]`: añade un punto a un camino de la zona (tu posición o coordenadas del mapa); `/qr road rec`
  graba un camino mientras andas; `new`, `undo`, `list`, `clear`. Los caminos propios se guardan en la configuración.

## Idiomas

La interfaz sale en el idioma del cliente si hay traducción; si no, en inglés. Los nombres de misiones,
NPCs y zonas los traducen Questie y el propio juego (siempre en el idioma del cliente).

- `/qr load_es`, `/qr load_en`, `/qr load_fr`, `/qr load_de`, `/qr load_ru`: carga la interfaz del
  addon en ese idioma (se guarda y recarga la interfaz). `/qr load_auto` vuelve al idioma del cliente.
- `/qr locale`: idioma activo y textos que faltan por traducir.
- Traducciones en `Locales/`: `enUS.lua` tiene **todas** las claves (el texto en inglés); cada idioma
  es un archivo `<código>.lua` que llama a `QR:RegisterLocale("<código>", { ["clave"] = "texto" })` y
  se añade a `Locales/Locales.xml`. En el código: `local L = QR.L` y `L["Turn in to %s"]`.
- Hoy: inglés y español (esES/esMX). Francés, alemán y ruso: pendientes (el ruso necesita una
  fuente con cirílico; LizeUI no lo tiene).

## Arquitectura

Carpetas: `Core/` (arranque, Questie, comandos), `Guide/` (qué hacer y adónde ir), `UI/` (lo que se ve),
`Navigation/` (flecha y líneas del mapa), `Locales/`, `Data/`, `Zones/` y `Media/`. El orden de carga está en el `.toc`.

| Archivo | Función |
|---|---|
| `Locales/` | Traducciones (`Locales.lua` núcleo, `enUS.lua` base con todas las claves, `esES.lua`...) |
| `Core/Core.lua` | Namespace, ajustes (`QuestieRouterDB`), bus de mensajes, arranque con `Questie.API.RegisterOnReady` |
| `Core/QuestieBridge.lua` | **Único** punto que toca internos de Questie (foco, `DistanceUtils`, `ZoneDB`, HereBeDragons) |
| `Guide/Target.lua` | Elige el destino (con histéresis para que no "salte" entre spawns) y emite `TARGET_CHANGED` |
| `Navigation/Arrow.lua` | Flecha giratoria |
| `Navigation/MapLines.lua` | Pines + líneas en mapa y minimapa (HereBeDragons-Pins de Questie) |
| `Guide/ZoneGuides.lua` | Registro de las guías de `Zones/` (solo las de tu facción) y guía recomendada |
| `Guide/Planner.lua` | Planificador coger → hacer → entregar por hubs |
| `UI/GuideUI.lua` | Ventana: tarjeta activa, banner, lista de pasos/misiones y pie |
| `UI/Skin.lua` | Zonas, detección, paleta por zona, fundidos, fuentes, tarjetas redondeadas, iconos |
| `UI/Banner.lua` | Banner con ciclo día/noche (cielo, estrellas, luna, niebla, ilustración, textos) |
| `Guide/Steps.lua` | Pasos agrupados, simulación del orden futuro e historial de lo hecho |
| `UI/ZonePicker.lua` | Selector de zona con miniaturas (`/qr pick`) |
| `UI/Options.lua` | Opciones gráficas (incluye la cuadrícula de flechas) |
| `UI/Menu.lua` | Menú contextual del clic derecho, con submenús |
| `Core/Slash.lua` | `/qr` (`guide`, `pick`, `options`, `zone <texto>`, `stop`, `info`...) |
| `Guide/Router.lua` | Viajes: ruta más rápida (vuelos, barcos, zepelines), ruta completa para el mapa y la lista, vuelo en curso |
| `UI/ActiveFrames.lua` | Ventanitas de Objetivo (bichos / NPC) y Objetos (objetos de misión) |
| `UI/MinimapButton.lua` | Botón del minimapa y de la lista de addons |
| `Data/` | Datos propios: red de viajes (`Travel.lua`), pasos entre zonas, tranvía y portales (`Borders.lua`), caminos dentro de las zonas (`Roads.lua`), entradas de mazmorras (`Dungeons.lua`) y paquete de flechas (`ArrowPack.lua`) |
| `Zones/` | Las guías por zona, generadas con `tools/zone_guides.py` |
| `Media/` | Imágenes, fuentes (`Media/Fonts/Fonts.xml`) y créditos |

## Ideas siguientes

- Objetivos: ir al centro del grupo de spawns más denso en vez de al spawn más cercano, y agrupar
  objetivos de varias misiones que están en la misma área.
- Al terminar una zona, proponer automáticamente la siguiente guía.
- Panel de opciones (AceConfig ya viene con Questie).

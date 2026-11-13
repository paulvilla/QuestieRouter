# Procedencia del material gráfico

Desde el 2026-11-09 casi todo lo que hay en `Media/` está **hecho por el proyecto**: lo dibujan los scripts de
`tools/media/` y `tools/icon/` (se puede volver a generar en cualquier momento). La copia de lo que había antes está en
`backups/Media_2026-11-09/` (fuera del addon; no se distribuye).

## Propio (generado por scripts)

| Carpeta / archivo | Script | Qué es |
|---|---|---|
| `Skies/*.blp` | `tools/media/make_skies.py` | Cielos del banner (tira día-noche de 2048x256). Nubes y estrellas propias. Del cielo anterior solo se tomó la gradación de color por hora (8x64 valores, muy difuminada) para que cada hora quede en su sitio. |
| `Ornaments/ZEPHRAS_ISLE.blp`, `Icons/Neutral.tga` | `tools/media/make_ornaments.py` | Ilustración de Zephras Isle y la neutra: paisaje por capas dibujado por código (las demás zonas usan las del autor, ver abajo). |
| `Sky/*.tga`, `Textures/*.tga`, `Icons/BodyWash.tga`, `ReflectionFade.tga`, `ScrollBar.tga`, `ScrollMarker.tga` | `tools/media/make_textures.py` | Máscaras redondeadas, aros, degradados, velos, aurora, estrellas, niebla y luna. |
| `Icons/UI/*.tga` | `tools/media/make_ui_icons.py`, `tools/icon/*` | Iconos de línea de la interfaz (más Boat, Gryphon y los de `logos/`, ver abajo). |
| `Icons/Actions/*.tga` | `tools/media/make_action_icons.py` | Iconos de acción (!, ?, espadas, bolsa, medalla, bocadillo, flecha, prohibido, xp, reloj, bandera). Los signos usan la fuente Barlow Bold (OFL). |
| `Arrows/<NN>-*.tga`, `ArrowMaterials/*.tga` | `tools/media/make_hd_arrows.py` | Flechas HD (sombra, contorno y relleno) y sus materiales. |
| `Arrows/RX/`, `Arrows/RXRound/` | `tools/icon/make_rx_arrow.py` | Flechas RX y RX redonda. |
| `Arrows/RXPrism/`, `Arrows/RXSlab/` | `tools/icon/make_3d_arrows.py` | Flechas 3D (hojas de 150 fotogramas) con renderizador propio. |
| `Lines/mapline.tga` | `tools/media/make_mapline.py` | Líneas del mapa: camino, burbujas, flechas y rayo. |
| `Icons/QuestieRouter*.tga` | `tools/icon/make_icon.py` | Icono del addon. |
| `Icons/UI/Boat.tga`, `Gryphon.tga` | `tools/icon/make_boat.py`, `make_gryphon.py` | Iconos de barco y grifo. |

Las texturas `.blp` se escriben con `tools/media/blp.py` (codificador BLP2 DXT1/DXT5 propio).

## Aportado por el autor del addon

- `Ornaments/*.blp` (50 zonas): ilustraciones de `imagenes/nuevos_Ornaments/` aportadas por el autor del addon,
  ajustadas a 1024x512 y pasadas a BLP con `tools/media/import_ornaments.py` (al Pantano de las Penas se le quita el
  cielo de color liso para dejarlo transparente).

- `Icons/UI/ScrollTop`, `Lock`, `Unlock`, `Cog` y `Menu`: iconos de la carpeta `logos/` del proyecto, pasados a
  blanco y 64x64 con `tools/icon/import_logos.py`.
- `Arrows/Pack/`: las 75 flechas de la carpeta `arrows/` del proyecto, giradas y renombradas con
  `tools/icon/import_arrow_pack.py` (que también genera `Data/ArrowPack.lua`). La «Flecha oficial» del paquete es la
  flecha de acción propia (`Icons/Actions/Action_arrow.tga`).

## Fuentes

- `Fonts/*-OFL.txt`: Barlow, Barlow Condensed, Fira Sans, Inter, Lato, Rajdhani y Source Sans 3, con licencia SIL OFL.
- `Fonts/LizeUI-*.ttf`: las fuentes del addon **LizeUI** (AvantGarde LT, comercial), renombradas por tipo. Se dejan a
  decisión del autor; revisar su licencia antes de publicar.

## Código de terceros

- Parte del código de la skin (paleta por zona, tarjetas, banner) está adaptado de **Fusion: RestedXP Skins**
  (licencia MIT, ver `LICENSE-FusionRestedXPSkins.txt`). Las imágenes de Fusion ya no se usan.

## Datos

`../Data/Travel.lua` (maestros de vuelo, rutas de vuelo, barcos, zepelines y dirigibles de WoW Forever)
se genera con `tools/travel_data.py` a partir de **OpenMap** (código MIT; datos de las tablas del juego).

`../Data/Borders.lua` (pasos a pie entre zonas: puertos, túneles, puentes, ascensores y puertas de ciudad)
se genera con `tools/zone_borders.py`. Los puntos de unión son geografía del juego; se tomaron de la tabla de
cruces de LibRover que trae **Zygor Guides Viewer (Forever)** (el código de LibRover es MIT; su tabla de datos no
lleva licencia). La lista de fronteras abiertas es propia. El addon no usa Zygor en el juego.
También de esa librería (`data_transit.lua`) salen el tranvía subterráneo y los portales que no dependen de
la clase (Rut'theran ↔ Darnassus, interiores de Dalaran), en `Borders.lua` (`links`).

`../Data/TaxiTimes.lua` (segundos de cada vuelo directo entre maestros de vuelo) se genera con
`tools/taxi_times.py`. Son medidas del juego tomadas una vez de la tabla de tiempos de LibTaxi que trae
**Zygor Guides Viewer (Forever)**; el addon no usa Zygor en el juego y lo que mide en tus vuelos tiene prioridad.

`../Data/Dungeons.lua` (entradas de mazmorras y bandas) se genera con `tools/travel_data.py` a partir de
**OpenMap** (código MIT; datos de las tablas del juego).

`../Data/Roads.lua` (caminos dentro de una zona) es propio, escrito a mano o grabado con `/qr road`.

## Misiones de las guías

`tools/data/zone_entries.json` fija la primera misión de cada guía de zona (71 IDs de misión). Se eligieron una vez
siguiendo el orden de las guías públicas de RestedXP; el resto del orden lo calcula `tools/zone_guides.py` con datos
de QuestieDB (nivel, cercanía y requisitos).

`tools/data/dungeon_quests.json` es una lista de IDs de misión por mazmorra, sacada una vez de las guías de mazmorras
de RestedXP (solo los IDs; no se copia ningún texto ni paso). Las guías (`../Dungeons/`) las genera
`tools/dungeon_guides.py` con esa lista más las misiones que QuestieDB tiene en el área de cada mazmorra.
El addon no usa nada de RestedXP en el juego.

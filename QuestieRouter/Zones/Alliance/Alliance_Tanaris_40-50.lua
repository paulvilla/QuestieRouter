-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Tanaris · niveles 40-50 · 111 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_Tanaris",
    faction = "Alliance",
    zone = "Tanaris",
    areaId = 440,
    minLevel = 40,
    maxLevel = 50,
    entry = { quest = 1690, areaId = 440, x = 52.46, y = 28.51 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 1690, 43, 40 }, -- Justicia para bandidos
        { 95144, 38, 36 }, -- Entrega de ultramar
        { 95321, 40, 1 }, -- La deuda de Tazzik
        { 95383, 40, 1 }, -- Envíos y portes
        { 1189, 41, 29 }, -- La seguridad primero
        { 1707, 44, 40 }, -- Cazador de bolsas de agua
        { 1878, 44, 40 }, -- Cazador de bolsas de agua
        { 1691, 44, 40 }, -- Más justicia para bandidos
        { 3520, 44, 40 }, -- Los espíritus de los estriadores
        { 2875, 45, 40 }, -- SE BUSCA: Andre Barbafuego
        { 8365, 45, 40 }, -- ¡Sombreros de pirata da babor!
        { 8366, 45, 40 }, -- Mamporros en el Mar del Sur
        { 2873, 45, 40 }, -- el Cargamento de Stoley
        { 2874, 45, 40 }, -- Un envío para MacKinley
        { 97536, 45, 40 }, -- Basura gnómica
        { 2865, 45, 40 }, -- Caparazones de escarabajo
        { 3042, 45, 40 }, -- Temple trol
        { 95753, 45, 1 }, -- Challenge of the Desert Wolf
        { 2876, 45, 40 }, -- El registro náutico
        { 2882, 45, 40 }, -- El oro de Cuergo
        { 992, 46, 38 }, -- Un estudio de agua de Gadgetzan
        { 2781, 46, 39 }, -- SE BUSCA: Caliph Escorpijón
        { 3527, 47, 40 }, -- La profecía de Mosh'aru
        { 97530, 47, 40 }, -- Machacadunas deudores
        { 3022, 47, 42 }, -- Un envío frágil
        { 2768, 47, 40 }, -- Cetro Divinomático
        { 82, 47, 39 }, -- Investigación en la Guarida Ponzoñosa
        { 10, 48, 39 }, -- La redención de Patagolpe
        { 110, 48, 39 }, -- Análisis de trozos de insecto
        { 113, 48, 39 }, -- Análisis de trozos de insecto
        { 2944, 48, 42 }, -- Superistánea FX
        { 3161, 48, 43 }, -- Gahz'rilo
        { 351, 48, 43 }, -- ¡Encontrar a OOX-17/TN!
        { 648, 48, 43 }, -- ¡Rescatar a OOX-17/TN!
        { 2605, 49, 44 }, -- El goblin sediento
        { 2606, 49, 44 }, -- Un buen sabor
        { 5863, 49, 44 }, -- El Territorio Machacaduna
        { 2641, 49, 44 }, -- El ingrediente secreto de Roxio
        { 2661, 49, 44 }, -- Un envío para Marin
        { 162, 49, 39 }, -- La sublevación de los silítidos
        { 2662, 49, 44 }, -- El elixir de Tragonublo
        { 3362, 50, 45 }, -- El Valle Cardizal
        { 4787, 50, 40 }, -- El huevo antiguo
        { 1560, 50, 40 }, -- La misión de Tooga
        { 97540, 50, 1 }, -- Oasis
        { 2954, 50, 45 }, -- El guardapiedras
        { 2977, 50, 45 }, -- El regreso a Forjaz
        { 3444, 51, 46 }, -- El Círculo de Piedras
        { 3446, 51, 46 }, -- En las profundidades
        { 3447, 51, 46 }, -- El secreto del círculo
        { 3913, 52, 47 }, -- Una situación mortal
        { 3914, 52, 47 }, -- La Espada de Linken
        { 4496, 53, 50 }, -- Que jungla tan chunga
        { 4324, 53, 48 }, -- Yuka Llavenrosca
        { 3528, 53, 40 }, -- El dios Hakkar
        { 4493, 53, 50 }, -- La marcha de los silítidos
        { 4504, 54, 48 }, -- Superpegajoso
        { 4507, 54, 50 }, -- El señuelo atrapa a la reina
        { 4508, 54, 50 }, -- La calma que precede a la tormenta
        { 5801, 57, 55 }, -- La forja del Penacho en Llamas
        { 5065, 58, 40 }, -- Las tablillas perdidas de Mosh'aru
        { 4788, 58, 40 }, -- Las últimas tablillas
        { 8181, 58, 40 }, -- La confrontación con Yeh'kinya
        { 8182, 58, 40 }, -- La mano de Rastakhan
        { 8576, 60, 60 }, -- La traducción del libro de contabilidad
        { 8577, 60, 60 }, -- Stewvul, ex mejor amigo
        { 8584, 60, 60 }, -- ¡Nunca me preguntes por mi negocio!
        { 8597, 60, 60 }, -- Dracónico para torpes
        { 8606, 60, 60 }, -- ¡Señuelo!
        { 8620, 60, 60 }, -- La única receta
        { 2741, 60, 42 }, -- El Superhuevomático
        { 8893, 47, 42 }, -- El Superhuevomático
        { 2750, 47, 42 }, -- Un huevo pasado
        { 2747, 60, 42 }, -- Un huevo muy especial
        { 2748, 60, 42 }, -- Un huevo de primera
        { 2749, 60, 42 }, -- Un huevo normal
        { 8921, 60, 58 }, -- El destilador ectoplásmico
        { 8924, 60, 58 }, -- Caza de ectoplasmas
        { 8925, 60, 58 }, -- Fuente de energía portátil
        { 8928, 60, 58 }, -- Un mercader sospechoso
        { 8977, 60, 58 }, -- Regresa junto a Deliana
        { 96912, 60, 1 }, -- Field of Honor: Week 1
        { 8585, 60, 60 }, -- La Isla del Terror
        { 8586, 60, 60 }, -- Pinchos quimerok potentes de Dirge
        { 8587, 60, 60 }, -- Regresa junto a Narain
        { 9268, 60, 40 }, -- Guerra en el mar
        { 8728, 60, 60 }, -- Buenas y malas noticias
        { 8729, 60, 60 }, -- La cólera de Neptulon
        { 8305, 60, 60 }, -- Recuerdos olvidados
        { 8555, 60, 60 }, -- Encomienda a los Vuelos
        { 8742, 60, 60 }, -- El poder de Kalimdor
        { 8747, 60, 60 }, -- El camino del protector
        { 8748, 60, 60 }, -- El camino del protector
        { 8749, 60, 60 }, -- El camino del protector
        { 8750, 60, 60 }, -- El camino del protector
        { 8751, 60, 60 }, -- El protector de Kalimdor
        { 8752, 60, 60 }, -- El camino del conquistador
        { 8753, 60, 60 }, -- El camino del conquistador
        { 8754, 60, 60 }, -- El camino del conquistador
        { 8755, 60, 60 }, -- El camino del conquistador
        { 8756, 60, 60 }, -- El conquistador qiraji
        { 8757, 60, 60 }, -- El camino del conjurador
        { 8758, 60, 60 }, -- El camino del conjurador
        { 8759, 60, 60 }, -- El camino del conjurador
        { 8760, 60, 60 }, -- El camino del conjurador
        { 8761, 60, 60 }, -- El gran convocador
        { 8764, 60, 60 }, -- Cambio de ruta: protector, nunca más
        { 8765, 60, 60 }, -- Cambio de ruta: convocador, nunca más
        { 8766, 60, 60 }, -- Cambio de ruta: conquistador, nunca más
        { 8599, 60, 60 }, -- Una canción de amor para Narain
        { 8922, 60, 58 }, -- Un artefacto sobrenatural
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

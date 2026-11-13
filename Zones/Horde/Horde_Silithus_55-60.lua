-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Silithus · niveles 55-60 · 128 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_Silithus",
    faction = "Horde",
    zone = "Silithus",
    areaId = 1377,
    minLevel = 55,
    maxLevel = 60,
    entry = { quest = 1125, areaId = 1377, x = 81.87, y = 18.93 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 1125, 55, 54 }, -- Los espíritus de Viento del Sur
        { 8277, 55, 54 }, -- Veneno mortal del desierto
        { 8280, 55, 54 }, -- Asegurar las rutas de suministros
        { 8276, 55, 54 }, -- La reconquista de Silithus
        { 1126, 57, 54 }, -- Una colmena en la torre
        { 6844, 57, 54 }, -- Umber, el archivista
        { 8278, 57, 54 }, -- La última esperanza de Noggle
        { 8281, 57, 54 }, -- Intensificar la seguridad
        { 8282, 58, 54 }, -- La cartera perdida de Noggle
        { 8284, 58, 54 }, -- El misterio del Crepúsculo
        { 8285, 59, 54 }, -- El desertor
        { 8283, 59, 54 }, -- Se busca: Pinzamorten el Terror de las arenas
        { 8332, 60, 60 }, -- Duques del Consejo
        { 8333, 60, 60 }, -- Medallón de estatus
        { 8341, 60, 60 }, -- Señores del Consejo
        { 8342, 60, 60 }, -- Anillo de nobleza Crepuscular
        { 8349, 60, 60 }, -- Bor Bravacrín
        { 8351, 60, 60 }, -- Bor quiere hablar contigo
        { 9248, 60, 58 }, -- Una humilde ofrenda
        { 8556, 60, 60 }, -- El anillo con sello de fuerza implacable  [clase]
        { 8697, 60, 60 }, -- El anillo de infinitia sabiduría  [clase]
        { 8698, 60, 60 }, -- El anillo de la inminente tormenta  [clase]
        { 8699, 60, 60 }, -- La sortija de secretos oscuros  [clase]
        { 8700, 60, 60 }, -- La sortija de vida inagotable  [clase]
        { 8701, 60, 60 }, -- La sortija de las sombras ocultas  [clase]
        { 8702, 60, 60 }, -- El anillo de los nombres prohibidos  [clase]
        { 8704, 60, 60 }, -- El anillo con sello de la senda oculta  [clase]
        { 9023, 60, 60 }, -- El veneno perfecto
        { 8557, 60, 60 }, -- El mantón de fuerza implacable  [clase]
        { 8689, 60, 60 }, -- El sayo de infinita sabiduría  [clase]
        { 8690, 60, 60 }, -- La capa de la inminente tormenta  [clase]
        { 8691, 60, 60 }, -- El mantón de secretos oscuros  [clase]
        { 8692, 60, 60 }, -- Capa de vida inagotable  [clase]
        { 8693, 60, 60 }, -- La capa de las sombras ocultas  [clase]
        { 8694, 60, 60 }, -- El sayo de los nombres prohibidos  [clase]
        { 8696, 60, 60 }, -- La capa de la senda oculta  [clase]
        { 8558, 60, 60 }, -- La hoz de fuerza implacable  [clase]
        { 8705, 60, 60 }, -- El mazo de infinita sabiduría  [clase]
        { 8706, 60, 60 }, -- El martillo de la tormenta inminente  [clase]
        { 8707, 60, 60 }, -- La espada de secretos oscuros  [clase]
        { 8708, 60, 60 }, -- La maza de vida inagotable  [clase]
        { 8709, 60, 60 }, -- La daga de las sombras ocultas  [clase]
        { 8710, 60, 60 }, -- El kris de los nombres prohibidos  [clase]
        { 8712, 60, 60 }, -- La guadaña de la Senda Oculta  [clase]
        { 8858, 60, 51 }, -- Los secretos de los Colosos: Regal
        { 8859, 60, 51 }, -- Los secretos de los Colosos: Zora
        { 8857, 60, 51 }, -- Los secretos de los Colosos: Ashi
        { 9416, 60, 1 }, -- Preséntate ante el general Kirika
        { 8286, 60, 60 }, -- Lo que nos depara el futuro
        { 8288, 60, 60 }, -- Solo uno puede alzarse
        { 8301, 60, 60 }, -- El buen camino
        { 8302, 60, 60 }, -- Una buena mano
        { 8303, 60, 60 }, -- Anacronos
        { 8731, 60, 60 }, -- Servicio de campo
        { 8800, 60, 60 }, -- Equipamiento de Cenarion
        { 9338, 60, 60 }, -- Lealtad al Círculo Cenarion
        { 8318, 60, 57 }, -- Mensajes secretos
        { 8319, 60, 57 }, -- Textos Crepusculares encriptados
        { 8348, 60, 60 }, -- Sellos de los Duques
        { 8352, 60, 60 }, -- Cetro del Consejo
        { 8361, 60, 60 }, -- Contactos Abisales
        { 8362, 60, 60 }, -- Emblemas Abisales
        { 8363, 60, 60 }, -- Sellos Abisales
        { 8364, 60, 60 }, -- Cetros Abisales
        { 8320, 60, 60 }, -- Geoseñores Crepusculares
        { 8321, 60, 60 }, -- Vyral el Vil
        { 8331, 60, 60 }, -- Aurel Hojaurea
        { 8343, 60, 60 }, -- El descubrimiento de Hojaurea
        { 8548, 60, 60 }, -- Equipamiento de Voluntario
        { 8572, 60, 60 }, -- Equipamiento de Veterano
        { 8573, 60, 60 }, -- Equipamiento de Campeón
        { 8574, 60, 60 }, -- Equipamiento de adepto
        { 8304, 60, 58 }, -- Queridísima Natalia
        { 8306, 60, 58 }, -- En las fauces de la locura
        { 8732, 60, 60 }, -- Documentación de instrucción de campo
        { 9422, 60, 1 }, -- Peinando el desierto
        { 8279, 60, 54 }, -- El Lexicón del Crepúsculo
        { 8323, 59, 54 }, -- El creyente verdadero
        { 8324, 59, 54 }, -- Seguir creyendo
        { 8287, 60, 54 }, -- Un propósito terrible
        { 8309, 60, 58 }, -- Los grabados de los glifos
        { 8310, 60, 58 }, -- Descifrar el código
        { 8314, 60, 58 }, -- Desentrañar el misterio
        { 8519, 60, 60 }, -- Un peón en el ajedrez de la vida
        { 8745, 60, 60 }, -- El tesoro del Atemporal
        { 8743, 60, 60 }, -- Golpear el gong
        { 8315, 60, 58 }, -- La llamada
        { 8316, 60, 58 }, -- Armamentos de guerra  [clase]
        { 8377, 60, 58 }, -- Armamentos de guerra  [clase]
        { 8378, 60, 58 }, -- Armamentos de guerra  [clase]
        { 8379, 60, 58 }, -- Armamentos de guerra  [clase]
        { 8380, 60, 58 }, -- Armamentos de guerra  [clase]
        { 8381, 60, 58 }, -- Armamentos de guerra  [clase]
        { 8382, 60, 58 }, -- Armamentos de guerra  [clase]
        { 8308, 60, 58 }, -- La carta perdida de Brann Barbabronce
        { 8498, 60, 60 }, -- Órdenes de batalla de Crepusculares
        { 8501, 60, 60 }, -- Objetivo: los aguijoneros de Colmen'Ashi
        { 8502, 60, 60 }, -- Objetivo: los trabajadores de Colmen'Ashi
        { 8534, 60, 60 }, -- Informe de exploración de Colmen'Zora
        { 8535, 60, 60 }, -- Templario vetusto
        { 8536, 60, 60 }, -- Templario de tierra
        { 8537, 60, 60 }, -- Templario carmesí
        { 8538, 60, 60 }, -- Los cuatro Duques
        { 8539, 60, 60 }, -- Objetivo: las hermanas de la colmena de Colmen'Zora
        { 8687, 60, 60 }, -- Objetivo: los tuneladores de Colmen'Zora
        { 8737, 60, 60 }, -- Templario azur
        { 8738, 60, 60 }, -- Informe de exploración de Colmen'Regal
        { 8739, 60, 60 }, -- Informe de exploración de Colmen'Ashi
        { 8740, 60, 60 }, -- Los merodeadores Crepusculares
        { 8770, 60, 60 }, -- Objetivo: los defensores de Colmen'Ashi
        { 8771, 60, 60 }, -- Objetivo: los acecharenas de Colmen'Ashi
        { 8772, 60, 60 }, -- Objetivo: los oteadores de Colmen'Zora
        { 8773, 60, 60 }, -- Objetivo: los atracadores de Colmen'Zora
        { 8774, 60, 60 }, -- Objetivo: los emboscadores de Colmen'Regal
        { 8775, 60, 60 }, -- Objetivo: los escupefuego de Colmen'Regal
        { 8776, 60, 60 }, -- Objetivo: los esclavizadores de Colmen'Regal
        { 8777, 60, 60 }, -- Objetivo: los hurgadores de Colmen'Regal
        { 8785, 60, 60 }, -- ¡La Legión de Orgrimmar necesita mojo!
        { 8786, 60, 60 }, -- Armas para el campo de batalla
        { 8787, 60, 60 }, -- Complementos para armadura para el campo de batalla
        { 8804, 60, 55 }, -- Material de supervivencia en el desierto
        { 8805, 60, 60 }, -- Botas para la guardia
        { 8806, 60, 60 }, -- Piedra de pulir para la guardia
        { 8807, 60, 60 }, -- Materiales de visión
        { 8808, 60, 60 }, -- Suministros para uniformes
        { 8809, 60, 60 }, -- Materiales encantados
        { 8810, 60, 60 }, -- Vendas para el campo de batalla
        { 8829, 60, 60 }, -- El último engaño
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

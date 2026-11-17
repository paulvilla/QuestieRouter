-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Duskwood · niveles 18-30 · 71 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_Duskwood",
    faction = "Alliance",
    zone = "Duskwood",
    areaId = 10,
    minLevel = 18,
    maxLevel = 30,
    entry = { quest = 226, areaId = 10, x = 7.71, y = 33.2 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 226, 21, 19 }, -- Con los lobos en los talones
        { 146, 18, 18 }, -- Mensajero a Villa Oscura
        { 163, 20, 17 }, -- Cerro del Cuervo
        { 5, 20, 17 }, -- La hambruna de Gato
        { 93, 20, 17 }, -- Las croquetas de cangrejo
        { 240, 20, 17 }, -- Entrega para Gato
        { 245, 21, 17 }, -- Las amenazas de ocho patas
        { 95161, 22, 15 }, -- Recuerda el amor que te tengo
        { 164, 23, 17 }, -- Entrega a Sven
        { 96139, 23, 18 }, -- La familia Valor
        { 56, 24, 18 }, -- Vigilancia nocturna
        { 148, 24, 20 }, -- Suministros de Villa Oscura
        { 149, 24, 20 }, -- Hilo de pelo de fantasma
        { 154, 24, 20 }, -- Devuelve el peine
        { 157, 24, 20 }, -- Devolver el pelo
        { 158, 24, 20 }, -- Zumo de zombi
        { 156, 24, 20 }, -- Busca flores podridas
        { 159, 24, 20 }, -- Entrega de zumo
        { 101, 25, 18 }, -- El Tótem de castigo
        { 165, 25, 17 }, -- El ermitaño
        { 174, 25, 20 }, -- Mira las estrellas
        { 175, 25, 20 }, -- Mira las estrellas
        { 177, 25, 20 }, -- Mira las estrellas
        { 95, 25, 20 }, -- La venganza de Sven
        { 230, 25, 20 }, -- El campamento de Sven
        { 262, 25, 20 }, -- La figura en las sombras
        { 265, 25, 20 }, -- La búsqueda de la figura continúa
        { 266, 25, 20 }, -- Busqueda en la posada
        { 453, 25, 20 }, -- Encuentra a la figura
        { 268, 25, 20 }, -- Entrega para Sven
        { 337, 25, 20 }, -- Un libro de Historia viejo
        { 377, 26, 22 }, -- Crimen y castigo
        { 57, 26, 18 }, -- Vigilancia nocturna
        { 133, 27, 20 }, -- Un espantapájaros para necrófagos
        { 323, 28, 20 }, -- Prueba de valor
        { 69, 28, 22 }, -- La leyenda de Stalvan
        { 79, 28, 22 }, -- La leyenda de Stalvan
        { 66, 28, 22 }, -- La leyenda de Stalvan
        { 173, 28, 23 }, -- Ferocanis en el bosque
        { 80, 28, 22 }, -- La leyenda de Stalvan
        { 67, 28, 22 }, -- La leyenda de Stalvan
        { 97, 28, 22 }, -- La leyenda de Stalvan
        { 72, 28, 22 }, -- La leyenda de Stalvan
        { 1243, 28, 28 }, -- El diplomático desaparecido
        { 325, 29, 20 }, -- Armado y listo
        { 221, 29, 23 }, -- Ferocanis en el bosque
        { 269, 29, 20 }, -- En busca de sabiduría
        { 134, 30, 20 }, -- Ladrones ogros
        { 160, 30, 20 }, -- Nota para el alcalde
        { 251, 30, 20 }, -- Traduce la nota de Abercrombie
        { 1042, 30, 25 }, -- La familia Carevin
        { 401, 30, 20 }, -- Espera a que Sirra acabe
        { 252, 30, 20 }, -- Una traducción para Ello
        { 58, 30, 18 }, -- Vigilancia nocturna
        { 253, 30, 20 }, -- La novia del embalsamador
        { 1244, 30, 28 }, -- El diplomático desaparecido
        { 1245, 30, 28 }, -- El diplomático desaparecido
        { 1043, 30, 25 }, -- La Guadaña de Elune
        { 1044, 30, 25 }, -- La respuesta a las preguntas
        { 181, 30, 20 }, -- Mira las estrellas
        { 96138, 30, 18 }, -- Arco de Merrick
        { 222, 31, 23 }, -- Ferocanis en el bosque
        { 223, 31, 23 }, -- Ferocanis en el bosque
        { 55, 32, 20 }, -- Morbent Vil
        { 225, 35, 28 }, -- La lápida desgastada
        { 254, 35, 20 }, -- Escavar la tierra
        { 227, 35, 28 }, -- Morgan Ladimor
        { 98, 35, 22 }, -- La leyenda de Stalvan
        { 228, 35, 28 }, -- Mor'Ladim
        { 229, 35, 28 }, -- La hija superviviente
        { 231, 35, 28 }, -- El amor de una hija
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 1395, 45, 40 }, -- Suministros para Nethergarde
        { 1477, 45, 40 }, -- Suministros de vital importancia
        { 98372, 60, 1 }, -- Un final desafortunado
    },
})

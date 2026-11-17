-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Loch Modan · niveles 10-20 · 45 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_LochModan",
    faction = "Alliance",
    zone = "Loch Modan",
    areaId = 38,
    minLevel = 10,
    maxLevel = 20,
    entry = { quest = 307, areaId = 38, x = 24.76, y = 18.4 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 307, 15, 9 }, -- Zarpas asquerosas
        { 6387, 10, 10 }, -- Estudiantes de honor
        { 86667, 10, 10 }, -- Recogida de nieve
        { 6391, 10, 10 }, -- Vuela a Forjaz
        { 6392, 10, 10 }, -- Vuelve con Brock
        { 416, 11, 10 }, -- Mata ratas
        { 418, 11, 7 }, -- Morcillas de Thelsamar
        { 267, 12, 10 }, -- La amenaza trogg
        { 224, 12, 10 }, -- En defensa de las tierras del rey
        { 1338, 14, 9 }, -- Un pedido de Pico Tormenta
        { 1339, 15, 9 }, -- El montaraz de Picos Tormenta
        { 237, 15, 10 }, -- En defensa de las tierras del rey
        { 263, 15, 10 }, -- En defensa de las tierras del rey
        { 298, 15, 10 }, -- Un informe sobre el avance de la excavación
        { 385, 15, 10 }, -- La caza de crocoliscos
        { 2038, 15, 12 }, -- Suministros de Bingles
        { 301, 15, 10 }, -- Informe a Forjaz
        { 302, 15, 10 }, -- Pólvora para Vetaferro
        { 2039, 15, 12 }, -- Encuentra a Bingles
        { 273, 15, 10 }, -- Aprovisionar la excavación
        { 454, 15, 10 }, -- Tras la emboscada
        { 309, 15, 10 }, -- Proteger el envío
        { 353, 15, 9 }, -- Una entrega a Pico Tormenta
        { 257, 16, 11 }, -- La fanfarronada de un cazador
        { 86758, 16, 12 }, -- Retorcer el cuchillo
        { 258, 17, 11 }, -- El reto de un cazador
        { 86585, 17, 10 }, -- Estandarte de los Caídos
        { 217, 17, 10 }, -- En defensa de las tierras del rey
        { 436, 18, 13 }, -- La excavación de Vetaferro
        { 297, 18, 13 }, -- Recoger ídolos
        { 250, 18, 16 }, -- Se aproxima una oscura amenaza
        { 278, 18, 16 }, -- Se aproxima una oscura amenaza
        { 280, 18, 16 }, -- Se aproxima una oscura amenaza
        { 199, 18, 16 }, -- Se aproxima una oscura amenaza
        { 161, 18, 16 }, -- Se aproxima una oscura amenaza
        { 86613, 18, 13 }, -- Herramientas de excavación
        { 255, 19, 15 }, -- Mercenarios
        { 86614, 20, 13 }, -- El plateado de las olas
        { 283, 20, 16 }, -- Se aproxima una oscura amenaza
        { 271, 20, 15 }, -- La venganza de Vyrin
        { 531, 20, 15 }, -- La venganza de Vyrin
        { 468, 21, 19 }, -- Preséntate ante el montaraz Rockgar
        { 455, 21, 19 }, -- El asedio de Algaz
        { 256, 22, 17 }, -- SE BUSCAN: Chok'sul
        { 467, 23, 20 }, -- La búsqueda de los Roscapiedra
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 79975, 32, 14 }, -- El puño del águila
        { 707, 37, 30 }, -- ¡Vetaferro te necesita!
        { 704, 38, 30 }, -- El sino de Agmond
        { 738, 38, 30 }, -- Encontrar a Agmond
        { 2500, 39, 36 }, -- Componentes de Tierras Inhóspitas
        { 17, 42, 38 }, -- Componentes de Uldaman
        { 3182, 48, 40 }, -- Certificado de autenticidad
        { 3201, 48, 40 }, -- ¡Al fin!
    },
})

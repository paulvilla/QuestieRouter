-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Hillsbrad Foothills · niveles 20-30 · 33 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_HillsbradFoothills",
    faction = "Alliance",
    zone = "Hillsbrad Foothills",
    areaId = 267,
    minLevel = 20,
    maxLevel = 30,
    entry = { quest = 564, areaId = 267, x = 52.42, y = 55.96 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 564, 34, 30 }, -- Una amenaza costosa
        { 98071, 27, 23 }, -- El oficio de cervecero
        { 98059, 27, 23 }, -- El tesoro de Trabalomas
        { 536, 30, 25 }, -- Al lo largo de la costa
        { 98219, 30, 20 }, -- Un teniente avergonzado
        { 555, 31, 28 }, -- Sopa de tortuga reconfortante
        { 559, 32, 25 }, -- La prueba de Farren
        { 560, 32, 25 }, -- La prueba de Farren
        { 561, 32, 25 }, -- La prueba de Farren
        { 562, 32, 25 }, -- Cambio de destino
        { 563, 32, 25 }, -- Nueva asignación
        { 98463, 33, 28 }, -- En boca de todos
        { 659, 33, 30 }, -- Sospechas de una nueva Peste
        { 505, 33, 26 }, -- Hermandad de asesinos
        { 92432, 33, 30 }, -- Una petición alarmante
        { 514, 34, 30 }, -- Una carta para Pico Tormenta
        { 565, 34, 29 }, -- Capa de piel de yeti de Bartolo
        { 525, 34, 30 }, -- Más misterios
        { 500, 36, 30 }, -- La recompensa Aplastacresta
        { 512, 36, 26 }, -- Nobles muertes
        { 538, 38, 20 }, -- Costasur
        { 540, 38, 20 }, -- Proteger el conocimiento
        { 542, 38, 20 }, -- Vuelve con Milton
        { 554, 40, 28 }, -- La descodificación de Pico Tormenta
        { 95787, 40, 30 }, -- Segunda prueba con el agua
        { 95788, 40, 30 }, -- La magia de la Ciudad Sumergida
        { 95798, 40, 30 }, -- Una red de magia
        { 95799, 40, 30 }, -- Descubrimientos para la Liga de Expedicionarios
        { 1053, 40, 34 }, -- En el nombre de la Luz
        { 504, 40, 30 }, -- Belicistas Aplastacresta
        { 523, 40, 30 }, -- Muerte al Barón
        { 537, 40, 30 }, -- Consejo oscuro
        { 99326, 40, 40 }, -- Your First Horse
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

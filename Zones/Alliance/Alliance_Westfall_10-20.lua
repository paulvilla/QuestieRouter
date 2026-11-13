-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Westfall · niveles 10-20 · 43 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_Westfall",
    faction = "Alliance",
    zone = "Westfall",
    areaId = 40,
    minLevel = 10,
    maxLevel = 20,
    entry = { quest = 64, areaId = 40, x = 59.95, y = 19.36 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 64, 12, 9 }, -- La reliquia olvidada
        { 184, 9, 8 }, -- La escritura de Furlbrow
        { 36, 10, 9 }, -- Estofado de los Páramos de Poniente
        { 6181, 10, 10 }, -- Mensajero a toda prisa
        { 6281, 10, 10 }, -- Prosigue hasta Ventormenta
        { 6285, 10, 10 }, -- Regresa con Lewis
        { 12, 12, 9 }, -- Las Milicias del Pueblo
        { 92742, 12, 9 }, -- Probar los pozos
        { 92744, 12, 9 }, -- Branquias de múrloc
        { 22, 12, 9 }, -- Pastel de hígado de dentosangre
        { 38, 13, 9 }, -- Estofado de los Páramos de Poniente
        { 98021, 13, 7 }, -- Viaje a la Colina del Centinela
        { 13, 14, 9 }, -- Las Milicias del Pueblo
        { 144, 14, 14 }, -- Mensajero a Villa Oscura
        { 102, 14, 8 }, -- En patrulla por Páramos de Poniente
        { 92745, 14, 9 }, -- El estado de las minas
        { 151, 14, 9 }, -- La pobre y vieja Blanchy
        { 9, 15, 8 }, -- Campos de la muerte
        { 92909, 15, 8 }, -- Cosechar a los cosechadores
        { 92747, 15, 9 }, -- Espionaje en Arroyo de la Luna
        { 153, 15, 10 }, -- Pañuelos rojos de cuero
        { 117, 15, 10 }, -- Cebatruenos
        { 93928, 15, 15 }, -- Of Mice and Milk
        { 103, 16, 10 }, -- Guardián de la Llama
        { 92748, 16, 9 }, -- Consultoría explosiva
        { 136, 16, 10 }, -- El tesoro escondido del capitán Sanders
        { 138, 16, 10 }, -- El tesoro escondido del capitán Sanders
        { 139, 16, 10 }, -- El tesoro escondido del capitán Sanders
        { 140, 16, 10 }, -- El tesoro escondido del capitán Sanders
        { 92752, 16, 9 }, -- Consultoría explosiva
        { 14, 17, 9 }, -- Las Milicias del Pueblo
        { 65, 18, 14 }, -- La hermandad de los Defias
        { 135, 18, 14 }, -- La hermandad de los Defias
        { 92753, 18, 9 }, -- Destrucción en las Minas de la Muerte
        { 92819, 18, 9 }, -- Destruction in Deadmines
        { 141, 18, 14 }, -- La hermandad de los Defias
        { 142, 18, 14 }, -- La hermandad de los Defias
        { 155, 18, 14 }, -- La hermandad de los Defias
        { 214, 17, 14 }, -- Pañuelos rojos de seda
        { 152, 19, 10 }, -- Hay moros en la costa
        { 104, 20, 15 }, -- La amenaza costera
        { 79008, 22, 14 }, -- y la nota que has encontrado...
        { 166, 22, 14 }, -- La hermandad de los Defias
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 68, 28, 22 }, -- La leyenda de Stalvan
        { 48, 44, 40 }, -- Dulce ámbar
        { 49, 44, 40 }, -- Dulce ámbar
        { 50, 44, 40 }, -- Dulce ámbar
        { 51, 44, 40 }, -- Dulce ámbar
        { 53, 44, 40 }, -- Dulce ámbar
    },
})

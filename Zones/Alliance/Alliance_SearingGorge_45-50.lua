-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Searing Gorge · niveles 45-50 · 29 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_SearingGorge",
    faction = "Alliance",
    zone = "Searing Gorge",
    areaId = 51,
    minLevel = 45,
    maxLevel = 50,
    entry = { quest = 7722, areaId = 51, x = 38.8, y = 28.51 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 7722, 50, 45 }, -- La receta del fluido ardiente
        { 81955, 45, 1 }, -- A Mind of Metal
        { 4449, 45, 43 }, -- Atrapado
        { 4450, 46, 43 }, -- El libro de contabilidad de Tanaris
        { 4451, 47, 43 }, -- La llave de la libertad
        { 3367, 48, 40 }, -- Piedras de Suntara
        { 3441, 48, 40 }, -- Castigo divino
        { 3442, 48, 40 }, -- La llama pura
        { 3443, 48, 40 }, -- Forjar el mango
        { 7728, 48, 45 }, -- OBJETOS ROBADOS: Tobera y espejo espía
        { 7729, 48, 45 }, -- OPORTUNIDAD LABORAL: Acabar con la competencia
        { 3368, 48, 40 }, -- Piedras de Suntara
        { 3181, 48, 40 }, -- El cuerno de la bestia
        { 7723, 49, 45 }, -- ¡Malditos dedos gordos!
        { 7724, 49, 45 }, -- Amenaza abrasadora
        { 7727, 49, 45 }, -- ¿Incendosaurio? Loqueseasaurio más bien
        { 7701, 50, 45 }, -- SE BUSCA: vigía Maltorius
        { 3377, 50, 40 }, -- Oración a Elune
        { 3378, 50, 40 }, -- Oración a Elune
        { 3452, 50, 40 }, -- El soporte para la llama
        { 3453, 50, 40 }, -- La Antorcha de Reprensión
        { 3454, 50, 40 }, -- La Antorcha de Reprensión
        { 3462, 50, 40 }, -- Escudero Maltrake
        { 7704, 50, 45 }, -- ¡Mira el tamaño de esto!
        { 3463, 52, 40 }, -- ¡Préndelas fuego!
        { 3481, 50, 40 }, -- Abalarios...
        { 3371, 55, 40 }, -- La justicia de los enanos
        { 3372, 52, 40 }, -- Libéralos
        { 3566, 52, 45 }, -- ¡Arriba, Obsidion!
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 7736, 60, 45 }, -- Fabricar fluido ardiente con sangrerregia
        { 7737, 60, 45 }, -- Ganarse el respeto
        { 7848, 60, 55 }, -- Armonización con el Núcleo
        { 8241, 60, 45 }, -- Fabricar fluido ardiente con hierro
        { 8242, 60, 45 }, -- Fabricar fluido ardiente con cuero pesado
    },
})

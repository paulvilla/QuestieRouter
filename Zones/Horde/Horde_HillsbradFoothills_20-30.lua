-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Hillsbrad Foothills · niveles 20-30 · 48 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_HillsbradFoothills",
    faction = "Horde",
    zone = "Hillsbrad Foothills",
    areaId = 267,
    minLevel = 20,
    maxLevel = 30,
    entry = { quest = 494, areaId = 267, x = 20.79, y = 47.4 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 494, 20, 19 }, -- El momento de atacar
        { 1065, 18, 13 }, -- Viaja a Molino Tarren
        { 496, 22, 19 }, -- Elixir del sufrimiento
        { 499, 22, 19 }, -- Elixir del sufrimiento
        { 549, 22, 17 }, -- SE BUSCA: Personal de la Hermandad
        { 498, 22, 17 }, -- El rescate
        { 1066, 23, 13 }, -- Sangre de inocentes
        { 1067, 23, 13 }, -- Vuelve a Cima del Trueno
        { 501, 24, 21 }, -- Elixir de dolor
        { 502, 24, 21 }, -- Elixir del dolor
        { 527, 24, 19 }, -- La batalla de Trabalomas
        { 528, 25, 19 }, -- La batalla de Trabalomas
        { 98094, 25, 19 }, -- Scout Support
        { 546, 25, 20 }, -- Recuerdos de muerte
        { 529, 26, 19 }, -- La batalla de Trabalomas
        { 532, 26, 19 }, -- La batalla de Trabalomas
        { 539, 28, 19 }, -- La batalla de Trabalomas
        { 567, 28, 19 }, -- ¡Atención!
        { 509, 28, 24 }, -- Elixir de agonía
        { 513, 28, 24 }, -- Elixir de agonía
        { 541, 30, 19 }, -- La batalla de Trabalomas
        { 547, 30, 26 }, -- La espada de Humbert
        { 515, 30, 24 }, -- Elixir de agonía
        { 517, 30, 24 }, -- Elixir de agonía
        { 524, 30, 24 }, -- Elixir de agonía
        { 676, 32, 30 }, -- La Sentencia
        { 550, 32, 19 }, -- La batalla de Trabalomas
        { 556, 32, 30 }, -- Muestras de piedra
        { 93680, 33, 30 }, -- Key to the City
        { 97287, 33, 24 }, -- Shrewd Negotiations
        { 96986, 33, 24 }, -- The Grave Knight
        { 552, 33, 29 }, -- La venganza de Helcular
        { 553, 33, 29 }, -- La venganza de Helcular
        { 533, 34, 29 }, -- Infiltración
        { 544, 34, 30 }, -- Colarse en la cárcel
        { 92434, 34, 30 }, -- Blood in the Streets
        { 557, 34, 30 }, -- Brazales de vínculo
        { 545, 35, 30 }, -- Las patrullas de Dalaran
        { 503, 36, 29 }, -- Gol'dir
        { 518, 39, 34 }, -- Corona de la Voluntad
        { 495, 39, 34 }, -- La Corona de la Voluntad
        { 566, 40, 35 }, -- SE BUSCA: Barón Vardus
        { 519, 41, 34 }, -- Corona de la Voluntad
        { 507, 42, 29 }, -- Lord Aliden Perenolde
        { 520, 43, 34 }, -- Corona de la Voluntad
        { 521, 43, 34 }, -- Corona de la Voluntad
        { 2934, 45, 40 }, -- Glándula de veneno intacta
        { 2935, 45, 40 }, -- Consulta al maestro Gadrin
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 2938, 55, 40 }, -- Veneno para Entrañas
    },
})

-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Ashenvale · niveles 18-30 · 33 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_Ashenvale",
    faction = "Horde",
    zone = "Ashenvale",
    areaId = 331,
    minLevel = 18,
    maxLevel = 30,
    entry = { quest = 6544, areaId = 331, x = 68.34, y = 75.3 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 6544, 24, 20 }, -- El asalto de Torek
        { 6545, 19, 17 }, -- Novedades del corredor Grito de Guerra
        { 6442, 19, 14 }, -- Naga en la Ensenada de Zoram
        { 6383, 20, 20 }, -- La Caza de Vallefresno
        { 235, 20, 20 }, -- La Caza de Vallefresno
        { 742, 20, 20 }, -- La Caza de Vallefresno
        { 6547, 21, 17 }, -- Novedades del explorador Grito de Guerra
        { 6563, 22, 17 }, -- La esencia de Aku'Mai
        { 6641, 23, 20 }, -- Vorsha la Azotadora
        { 98251, 23, 18 }, -- Never Coming Back
        { 98252, 23, 18 }, -- A Void Path
        { 6482, 24, 19 }, -- Liberar a Ruul
        { 216, 24, 21 }, -- Entre una roca y un Piel de Cardo
        { 6462, 24, 19 }, -- Los talismanes trols
        { 6503, 24, 19 }, -- Avanzada de Vallefresno
        { 23, 24, 20 }, -- La zarpa de Ursangous
        { 25, 25, 23 }, -- Paso del Espolón bloqueado
        { 6546, 25, 17 }, -- Novedades del escolta Grito de Guerra
        { 78132, 25, 15 }, -- Dragonslayer's Helm
        { 78133, 25, 15 }, -- Dragonslayer's Shield
        { 78134, 25, 15 }, -- Dragonslayer's Lance
        { 6441, 26, 21 }, -- Los cuernos de sátiro
        { 6621, 26, 21 }, -- El rey de los Corrupto
        { 6565, 26, 17 }, -- Lealtad a los dioses antiguos
        { 6921, 27, 21 }, -- Entre ruinas
        { 6581, 27, 22 }, -- Las hojas de sierra Grito de Guerra
        { 6571, 27, 22 }, -- Suministros Grito de Guerra
        { 24, 27, 20 }, -- La cabeza de Shadumbra
        { 1918, 27, 23 }, -- El elemento podrido
        { 824, 27, 23 }, -- Je'neu del Anillo de la Tierra
        { 6504, 30, 23 }, -- Las páginas perdidas
        { 2, 30, 20 }, -- La garra de Garrafilada
        { 247, 30, 20 }, -- El fin de la Caza
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

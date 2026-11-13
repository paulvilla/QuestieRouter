-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · The Hinterlands · niveles 40-50 · 29 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_TheHinterlands",
    faction = "Horde",
    zone = "The Hinterlands",
    areaId = 47,
    minLevel = 40,
    maxLevel = 50,
    entry = { quest = 2933, areaId = 47, x = 23.54, y = 58.8 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 2933, 43, 40 }, -- Botellas de veneno
        { 1444, 44, 38 }, -- Vuelve con Fel'Zerul
        { 2742, 47, 42 }, -- ¡Capturaron a Rin'ji!
        { 2782, 47, 42 }, -- El secreto de Rin'ji
        { 2995, 47, 42 }, -- Líneas de comunicación
        { 485, 48, 43 }, -- ¡Encuentra a OOX-09/HL!
        { 650, 48, 42 }, -- Recupera el calimocho
        { 77, 48, 42 }, -- Una situación peliaguda
        { 81, 48, 42 }, -- Entrega el calimocho
        { 836, 48, 43 }, -- ¡Rescata a OOX-09/HL!
        { 7844, 48, 44 }, -- Unos primos caníbales
        { 7841, 48, 44 }, -- Un mensaje para los Martillo Salvaje
        { 7842, 48, 44 }, -- Un nuevo mensaje para los Martillo Salvaje
        { 7828, 48, 44 }, -- Acechar a los acechadores
        { 7829, 48, 44 }, -- Cazar a los salvajes
        { 7830, 48, 44 }, -- Vengar a los Caídos
        { 7839, 48, 44 }, -- Los vándalos de Vilrama
        { 7816, 48, 44 }, -- Gammerita
        { 7840, 49, 44 }, -- Lard perdió su comida
        { 7850, 50, 46 }, -- Vasijas oscuras
        { 7849, 50, 46 }, -- Una separación angustiosa
        { 7843, 50, 44 }, -- Un mensaje final para los Martillo Salvaje
        { 7815, 50, 44 }, -- Los quijafortes
        { 7845, 51, 46 }, -- El secuestro del anciano Cuernorroto
        { 7861, 51, 46 }, -- Se busca: sacerdotisa vil Hexx y sus esbirros
        { 7862, 51, 46 }, -- Oferta de empleo: capitán de la guardia de Poblado Sañadiente
        { 7846, 51, 46 }, -- ¡Recupera la llave!
        { 7847, 51, 46 }, -- Vuelve con Primigenia Cuernorroto
        { 1446, 53, 38 }, -- El profeta Jammal'an
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

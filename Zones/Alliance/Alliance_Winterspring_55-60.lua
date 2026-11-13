-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Winterspring · niveles 55-60 · 54 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_Winterspring",
    faction = "Alliance",
    zone = "Winterspring",
    areaId = 618,
    minLevel = 55,
    maxLevel = 60,
    entry = { quest = 3909, areaId = 618, x = 31.27, y = 45.16 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 3909, 52, 47 }, -- El Elixir de Videre
        { 3912, 52, 47 }, -- Encuentro en la tumba
        { 6028, 52, 50 }, -- El informe Vista Eterna
        { 6030, 52, 50 }, -- El duque Nicolas Zverenhoff
        { 4809, 54, 50 }, -- Cuernos de quimera venfresco
        { 4810, 54, 50 }, -- Vuelve con Tinkee
        { 5601, 55, 50 }, -- Pamela, mi hermana
        { 6603, 56, 52 }, -- Problemas en Cuna del Invierno
        { 3783, 56, 52 }, -- Yeti... ¿ya hemos llegado?
        { 5244, 56, 53 }, -- Las ruinas de Kel'Theril
        { 5245, 56, 53 }, -- Espíritus condenados de Kel'Theril
        { 4842, 56, 51 }, -- Fuentes extrañas
        { 5082, 56, 52 }, -- La amenaza de los Nevada
        { 5086, 56, 52 }, -- Horrores tóxicos
        { 5083, 56, 52 }, -- Piroagua Nevada
        { 5084, 56, 52 }, -- Sucumbir a la corrupción
        { 8471, 56, 50 }, -- Tótem ritual Nevada
        { 5087, 57, 52 }, -- Corredores Nevada
        { 8464, 58, 45 }, -- Actividad de los Nevada
        { 8469, 56, 50 }, -- Cuentas para Salfa
        { 5252, 58, 53 }, -- Altonato arrepentido
        { 977, 58, 52 }, -- Yeti... ¿ya hemos llegado?
        { 5163, 58, 52 }, -- Yeti... ¿ya hemos llegado?
        { 5253, 58, 53 }, -- El cristal de Zin-Malor
        { 4861, 59, 53 }, -- Lechúcico iracundo
        { 6604, 59, 53 }, -- Lechúcico iracundo
        { 4901, 59, 52 }, -- Guardianes del altar
        { 4863, 59, 53 }, -- Lechúcico salvaje iracundo
        { 4864, 59, 53 }, -- Lechúcico iracundo
        { 5121, 59, 52 }, -- Alto Jefe Nevada
        { 5123, 59, 52 }, -- La pieza final
        { 5128, 59, 52 }, -- Palabras del Gran Jefe
        { 5161, 60, 57 }, -- La cólera del Vuelo Azul
        { 5162, 60, 57 }, -- La cólera del Vuelo Azul
        { 9266, 60, 40 }, -- Enmendar los errores
        { 5063, 60, 57 }, -- Almete del Sabio Escarlata
        { 5067, 60, 57 }, -- Leotardos de Arcana
        { 5068, 60, 57 }, -- Coraza Sed de Sangre
        { 6606, 60, 55 }, -- Un poco de suerte
        { 4907, 60, 57 }, -- Tinkee Vaporino
        { 969, 60, 55 }, -- Que la suerte sea contigo
        { 975, 60, 55 }, -- Alijo de Mau'ari
        { 4801, 60, 55 }, -- E'ko de Sable de Hielo
        { 4802, 60, 55 }, -- E'ko de los Nevada
        { 4803, 60, 55 }, -- E'ko de los dentoesquirla
        { 4804, 60, 55 }, -- E'ko de los venfresco
        { 4805, 60, 55 }, -- E'ko de los Cardo Nevado
        { 4806, 60, 55 }, -- E'ko de los Machacahielo
        { 4807, 60, 55 }, -- E'ko de lechúcico salvaje
        { 4970, 60, 58 }, -- Provisiones Sable de hielo
        { 5201, 60, 58 }, -- Intrusión Nevada
        { 5981, 60, 58 }, -- Gigantes arrasadores
        { 6501, 60, 50 }, -- El Ojo del dragón
        { 6502, 60, 50 }, -- Amuleto Pirodraco
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

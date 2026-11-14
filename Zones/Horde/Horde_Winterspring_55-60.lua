-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Winterspring · niveles 55-60 · 54 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_Winterspring",
    faction = "Horde",
    zone = "Winterspring",
    areaId = 618,
    minLevel = 55,
    maxLevel = 60,
    entry = { quest = 5082, areaId = 618, x = 31.27, y = 45.16 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 5082, 56, 52 }, -- La amenaza de los Nevada
        { 3909, 52, 47 }, -- El Elixir de Videre
        { 3912, 52, 47 }, -- Encuentro en la tumba
        { 6029, 52, 50 }, -- El informe Vista Eterna
        { 6030, 52, 50 }, -- El duque Nicolas Zverenhoff
        { 4809, 54, 50 }, -- Cuernos de quimera venfresco
        { 4810, 54, 50 }, -- Vuelve con Tinkee
        { 6605, 54, 49 }, -- Algo extraño
        { 5601, 55, 50 }, -- Pamela, mi hermana
        { 93406, 56, 1 }, -- Unfrozen Deliveries
        { 5054, 56, 53 }, -- Ursius de los dentoesquirla
        { 6603, 56, 52 }, -- Problemas en Cuna del Invierno
        { 3783, 56, 52 }, -- Yeti... ¿ya hemos llegado?
        { 92009, 56, 1 }, -- Crate Expectations
        { 4842, 56, 51 }, -- Fuentes extrañas
        { 5086, 56, 52 }, -- Horrores tóxicos
        { 5083, 56, 52 }, -- Piroagua Nevada
        { 5084, 56, 52 }, -- Sucumbir a la corrupción
        { 8471, 56, 50 }, -- Tótem ritual Nevada
        { 5087, 57, 52 }, -- Corredores Nevada
        { 8464, 58, 45 }, -- Actividad de los Nevada
        { 8469, 56, 50 }, -- Cuentas para Salfa
        { 977, 58, 52 }, -- Yeti... ¿ya hemos llegado?
        { 5163, 58, 52 }, -- Yeti... ¿ya hemos llegado?
        { 5055, 58, 53 }, -- Brumeran de los Venfresco
        { 93269, 58, 1 }, -- Top of the Post
        { 97264, 58, 55 }, -- Shardtooth Pulling
        { 5121, 59, 52 }, -- Alto Jefe Nevada
        { 4882, 59, 52 }, -- Guardar un secreto
        { 5123, 59, 52 }, -- La pieza final
        { 5128, 59, 52 }, -- Palabras del Gran Jefe
        { 97403, 59, 55 }, -- Two-Headed Ravagers
        { 97404, 59, 55 }, -- Too Bad to Bear
        { 5161, 60, 57 }, -- La cólera del Vuelo Azul
        { 5162, 60, 57 }, -- La cólera del Vuelo Azul
        { 9266, 60, 40 }, -- Enmendar los errores
        { 5063, 60, 57 }, -- Almete del Sabio Escarlata
        { 5067, 60, 57 }, -- Leotardos de Arcana
        { 5068, 60, 57 }, -- Coraza Sed de Sangre
        { 4907, 60, 57 }, -- Tinkee Vaporino
        { 5056, 60, 53 }, -- Shy-Rotam
        { 5057, 60, 53 }, -- Esfuerzos del pasado
        { 969, 60, 55 }, -- Que la suerte sea contigo
        { 975, 60, 55 }, -- Alijo de Mau'ari
        { 4801, 60, 55 }, -- E'ko de Sable de Hielo
        { 4802, 60, 55 }, -- E'ko de los Nevada
        { 4803, 60, 55 }, -- E'ko de los dentoesquirla
        { 4804, 60, 55 }, -- E'ko de los venfresco
        { 4805, 60, 55 }, -- E'ko de los Cardo Nevado
        { 4806, 60, 55 }, -- E'ko de los Machacahielo
        { 4807, 60, 55 }, -- E'ko de lechúcico salvaje
        { 97490, 60, 1 }, -- Halt the Hail
        { 92859, 60, 1 }, -- Shroud of the Winter Wilds
        { 98462, 60, 1 }, -- Shroud of the Winter Wilds
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Feralas · niveles 40-50 · 48 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_Feralas",
    faction = "Alliance",
    zone = "Feralas",
    areaId = 357,
    minLevel = 40,
    maxLevel = 50,
    entry = { quest = 2821, areaId = 357, x = 30.63, y = 42.71 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 2821, 46, 40 }, -- La marca de la calidad
        { 92858, 43, 39 }, -- SE BUSCA: Ohk'zi
        { 4124, 43, 40 }, -- El mensajero desaparecido
        { 2866, 43, 40 }, -- Las Ruinas de Solarsal
        { 4125, 43, 40 }, -- El mensajero desaparecido
        { 2867, 43, 40 }, -- Regresa al Bastión Plumaluna
        { 3130, 43, 40 }, -- En contra de los Crestafuria
        { 2869, 43, 40 }, -- En contra de los Crestafuria
        { 2982, 44, 39 }, -- Las Altas Tierras Salvajes
        { 4127, 44, 40 }, -- Los restos del bote
        { 4129, 44, 40 }, -- La revelación del cuchillo
        { 4130, 44, 40 }, -- Lectura psicométrica
        { 4131, 44, 40 }, -- Los gnolls Zarpaleña
        { 4281, 44, 40 }, -- Una entrega en Thalanaar
        { 2870, 45, 40 }, -- En contra del Señor Shalzaru
        { 2871, 45, 40 }, -- Entrega la reliquia
        { 2766, 45, 40 }, -- ¡Encuentra a OOX-22/FE!
        { 2767, 45, 40 }, -- ¡Escolta a OOX-22/FE!
        { 4135, 46, 40 }, -- Las Entrañas Retorcidas
        { 4265, 46, 40 }, -- Liberado de la colmena
        { 4266, 46, 40 }, -- La bienvenida de un héroe
        { 4267, 46, 40 }, -- El alzamiento de los silítidos
        { 2939, 47, 42 }, -- La búsqueda del conocimiento
        { 2969, 47, 38 }, -- Libertad para todas las criaturas
        { 2970, 47, 38 }, -- La justicia del castigo
        { 2972, 47, 38 }, -- La justicia del castigo
        { 3841, 47, 38 }, -- Un huérfano que busca un hogar
        { 7003, 48, 45 }, -- Gigantes reducidos
        { 7721, 48, 45 }, -- Combustible para el Ultra-reductor
        { 7733, 48, 40 }, -- Calidad mejorada
        { 7735, 48, 40 }, -- Pellejo de yeti prístino
        { 2844, 49, 44 }, -- El guardián gigante
        { 2845, 49, 44 }, -- Las andanzas de Shay
        { 3788, 50, 47 }, -- La petición de Jonguja
        { 3791, 50, 47 }, -- El misterio de mañagrana
        { 2879, 50, 42 }, -- El Bastón de Equinex
        { 2942, 50, 42 }, -- La Piedra del mañana
        { 3787, 50, 47 }, -- La petición de Jonguja
        { 3445, 51, 46 }, -- El Templo Sumergido
        { 4041, 52, 47 }, -- El Elixir de Videre
        { 4143, 52, 47 }, -- Bruma del mal
        { 7725, 55, 45 }, -- Encoge más gigantes
        { 7726, 55, 45 }, -- Más combustible para el Ultra-reductor
        { 3792, 55, 47 }, -- Mañagrana a Bastión Plumaluna
        { 7494, 57, 54 }, -- Bastión Plumaluna
        { 7488, 57, 54 }, -- La Membrana de Lethtendris
        { 7441, 58, 54 }, -- Pusillín y el ancestro Azj'Tordin
        { 7482, 60, 54 }, -- Leyendas élficas
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

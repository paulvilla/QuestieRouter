-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Feralas · niveles 40-50 · 45 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_Feralas",
    faction = "Horde",
    zone = "Feralas",
    areaId = 357,
    minLevel = 40,
    maxLevel = 50,
    entry = { quest = 2975, areaId = 357, x = 75.8, y = 43.58 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 2975, 43, 38 }, -- Los ogros de Feralas
        { 2862, 42, 39 }, -- En guerra con los Zarpaleña
        { 2863, 43, 39 }, -- Ataca a los Alfas
        { 2902, 43, 39 }, -- Investiga a los Zarpaleña
        { 92878, 43, 36 }, -- Sin palabras
        { 2987, 43, 38 }, -- El cobalto Gordunni
        { 2903, 43, 39 }, -- Los planes de batalla de los Zarpaleña
        { 2978, 43, 38 }, -- El pergamino Gordunni
        { 2981, 43, 38 }, -- Una amenaza en Feralas
        { 2980, 44, 38 }, -- Los ogros de Feralas
        { 2973, 45, 38 }, -- Una capa nueva
        { 2974, 45, 38 }, -- Un descubrimiento siniestro
        { 2976, 45, 37 }, -- Un descubrimiento siniestro
        { 7730, 45, 39 }, -- Infestación de Zukk'ash
        { 3121, 45, 40 }, -- Una extraña petición
        { 2766, 45, 40 }, -- ¡Encuentra a OOX-22/FE!
        { 2767, 45, 40 }, -- ¡Escolta a OOX-22/FE!
        { 3122, 45, 40 }, -- Vuelve con el médico brujo Uzer'i
        { 2822, 46, 40 }, -- La marca de la calidad
        { 2979, 46, 38 }, -- Una ceremonia oscura
        { 3002, 47, 38 }, -- El orbe Gordunni
        { 3123, 47, 40 }, -- Probar la vasija
        { 3124, 47, 40 }, -- Hipogrifos muisek
        { 3125, 45, 40 }, -- Dragones feéricos muisek
        { 7731, 47, 39 }, -- Aguijolatigador
        { 7732, 48, 39 }, -- El informe Zukk'ash
        { 7734, 48, 40 }, -- Calidad mejorada
        { 7003, 48, 45 }, -- Gigantes reducidos
        { 7721, 48, 45 }, -- Combustible para el Ultra-reductor
        { 7738, 48, 40 }, -- Pellejo de yeti perfecto
        { 3126, 50, 40 }, -- Antárboles muisek
        { 3127, 50, 40 }, -- Gigantes de montaña muisek
        { 3128, 50, 40 }, -- Materiales naturales
        { 3129, 50, 40 }, -- Armas del espíritu
        { 3062, 50, 45 }, -- Negro corazón
        { 3063, 50, 45 }, -- Vengarse de las Nortearroyo
        { 3380, 51, 46 }, -- El Templo Sumergido
        { 4120, 52, 47 }, -- La fuerza de la corrupción
        { 4041, 52, 47 }, -- El Elixir de Videre
        { 7725, 55, 45 }, -- Encoge más gigantes
        { 7726, 55, 45 }, -- Más combustible para el Ultra-reductor
        { 7489, 57, 54 }, -- La Membrana de Lethtendris
        { 7492, 57, 54 }, -- Campamento Mojache
        { 7441, 58, 54 }, -- Pusillín y el ancestro Azj'Tordin
        { 7481, 60, 54 }, -- Leyendas élficas
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

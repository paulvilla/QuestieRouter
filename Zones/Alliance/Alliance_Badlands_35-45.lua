-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Badlands · niveles 35-45 · 32 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_Badlands",
    faction = "Alliance",
    zone = "Badlands",
    areaId = 3,
    minLevel = 35,
    maxLevel = 45,
    entry = { quest = 719, areaId = 3, x = 53.42, y = 43.39 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 719, 35, 35 }, -- Un enanos y sus herramientas
        { 720, 35, 35 }, -- Un signo de esperanza
        { 721, 35, 35 }, -- Un signo de esperanza
        { 2418, 36, 30 }, -- Las piedras de energía
        { 705, 37, 30 }, -- La pesca de perlas
        { 710, 37, 35 }, -- Estudio de los elementos: roca
        { 713, 37, 35 }, -- Mantener la cabeza fría
        { 714, 37, 35 }, -- Un giro... ¿Qué?
        { 715, 37, 35 }, -- Piedra líquida
        { 718, 38, 35 }, -- Espejismos
        { 1108, 39, 28 }, -- Indurio
        { 1137, 38, 28 }, -- Noticias para Fizzle
        { 711, 39, 35 }, -- Estudio de los elementos: roca
        { 703, 40, 33 }, -- Alas de águila ratonera a la parrilla
        { 733, 40, 35 }, -- ¡A gorronear!
        { 709, 40, 30 }, -- La solución a la maldición
        { 727, 40, 30 }, -- Ir a Forjaz a buscar el "Compendio" de Yagyin
        { 722, 40, 35 }, -- El amuleto de los secretos
        { 723, 40, 35 }, -- Tener fe en el porvenir
        { 724, 40, 35 }, -- Tener fe en el porvenir
        { 687, 40, 30 }, -- Theldurin, el perdido
        { 737, 40, 30 }, -- El saber prohibido
        { 708, 40, 30 }, -- La caja negra
        { 692, 41, 30 }, -- Los fragmentos perdidos
        { 739, 42, 30 }, -- Murdaloc
        { 712, 42, 35 }, -- Estudio de los elementos: roca
        { 734, 42, 35 }, -- Lo tienes crudo
        { 716, 42, 35 }, -- Es mejor la piedra que la tela
        { 777, 42, 35 }, -- Lo tienes crudo
        { 732, 43, 40 }, -- Terremotos
        { 706, 45, 40 }, -- Encantamientos de fuego abrasador
        { 778, 45, 35 }, -- Lo tienes crudo
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 656, 50, 30 }, -- Invocar a la princesa
        { 717, 50, 40 }, -- Terremotos
        { 779, 50, 40 }, -- El Sello de la Tierra
    },
})

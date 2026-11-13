-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Badlands · niveles 35-45 · 28 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_Badlands",
    faction = "Horde",
    zone = "Badlands",
    areaId = 3,
    minLevel = 35,
    maxLevel = 45,
    entry = { quest = 782, areaId = 3, x = 2.91, y = 45.6 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 782, 43, 40 }, -- Alianzas rotas
        { 2418, 36, 30 }, -- Las piedras de energía
        { 705, 37, 30 }, -- La pesca de perlas
        { 710, 37, 35 }, -- Estudio de los elementos: roca
        { 713, 37, 35 }, -- Mantener la cabeza fría
        { 714, 37, 35 }, -- Un giro... ¿Qué?
        { 715, 37, 35 }, -- Piedra líquida
        { 711, 39, 35 }, -- Estudio de los elementos: roca
        { 1108, 39, 28 }, -- Indurio
        { 1137, 38, 28 }, -- Noticias para Fizzle
        { 2258, 39, 36 }, -- Componentes de Tierras Inhóspitas
        { 1419, 40, 30 }, -- Ladrones coyote
        { 1420, 40, 30 }, -- Un informe para Helgrum
        { 703, 40, 33 }, -- Alas de águila ratonera a la parrilla
        { 709, 40, 30 }, -- La solución a la maldición
        { 728, 40, 30 }, -- Ir a Entrañas a buscar el "Compendio" de Yagyin
        { 737, 40, 30 }, -- El saber prohibido
        { 692, 41, 30 }, -- Los fragmentos perdidos
        { 712, 42, 35 }, -- Estudio de los elementos: roca
        { 734, 42, 35 }, -- Lo tienes crudo
        { 716, 42, 35 }, -- Es mejor la piedra que la tela
        { 777, 42, 35 }, -- Lo tienes crudo
        { 2202, 42, 36 }, -- Componentes de Uldaman
        { 2338, 42, 37 }, -- La traducción del diario
        { 2339, 44, 37 }, -- Encuentra las gemas y la fuente de poder
        { 2340, 44, 37 }, -- Entregar las gemas
        { 2341, 44, 40 }, -- La recuperación del collar, 3ª parte
        { 778, 45, 35 }, -- Lo tienes crudo
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 656, 50, 30 }, -- Invocar a la princesa
        { 793, 50, 40 }, -- Alianzas rotas
        { 3821, 52, 48 }, -- Roca Machacamiedo
        { 3906, 52, 48 }, -- La discordia de las llamas
        { 3981, 52, 48 }, -- Comandante Gor'shak
        { 4081, 52, 48 }, -- MATAR INMEDIATAMENTE: enanos Hierro Negro
        { 4061, 54, 52 }, -- La revuelta de las máquinas
        { 4062, 54, 52 }, -- La revuelta de las máquinas
        { 4082, 54, 50 }, -- MATAR INMEDIATAMENTE: oficiales Hierro Negro de alto rango
        { 7201, 54, 48 }, -- El último elemento
        { 795, 55, 40 }, -- El Sello de la Tierra
        { 4133, 55, 50 }, -- Vivian Latumba
        { 4134, 55, 50 }, -- La receta perdida de Cebatruenos
        { 3907, 56, 48 }, -- La discordia de las llamas
        { 4063, 58, 52 }, -- La revuelta de las máquinas
        { 4122, 58, 52 }, -- Grark Lorkrub
        { 4132, 58, 52 }, -- Operación: muerte a Forjainquina
        { 4724, 59, 55 }, -- La maestra de la manada
        { 4981, 59, 55 }, -- La espía Bijou
        { 4768, 60, 57 }, -- La tablilla de Rocanegra
        { 4769, 60, 57 }, -- Vivian Latumba y la tablilla de Rocanegra
        { 4903, 60, 55 }, -- La orden del Señor de la Guerra
        { 4941, 60, 55 }, -- La sabiduría de Eitrigg
    },
})

-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Dustwallow Marsh · niveles 35-45 · 30 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_DustwallowMarsh",
    faction = "Alliance",
    zone = "Dustwallow Marsh",
    areaId = 15,
    minLevel = 35,
    maxLevel = 45,
    entry = { quest = 1265, areaId = 15, x = 68.02, y = 48.71 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 1265, 35, 28 }, -- El diplomático desaparecido
        { 1282, 35, 30 }, -- Lo llaman Jim Sonrisas
        { 1218, 35, 30 }, -- Especias calmantes
        { 1206, 35, 30 }, -- Jarl necesita ojos
        { 1203, 35, 30 }, -- Jarl necesita una espada
        { 81570, 35, 30 }, -- Jarl Needs a Blade
        { 1219, 35, 30 }, -- El informe orco
        { 1220, 35, 30 }, -- Capitán Vimes
        { 1284, 35, 30 }, -- Huellas pezuñales sospechosas
        { 1253, 35, 30 }, -- El escudo negro
        { 1319, 35, 30 }, -- El escudo negro
        { 1320, 35, 30 }, -- El escudo negro
        { 1266, 36, 28 }, -- El diplomático desaparecido
        { 1177, 36, 32 }, -- ¡Qué hambre!
        { 1222, 37, 30 }, -- La fuga de Apestoso
        { 1324, 38, 28 }, -- El diplomático desaparecido
        { 1204, 38, 33 }, -- Sopa de fangorroca con tropezones
        { 1267, 38, 28 }, -- El diplomático desaparecido
        { 1260, 38, 33 }, -- Morgan Stern
        { 1252, 40, 30 }, -- Teniente Paval Reethe
        { 1258, 40, 33 }, -- ... con tropezones
        { 1259, 40, 30 }, -- Teniente Paval Reethe
        { 1285, 38, 30 }, -- Los hombres de Daelin
        { 1286, 38, 30 }, -- Los desertores
        { 7070, 42, 39 }, -- Fragmentos Oscuros
        { 98231, 44, 1 }, -- Ingrediente activo
        { 98205, 44, 1 }, -- ¡Las crías son lo peor!
        { 98215, 44, 1 }, -- Escamas de dragón y colas chamuscadas
        { 2846, 46, 40 }, -- Tiara de la Profundidad
        { 2861, 46, 40 }, -- La tarea de Tabetha
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 626, 51, 35 }, -- El enigma de Cortello
        { 95194, 53, 48 }, -- Our Man in Theramore
    },
})

-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Dustwallow Marsh · niveles 35-45 · 33 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_DustwallowMarsh",
    faction = "Horde",
    zone = "Dustwallow Marsh",
    areaId = 15,
    minLevel = 35,
    maxLevel = 45,
    entry = { quest = 1268, areaId = 15, x = 29.7, y = 47.64 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 1268, 35, 30 }, -- Huellas pezuñales sospechosas
        { 1251, 35, 30 }, -- El escudo negro
        { 1321, 35, 30 }, -- El escudo negro
        { 1201, 35, 30 }, -- Los espías de Theramore
        { 1202, 35, 30 }, -- El puerto de Theramore
        { 1218, 35, 30 }, -- Especias calmantes
        { 1206, 35, 30 }, -- Jarl necesita ojos
        { 1203, 35, 30 }, -- Jarl necesita una espada
        { 81570, 35, 30 }, -- Jarl Needs a Blade
        { 1238, 35, 30 }, -- El informe perdido
        { 1239, 35, 30 }, -- La cabeza decapitada
        { 1240, 35, 30 }, -- El trol médico brujo
        { 1177, 36, 32 }, -- ¡Qué hambre!
        { 1322, 37, 30 }, -- El escudo negro
        { 1323, 37, 30 }, -- El escudo negro
        { 1270, 37, 30 }, -- La fuga de Apestoso
        { 1269, 37, 30 }, -- Teniente Paval Reethe
        { 1273, 37, 30 }, -- El interrogatorio de Reethe
        { 1276, 37, 30 }, -- El escudo negro
        { 1262, 40, 30 }, -- Informa a Zor
        { 98192, 43, 38 }, -- Despellejar con cuidado y con destreza
        { 1166, 43, 38 }, -- Las pertenencias del Señor Supremo Mok'Morokk
        { 1168, 43, 38 }, -- El ejército de los dragones negros
        { 1169, 43, 38 }, -- Identifica a los cachorros
        { 1170, 43, 38 }, -- Los hijos de Onyxia
        { 1171, 43, 38 }, -- Los hijos de Onyxia
        { 98231, 44, 1 }, -- Ingrediente activo
        { 98205, 44, 1 }, -- ¡Las crías son lo peor!
        { 98215, 44, 1 }, -- Escamas de dragón y colas chamuscadas
        { 1172, 45, 38 }, -- Los hijos de Onyxia
        { 1173, 45, 38 }, -- Desafiar al Señor Supremo Mok'Morokk
        { 2846, 46, 40 }, -- Tiara de la Profundidad
        { 2861, 46, 40 }, -- La tarea de Tabetha
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 626, 51, 35 }, -- El enigma de Cortello
        { 95283, 53, 48 }, -- The Missing Kor'kron
        { 95284, 53, 48 }, -- The Elite of the Elite
        { 95285, 53, 48 }, -- Right Place, Wrong Time
        { 95309, 53, 48 }, -- No Orc Left Behind
        { 96332, 53, 48 }, -- A Little Payback
        { 96334, 53, 48 }, -- Blood Red Bandanas
    },
})

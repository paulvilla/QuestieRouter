-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Felwood · niveles 48-55 · 33 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_Felwood",
    faction = "Horde",
    zone = "Felwood",
    areaId = 361,
    minLevel = 48,
    maxLevel = 55,
    entry = { quest = 8460, areaId = 361, x = 50.93, y = 85.01 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 8460, 48, 45 }, -- Aliado a los Fauces de Madera
        { 5155, 51, 48 }, -- Las fuerzas de Jaedenar
        { 6162, 51, 46 }, -- La última batalla de un esposo
        { 5157, 52, 48 }, -- Una muestra de agua corrupta
        { 5158, 52, 48 }, -- Buscando ayuda espiritual
        { 5156, 54, 48 }, -- Investigación acerca de la corrupción
        { 4084, 54, 47 }, -- Corazón de plata
        { 4005, 54, 47 }, -- Aquementas
        { 4505, 54, 49 }, -- El pozo de la corrupción
        { 4506, 54, 49 }, -- Dientes de sable corruptos
        { 86612, 55, 48 }, -- Stag Lord's Bauble
        { 86577, 55, 1 }, -- A Sampling of Putrescence
        { 5165, 55, 48 }, -- Sofocar las llamas de protección
        { 91952, 55, 1 }, -- The Source of the Corruption
        { 8462, 55, 45 }, -- Habla con Nafien
        { 8466, 55, 45 }, -- Plumas para Grazle
        { 4102, 55, 48 }, -- Limpiar Frondavil
        { 5887, 55, 48 }, -- Bálsamo por caza
        { 4108, 55, 48 }, -- Bálsamo por caza
        { 8461, 55, 45 }, -- Los Muertobosque del Norte
        { 8465, 55, 45 }, -- Habla con Salfa
        { 8467, 55, 45 }, -- Plumas para Nafien
        { 5202, 55, 49 }, -- Una extraña llave roja
        { 5203, 55, 49 }, -- El rescate en Jaedenar
        { 8470, 55, 45 }, -- El tótem ritual de los Muertobosque
        { 4521, 56, 52 }, -- Guardianes salvajes
        { 5085, 56, 52 }, -- Baba misteriosa
        { 5204, 57, 49 }, -- La reprensión de la Luz
        { 5385, 57, 49 }, -- Restos de Trey Forjaluz
        { 4741, 58, 52 }, -- Guardianes salvajes
        { 5242, 58, 48 }, -- El golpe final
        { 4721, 59, 52 }, -- Guardianes salvajes
        { 4883, 59, 52 }, -- Guardar un secreto
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Felwood · niveles 48-55 · 33 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_Felwood",
    faction = "Alliance",
    zone = "Felwood",
    areaId = 361,
    minLevel = 48,
    maxLevel = 55,
    entry = { quest = 4101, areaId = 361, x = 54.15, y = 86.83 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 4101, 55, 48 }, -- Limpiar Frondavil
        { 8460, 48, 45 }, -- Aliado a los Fauces de Madera
        { 5155, 51, 48 }, -- Las fuerzas de Jaedenar
        { 5157, 52, 48 }, -- Una muestra de agua corrupta
        { 5158, 52, 48 }, -- Buscando ayuda espiritual
        { 5156, 54, 48 }, -- Investigación acerca de la corrupción
        { 4084, 54, 47 }, -- Corazón de plata
        { 4005, 54, 47 }, -- Aquementas
        { 4421, 54, 49 }, -- La corrupción de los Fuego de Jade
        { 4906, 54, 49 }, -- Más corrupción
        { 939, 54, 49 }, -- La Flauta de Xavaric
        { 4441, 54, 49 }, -- Los Ancestros corrompidos
        { 4442, 54, 49 }, -- ¡Purificada!
        { 86577, 55, 1 }, -- A Sampling of Putrescence
        { 5165, 55, 48 }, -- Sofocar las llamas de protección
        { 91952, 55, 1 }, -- The Source of the Corruption
        { 8462, 55, 45 }, -- Habla con Nafien
        { 8466, 55, 45 }, -- Plumas para Grazle
        { 5882, 55, 48 }, -- Bálsamo por caza
        { 4103, 55, 48 }, -- Bálsamo por caza
        { 86611, 55, 48 }, -- Stag Lord's Bauble
        { 8461, 55, 45 }, -- Los Muertobosque del Norte
        { 8465, 55, 45 }, -- Habla con Salfa
        { 8467, 55, 45 }, -- Plumas para Nafien
        { 5202, 55, 49 }, -- Una extraña llave roja
        { 5203, 55, 49 }, -- El rescate en Jaedenar
        { 8470, 55, 45 }, -- El tótem ritual de los Muertobosque
        { 4261, 56, 49 }, -- El espíritu de un Ancestro
        { 5085, 56, 52 }, -- Baba misteriosa
        { 5249, 56, 53 }, -- ¡A la Cuna del Invierno!
        { 5204, 57, 49 }, -- La reprensión de la Luz
        { 5385, 57, 49 }, -- Restos de Trey Forjaluz
        { 5242, 58, 48 }, -- El golpe final
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

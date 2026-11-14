-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Un'Goro Crater · niveles 48-55 · 42 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_UnGoroCrater",
    faction = "Alliance",
    zone = "Un'Goro Crater",
    areaId = 490,
    minLevel = 48,
    maxLevel = 55,
    entry = { quest = 4289, areaId = 490, x = 71.64, y = 75.96 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 4289, 55, 47 }, -- Los simios de Un'Goro
        { 3884, 50, 48 }, -- Diario de Williden
        { 4503, 51, 49 }, -- El aparato volador de Shizzle
        { 3882, 51, 49 }, -- Choca esos huesos
        { 3883, 52, 48 }, -- Ecología alienígena
        { 3941, 52, 47 }, -- La ayuda de una gnoma
        { 4141, 52, 47 }, -- Muigin y Larion
        { 4142, 52, 47 }, -- Visita a Gregan
        { 3844, 52, 47 }, -- Un secreto bien guardado
        { 3845, 52, 47 }, -- Un secreto bien guardado
        { 3908, 52, 47 }, -- Un secreto bien guardado
        { 3881, 53, 48 }, -- Expedición Salvación
        { 4144, 53, 47 }, -- Brote pétalo de sangre
        { 4243, 53, 48 }, -- Buscando a Memo 01
        { 4284, 53, 47 }, -- Cristales de poder
        { 4285, 53, 47 }, -- La Torre del Norte
        { 4287, 53, 47 }, -- La Torre del Este
        { 4288, 53, 47 }, -- La Torre del Oeste
        { 4321, 53, 47 }, -- Entender el significado
        { 4381, 53, 47 }, -- Recuperar el cristal
        { 4385, 53, 47 }, -- Carga de cristal
        { 4244, 53, 48 }, -- Buscando a Memo 01
        { 4245, 53, 48 }, -- Buscando a Memo 01
        { 4382, 53, 47 }, -- La fuerza del cristal
        { 4386, 53, 47 }, -- Aguja de cristal
        { 4290, 53, 48 }, -- La comida de Lar'korwi
        { 4291, 53, 48 }, -- Una aroma irresistible para Lar'korwi
        { 4383, 53, 47 }, -- Custodia de cristal
        { 4384, 53, 47 }, -- Rendimiento de cristal
        { 3942, 54, 47 }, -- Recuerdos de Linken
        { 3961, 54, 47 }, -- La aventura de Linken
        { 5150, 55, 47 }, -- ¡Dadanga tiene hambre!
        { 92020, 55, 1 }, -- Hol'anyee's Big Book of Big Lizards
        { 4501, 55, 49 }, -- Cuidado con los pterrordáctilos
        { 4492, 55, 50 }, -- ¡Perdido!
        { 4491, 55, 50 }, -- Un poco de ayuda de mis amigos
        { 974, 55, 51 }, -- Busca la fuente
        { 980, 55, 51 }, -- Nuevos manantiales
        { 4301, 55, 50 }, -- El poderoso U'cha
        { 87492, 55, 50 }, -- Uncanny Crystal
        { 4292, 56, 48 }, -- El cebo para Lar'korwi
        { 3962, 56, 47 }, -- Ir solo es peligroso
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

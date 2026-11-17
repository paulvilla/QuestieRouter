-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Arathi Highlands · niveles 30-40 · 39 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_ArathiHighlands",
    faction = "Alliance",
    zone = "Arathi Highlands",
    areaId = 45,
    minLevel = 30,
    maxLevel = 40,
    entry = { quest = 647, areaId = 45, x = 43.24, y = 92.64 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 647, 30, 28 }, -- Licor de Luna de Mackreel
        { 681, 31, 30 }, -- Mansión Redilnorte
        { 79976, 32, 14 }, -- Este debe de ser el lugar
        { 690, 32, 30 }, -- Una petición de Malin
        { 8260, 34, 25 }, -- Paquete de curación elemental de Arathor
        { 8167, 35, 30 }, -- La batalla por la Cuenca de Arathi
        { 663, 35, 35 }, -- ¡Tierra a vista!
        { 635, 35, 30 }, -- Cristal en las montañas
        { 691, 36, 30 }, -- Valer su peso en oro
        { 658, 36, 30 }, -- Sospechas de una nueva Peste
        { 657, 36, 30 }, -- Sospechas de una nueva Peste
        { 660, 37, 30 }, -- Sospechas de una nueva Peste
        { 661, 37, 30 }, -- Sospechas de una nueva Peste
        { 682, 37, 30 }, -- Insignias de Stromgarde
        { 642, 37, 30 }, -- La princesa secuestrada
        { 95315, 38, 36 }, -- El informe de Clarofluvial
        { 92872, 38, 32 }, -- Pasos obedientes
        { 651, 38, 30 }, -- Piedras de vínculo
        { 693, 39, 30 }, -- Empuñar la varita
        { 694, 39, 30 }, -- Las defensas de Trelane
        { 695, 39, 30 }, -- Un encantamiento de aprendiz
        { 684, 39, 30 }, -- SE BUSCA: Marez Cogulla
        { 696, 39, 30 }, -- Ataque a la torre
        { 697, 39, 30 }, -- Una petición de Malin
        { 685, 40, 30 }, -- SE BUSCA: Otto y Lord Cresta de Halcón
        { 665, 40, 35 }, -- El tesoro sumergido
        { 666, 40, 35 }, -- El tesoro sumergido
        { 668, 40, 35 }, -- El tesoro sumergido
        { 664, 40, 35 }, -- Ahogar las penas
        { 662, 40, 35 }, -- Rescate en alta mar
        { 669, 40, 35 }, -- El tesoro sumergido
        { 79624, 40, 32 }, -- Cualquiera puede cocinar
        { 79677, 40, 26 }, -- Una compra rápida
        { 79678, 40, 26 }, -- La cata
        { 652, 42, 30 }, -- Desbloquear la piedra angular
        { 653, 40, 30 }, -- Aliados de Myzrael
        { 8261, 44, 35 }, -- Paquete de curación normal de Arathor
        { 667, 44, 35 }, -- La muerte viene de las profundidades
        { 8166, 45, 40 }, -- La batalla por la Cuenca de Arathi
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 8105, 55, 50 }, -- La batalla por la Cuenca de Arathi
        { 8114, 60, 60 }, -- Toma el control de cuatro bases
        { 8115, 60, 60 }, -- Toma el control de cinco bases
        { 8262, 60, 45 }, -- Paquete de curación avanzado de Arathor
    },
})

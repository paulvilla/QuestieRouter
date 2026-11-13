-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Arathi Highlands · niveles 30-40 · 46 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_ArathiHighlands",
    faction = "Horde",
    zone = "Arathi Highlands",
    areaId = 45,
    minLevel = 30,
    maxLevel = 40,
    entry = { quest = 79976, areaId = 45, x = 22.48, y = 24.18 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 79976, 32, 14 }, -- This Must Be The Place
        { 95663, 31, 24 }, -- Dragonmaw Rumors
        { 677, 32, 30 }, -- Un llamamiento a las armas
        { 671, 33, 30 }, -- Magia demoníaca
        { 92707, 33, 30 }, -- The Giant in the Den
        { 655, 34, 29 }, -- Sentencia
        { 672, 34, 29 }, -- El despertar de los espíritus
        { 674, 34, 29 }, -- El despertar de los espíritus
        { 675, 34, 29 }, -- El despertar de los espíritus
        { 8263, 34, 25 }, -- Paquete de curación elemental de los Rapiñadores
        { 8170, 35, 30 }, -- La batalla por la Cuenca de Arathi
        { 663, 35, 35 }, -- ¡Tierra a vista!
        { 635, 35, 30 }, -- Cristal en las montañas
        { 636, 35, 30 }, -- Legends of the Earth
        { 97539, 36, 30 }, -- Silky Sutures
        { 92519, 36, 30 }, -- Ward Restocking
        { 701, 37, 29 }, -- La astucia del raptor
        { 702, 37, 29 }, -- La astucia del raptor
        { 639, 37, 32 }, -- El sigilo de Strom
        { 847, 37, 29 }, -- La astucia del raptor
        { 642, 37, 30 }, -- La princesa secuestrada
        { 678, 38, 30 }, -- Un llamamiento a las armas
        { 651, 38, 30 }, -- Piedras de vínculo
        { 92867, 39, 32 }, -- Ground to Keep
        { 680, 40, 30 }, -- Una auténtica amenaza
        { 679, 40, 30 }, -- Un llamamiento a las armas
        { 640, 40, 32 }, -- El sigilo roto
        { 687, 40, 30 }, -- Theldurin, el perdido
        { 641, 40, 32 }, -- El sigilo de Thoradin
        { 673, 40, 35 }, -- Magia demoníaca
        { 665, 40, 35 }, -- El tesoro sumergido
        { 666, 40, 35 }, -- El tesoro sumergido
        { 668, 40, 35 }, -- El tesoro sumergido
        { 664, 40, 35 }, -- Ahogar las penas
        { 662, 40, 35 }, -- Rescate en alta mar
        { 669, 40, 35 }, -- El tesoro sumergido
        { 79624, 40, 32 }, -- Anyone Can Cook
        { 643, 41, 32 }, -- El sigilo de Arathor
        { 644, 42, 32 }, -- El sigilo de Aterratrols
        { 645, 42, 32 }, -- Trol'kalar
        { 652, 42, 30 }, -- Desbloquear la piedra angular
        { 688, 40, 30 }, -- Aliados de Myzrael
        { 646, 42, 32 }, -- Trol'kalar
        { 667, 44, 35 }, -- La muerte viene de las profundidades
        { 8264, 44, 35 }, -- Paquete de curación normal de los Rapiñadores
        { 8169, 45, 40 }, -- La batalla por la Cuenca de Arathi
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 8120, 55, 50 }, -- La batalla por la Cuenca de Arathi
        { 8121, 60, 60 }, -- Toma el control de cuatro bases
        { 8122, 60, 60 }, -- Toma el control de cinco bases
        { 8265, 60, 45 }, -- Paquete de curación avanzado de los Rapiñadores
    },
})

-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Riverglades · niveles 35-45 · 93 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_Riverglades",
    faction = "Alliance",
    zone = "Riverglades",
    areaId = 16591,
    minLevel = 35,
    maxLevel = 45,
    entry = { quest = 94999, areaId = 16591, x = 43.43, y = 82.43 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 94999, 36, 36 }, -- Ojitos para el vigía
        { 95059, 36, 36 }, -- La caja de Friz Chispachás
        { 95156, 37, 36 }, -- Rellenar y plantar
        { 95330, 37, 36 }, -- Cuida del prójimo
        { 95147, 37, 36 }, -- El explorador perdido
        { 95148, 37, 36 }, -- Informe sobre los gnolls de la guardia sureña
        { 94678, 38, 36 }, -- Plaga de gnolls
        { 94923, 38, 36 }, -- Me quito el sombrero
        { 94614, 38, 36 }, -- Diablillos de agua dulce
        { 95943, 38, 36 }, -- La afición del supervisor
        { 96009, 38, 36 }, -- Alto riesgo
        { 95184, 38, 36 }, -- La hoja más afilada
        { 94613, 38, 36 }, -- Mi reino por un caballo
        { 94881, 38, 36 }, -- Abalorios curiosos
        { 94615, 38, 36 }, -- No tengo potra
        { 94617, 38, 36 }, -- A cazar coyotes
        { 94618, 38, 36 }, -- Los corceles huidos de los Wheeler
        { 94992, 38, 36 }, -- Ronda de rescate
        { 95983, 38, 36 }, -- Un festín para los buitres
        { 96063, 38, 1 }, -- Oro gaseoso
        { 95982, 38, 36 }, -- No es mi circo ni son mis monos
        { 95988, 38, 36 }, -- Qué bien entra
        { 95957, 38, 36 }, -- ¡A beber!
        { 94842, 38, 36 }, -- Abono gourmet
        { 94843, 38, 36 }, -- De la semilla al brote
        { 94931, 38, 36 }, -- Sierras robadas
        { 94857, 39, 36 }, -- Si un árbol cae y nadie lo oye...
        { 94861, 39, 36 }, -- Manos amigas
        { 94924, 39, 36 }, -- Cazar a los cazadores
        { 94925, 39, 36 }, -- Un trato peludo
        { 94928, 39, 36 }, -- Unas pieles para Friz
        { 95064, 39, 36 }, -- Medidas preventivas
        { 95426, 39, 36 }, -- Suministros de Rog'mar
        { 95066, 39, 36 }, -- El problema de Rog'mar
        { 95984, 39, 36 }, -- La canción del zancaalta
        { 96067, 40, 1 }, -- Prueba sobre el terreno
        { 95121, 40, 36 }, -- El sabor del mar
        { 94829, 40, 36 }, -- Lo perdido
        { 94858, 40, 36 }, -- Todo lo que queda
        { 95642, 40, 36 }, -- Magias abominables
        { 95643, 40, 36 }, -- Purga indiscriminada
        { 94679, 40, 36 }, -- El hocico de Snargl
        { 94877, 40, 36 }, -- Salvar Clarosol
        { 95329, 38, 36 }, -- Trabajo de campo
        { 94879, 40, 36 }, -- Retazos de conocimiento
        { 94885, 40, 36 }, -- El registro de Mariscal de campo
        { 94981, 41, 38 }, -- Los ingredientes de la llave
        { 95986, 41, 36 }, -- El rey de las Llanuras Salvajes
        { 95562, 41, 36 }, -- Que les corten la cabeza
        { 94884, 41, 36 }, -- Un descubrimiento perturbador
        { 95219, 41, 40 }, -- De puerto a puerto
        { 95975, 41, 36 }, -- Su mundo
        { 95118, 41, 36 }, -- Salvajes de agua salada
        { 95120, 42, 1 }, -- SE BUSCA: Viejo Podrecarnada
        { 95254, 42, 36 }, -- SE BUSCA: Garratrampa
        { 95260, 42, 1 }, -- Terror en las profundidades
        { 95261, 42, 1 }, -- De tripas corazón
        { 95267, 42, 38 }, -- La bestia asoma
        { 95991, 42, 38 }, -- SE BUSCA: Faucespectral
        { 95912, 42, 38 }, -- SE BUSCA: Maestro del acero Kaijo
        { 95792, 42, 1 }, -- Limpieza a fondo
        { 95934, 42, 1 }, -- Prueba de beneficios
        { 96125, 43, 38 }, -- Un poquito de ayuda
        { 95288, 43, 1 }, -- El paraíso de los contrabandistas
        { 95293, 42, 38 }, -- El especial de la contrabandista
        { 95294, 42, 1 }, -- La negociación de la contrabandista
        { 95295, 40, 36 }, -- Conozco a alguien que...
        { 95296, 40, 1 }, -- Envíos y portes
        { 95119, 43, 38 }, -- Una competencia poco amistosa
        { 95935, 43, 36 }, -- Larga vida al matadragones
        { 95122, 44, 1 }, -- Una expansión descontrolada
        { 95123, 44, 1 }, -- ¡A volar, mequetrefes!
        { 95165, 44, 38 }, -- ¡Adiós, tunantes!
        { 94886, 44, 38 }, -- El frente occidental
        { 96015, 43, 38 }, -- Un problema minero
        { 94888, 44, 38 }, -- Ningún soldado se queda atrás
        { 94889, 44, 38 }, -- Labrarse un camino
        { 94907, 44, 36 }, -- Un pequeño favor
        { 94984, 44, 39 }, -- El escrito del Crepúsculo
        { 96126, 44, 38 }, -- Prisionero de los ogros
        { 94927, 44, 38 }, -- Dunston se despide
        { 95124, 45, 1 }, -- El almirante Lamora
        { 94982, 45, 40 }, -- El ojo de Mugg
        { 94926, 45, 38 }, -- Abajo el martillo
        { 94890, 46, 38 }, -- Traedme su cabeza
        { 94983, 42, 38 }, -- Recuerdos Crepusculares
        { 94997, 42, 38 }, -- Esencia persistente
        { 94998, 42, 38 }, -- Curiosidad por los recuerdos
        { 94891, 46, 38 }, -- Noticias para Farholde
        { 94894, 45, 38 }, -- La amenaza Crepuscular
        { 94887, 47, 36 }, -- Salvar al mariscal Ryan
        { 94892, 47, 36 }, -- Últimas voluntades
        { 94893, 47, 36 }, -- Cerrando heridas
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

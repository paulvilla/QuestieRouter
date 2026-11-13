-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Zephras Isle · niveles 1-12 · 90 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_ZephrasIsle",
    faction = "Horde",
    zone = "Zephras Isle",
    areaId = 16593,
    minLevel = 1,
    maxLevel = 12,
    entry = { quest = 92460, areaId = 16593, x = 42.82, y = 23.39 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 92460, 1, 1 }, -- Edad adulta
        { 92461, 1, 1 }, -- Armonía en el equilibrio
        { 92474, 2, 2 }, -- Caer con elegancia
        { 94414, 2, 2 }, -- Los anclajes de Zephras
        { 92462, 2, 1 }, -- Investigación de plagas
        { 92463, 3, 2 }, -- La reina mosca de cirro
        { 92464, 3, 2 }, -- Agitación elemental
        { 92465, 3, 2 }, -- Agitadores
        { 92469, 4, 3 }, -- Vuelve con Rorian
        { 93552, 4, 2 }, -- Cosecha de piedras de viento
        { 92466, 4, 3 }, -- Call of Earth  [clase]
        { 92467, 4, 3 }, -- Call of Earth  [clase]
        { 92471, 4, 4 }, -- Aetheen de los Vendavales
        { 92598, 4, 2 }, -- El don de la Visión cielonata
        { 92473, 4, 3 }, -- Invasión agresiva
        { 92468, 4, 3 }, -- Call of Earth  [clase]
        { 92470, 5, 2 }, -- Matriarca funesta
        { 92472, 5, 3 }, -- El paso siguiente
        { 92544, 5, 2 }, -- Maleantes Al'Aketh
        { 92553, 6, 4 }, -- Reponer la alacena
        { 92595, 6, 4 }, -- Los Formavientos
        { 94411, 6, 4 }, -- Magos entrometidos
        { 92515, 6, 4 }, -- El problema con las garramanadas
        { 92514, 6, 4 }, -- La Aldea Shen'dar
        { 92517, 7, 4 }, -- El elemento criminal
        { 92516, 7, 4 }, -- Incordio hipogrífico
        { 93319, 7, 4 }, -- Piedras de viento birladas
        { 93951, 7, 4 }, -- Belleza de un plumazo
        { 93036, 8, 5 }, -- Infiltrarse en el culto
        { 92529, 8, 5 }, -- Aldea Falaath
        { 92528, 8, 5 }, -- Entre los fieles
        { 92550, 8, 5 }, -- Caos en las Tierras Altas
        { 93926, 8, 5 }, -- La torre occidental
        { 92551, 8, 5 }, -- Suministros robados
        { 93927, 8, 5 }, -- Una última petición
        { 92579, 8, 6 }, -- A Valanaar
        { 93948, 9, 6 }, -- Entrega el sello
        { 93949, 8, 6 }, -- Vigilados
        { 92700, 9, 4 }, -- La suma vidente del cielo
        { 92679, 9, 5 }, -- Diezmo de sangre
        { 93317, 9, 4 }, -- Temporada de cangrejo
        { 93736, 9, 4 }, -- Espíritus no deseados
        { 93735, 9, 4 }, -- El constructo roto
        { 93737, 9, 4 }, -- El constructo roto
        { 93738, 9, 4 }, -- El constructo roto
        { 93746, 9, 4 }, -- Una respuesta firme
        { 92698, 9, 5 }, -- ¿Cuál es mi propósito?
        { 92682, 9, 5 }, -- Prestar tus servicios
        { 92683, 9, 5 }, -- Polvo de alabatiente
        { 92684, 9, 5 }, -- Unos zancavendavales muy malhumorados
        { 92685, 9, 5 }, -- Las colinas tienen ojos
        { 92693, 9, 5 }, -- Nos mantenemos firmes
        { 92703, 9, 5 }, -- La entrega de las noticias
        { 93318, 9, 4 }, -- SE BUSCA: Vulgara el Insaciable
        { 94493, 11, 8 }, -- A Sacrifice in Vain
        { 98512, 11, 6 }, -- Asesinos Al'Aketh
        { 94484, 11, 8 }, -- Un silencio inquietante
        { 94896, 11, 8 }, -- Ayuda para los refugiados
        { 94897, 11, 8 }, -- El destino de un amado
        { 93320, 11, 6 }, -- Defender las torres
        { 92871, 11, 6 }, -- Al servicio de Zephras
        { 93740, 11, 6 }, -- Sangre por sangre
        { 92642, 11, 6 }, -- Ataque a la logística
        { 92645, 11, 6 }, -- Romper a la Rompedora
        { 92880, 11, 6 }, -- Regreso a Valanaar
        { 92881, 11, 6 }, -- La petición del sumo anciano
        { 92643, 11, 6 }, -- Cambiacapas
        { 92644, 11, 6 }, -- Malas noticias
        { 94486, 11, 8 }, -- Vendas plumíferas
        { 94487, 11, 8 }, -- Indeseados e indignos
        { 94568, 11, 6 }, -- Las verdaderas intenciones del culto
        { 92640, 11, 6 }, -- Tiempos desesperados
        { 93065, 12, 7 }, -- Preparativos para la batalla
        { 92947, 12, 7 }, -- Es nuestro turno
        { 92708, 12, 7 }, -- Una gran aventura
        { 93958, 12, 7 }, -- El Sagrario Interior
        { 92646, 12, 7 }, -- La confrontación con Lorthuna
        { 94485, 12, 8 }, -- Lágrimas de doncella
        { 94488, 11, 8 }, -- Los lazos que nos unen
        { 94489, 12, 8 }, -- Las heridas de la traición
        { 93836, 12, 7 }, -- El destino de Zephras
        { 94490, 12, 9 }, -- La misiva rasgada
        { 94491, 12, 8 }, -- El destino del cubil
        { 93165, 13, 8 }, -- La misericordia no existe
        { 93459, 13, 8 }, -- Más orejas Al'Aketh
        { 93159, 13, 8 }, -- El ermitaño extraño
        { 93160, 13, 8 }, -- La recompensa del bosque
        { 93172, 13, 8 }, -- Libera a los huecos
        { 93090, 13, 7 }, -- Lo que está por venir
        { 95349, 13, 7 }, -- El Anillo de la Tierra
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Elwynn Forest · niveles 1-10 · 76 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_ElwynnForest",
    faction = "Alliance",
    zone = "Elwynn Forest",
    areaId = 12,
    minLevel = 1,
    maxLevel = 10,
    entry = { quest = 783, areaId = 12, x = 48.17, y = 42.94 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 783, 1, 1 }, -- Una amenaza del interior
        { 91736, 1, 1 }, -- Alambique de sidra de manzana
        { 16, 1, 1 }, -- Dale de beber a Gerard
        { 579, 1, 1 }, -- La biblioteca de Ventormenta
        { 333, 2, 1 }, -- Harlan necesita un nuevo suministro
        { 334, 2, 1 }, -- Un paquete para Thurman
        { 332, 2, 1 }, -- Publicidad de la bodega
        { 7, 2, 1 }, -- La limpieza del campamento kóbold
        { 33, 2, 1 }, -- Los lobos cruzan la frontera
        { 5261, 2, 1 }, -- Eagan Desollapieles
        { 91741, 2, 1 }, -- El libro mordisqueado
        { 92124, 2, 1 }, -- Inventario de libros
        { 91743, 2, 1 }, -- Roedores traviesos
        { 91745, 3, 1 }, -- Asesores de minería
        { 15, 3, 1 }, -- Investigar la Mina del Eco
        { 91752, 3, 1 }, -- La situación en su conjunto
        { 91758, 4, 1 }, -- ¡Sigue a ese kóbold!
        { 18, 4, 2 }, -- Hermandad de ladrones
        { 3903, 4, 2 }, -- Milly Osworth
        { 91772, 4, 1 }, -- ¡Shhh! Aquí se cazan kóbolds
        { 3904, 4, 2 }, -- La cosecha de Milly
        { 3905, 4, 2 }, -- Informe de la vendimia
        { 21, 5, 1 }, -- Escarmuza en la Mina del eco
        { 54, 5, 1 }, -- Informa en Villadorada
        { 6, 5, 2 }, -- La recompensa por Garrick Piesuaves
        { 2158, 5, 1 }, -- Descanso y relajación
        { 91775, 6, 1 }, -- Devolución de libros
        { 85, 6, 5 }, -- El collar perdido
        { 86, 6, 5 }, -- Un pastel para Billy
        { 106, 6, 5 }, -- Jóvenes enamorados
        { 84, 6, 5 }, -- Vuelve con Billy
        { 111, 6, 5 }, -- Habla con la abuelita
        { 107, 6, 5 }, -- Una nota para William
        { 47, 7, 4 }, -- Intercambio de polvo de oro
        { 62, 7, 4 }, -- La Mina Abisal
        { 91777, 7, 1 }, -- Rarezas del bibliófilo
        { 60, 7, 3 }, -- Las velas de los kobolds
        { 61, 7, 3 }, -- Un envío para Ventormenta
        { 112, 7, 5 }, -- La recolección de Kelp
        { 114, 7, 5 }, -- La fuga
        { 99127, 7, 4 }, -- Desastre pesquero
        { 99128, 7, 4 }, -- Amenaza babosa
        { 99129, 7, 4 }, -- Múrloc por liebre
        { 99143, 7, 4 }, -- Botellas y baratijas
        { 99130, 7, 4 }, -- Una oferta tentadora
        { 99131, 7, 4 }, -- El cebo del éxito
        { 91732, 7, 6 }, -- Acero del bueno
        { 91723, 8, 7 }, -- Instrumental delicado
        { 87, 8, 5 }, -- Dientes de oro
        { 88, 9, 6 }, -- ¡Princesa debe morir!
        { 83, 9, 4 }, -- Pañuelos de lino rojo
        { 5545, 9, 5 }, -- El cumplimiento del plazo
        { 91733, 10, 7 }, -- Aguas abajo
        { 52, 10, 7 }, -- Proteger la frontera
        { 91724, 10, 7 }, -- Instrumental delicado
        { 91725, 10, 7 }, -- Suministros de encantamiento robados
        { 40, 10, 7 }, -- Un peligro con olor a pescado
        { 35, 10, 7 }, -- Más preocupaciones
        { 76, 10, 4 }, -- La Cantera de Jaspe
        { 109, 10, 9 }, -- Habla con Gryan Mantorrecio
        { 239, 10, 6 }, -- El Cuartel Arroyoeste necesita ayuda
        { 91738, 10, 7 }, -- Ambrosía amanzanada
        { 11, 10, 6 }, -- Recompensas por los gnolls Zarparrío
        { 37, 10, 7 }, -- Encuentra a los guardias perdidos
        { 45, 10, 7 }, -- Descubre el destino de Rolf
        { 71, 10, 7 }, -- Informa a Thomas
        { 39, 10, 7 }, -- Entrega el informe de Thomas
        { 46, 10, 7 }, -- Recompensas por los murlocs
        { 59, 10, 7 }, -- Armadura de tela y cuero
        { 123, 10, 7 }, -- El Coleccionista
        { 147, 10, 7 }, -- La persecución
        { 6261, 10, 10 }, -- Dungar Tragolargo
        { 176, 11, 5 }, -- SE BUSCA: Hogger
        { 91740, 11, 7 }, -- Cabeza de Croador
        { 91746, 12, 7 }, -- La cabeza de Zarpaolmo
        { 95065, 12, 7 }, -- Jornada de pesca
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 399, 15, 10 }, -- Principios humildes
        { 2041, 15, 15 }, -- Habla con Shoni
        { 97220, 15, 9 }, -- El favor de Philmor
        { 97222, 15, 9 }, -- Bienes de la torre de entrada
        { 92749, 16, 9 }, -- Un plan explosivo
        { 92750, 16, 9 }, -- Detonación a distancia
        { 92751, 16, 9 }, -- Detonación a distancia
        { 119, 18, 13 }, -- Vuelve con Verner
        { 168, 18, 14 }, -- La recolección de Tarjetas del Sindicato Minero
        { 97234, 18, 13 }, -- Sala de lectura
        { 97237, 18, 13 }, -- Estanterías a tu disposición
        { 167, 20, 15 }, -- Oh, hermano...
        { 2040, 20, 15 }, -- Asalto subterráneo
        { 94, 21, 20 }, -- Un ojo vigilante
        { 1076, 21, 17 }, -- Demonios en Páramos de Poniente
        { 373, 22, 16 }, -- La carta sin enviar
        { 389, 22, 16 }, -- Bazil Thredd
        { 343, 24, 20 }, -- Hablando de fortaleza
        { 344, 24, 20 }, -- Hermano Paxton
        { 345, 24, 20 }, -- Suministros de tinta
        { 346, 24, 20 }, -- Vuelve con Kristoff
        { 98191, 25, 20 }, -- Un amigo de la familia
        { 388, 26, 22 }, -- El color de la sangre
        { 1078, 26, 17 }, -- Escamas cristalizadas para Mauren
        { 70, 28, 22 }, -- La leyenda de Stalvan
        { 74, 28, 22 }, -- La leyenda de Stalvan
        { 75, 28, 22 }, -- La leyenda de Stalvan
        { 78, 28, 22 }, -- La leyenda de Stalvan
        { 1241, 28, 28 }, -- El diplomático desaparecido
        { 1242, 28, 28 }, -- El diplomático desaparecido
        { 1274, 28, 28 }, -- El diplomático desaparecido
        { 391, 29, 16 }, -- El motín de las Mazmorras
        { 392, 29, 16 }, -- Extraño visitante
        { 393, 29, 16 }, -- Sombras del pasado
        { 335, 30, 25 }, -- Una noble cerveza
        { 336, 30, 25 }, -- Una noble cerveza
        { 397, 30, 25 }, -- Nos has hecho un gran servicio
        { 2928, 30, 20 }, -- Gyrodrillmatic Excavationators
        { 350, 31, 16 }, -- Mira por un viejo amigo
        { 394, 31, 16 }, -- La cabeza de la bestia
        { 395, 31, 16 }, -- El fin de la Hermandad
        { 396, 31, 16 }, -- Una audiencia con el Rey
        { 434, 31, 16 }, -- El ataque
        { 1246, 31, 28 }, -- El diplomático desaparecido
        { 1247, 31, 28 }, -- El diplomático desaparecido
        { 1447, 31, 28 }, -- El diplomático desaparecido
        { 2745, 31, 16 }, -- Infíltrate en el castillo
        { 2746, 31, 16 }, -- Objetos importantes
        { 92456, 33, 24 }, -- Una muestra verde
        { 1271, 37, 30 }, -- ¡Una fiesta en tu honor!
        { 212, 40, 35 }, -- Un plato bien frío
        { 543, 40, 30 }, -- La Tiara Perenolde
        { 97045, 40, 40 }, -- Tu primer caballo
        { 97170, 40, 40 }, -- Lecciones de monta
        { 1363, 41, 37 }, -- La orden de Mazen
        { 1448, 43, 38 }, -- En búsqueda del templo
        { 1475, 50, 41 }, -- En El Templo de Atal'Hakkar
        { 5048, 52, 50 }, -- El buen carácter de Emma
        { 4185, 54, 48 }, -- Los verdaderos maestros
        { 6182, 60, 56 }, -- El primero y el último
        { 6183, 60, 56 }, -- Honrar a los muertos
        { 6403, 60, 50 }, -- La gran farsa
        { 7495, 60, 60 }, -- Victoria para la Alianza
        { 7496, 60, 60 }, -- Celebrar los buenos momentos
        { 7781, 60, 60 }, -- Señor de Roca Negra
        { 7782, 60, 60 }, -- Señor de Roca Negra
        { 7791, 60, 12 }, -- Un donativo de lana
        { 7793, 60, 26 }, -- Un donativo de seda
        { 7794, 60, 40 }, -- Un donativo de paño mágico
        { 7795, 60, 50 }, -- Un donativo de paño rúnico
        { 7796, 60, 50 }, -- Un donativo extra de paño rúnico
    },
})

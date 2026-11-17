-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Stranglethorn Vale · niveles 30-45 · 178 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_StranglethornVale",
    faction = "Alliance",
    zone = "Stranglethorn Vale",
    areaId = 33,
    minLevel = 30,
    maxLevel = 45,
    entry = { quest = 215, areaId = 33, x = 40.34, y = 8.44 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 215, 33, 30 }, -- Los secretos de la jungla
        { 583, 30, 28 }, -- Bienvenido a la jungla
        { 1041, 30, 25 }, -- La ruta de la caravana
        { 575, 31, 26 }, -- La oferta y la demanda
        { 185, 31, 28 }, -- Domina el tigre
        { 190, 31, 28 }, -- Domina la pantera
        { 198, 32, 30 }, -- Suministros para el soldado Thorsen
        { 201, 32, 28 }, -- Investiga el campamento
        { 186, 33, 28 }, -- Domina el tigre
        { 191, 33, 28 }, -- Domina la pantera
        { 203, 33, 30 }, -- La segunda rebelión
        { 204, 34, 30 }, -- Mala medicina
        { 194, 34, 28 }, -- Domina el raptor
        { 187, 35, 28 }, -- Domina el tigre
        { 97328, 35, 30 }, -- Cualquier objeto de valor
        { 97329, 35, 30 }, -- ¿Dónde está la llave?
        { 97331, 35, 30 }, -- La gran evasión de Zimmix
        { 200, 35, 30 }, -- Bookie Herod
        { 189, 35, 30 }, -- Orejas de Sangrapellejo
        { 605, 35, 30 }, -- Fragmentos de cristales canto azules
        { 213, 36, 31 }, -- OPA hostil
        { 1116, 36, 30 }, -- Polvo de sueño en el pantano
        { 1117, 36, 30 }, -- Rumores para Kravel
        { 577, 36, 31 }, -- Hay que ensamblar
        { 97420, 36, 31 }, -- Reduce, reutiliza, reconcilia
        { 195, 36, 28 }, -- Domina el raptor
        { 93443, 36, 36 }, -- El cajón de transporte perdido
        { 210, 37, 32 }, -- La cocina de Krazek
        { 188, 37, 28 }, -- Domina el tigre
        { 328, 37, 30 }, -- La llave oculta
        { 329, 37, 30 }, -- ¡Espía descubierto!
        { 330, 37, 30 }, -- Horarios de patrulla
        { 331, 37, 30 }, -- Informa a Doren
        { 1181, 37, 29 }, -- Apoyo al goblin
        { 1182, 37, 29 }, -- Apoyo al goblin
        { 1183, 37, 29 }, -- Apoyo al goblin
        { 616, 37, 32 }, -- La isla fantasma
        { 627, 37, 32 }, -- Un favor a Krazek
        { 622, 37, 32 }, -- Vuelve con el cabo Kaleb
        { 578, 37, 32 }, -- La piedra de las mareas
        { 601, 37, 32 }, -- Elementales de agua
        { 602, 37, 32 }, -- Análisis mágico
        { 628, 38, 31 }, -- Borceguí
        { 192, 38, 28 }, -- Domina la pantera
        { 207, 38, 30 }, -- El misterio de Kurzen
        { 574, 38, 30 }, -- Fuerzas especiales
        { 97047, 38, 30 }, -- Cocinero entre rejas
        { 97048, 38, 30 }, -- Vuelta al puerto
        { 610, 39, 32 }, -- "El Guapo" Duncan"
        { 611, 40, 32 }, -- La maldición de las mareas
        { 79236, 40, 30 }, -- Una jarra y te lo cuento
        { 79242, 40, 30 }, -- No hay honor entre ladrones
        { 95789, 40, 34 }, -- Videntesal sospechosos
        { 95791, 40, 34 }, -- El capitán Videntesal
        { 670, 40, 35 }, -- El tesoro sumergido
        { 95322, 40, 1 }, -- Conseguir la mercancía
        { 95325, 40, 1 }, -- ¡Nos han robado!
        { 95326, 39, 1 }, -- The Big Payback
        { 78830, 40, 26 }, -- El terror de los cielos del desierto  [clase]
        { 338, 40, 30 }, -- Las verdes colinas de Tuercespina
        { 339, 40, 30 }, -- Capítulo I
        { 340, 40, 30 }, -- Capítulo II
        { 341, 40, 30 }, -- Capítulo III
        { 342, 40, 30 }, -- Capítulo IV
        { 193, 40, 28 }, -- Domina la pantera
        { 205, 40, 30 }, -- Brujería trol
        { 95786, 40, 30 }, -- Alguien conocido en Costasur
        { 202, 40, 30 }, -- Coronel Kurzen
        { 95327, 40, 1 }, -- All's Well That Ends Well
        { 95384, 40, 32 }, -- Las notas místicas parciales
        { 97332, 41, 36 }, -- Tropezar dos veces con la misma piedra
        { 595, 41, 37 }, -- Bucaneros Velasangre
        { 606, 41, 30 }, -- Asusta a Trémulo
        { 600, 41, 30 }, -- La minería de Ventura y Cía.
        { 607, 41, 30 }, -- Vuelve con MacKinley
        { 597, 41, 37 }, -- Bucaneros Velasangre
        { 599, 41, 37 }, -- Bucaneros Velasangre
        { 587, 41, 37 }, -- Tabaco rapé
        { 196, 41, 28 }, -- Domina el raptor
        { 576, 42, 37 }, -- ¡Ojo!
        { 209, 42, 37 }, -- Colmillos de Machacacráneos
        { 604, 43, 37 }, -- Bucaneros Velasangre
        { 617, 43, 38 }, -- Tallos de juncos akiris
        { 623, 43, 38 }, -- Tallos de juncos akiris
        { 197, 43, 28 }, -- Domina el raptor
        { 208, 43, 28 }, -- Caza mayor
        { 624, 43, 35 }, -- El enigma de Cortello
        { 97405, 44, 38 }, -- Quejas por ruidos
        { 609, 44, 30 }, -- El vudú debido
        { 613, 44, 30 }, -- El pie roto de Maury
        { 621, 44, 35 }, -- El secreto de Zanzil
        { 1119, 44, 35 }, -- La mezcla y cerveza de tontos de Zanzil
        { 2864, 45, 40 }, -- Tran'rek
        { 608, 45, 37 }, -- Bucaneros Velasangre
        { 348, 45, 40 }, -- La fiebre de Tuercespina
        { 2872, 45, 40 }, -- La deuda de Stoley
        { 349, 45, 32 }, -- La fiebre de Tuercespina
        { 594, 45, 45 }, -- Mensaje en una botella
        { 206, 46, 30 }, -- Mai'Zoth
        { 8551, 47, 35 }, -- El cofre del capitán
        { 8554, 50, 40 }, -- Enfréntate a Negolash
        { 3721, 50, 45 }, -- Tu propio OOX
        { 580, 50, 40 }, -- El grog de Whiskey Slim
        { 8552, 50, 40 }, -- La banda con monograma
        { 8553, 50, 40 }, -- El aflanje del capitán
        { 630, 51, 45 }, -- Mensaje en una botella
        { 619, 52, 35 }, -- La tentación de Negolash
        { 7810, 55, 1 }, -- El maestro de la arena
        { 7838, 55, 1 }, -- El maestro mayor de la arena
        { 3625, 58, 45 }, -- Armas Fel en Azsharita encantada
        { 3626, 58, 45 }, -- El regreso a Las Tierras Devastadas
        { 8049, 60, 60 }, -- El ojo de Zuldazar  [clase]
        { 8050, 60, 60 }, -- El ojo de Zuldazar  [clase]
        { 8051, 60, 60 }, -- El ojo de Zuldazar  [clase]
        { 8052, 60, 60 }, -- El ojo de Zuldazar que todo lo ve  [clase]
        { 8059, 60, 60 }, -- Dechados de Poder: los Brazaletes de endemoniado  [clase]
        { 8060, 60, 60 }, -- Dechados de Poder: los Brazaletes de ilusionista  [clase]
        { 8061, 60, 60 }, -- Dechados de Poder: los Brazaletes de confesor  [clase]
        { 8068, 60, 60 }, -- Dechados de Poder: el Manto de ilusionista  [clase]
        { 8069, 60, 60 }, -- Dechados de Poder: la Toga de ilusionista  [clase]
        { 8070, 60, 60 }, -- Dechados de Poder: las Ataduras de confesor  [clase]
        { 8071, 60, 60 }, -- Dechados de Poder: el Manto de confesor  [clase]
        { 8076, 60, 60 }, -- Dechados de Poder: el Manto de endemoniado  [clase]
        { 8077, 60, 60 }, -- Dechados de Poder: la Toga de endemoniado  [clase]
        { 8101, 60, 60 }, -- El guijarro de Kajaro  [clase]
        { 8102, 60, 60 }, -- El guijarro de Kajaro  [clase]
        { 8103, 60, 60 }, -- El guijarro de Kajaro  [clase]
        { 8104, 60, 60 }, -- La Joya de Kajaro  [clase]
        { 8106, 60, 60 }, -- Ocaso de Kezan  [clase]
        { 8107, 60, 60 }, -- Ocaso de Kezan  [clase]
        { 8108, 60, 60 }, -- Ocaso de Kezan  [clase]
        { 8109, 60, 60 }, -- Mancha imparable de Kezan  [clase]
        { 8056, 60, 60 }, -- Dechados de Poder: los Brazales de augur  [clase]
        { 8057, 60, 60 }, -- Dechados de Poder: los Brazales de adivino  [clase]
        { 8064, 60, 60 }, -- Dechados de Poder: el Cinturón de adivino  [clase]
        { 8065, 60, 60 }, -- Dechados de Poder: la guerrera de haruspex  [clase]
        { 8074, 60, 60 }, -- Dechados de Poder: el Cinturón de augur  [clase]
        { 8075, 60, 60 }, -- Dechados de Poder: el Camisote de augur  [clase]
        { 8110, 60, 60 }, -- Algas de los Mares del Sur encantadas  [clase]
        { 8111, 60, 60 }, -- Algas de los Mares del Sur encantadas  [clase]
        { 8112, 60, 60 }, -- Algas de los Mares del Sur encantadas  [clase]
        { 8113, 60, 60 }, -- Algas de los Mares del Sur encantadas prístinas  [clase]
        { 8196, 60, 58 }, -- Mangos de esencia
        { 8243, 60, 58 }, -- Los mejunjes potentes de Zanza
        { 8246, 60, 58 }, -- Las sortijas de Zandalar
        { 8201, 60, 58 }, -- Una colección de cabezas
        { 8195, 60, 58 }, -- Las monedas Zulian, Razzashi y Hakkari
        { 8238, 60, 58 }, -- Las monedas Gurubashi, Vilrama y Secacorteza
        { 8239, 60, 58 }, -- Las monedas Furiarena, Machacacráneos y Sangrapellejo
        { 8240, 60, 58 }, -- Una presea para Zanza
        { 8041, 60, 60 }, -- La fuerza del Monte Mugamba  [clase]
        { 8042, 60, 60 }, -- La fuerza del Monte Mugamba  [clase]
        { 8043, 60, 60 }, -- La fuerza del Monte Mugamba  [clase]
        { 8044, 60, 60 }, -- La Ira de Mugamba  [clase]
        { 8045, 60, 60 }, -- La Enseña del pagano.  [clase]
        { 8046, 60, 60 }, -- La Enseña del pagano.  [clase]
        { 8047, 60, 60 }, -- La Enseña del pagano.  [clase]
        { 8048, 60, 60 }, -- La Enseña del héroe  [clase]
        { 8058, 60, 60 }, -- Dechados de Poder: los Guardabrazos de vindicador  [clase]
        { 8078, 60, 60 }, -- Dechados de Poder: el Cinturón de vindicador  [clase]
        { 8079, 60, 60 }, -- Dechados de Poder: el Peto de vindicador  [clase]
        { 8062, 60, 60 }, -- Dechados de Poder: los Brazales de depredador  [clase]
        { 8063, 60, 60 }, -- Dechados de Poder: los Brazales de sinconcierto  [clase]
        { 8066, 60, 60 }, -- Dechados de Poder: el Cinturón de predador  [clase]
        { 8067, 60, 60 }, -- Dechados de Poder: el Manto de depredador  [clase]
        { 8072, 60, 60 }, -- Dechados de Poder: el Manto de sinconcierto  [clase]
        { 8073, 60, 60 }, -- Dechados de Poder: la guerrera de sinconcierto  [clase]
        { 8141, 60, 60 }, -- Talismán de las Sombras Zandalar  [clase]
        { 8142, 60, 60 }, -- Talismán de las Sombras Zandalar  [clase]
        { 8143, 60, 60 }, -- Talismán de la Sombras Zandalar  [clase]
        { 8144, 60, 60 }, -- Talismán de dominio de las sombras de Zandalarian  [clase]
        { 8145, 60, 60 }, -- Zarcillo de La Vorágine  [clase]
        { 8146, 60, 60 }, -- Zarcillo de La Vorágine  [clase]
        { 8147, 60, 60 }, -- Zarcillo de La Vorágine  [clase]
        { 8148, 60, 60 }, -- Cólera de La Vorágine  [clase]
        { 9259, 60, 30 }, -- Un traidor de Velasangre
        { 83934, 60, 55 }, -- Show Me the Money!
        { 96076, 60, 1 }, -- In Demand - Ancient Elven Curiosities
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

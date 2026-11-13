-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Stranglethorn Vale · niveles 30-45 · 167 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_StranglethornVale",
    faction = "Horde",
    zone = "Stranglethorn Vale",
    areaId = 33,
    minLevel = 30,
    maxLevel = 45,
    entry = { quest = 575, areaId = 33, x = 28.29, y = 77.59 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 575, 31, 26 }, -- La oferta y la demanda
        { 583, 30, 28 }, -- Bienvenido a la jungla
        { 185, 31, 28 }, -- Domina el tigre
        { 190, 31, 28 }, -- Domina la pantera
        { 201, 32, 28 }, -- Investiga el campamento
        { 186, 33, 28 }, -- Maestría en tigres
        { 191, 33, 28 }, -- Domina la pantera
        { 194, 34, 28 }, -- Domina el raptor
        { 581, 34, 30 }, -- Caza para Yenniku
        { 97328, 35, 30 }, -- Anything of Value
        { 187, 35, 28 }, -- Domina el tigre
        { 79535, 35, 1 }, -- Basilisks: Should Petrification be Feared?
        { 189, 35, 30 }, -- Orejas de Sangrapellejo
        { 605, 35, 30 }, -- Fragmentos de cristales canto azules
        { 2842, 35, 20 }, -- Scooty, ingeniero jefe
        { 2843, 35, 20 }, -- ¡Gnomer-yaaaaa!
        { 97329, 35, 30 }, -- Where's the Key?
        { 97331, 35, 30 }, -- Zimmix's Great Escape
        { 213, 36, 31 }, -- OPA hostil
        { 1116, 36, 30 }, -- Polvo de sueño en el pantano
        { 1117, 36, 30 }, -- Rumores para Kravel
        { 577, 36, 31 }, -- Hay que ensamblar
        { 568, 36, 33 }, -- La defensa de Grom'gol
        { 195, 36, 28 }, -- Domina el raptor
        { 188, 37, 28 }, -- Domina el tigre
        { 596, 37, 30 }, -- Collares de huesos sangrientos
        { 629, 37, 30 }, -- El Arrecife Mortal
        { 582, 37, 30 }, -- Caza cabezas
        { 638, 37, 32 }, -- Aterratrols
        { 569, 37, 33 }, -- La defensa de Grom'gol
        { 1181, 37, 29 }, -- Patrocinio goblin
        { 1182, 37, 29 }, -- Apoyo al goblin
        { 1183, 37, 29 }, -- Apoyo al goblin
        { 95773, 37, 30 }, -- Enemies in the Water
        { 628, 38, 31 }, -- Borceguí
        { 570, 38, 33 }, -- El encantamiento de Mok'thardin
        { 192, 38, 28 }, -- Domina la pantera
        { 97047, 38, 30 }, -- The Cook in the Cage
        { 97048, 38, 30 }, -- Returning to Port
        { 193, 40, 28 }, -- Domina la pantera
        { 338, 40, 30 }, -- Las verdes colinas de Tuercespina
        { 339, 40, 30 }, -- Capítulo I
        { 340, 40, 30 }, -- Capítulo II
        { 341, 40, 30 }, -- Capítulo III
        { 342, 40, 30 }, -- Capítulo IV
        { 1261, 40, 30 }, -- Las declaraciones de Marg
        { 670, 40, 35 }, -- El tesoro sumergido
        { 95384, 40, 32 }, -- Partial Mystical Notes
        { 95748, 40, 30 }, -- The Gurubashi Legends of Old
        { 95770, 40, 30 }, -- Locating the Lost City
        { 600, 41, 30 }, -- La minería de Ventura y Cía.
        { 606, 41, 30 }, -- Asusta a Trémulo
        { 595, 41, 37 }, -- Bucaneros Velasangre
        { 607, 41, 30 }, -- Vuelve con MacKinley
        { 597, 41, 37 }, -- Bucaneros Velasangre
        { 599, 41, 37 }, -- Bucaneros Velasangre
        { 587, 41, 37 }, -- Tabaco rapé
        { 572, 41, 33 }, -- El encantamiento de Mok'thardin
        { 571, 41, 33 }, -- El encantamiento de Mok'thardin
        { 584, 41, 30 }, -- Las cabezas de los Sangrapellejo
        { 585, 40, 30 }, -- Hablando con Nezzliok
        { 196, 41, 28 }, -- Domina el raptor
        { 598, 42, 30 }, -- Collares de huesos partidos
        { 2932, 42, 35 }, -- Un macabro mensaje
        { 576, 42, 37 }, -- ¡Ojo!
        { 209, 42, 37 }, -- Colmillos de Machacacráneos
        { 604, 43, 37 }, -- Bucaneros Velasangre
        { 617, 43, 38 }, -- Tallos de juncos akiris
        { 197, 43, 28 }, -- Domina el raptor
        { 208, 43, 28 }, -- Caza mayor
        { 624, 43, 35 }, -- El enigma de Cortello
        { 573, 44, 33 }, -- El encantamiento de Mok'thardin
        { 609, 44, 30 }, -- El vudú debido
        { 613, 44, 30 }, -- El pie roto de Maury
        { 621, 44, 35 }, -- El secreto de Zanzil
        { 1119, 44, 35 }, -- La mezcla y cerveza de tontos de Zanzil
        { 1127, 44, 36 }, -- Cerveza de tontos
        { 2864, 45, 40 }, -- Tran'rek
        { 608, 45, 37 }, -- Bucaneros Velasangre
        { 348, 45, 40 }, -- La fiebre de Tuercespina
        { 2872, 45, 40 }, -- La deuda de Stoley
        { 349, 45, 32 }, -- La fiebre de Tuercespina
        { 594, 45, 45 }, -- Mensaje en una botella
        { 586, 46, 30 }, -- Hablando con Gan'zulah
        { 588, 45, 30 }, -- El destino de Yenniku
        { 589, 45, 30 }, -- Los cristales canto
        { 591, 46, 30 }, -- El Ojo de la Mente
        { 592, 46, 30 }, -- Salvar a Yenniku
        { 8551, 47, 35 }, -- El cofre del capitán
        { 3721, 50, 45 }, -- Tu propio OOX
        { 580, 50, 40 }, -- El grog de Whiskey Slim
        { 618, 50, 40 }, -- Enfréntate a Negolash
        { 8552, 50, 40 }, -- La banda con monograma
        { 8553, 50, 40 }, -- El aflanje del capitán
        { 8554, 50, 40 }, -- Enfréntate a Negolash
        { 630, 51, 45 }, -- Mensaje en una botella
        { 615, 51, 35 }, -- El aflanje del capitán
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
        { 8116, 60, 60 }, -- Visión de Voodress  [clase]
        { 8117, 60, 60 }, -- Visión de Voodress  [clase]
        { 8118, 60, 60 }, -- Visión de Voodress  [clase]
        { 8119, 60, 60 }, -- Visión inmaculada de Voodress  [clase]
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
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
        { 8053, 61, 60 }, -- Dechados de Poder: los Guardabrazos de librepensador
        { 8054, 61, 60 }, -- Dechados de Poder: el Cinturón de librepensador
        { 8055, 61, 60 }, -- Dechados de Poder: el Peto de librepensador
    },
})

-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Horde · Eastern Plaguelands · niveles 53-60 · 208 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Horde_EasternPlaguelands",
    faction = "Horde",
    zone = "Eastern Plaguelands",
    areaId = 139,
    minLevel = 53,
    maxLevel = 60,
    entry = { quest = 5542, areaId = 139, x = 5.16, y = 35.57 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 5542, 56, 52 }, -- Perros demoníacos
        { 6164, 55, 50 }, -- Libro de entradas de Augustus
        { 5149, 55, 50 }, -- La muñeca de Pamela
        { 6021, 55, 50 }, -- Zaeldarr el Marginado
        { 5503, 55, 50 }, -- Comisión del Alba Argenta
        { 5508, 55, 50 }, -- Piedras de la Plaga de un corruptor
        { 5509, 55, 50 }, -- Piedras de la Plaga de un invasor
        { 5510, 55, 50 }, -- Piedras de la Plaga de un esbirro
        { 5211, 55, 50 }, -- Los defensores de Villa Darrow
        { 5168, 56, 50 }, -- Los héroes de Villa Darrow
        { 5152, 56, 50 }, -- Tía Marlene
        { 5241, 56, 50 }, -- Tío Carlin
        { 5543, 56, 52 }, -- Cielos sangrientos
        { 5544, 56, 52 }, -- Gusanos carroñeros
        { 5742, 56, 52 }, -- Redención
        { 5961, 56, 54 }, -- Campeón de la Reina alma en pena
        { 5181, 57, 50 }, -- Los villanos de Villa Darrow
        { 5781, 57, 52 }, -- De recuerdos olvidados
        { 5845, 58, 52 }, -- Del honor perdido
        { 5846, 58, 52 }, -- De amor y familia
        { 6022, 58, 54 }, -- Matar con un propósito
        { 6042, 58, 54 }, -- Los pequeños problemas de la no-vida
        { 6026, 58, 54 }, -- Eso pide mucho
        { 6041, 58, 54 }, -- Cuando Smokey canta, me pongo violento
        { 5529, 58, 55 }, -- Crías de dragón apestadas
        { 5212, 60, 55 }, -- La carne no miente
        { 5213, 60, 55 }, -- El agente activo
        { 5206, 60, 50 }, -- Los merodeadores de Villa Dorrow
        { 5941, 60, 50 }, -- Vuelve con Chromie
        { 5251, 60, 55 }, -- El archivista
        { 5263, 60, 55 }, -- Por encima y más allá
        { 5264, 60, 55 }, -- Lord Maxwell Neófitus
        { 5513, 60, 55 }, -- Mantos del Alba
        { 5517, 60, 55 }, -- Manto del Alba cromático
        { 9221, 60, 55 }, -- Armamento superior de batalla: amistoso con El Alba
        { 9222, 60, 55 }, -- Armamento épico de batalla: amistoso con El Alba
        { 9223, 60, 55 }, -- Armamento superior de batalla: honorable con El Alba
        { 9224, 60, 55 }, -- Armamento épico de batalla: honorable con El Alba
        { 9225, 60, 55 }, -- Armamento épico de batalla: venerado con El Alba
        { 9226, 60, 55 }, -- Armamento superior de batalla: venerado con El Alba
        { 9227, 60, 55 }, -- Armamento superior de batalla: exaltado con El Alba
        { 9228, 60, 55 }, -- Armamento épico de batalla: exaltado con El Alba
        { 9234, 60, 60 }, -- Los guanteletes Deliriohelado  [clase]
        { 9235, 60, 60 }, -- Los brazales Deliriohelado  [clase]
        { 9236, 60, 60 }, -- La coraza Deliriohelado  [clase]
        { 9237, 60, 60 }, -- La capa glacial
        { 9238, 60, 60 }, -- Las muñequeras glaciales  [clase]
        { 9239, 60, 60 }, -- Los guantes glaciales  [clase]
        { 9240, 60, 60 }, -- El jubón glacial  [clase]
        { 9241, 60, 60 }, -- Los brazales polares  [clase]
        { 9242, 60, 60 }, -- Los guantes polares  [clase]
        { 9243, 60, 60 }, -- La guerrera polar  [clase]
        { 9244, 60, 60 }, -- Los brazales de escamas heladas  [clase]
        { 9245, 60, 60 }, -- Los guanteletes de escamas heladas  [clase]
        { 9246, 60, 60 }, -- La coraza de escamas heladas  [clase]
        { 9136, 60, 55 }, -- Flora salvaje
        { 9137, 60, 55 }, -- Hojas salvajes
        { 9126, 60, 55 }, -- Excavaciones para la armadura Segahuesos
        { 9127, 60, 55 }, -- Trozos de hueso
        { 9124, 60, 55 }, -- La armadura de acechacriptas no se hace sola...
        { 9125, 60, 55 }, -- Trozos de maligno de cripta
        { 9121, 60, 60 }, -- La ciudadela del terror: Naxxramas
        { 9122, 60, 60 }, -- La ciudadela del terror: Naxxramas
        { 9123, 60, 60 }, -- La ciudadela del terror: Naxxramas
        { 9128, 60, 55 }, -- La ecuación elemental
        { 9129, 60, 55 }, -- Núcleo de elementos
        { 9033, 60, 60 }, -- Ecos de Guerra
        { 9043, 60, 60 }, -- La guerrera de redención  [clase]
        { 9044, 60, 60 }, -- Las musleras de redención  [clase]
        { 9045, 60, 60 }, -- La celada de redención  [clase]
        { 9046, 60, 60 }, -- Las bufas de redención  [clase]
        { 9047, 60, 60 }, -- Las botas de redención  [clase]
        { 9048, 60, 60 }, -- Las manoplas de redención  [clase]
        { 9049, 60, 60 }, -- La faja de redención  [clase]
        { 9050, 60, 60 }, -- Los guardamuñecas de redención  [clase]
        { 9111, 60, 60 }, -- La toga de fe  [clase]
        { 9112, 60, 60 }, -- Los leotardos de fe  [clase]
        { 9113, 60, 60 }, -- El aro de fe  [clase]
        { 9114, 60, 60 }, -- Las hombreras de fe  [clase]
        { 9115, 60, 60 }, -- Los botines de fe  [clase]
        { 9116, 60, 60 }, -- Los guantes de fe  [clase]
        { 9117, 60, 60 }, -- El cinturón de fe  [clase]
        { 9118, 60, 60 }, -- Las ataduras de fe  [clase]
        { 9103, 60, 60 }, -- La toga corazón de la peste  [clase]
        { 9104, 60, 60 }, -- Los leotardos corazón de la peste  [clase]
        { 9105, 60, 60 }, -- El aro corazón de la peste  [clase]
        { 9106, 60, 60 }, -- Las hombreras corazón de la peste  [clase]
        { 9107, 60, 60 }, -- Los botines corazón de peste  [clase]
        { 9108, 60, 60 }, -- Los guantes corazón de la peste  [clase]
        { 9109, 60, 60 }, -- El cinturón corazón de la peste  [clase]
        { 9110, 60, 60 }, -- Las ataduras corazón de la peste  [clase]
        { 9211, 60, 60 }, -- El guardahielo
        { 9213, 60, 60 }, -- El Guarda de las Sombras
        { 9095, 60, 60 }, -- La toga de Fuego de Escarcha  [clase]
        { 9096, 60, 60 }, -- Los leotardos de Fuego de Escarcha  [clase]
        { 9097, 60, 60 }, -- El aro de Fuego de Escarcha  [clase]
        { 9098, 60, 60 }, -- Las hombreras de Fuego de Escarcha  [clase]
        { 9099, 60, 60 }, -- Los botines de Fuego de Escarcha  [clase]
        { 9100, 60, 60 }, -- Los guantes de Fuego de Escarcha  [clase]
        { 9101, 60, 60 }, -- El cinturón de Fuego de Escarcha  [clase]
        { 9102, 60, 60 }, -- Las ataduras de Fuego de Escarcha  [clase]
        { 9077, 60, 60 }, -- La coraza Segahuesos  [clase]
        { 9078, 60, 60 }, -- Los quijotes Segahuesos  [clase]
        { 9079, 60, 60 }, -- El casco Segahuesos  [clase]
        { 9080, 60, 60 }, -- Los espaldares Segahuesos  [clase]
        { 9081, 60, 60 }, -- Los escarpes Segahuesos  [clase]
        { 9082, 60, 60 }, -- Los guanteletes Segahuesos  [clase]
        { 9083, 60, 60 }, -- Los guardarrenes Segahuesos  [clase]
        { 9084, 60, 60 }, -- Los brazales Segahuesos  [clase]
        { 9054, 60, 60 }, -- La guerrera de acechacriptas  [clase]
        { 9055, 60, 60 }, -- Las musleras de acechacriptas  [clase]
        { 9056, 60, 60 }, -- La celada de acechacriptas  [clase]
        { 9057, 60, 60 }, -- Las bufas de acechacriptas  [clase]
        { 9058, 60, 60 }, -- Las botas de acechacriptas  [clase]
        { 9059, 60, 60 }, -- Las manoplas de acechacriptas  [clase]
        { 9060, 60, 60 }, -- La faja de acechacriptas  [clase]
        { 9061, 60, 60 }, -- Los guardamuñecas de acechacriptas  [clase]
        { 9034, 60, 60 }, -- La coraza acorator  [clase]
        { 9036, 60, 60 }, -- Los quijotes acorator  [clase]
        { 9037, 60, 60 }, -- El casco acorator  [clase]
        { 9038, 60, 60 }, -- Los espaldares acorator  [clase]
        { 9039, 60, 60 }, -- Los escarpes acorator  [clase]
        { 9040, 60, 60 }, -- Los guanteletes acorator  [clase]
        { 9041, 60, 60 }, -- Los guardarrenes acorator  [clase]
        { 9042, 60, 60 }, -- Los brazales acorator  [clase]
        { 9131, 60, 55 }, -- Armar la acorator
        { 9132, 60, 55 }, -- Fragmentos de hierro negro
        { 9229, 60, 60 }, -- El destino de Ramaladni
        { 9230, 60, 60 }, -- La garra helada de Ramaladni
        { 5265, 60, 55 }, -- El Bastión Argenta
        { 5243, 60, 55 }, -- Las casas de lo sagrado
        { 5463, 60, 57 }, -- El Obsequio de Menethil
        { 5531, 60, 57 }, -- Betina Bigglezink
        { 9141, 60, 55 }, -- Me llaman "El Gallo"
        { 9142, 60, 55 }, -- Libranza del artesano
        { 5214, 60, 55 }, -- El gran Ezra Grimm
        { 9165, 60, 55 }, -- La libranza de salvoconducto
        { 9665, 60, 55 }, -- Fortalecimiento de nuestras defensas
        { 9068, 60, 60 }, -- La túnica Fatalidad  [clase]
        { 9069, 60, 60 }, -- Las grebas Fatalidad  [clase]
        { 9070, 60, 60 }, -- La celada Fatalidad  [clase]
        { 9071, 60, 60 }, -- Las hombreras Fatalidad  [clase]
        { 9072, 60, 60 }, -- Las botas Fatalidad  [clase]
        { 9073, 60, 60 }, -- Las manoplas Fatalidad  [clase]
        { 9074, 60, 60 }, -- La faja Fatalidad  [clase]
        { 9075, 60, 60 }, -- Las muñequeras Fatalidad  [clase]
        { 9086, 60, 60 }, -- La guerrera Caminasueños  [clase]
        { 9087, 60, 60 }, -- Las musleras Caminasueños  [clase]
        { 9088, 60, 60 }, -- La celada Caminasueños  [clase]
        { 9089, 60, 60 }, -- Las bufas Caminasueños  [clase]
        { 9090, 60, 60 }, -- Las botas Caminasueños  [clase]
        { 9091, 60, 60 }, -- Las manoplas Caminasueños  [clase]
        { 9092, 60, 60 }, -- La faja Caminasueños  [clase]
        { 9093, 60, 60 }, -- Los guardamuñecas Caminasueños  [clase]
        { 9232, 60, 60 }, -- La única canción que conozco
        { 4771, 60, 57 }, -- Gambito del Alba
        { 5281, 60, 55 }, -- Espíritus inquietos
        { 5942, 60, 50 }, -- Tesoros ocultos
        { 6024, 60, 54 }, -- La súplica de Hameya
        { 6133, 60, 54 }, -- La orden del Señor de exploradores
        { 6135, 60, 56 }, -- Alatardecer, cómo te odio…
        { 6136, 60, 56 }, -- El corpulento
        { 6144, 60, 56 }, -- La llamada del teniente
        { 6148, 60, 56 }, -- El Oráculo Escarlata, Demetria
        { 6163, 60, 56 }, -- Ramstein
        { 5861, 60, 52 }, -- Encuentra a Myranda
        { 5282, 60, 55 }, -- Espíritus inquietos
        { 8945, 60, 58 }, -- La súplica de un muerto
        { 8947, 60, 58 }, -- La extraña petición de Anthion
        { 8948, 60, 58 }, -- Un viejo amigo de Anthion
        { 8957, 60, 58 }, -- La despedida de Anthion  [clase]
        { 9016, 60, 58 }, -- La despedida de Anthion  [clase]
        { 9017, 60, 58 }, -- La despedida de Anthion  [clase]
        { 9018, 60, 58 }, -- La despedida de Anthion  [clase]
        { 9019, 60, 58 }, -- La despedida de Anthion  [clase]
        { 9020, 60, 58 }, -- La despedida de Anthion  [clase]
        { 9021, 60, 58 }, -- La despedida de Anthion  [clase]
        { 9022, 60, 58 }, -- La despedida de Anthion  [clase]
        { 5464, 60, 57 }, -- El Obsequio de Menethil
        { 5465, 60, 57 }, -- Memorias del Vínculo del Alma
        { 6145, 60, 56 }, -- El mensajero carmesí
        { 6146, 60, 56 }, -- La estratagema de Nathanos
        { 8930, 60, 58 }, -- Buscando a Anthion
        { 9178, 60, 55 }, -- Libranza del artesano: piedrafuerte densa
        { 9179, 60, 55 }, -- Libranza del artesano: peto de placas imperial
        { 9181, 60, 55 }, -- Libranza del artesano: martillo volcánico
        { 9182, 60, 55 }, -- Libranza del artesano: hacha de combate de torio enorme
        { 9183, 60, 55 }, -- Libranza del artesano: aro radiante
        { 9184, 60, 55 }, -- Libranza del artesano: cinta de pelo de cuero maligna
        { 9185, 60, 55 }, -- Libranza del artesano: complemento basto para armadura
        { 9186, 60, 55 }, -- Libranza del artesano: cinturón de cuero maligno
        { 9187, 60, 55 }, -- Libranza del artesano: pantalones de cuero rúnicos
        { 9188, 60, 55 }, -- Libranza del artesano: pantalones de paño brillante
        { 9190, 60, 55 }, -- Libranza del artesano: botas de paño rúnico
        { 9191, 60, 55 }, -- Libranza del artesano: bolsas de paño rúnico
        { 9194, 60, 55 }, -- Libranza del artesano: toga de paño rúnico
        { 9195, 60, 55 }, -- Libranza del artesano: carga de zapador goblin
        { 9196, 60, 55 }, -- Libranza del artesano: granada de torio
        { 9197, 60, 55 }, -- Libranza del artesano: gallo de batalla gnómico
        { 9198, 60, 55 }, -- Libranza del artesano: tubo de torio
        { 9200, 60, 55 }, -- Libranza del artesano: poción sublime de maná
        { 9201, 60, 55 }, -- Libranza del artesano: poción de Protección contra lo Arcano superior
        { 9202, 60, 55 }, -- Libranza del artesano: poción sublime de curación
        { 9203, 60, 55 }, -- Libranza del artesano: frasco de petrificación
        { 9204, 60, 55 }, -- Libranza del artesano: anguila Escama Tormentosa
        { 9205, 60, 55 }, -- Libranza del artesano: pez coraza plateado
        { 9206, 60, 55 }, -- Libranza del artesano: anguila relámpago
        { 9378, 60, 60 }, -- DND FLAG The Dread Citadel - Naxxramas
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})

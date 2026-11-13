-- QuestieRouter: registro de cambios en espanol (esES y esMX). El primero es el actual.
local _, QR = ...

QR.Changelogs = QR.Changelogs or {}
QR.Changelogs.esES = {
    {
        version = "0.9.3", date = "2026-11-13",
        title = "Arreglo de rutas y vuelos",
        lines = {
            "Arreglado el error continuo al coger un vuelo o al ir a una ciudad (Router.lua:551) con las versiones nuevas de Questie.",
            "QuestieRouter usa siempre la libreria de mapas de Questie y no la copia antigua de otros addons (como Spy).",
            "Arreglado el error del informe del mapa de vuelos con vuelos que el addon no conoce (por ejemplo, Cima de la Eternidad en Monte Hyjal).",
        },
    },
    {
        version = "0.9.2", date = "2026-11-12",
        title = "Asistente de instalacion y guias nuevas",
        lines = {
            "Asistente de instalacion al instalar el addon por primera vez: tamano de los textos, datos de la tarjeta de arriba y de la lista de pasos, y aviso de los vuelos (/qr install o desde Ajustes).",
            "Nuevas guias: Isla de Zephras (Alianza y Horda) e Islas Lanza Negra (PvP).",
            "Las guias usan el rango de niveles que muestra el mapa de cada zona.",
            "En las capitales se entregan primero todas las misiones completas de la ciudad y luego sigue la guia.",
            "Menu de la cadena (clic derecho en una mision): cadena completa con el estado de cada mision (hecha, en curso, para entregar, disponible, nivel), iconos de elite y mazmorra, y el motivo si esta bloqueada.",
            "Ya no se muestran como mision anterior misiones de otra raza o clase.",
            "Los retratos de la ventana Objetivo salen cuadrados, como su marco.",
            "Ventana Objetivo: ya no sale el retrato de otro bicho cuando el NPC aun no estaba cargado en el juego (se borran los retratos guardados con ese fallo).",
            "Ventana Objetivo: con los retratos 3D, mientras el modelo no termina de cargar (NPC lejano o en otro continente) se ve el retrato 2D en vez de un cuadro vacio.",
            "Ventana Objetivo: retratos 2D y modelos 3D de los NPC aunque no los hayas visto nunca (el addon trae el modelo de mas de 10.000 NPC); al seleccionarlos se usa el modelo real del juego si es distinto.",
            "La ventana de la guia se fija por el banner: la tarjeta de arriba crece hacia arriba y la lista de abajo ya no se mueve ni cambia de tamaño con cada paso.",
            "Barra de vuelo: el icono va a la izquierda con las esquinas redondeadas y el texto ya no se monta sobre el tiempo.",
            "Opciones: nueva seccion Configuracion tiempos viaje, con simulador de la barra de vuelo (se apaga al cerrar las opciones) y tamaño del destino y del tiempo restante.",
            "Corregido el error \"attempt to index field 'HBD'\" cuando la libreria de mapas de Questie no estaba disponible al arrancar.",
            "Ajustes: el registro de cambios carga solo la ultima version, la categoria QuestieRouter se despliega al pulsarla y el aspecto y el boton de donar son como los de LizeUI.",
        },
    },
    {
        version = "0.9.1", date = "2026-11-10",
        title = "Vuelos aprendidos fiables",
        lines = {
            "Cada vez que abres el mapa de un maestro de vuelo se comprueban solos todos tus vuelos del continente.",
            "Ya no se dan por aprendidos vuelos que no tienes, ni se pierden los que si tienes.",
            "Al descubrir un vuelo se apunta el del maestro de vuelo con el que hablas; los vuelos que haces tambien cuentan.",
            "Aviso al calcular una ruta si aun no se sabe que vuelos tienes en ese continente.",
            "Se borran los vuelos que se habian dado por aprendidos por error: abre una vez el mapa de un maestro de vuelo en cada continente.",
            "Iconos de elite y mazmorra mas grandes; ilustraciones de zona suavizadas.",
        },
    },
    {
        version = "0.9.0", date = "2026-11-09",
        title = "Automatismos y Ajustes",
        lines = {
            "Coger y entregar misiones automaticamente al hablar con el NPC (activables en el menu y en Ajustes; con Mayus pulsada no se hace).",
            "Clic derecho en una mision de la lista: ruta hasta quien la da o hasta el inicio de su cadena.",
            "Saltar y recuperar misiones desde la lista.",
            "Avisos de por que una mision aun no se puede coger: nivel, mision anterior o ya hecha.",
            "Iconos de elite y de mision de mazmorra en la lista, en los pasos y en la leyenda.",
            "Panel en Ajustes > AddOns con las opciones, el registro de cambios y soporte (/qr settings).",
        },
    },
    {
        version = "0.8.4", date = "2026-11-09",
        title = "Pasos mas estables",
        lines = {
            "La guia ya no cambia sin parar entre dos misiones cercanas.",
            "Aviso de cosas que recoger cerca del camino.",
            "Ventanas Objetivo y Objetos con botones cuadrados, colocadas encima del seguimiento de misiones.",
        },
    },
    {
        version = "0.8.3", date = "2026-11-09",
        title = "Cadenas de misiones y arte nuevo",
        lines = {
            "Cadenas: la lista de misiones indica la mision anterior que falta.",
            "Si un NPC no ofrece una mision, ya no te vuelve a llevar hasta que avances.",
            "Nuevas ilustraciones de zona, cielos, iconos y texturas.",
        },
    },
    {
        version = "0.8.2", date = "2026-11-09",
        title = "Menu",
        lines = {
            "El menu del clic derecho se cierra al hacer clic fuera de el.",
        },
    },
    {
        version = "0.8.1", date = "2026-11-09",
        title = "Guias de mazmorras",
        lines = {
            "Guias de mazmorras: te lleva a coger sus misiones por el mundo y luego a la entrada.",
            "Los pasos que se hacen dentro de una mazmorra salen marcados como \"(dentro de ...)\".",
            "Barra y cuenta atras de los vuelos con los tiempos reales de cada trayecto.",
            "Nuevas flechas: RX, RX redonda, RX 3D prisma, RX 3D bloque y la oficial.",
            "Ventana Objetivo: marca encima del objetivo al seleccionarlo, con un icono distinto por boton.",
            "Leyenda de iconos en la lista; la tarjeta activa se puede ocultar para ver mas lista.",
        },
    },
    {
        version = "0.8.0", date = "2026-11-09",
        title = "Rutas de viaje e idiomas",
        lines = {
            "Ruta completa en el mapa y en la lista: vuelos, barcos, zepelines, tranvia y portales.",
            "Pasos entre zonas y caminos dentro de cada zona; a las ciudades se entra y se sale por sus puertas.",
            "Ruta hasta la entrada de una mazmorra (/qr dungeon).",
            "Interfaz en ingles y español (esES / esMX).",
        },
    },
    {
        version = "0.7.0", date = "2026-11-08",
        title = "Primera version",
        lines = {
            "Guias por zona y faccion: te lleva a coger, hacer y entregar las misiones de la zona en orden.",
            "Planificador por grupos: coge todo lo que hay cerca, hace los objetivos de alrededor y vuelve a entregar.",
            "Flecha de navegacion con el nombre del objetivo y la distancia, y lineas animadas en el mapa y el minimapa.",
            "Ventana de la guia: tarjeta del paso actual, lista de pasos y misiones, y banner de la zona con ciclo dia/noche.",
            "Selector de zona con miniaturas.",
            "Ruta mas rapida con vuelos, barcos y zepelines, y barra del vuelo en curso.",
            "Ventanitas Objetivo y Objetos para seleccionar a los enemigos y usar los objetos de mision.",
            "Boton del minimapa, menu del clic derecho y opciones graficas.",
        },
    },
}
QR.Changelogs.esMX = QR.Changelogs.esES

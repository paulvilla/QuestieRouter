-- QuestieRouter: notas propias de las misiones: lo que hay que hacer cuando Questie y el texto de la mision no lo
-- dejan claro (pasos que no son objetivos, sitios concretos, trucos). Escritas a mano.
--
-- Se ven bajo la flecha mientras haces la mision, en la tarjeta del paso actual de la ventana de la guia y en el
-- tooltip de la mision (lista de la guia y menu de guias).
--
-- Formato:  [questId] = { enUS = "texto", esES = "texto", ... }   (sin el idioma activo, el ingles)
-- Las coordenadas, del mapa de la zona de la mision.

local _, QR = ...

QR.QuestNotes = {
    -- ¿Que es el amor? (brujo, Alianza: el incubo). La figurilla no se puede coger mientras el NPC la vigila: hay que
    -- quemar el carro para que se mueva (comprobado en el juego). Questie lo tiene como objetivo extra.
    [65602] = {
        enUS = "Before taking the figurine: first pick up the stick (Unlit Torch), light it at a campfire and set the Archaeologist's Cart on fire (Ashenvale 26.7, 22.6). The NPC moves away and you can take the Wooden Figurine in the house (26.6, 22.0).",
        esES = "Antes de coger la figurilla: primero coge el palo (antorcha apagada), enciéndelo en una hoguera y prende fuego al Carro del arqueólogo (Vallefresno 26.7, 22.6). Así el NPC se mueve y puedes coger la figurilla de madera de la casa (26.6, 22.0).",
    },
}

--- Nota de una mision en el idioma activo (o en ingles), o nil
function QR.QuestNote(questId)
    local n = questId and QR.QuestNotes[questId]
    if not n then return nil end
    return n[QR.locale] or n.enUS
end

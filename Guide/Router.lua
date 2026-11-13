-- QuestieRouter: viajes (vuelos, barcos, zepelines y dirigibles de WoW Forever).
--
--   * Ruta mas rapida hasta el destino: Dijkstra sobre los maestros de vuelo que conoces, los muelles
--     de tu faccion y trayectos a pie/montura entre ellos. Si compensa (o el destino esta en otro
--     continente), la flecha te lleva primero al maestro de vuelo o al muelle, con el texto del viaje.
--   * Vuelo en curso: destino, tiempo total estimado y tiempo restante (para la barra del pie).
--     El tiempo sale de las yardas reales de cada tramo (datos del juego) y la velocidad de vuelo, que
--     se ajusta sola con cada vuelo; los trayectos ya volados se recuerdan con su duracion exacta.
--   * Calibracion: los datos van en el orden de las tablas del juego; la primera vez que abres un mapa
--     de vuelos se comprueba con tu posicion junto al maestro de vuelo y se fija el orden de ejes.

local _, QR = ...
local L = QR.L

local Router = {}
QR.Router = Router

local D -- QR.TravelData (cargado antes que este archivo)

local RUN_SPEED, MOUNT_SPEED = 7, 10.5      -- yardas/segundo
local TAXI_OVERHEAD = 15                    -- segundos: hablar con el maestro, despegar, aterrizar
local SAIL_WAIT = 75                        -- segundos: espera media del barco / zepelin
local SAIL_SPEED = 14                       -- yardas/segundo navegando
local USE_RATIO = 0.85                      -- se usa transporte si ahorra al menos un 15 %
local MIN_DIRECT = 700                      -- yardas: por debajo de esto nunca se propone un viaje

local playerFactionNum = UnitFactionGroup("player") == "Horde" and 2 or 1

---------------------------------------------------------------------------
-- Coordenadas
---------------------------------------------------------------------------
--- Tablas del juego (X norte-sur, Y este-oeste) -> coordenadas de HereBeDragons
local function ToHBD(X, Y)
    if QR.db.travel.axisSwap == false then return X, Y end
    return Y, X
end

local function Dist(ax, ay, bx, by)
    local dx, dy = ax - bx, ay - by
    return math.sqrt(dx * dx + dy * dy)
end

local function NodePoint(id)
    local n = D.nodes[id]
    if not n then return nil end
    local x, y = ToHBD(n[3], n[4])
    return { x = x, y = y, inst = n[2], name = n[1], nodeId = id }
end

---------------------------------------------------------------------------
-- Maestros de vuelo aprendidos (como ForeverRoute):
--   * C_TaxiMap.GetTaxiNodesForMap(mapa) responde en cualquier momento (no hace falta estar en un maestro de
--     vuelo). Se pregunta por el mapa donde estas y sus padres, el mapa de vuelos abierto y los dos continentes.
--     Si no da nada, C_TaxiMap.GetAllTaxiNodes(mapa).
--   * Regla: isUndiscovered == false -> aprendido; isUndiscovered == true -> no; sin esa marca, estado 1 o 2
--     (Reachable / Unreachable) -> aprendido.
--   * Se lee al entrar al juego, al abrir un mapa de vuelos, cuando el juego avisa de un cambio de rutas
--     (TAXI_NODE_STATUS_CHANGED) y al descubrir una ruta nueva. Lo aprendido no se borra nunca.
--   * Se guarda por personaje y por nodeID (QuestieRouterCharDB.knownTaxi[id] = true).
---------------------------------------------------------------------------
local TAXI_CONT_MAP = { [0] = 1415, [1] = 1414 }   -- continente -> mapa del continente

--- (para el vuelo en curso: nodos del mapa de vuelos abierto)
local function TaxiNodesNow(inst)
    if not (C_TaxiMap and C_TaxiMap.GetAllTaxiNodes) then return nil end
    local maps = { GetTaxiMapID and GetTaxiMapID() or false, TAXI_CONT_MAP[inst] or false }
    for _, mapId in ipairs(maps) do
        if mapId then
            local ok, nodes = pcall(C_TaxiMap.GetAllTaxiNodes, mapId)
            if ok and type(nodes) == "table" and #nodes > 0 then return nodes end
        end
    end
    return nil
end

--- Mapas por los que preguntar: SOLO los de los continentes (Kalimdor 1414, Reinos del Este 1415).
--- (Comprobado en WoW Forever: en el mapa de una zona, GetTaxiNodesForMap devuelve maestros de vuelo de todo el
--- continente y TODOS con isUndiscovered = false, aprendidos o no. En los mapas de continente la marca es fiable.)
local function TaxiCandidateMaps()
    return { 1414, 1415 }
end

--- Nodos de vuelo de un mapa: GetTaxiNodesForMap (trae la marca de "no descubierto") o, si no, GetAllTaxiNodes
local function TaxiNodesOnMap(mapId)
    if not C_TaxiMap then return nil, "sin C_TaxiMap" end
    if C_TaxiMap.GetTaxiNodesForMap then
        local ok, nodes = pcall(C_TaxiMap.GetTaxiNodesForMap, mapId)
        if ok and type(nodes) == "table" and #nodes > 0 then return nodes, "GetTaxiNodesForMap" end
    end
    if C_TaxiMap.GetAllTaxiNodes then
        local ok, nodes = pcall(C_TaxiMap.GetAllTaxiNodes, mapId)
        if ok and type(nodes) == "table" and #nodes > 0 then return nodes, "GetAllTaxiNodes" end
    end
    return nil, "sin datos"
end

--- Lo que dice GetTaxiNodesForMap (solo para /qr taxi <nombre>; NO se usa para decidir que esta aprendido:
--- en Classic no trae marca y en WoW Forever isUndiscovered sale siempre false)
local function NodeIsKnown(nd)
    if type(nd) ~= "table" then return nil end
    if nd.isUndiscovered == false then return true end
    if nd.isUndiscovered == true then return false end
    if nd.state == 1 or nd.state == 2 then return true end
    if nd.state ~= nil then return false end
    return nil
end

-- Enum.FlightPathState (C_TaxiMap.GetAllTaxiNodes): 0 Current, 1 Reachable, 2 Unreachable (= no aprendido)
local FPS = Enum and Enum.FlightPathState or {}
local FPS_CURRENT, FPS_UNREACHABLE = FPS.Current or 0, FPS.Unreachable or 2

local function TaxiDB()
    local c = QR.charDB
    c.knownTaxi = c.knownTaxi or {}
    c.knownTaxiSource = c.knownTaxiSource or {}
    c.taxiScanned = c.taxiScanned or {}
    c.taxiPartial = c.taxiPartial or {}
    return c.knownTaxi, c.knownTaxiSource
end

--- Cambia el estado de un vuelo; cuenta en 'changes' (si se pasa) lo que se ha ganado / perdido
local function SetKnown(id, learned, source, changes)
    local known, src = TaxiDB()
    local was = known[id] == true
    if learned then known[id] = true; src[id] = source else known[id] = nil; src[id] = nil end
    if changes and was ~= (learned and true or false) then
        if learned then changes.add = changes.add + 1 else changes.del = changes.del + 1 end
    end
end

--- Antes se leia aqui GetTaxiNodesForMap en cualquier momento; esa marca no es fiable y daba todos los vuelos por
--- aprendidos. Ahora los vuelos solo salen del mapa del maestro de vuelo, de los avisos del juego y de tus
--- vuelos. Se mantiene por compatibilidad: si el mapa de vuelos esta abierto, lo relee.
function Router:ScanKnownTaxi()
    if NumTaxiNodes and NumTaxiNodes() > 0 then return self:OnTaxiMapOpened(true) end
    return 0
end

-- Tipos del mapa de vuelos (API clasica) que significan "aprendido". DISTANT es un punto por el que pasa un
-- vuelo pero que NO has aprendido.
local LEARNED = { CURRENT = true, REACHABLE = true, UNREACHABLE = true }

--- Nombre sin la zona ("Punta de Nijel, Desolace" -> "punta de nijel")
local function TaxiKey(name)
    if type(name) ~= "string" then return nil end
    local s = name:match("^[^,]+") or name
    local i = s:find("\239\188\140", 1, true) -- coma de ancho completo (clientes chino / coreano)
    if i then s = s:sub(1, i - 1) end
    s = s:lower():gsub("^%s+", ""):gsub("%s+$", "")
    return s ~= "" and s or nil
end

--- Nombre (del cliente, de los mapas de continente; o ingles, de Data/Travel.lua) -> nodeID
--- Solo los nombres que señalan a UN unico vuelo de tu faccion (o neutral): si dos vuelos se llaman igual (Bahia
--- del Botin de Alianza y de Horda...) ese nombre no se usa, mejor no saberlo que apuntar el que no es.
local function TaxiNameIndex()
    local cand = {}
    local function put(k, id)
        local n = D.nodes[id]
        if not (k and n) or (n[5] ~= 3 and n[5] ~= playerFactionNum) then return end
        cand[k] = cand[k] or {}
        cand[k][id] = true
    end
    for id, n in pairs(D.nodes) do put(TaxiKey(n[1]), id) end
    for _, mapId in ipairs({ 1414, 1415 }) do
        local nodes = TaxiNodesOnMap(mapId)
        for _, nd in ipairs(nodes or {}) do
            if nd.nodeID then put(TaxiKey(nd.name), nd.nodeID) end
        end
    end
    local byName = {}
    for k, ids in pairs(cand) do
        local only, count = nil, 0
        for id in pairs(ids) do only, count = id, count + 1 end
        if count == 1 then byName[k] = only end
    end
    return byName
end

--- Hueco del mapa de vuelos abierto -> nodeID: por slotIndex (si el juego lo da) o por nombre
local function SlotNodes(inst)
    local bySlot, how = {}, {}
    for _, n in ipairs(TaxiNodesNow(inst) or {}) do
        if n.slotIndex and n.nodeID then bySlot[n.slotIndex] = n.nodeID; how[n.slotIndex] = "slot" end
    end
    if NumTaxiNodes and TaxiNodeName then
        local byName
        for i = 1, NumTaxiNodes() do
            if not bySlot[i] then
                byName = byName or TaxiNameIndex()
                local id = byName[TaxiKey(TaxiNodeName(i)) or ""]
                if id then bySlot[i] = id; how[i] = "nombre" end
            end
        end
    end
    return bySlot, how
end

--- npcID de la criatura con la que hablas (o tu objetivo)
local function TalkingNpcId()
    for _, unit in ipairs({ "npc", "target" }) do
        local guid = UnitGUID and UnitGUID(unit)
        if guid then
            local kind, _, _, _, _, id = strsplit("-", guid)
            if kind == "Creature" and tonumber(id) then return tonumber(id) end
        end
    end
    return nil
end

local SRC_MAP = "mapa de vuelos de un maestro de vuelo"

--- Al abrir el mapa de un maestro de vuelo (automatico, en cada visita): es la UNICA fuente fiable en Classic
--- (como Zygor / LibTaxi). Se lee por nodeID con C_TaxiMap.GetAllTaxiNodes: state ~= Unreachable -> aprendido,
--- Unreachable -> no. Si no responde, la API antigua (TaxiNodeGetType; DISTANT = no aprendido) por hueco.
---   * Solo se cambia lo que el juego ha devuelto.
---   * Los vuelos de tu faccion de este continente que el mapa NO lista se dan por no aprendidos solo si la
---     lectura es completa (todos los puntos aprendidos del mapa se han reconocido). Si no, no se borra nada.
--- quiet: sin mensaje en el chat. Devuelve cuantos vuelos han cambiado.
function Router:OnTaxiMapOpened(quiet)
    local px, py, pinst = QR.HBD:GetPlayerWorldPosition()
    if not pinst then return 0 end
    TaxiDB()
    local read, current = {}, nil
    local unknownLearned = 0   -- (API antigua) puntos aprendidos del mapa que no sabemos que vuelo son
    local total = 0
    -- 1) API moderna: por nodeID, sin depender de nombres
    for _, nd in ipairs(TaxiNodesNow(pinst) or {}) do
        if nd.state ~= nil then
            total = total + 1
            local learned = nd.state ~= FPS_UNREACHABLE
            if nd.nodeID and D.nodes[nd.nodeID] then
                read[nd.nodeID] = learned
                if nd.state == FPS_CURRENT then current = nd.nodeID end
            end
            -- (un nodeID que no esta en Data/Travel.lua no es ninguno de nuestros vuelos: no impide la lectura completa)
        end
    end
    -- 2) API antigua (por hueco; nombres solo si son inequivocos)
    if total == 0 and NumTaxiNodes and TaxiNodeGetType then
        local bySlot = SlotNodes(pinst)
        for i = 1, NumTaxiNodes() do
            local kind = TaxiNodeGetType(i)
            if kind and kind ~= "NONE" then
                total = total + 1
                local learned = LEARNED[kind] or false
                local id = bySlot[i]
                if id then
                    read[id] = learned
                    if kind == "CURRENT" then current = id end
                elseif learned then
                    unknownLearned = unknownLearned + 1
                end
            end
        end
    end
    if total == 0 then return 0 end   -- el mapa no ha dado nada: no se toca lo que ya se sabe

    local changes = { add = 0, del = 0 }
    for id, learned in pairs(read) do SetKnown(id, learned, SRC_MAP, changes) end
    local complete = unknownLearned == 0 and next(read) ~= nil
    if complete then
        for id, n in pairs(D.nodes) do
            if read[id] == nil and n[2] == pinst and (n[5] == 3 or n[5] == playerFactionNum) then
                SetKnown(id, false, nil, changes)
            end
        end
        QR.charDB.taxiScanned[pinst] = true
        QR.charDB.taxiPartial[pinst] = nil
    else
        QR.charDB.taxiPartial[pinst] = true
    end
    QR.charDB.taxiRecorded = true
    -- recordar que NPC es este maestro de vuelo (para apuntar bien el siguiente "nueva ruta de vuelo")
    local npc = TalkingNpcId()
    if npc and current then
        QR.db.taxiNpc = QR.db.taxiNpc or {}
        QR.db.taxiNpc[npc] = current
    end
    if changes.add + changes.del > 0 then
        self:Invalidate()
        if not quiet then QR:Print(string.format(L["Flights updated: +%d / -%d."], changes.add, changes.del)) end
    end
    if self.hintedCont then self.hintedCont[pinst] = nil end
    -- calibrar el orden de ejes con el maestro de vuelo en el que estas
    local data = current and D.nodes[current]
    if data and px and data[2] == pinst then
        local swapped = Dist(px, py, data[4], data[3])
        local straight = Dist(px, py, data[3], data[4])
        if math.min(swapped, straight) < 150 then QR.db.travel.axisSwap = swapped <= straight end
    end
    return changes.add + changes.del
end

--- /qr taxi map: con el mapa de vuelos abierto, lo que dice cada punto y con que vuelo se empareja
function Router:TaxiMapReport()
    if not (NumTaxiNodes and TaxiNodeGetType) or NumTaxiNodes() == 0 then
        QR:Print(L["Open a flight master's map first."])
        return
    end
    local bySlot, how = SlotNodes(select(3, QR.HBD:GetPlayerWorldPosition()))
    for i = 1, NumTaxiNodes() do
        local id = bySlot[i]
        -- el juego puede dar vuelos que no estan en Data/Travel.lua (p. ej. 559, Cima de la Eternidad en Hyjal)
        local node = id and D.nodes[id]
        QR:Print(string.format("%d. %s: %s -> %s", i, tostring(TaxiNodeName(i)), tostring(TaxiNodeGetType(i)),
            id and string.format("[%d] %s (%s)", id, node and node[1] or "(no esta en los datos del addon)", how[i] or "?") or "?"))
    end
end

--- /qr taxi: que vuelos cree el addon que tienes (para comprobar la deteccion)
function Router:TaxiReport()
    local known = QR.charDB.knownTaxi or {}
    for _, inst in ipairs({ 0, 1 }) do
        local yes, total = {}, 0
        for id, n in pairs(D.nodes) do
            if n[2] == inst and (n[5] == 3 or n[5] == playerFactionNum) then
                total = total + 1
                if known[id] == true then yes[#yes + 1] = (n[1]:gsub(",.*", "")) end
            end
        end
        table.sort(yes)
        local scanned = QR.charDB.taxiScanned and QR.charDB.taxiScanned[inst]
        QR:Print(string.format(L["%s: %d of %d flight masters learned."], Router.MapName(TAXI_CONT_MAP[inst]), #yes, total)
            .. " " .. (scanned and L["(checked at a flight master)"] or L["(estimate: open a flight master's map there to confirm)"]))
        if #yes > 0 then QR:Print("   " .. table.concat(yes, ", ")) end
    end
end

--- /qr taxi debug: lo que responde el juego, sin interpretar (para saber si su marca es fiable)
function Router:TaxiDebug()
    for _, mapId in ipairs({ 1414, 1415 }) do
        local nodes, api = TaxiNodesOnMap(mapId)
        if not nodes then
            QR:Print(string.format("map %d: %s", mapId, api))
        else
            local und = { t = 0, f = 0, n = 0 }
            local st = {}
            for _, nd in ipairs(nodes) do
                if nd.isUndiscovered == true then und.t = und.t + 1
                elseif nd.isUndiscovered == false then und.f = und.f + 1
                else und.n = und.n + 1 end
                local k = tostring(nd.state)
                st[k] = (st[k] or 0) + 1
            end
            local states = {}
            for k, v in pairs(st) do states[#states + 1] = k .. "=" .. v end
            table.sort(states)
            QR:Print(string.format("map %d: %s, %d nodos | isUndiscovered true=%d false=%d nil=%d | state %s",
                mapId, api, #nodes, und.t, und.f, und.n, table.concat(states, " ")))
        end
    end
end

--- Maestros de vuelo cuyo nombre (ingles o del cliente) contiene 'text'
local function FindTaxiNodes(text)
    text = (text or ""):lower()
    local out, seen = {}, {}
    for id, n in pairs(D.nodes) do
        if n[1]:lower():find(text, 1, true) then out[#out + 1] = id; seen[id] = true end
    end
    for _, mapId in ipairs({ 1414, 1415 }) do
        local nodes = TaxiNodesOnMap(mapId)
        for _, nd in ipairs(nodes or {}) do
            if nd.nodeID and not seen[nd.nodeID] and type(nd.name) == "string" and nd.name:lower():find(text, 1, true) and D.nodes[nd.nodeID] then
                out[#out + 1] = nd.nodeID; seen[nd.nodeID] = true
            end
        end
    end
    table.sort(out)
    return out
end

--- /qr taxi <nombre>: estado de un maestro de vuelo: lo guardado, de donde salio y lo que dice cada mapa ahora
function Router:TaxiNodeReport(text)
    local ids = FindTaxiNodes(text)
    if #ids == 0 then QR:Print(string.format(L["No flight master matches '%s'."], text)) return end
    for _, id in ipairs(ids) do
        local n = D.nodes[id]
        local known = QR.charDB.knownTaxi and QR.charDB.knownTaxi[id]
        local src = QR.charDB.knownTaxiSource and QR.charDB.knownTaxiSource[id]
        QR:Print(string.format("[%d] %s (%s): %s%s", id, n[1], n[5] == 1 and "A" or n[5] == 2 and "H" or "A+H",
            known == true and "|cff71d6a2" .. L["learned"] .. "|r" or "|cffff8178" .. L["not learned"] .. "|r",
            src and (" - " .. src) or ""))
        for _, mapId in ipairs(TaxiCandidateMaps()) do
            local nodes, api = TaxiNodesOnMap(mapId)
            for _, nd in ipairs(nodes or {}) do
                if nd.nodeID == id then
                    QR:Print(string.format("   mapa %d (%s): isUndiscovered=%s state=%s -> %s", mapId, api,
                        tostring(nd.isUndiscovered), tostring(nd.state), tostring(NodeIsKnown(nd))))
                end
            end
        end
    end
end

--- /qr taxi forget <nombre>: lo marca como no aprendido (si el juego vuelve a decir que si, volvera)
function Router:TaxiForget(text)
    local ids = FindTaxiNodes(text)
    for _, id in ipairs(ids) do
        if QR.charDB.knownTaxi then QR.charDB.knownTaxi[id] = nil end
        if QR.charDB.knownTaxiSource then QR.charDB.knownTaxiSource[id] = nil end
        QR:Print(string.format(L["%s: marked as not learned."], D.nodes[id][1]))
    end
    if #ids == 0 then QR:Print(string.format(L["No flight master matches '%s'."], text)) end
    self:Invalidate()
end

--- "Has descubierto una nueva ruta de vuelo" / "No conoces rutas desde aqui": el maestro de vuelo con el que
--- hablas queda aprendido. Se busca por el NPC (aprendido de visitas anteriores); si no, el maestro de vuelo de tu
--- faccion mas cercano (a menos de 80 yd).
function Router:LearnTalkedTaxi(source)
    local id
    local npc = TalkingNpcId()
    if npc and QR.db.taxiNpc then id = QR.db.taxiNpc[npc] end
    if not id then
        local px, py, pinst = QR.HBD:GetPlayerWorldPosition()
        if not px then return end
        local bd
        for nid, n in pairs(D.nodes) do
            if n[2] == pinst and (n[5] == 3 or n[5] == playerFactionNum) then
                local x, y = ToHBD(n[3], n[4])
                local d = Dist(px, py, x, y)
                if not bd or d < bd then id, bd = nid, d end
            end
        end
        if not bd or bd >= 80 then return end
    end
    if id and D.nodes[id] and TaxiDB()[id] ~= true then
        SetKnown(id, true, source)
        self:Invalidate()
    end
    -- si el mapa de vuelos se ha abierto a la vez, leerlo entero
    C_Timer.After(0.3, function() if NumTaxiNodes and NumTaxiNodes() > 0 then Router:OnTaxiMapOpened() end end)
end
Router.LearnNearestTaxi = function(self) return self:LearnTalkedTaxi("aviso del juego: nueva ruta de vuelo") end

--- ¿Se puede usar este maestro de vuelo? Solo si esta aprendido (y es de tu faccion o neutral)
local function NodeUsable(id)
    local n = D.nodes[id]
    if not n then return false end
    if n[5] ~= 3 and n[5] ~= playerFactionNum then return false end
    return QR.charDB.knownTaxi and QR.charDB.knownTaxi[id] == true or false
end

--- ¿Sabemos de verdad que vuelos tienes en este continente? (leido entero en un maestro de vuelo)
function Router:TaxiVerified(inst)
    local c = QR.charDB
    return (inst ~= nil and c.taxiScanned and c.taxiScanned[inst] and not (c.taxiPartial and c.taxiPartial[inst])) and true or false
end

--- ¿Sabemos algun maestro de vuelo aprendido?
local function AnyKnownTaxi()
    for _, v in pairs(QR.charDB.knownTaxi or {}) do if v == true then return true end end
    return false
end

---------------------------------------------------------------------------
-- Grafo de viaje
---------------------------------------------------------------------------
local pathLen -- [a][b] = yardas (vuelo directo entre dos nodos)

local function BuildStatic()
    pathLen = {}
    for _, p in ipairs(D.paths) do
        pathLen[p[1]] = pathLen[p[1]] or {}
        local old = pathLen[p[1]][p[2]]
        if not old or p[3] < old then pathLen[p[1]][p[2]] = p[3] end
    end
end

local function GroundSpeed()
    if IsMounted and IsMounted() then return MOUNT_SPEED end
    return UnitLevel("player") >= 40 and MOUNT_SPEED or RUN_SPEED
end

---------------------------------------------------------------------------
-- Zonas y pasos entre zonas (Data/Borders.lua)
--   * Dentro de una zona se va en linea recta.
--   * Entre zonas con frontera abierta (Elwynn / Paramos de Poniente...) tambien.
--   * Entre zonas separadas por montañas o agua hay que pasar por un cruce (puerto, tunel, puente...):
--     ir en linea recta cuesta mucho mas, asi la ruta busca los cruces. Si faltara algun cruce en los
--     datos, la ruta sigue existiendo (en linea recta), solo que se prefieren los pasos conocidos.
---------------------------------------------------------------------------
local CONTINENT_MAP = { [0] = 1415, [1] = 1414 }   -- Reinos del Este, Kalimdor
local CLOSED_FACTOR = 4      -- linea recta entre dos zonas con cruces propios (montañas, agua)
-- tranvia y portales (Data/Borders.lua, links): segundos que cuesta usarlos
local LINK_COST = { tram = 60, portal = 8, door = 3 }
local playerFactionLetter = UnitFactionGroup("player") == "Horde" and "H" or "A"

local UNKNOWN_FACTOR = 1.3   -- linea recta entre zonas de las que no sabemos nada
local CROSS_COST = 0         -- segundos extra por pasar un cruce (0: el cruce siempre sale mas barato que saltarlo)
local ROUGH_FACTOR = 2       -- campo a traves dentro de una zona con caminos (Data/Roads.lua): mejor el camino
local ROAD_SNAP = 120        -- yardas: hasta esta distancia se va recto aunque la zona tenga caminos

local borderZone, openPair = {}, {}
local roughZone = {}
local factorCache = {}

--- Caminos dentro de las zonas: los del addon (Data/Roads.lua) y los añadidos con /qr road
local function AllRoads()
    local list = {}
    for _, r in ipairs(QR.RoadData or {}) do list[#list + 1] = r end
    for _, r in ipairs(QR.db and QR.db.customRoads or {}) do list[#list + 1] = r end
    return list
end

local function LoadRoads()
    wipe(roughZone)
    for _, r in ipairs(AllRoads()) do if #r[2] >= 4 then roughZone[r[1]] = true end end
end

local function LoadBorders()
    local B = QR.BorderData
    if not B then return end
    for _, c in ipairs(B.crossings or {}) do borderZone[c[1]], borderZone[c[4]] = true, true end
    for _, o in ipairs(B.open or {}) do
        openPair[o[1]] = openPair[o[1]] or {}; openPair[o[1]][o[2]] = true
        openPair[o[2]] = openPair[o[2]] or {}; openPair[o[2]][o[1]] = true
    end
end

--- Cuanto mas "cuesta" ir en linea recta de la zona za a la zb
local function WalkFactor(za, zb)
    if not za or not zb or za == zb then return 1 end
    local row = factorCache[za]
    if not row then row = {}; factorCache[za] = row end
    local f = row[zb]
    if not f then
        if openPair[za] and openPair[za][zb] then f = 1
        elseif borderZone[za] and borderZone[zb] then f = CLOSED_FACTOR
        else f = UNKNOWN_FACTOR end
        row[zb] = f
    end
    return f
end

--- Sube de subzona / mazmorra a la zona (o ciudad) que la contiene
local function NormalizeZone(map)
    local guard = 0
    while map and guard < 6 and C_Map and C_Map.GetMapInfo do
        local info = C_Map.GetMapInfo(map)
        if not info or not info.mapType or info.mapType <= 3 then return map end
        map, guard = info.parentMapID, guard + 1
    end
    return map
end

--- Zona de un punto del mundo (por su posicion en el mapa del continente)
local function ZoneAt(inst, x, y)
    local cont = CONTINENT_MAP[inst]
    if not (cont and C_Map and C_Map.GetMapInfoAtPosition) then return nil end
    local nx, ny = QR:ZoneCoordsFromWorld(x, y, inst, cont)
    if not nx then return nil end
    local ok, info = pcall(C_Map.GetMapInfoAtPosition, cont, nx, ny)
    local map = ok and info and NormalizeZone(info.mapID) or nil
    if not map then return nil end
    -- Ciudades amuralladas: en el mapa del continente el punto cae en la zona que la rodea (Ventormenta ->
    -- Bosque de Elwynn). Se pregunta tambien al mapa de esa zona: si el punto esta en una ciudad (otro mapa de
    -- tipo zona), la zona es la ciudad. Asi entrar o salir de ella obliga a pasar por la puerta (Data/Borders.lua).
    local zx, zy = QR:ZoneCoordsFromWorld(x, y, inst, map, true)
    if zx and zx >= 0 and zx <= 1 and zy >= 0 and zy <= 1 then
        local ok2, sub = pcall(C_Map.GetMapInfoAtPosition, map, zx, zy)
        if ok2 and sub and sub.mapID ~= map and sub.mapType == 3 then map = sub.mapID end
    end
    return map
end

local function MapName(map)
    local info = map and C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
    return info and info.name or "?"
end

---------------------------------------------------------------------------
-- Grafo fijo (maestros de vuelo, muelles y cruces). Se rehace solo si cambian los vuelos conocidos o los
-- ajustes. Los puntos 1 (salida) y 2 (llegada) se rellenan en cada calculo.
---------------------------------------------------------------------------
local graph

local function GraphKey(cfg)
    local n, f = 0, 0
    for _, v in pairs(QR.charDB.knownTaxi or {}) do n = n + (v and 2 or 1) end
    local roads = 0
    for _, r in ipairs(QR.db.customRoads or {}) do roads = roads + #r[2] end
    return table.concat({ cfg.flights and 1 or 0, cfg.boats and 1 or 0, n, f, tostring(cfg.axisSwap), roads }, ":")
end

local function BuildGraph(cfg)
    local taxiSpeed = cfg.taxiSpeed or 32
    local pts, edges = { false, false }, {}
    local function add(p) pts[#pts + 1] = p; return #pts end
    local function edge(i, j, cost, kind, extra)
        edges[i] = edges[i] or {}
        edges[i][#edges[i] + 1] = { j, cost, kind, extra }
    end
    if cfg.flights then
        local nodeIndex = {}
        for id in pairs(D.nodes) do
            if NodeUsable(id) then
                local p = NodePoint(id)
                p.kind = "flightmaster"
                p.zone = ZoneAt(p.inst, p.x, p.y)
                nodeIndex[id] = add(p)
            end
        end
        -- tramos de vuelo entre maestros aprendidos (las escalas tambien tienen que estar aprendidas).
        -- El tiempo de hablar con el maestro y despegar (TAXI_OVERHEAD) se cuenta al llegar andando al
        -- maestro de vuelo, no en cada escala: un vuelo con escalas no aterriza.
        for a, list in pairs(pathLen) do
            for b, yards in pairs(list) do
                if nodeIndex[a] and nodeIndex[b] then
                    -- segundos reales del vuelo directo si se conocen (Data/TaxiTimes.lua o tus vuelos)
                    local secs = (QR.db.travel.times and QR.db.travel.times[a .. "-" .. b])
                        or (QR.TaxiTimes and QR.TaxiTimes[a] and QR.TaxiTimes[a][b]) or yards / taxiSpeed
                    edge(nodeIndex[a], nodeIndex[b], secs, "flight", { yards = yards })
                end
            end
        end
    end
    if cfg.boats then
        for _, s in ipairs(D.sailings) do
            if s[3] == 3 or s[3] == playerFactionNum then
                local ax, ay = ToHBD(s[4][2], s[4][3])
                local bx, by = ToHBD(s[5][2], s[5][3])
                local ia = add({ x = ax, y = ay, inst = s[4][1], kind = "dock", sailing = s, zone = ZoneAt(s[4][1], ax, ay) })
                local ib = add({ x = bx, y = by, inst = s[5][1], kind = "dock", sailing = s, zone = ZoneAt(s[5][1], bx, by) })
                local cost = SAIL_WAIT + s[6] / SAIL_SPEED
                edge(ia, ib, cost, s[1], { sailing = s, to = ib })
                edge(ib, ia, cost, s[1], { sailing = s, to = ia })
            end
        end
    end
    -- cruces entre zonas: dos puntos (un lado en cada zona) unidos por un paso corto
    for _, c in ipairs(QR.BorderData and QR.BorderData.crossings or {}) do
        local ax, ay, ainst = QR.HBD:GetWorldCoordinatesFromZone(c[2], c[3], c[1])
        local bx, by, binst = QR.HBD:GetWorldCoordinatesFromZone(c[5], c[6], c[4])
        if ax and bx and ainst == binst then
            local ia = add({ x = ax, y = ay, inst = ainst, kind = "border", zone = c[1] })
            local ib = add({ x = bx, y = by, inst = binst, kind = "border", zone = c[4] })
            local d = Dist(ax, ay, bx, by)
            edge(ia, ib, nil, "border", { crossing = c[7], toZone = c[4], dist = d })
            edge(ib, ia, nil, "border", { crossing = c[7], toZone = c[1], dist = d })
        end
    end
    -- tranvia y portales (solo los de tu faccion o de las dos)
    for _, l in ipairs(QR.BorderData and QR.BorderData.links or {}) do
        if not l[8] or l[8] == playerFactionLetter then
            local ax, ay, ainst = QR.HBD:GetWorldCoordinatesFromZone(l[2], l[3], l[1])
            local bx, by, binst = QR.HBD:GetWorldCoordinatesFromZone(l[5], l[6], l[4])
            if ax and bx then
                local ia = add({ x = ax, y = ay, inst = ainst, kind = "link", zone = l[1] })
                local ib = add({ x = bx, y = by, inst = binst, kind = "link", zone = l[4] })
                local cost = LINK_COST[l[7]] or 10
                edge(ia, ib, cost, l[7], { toZone = l[4] })
                if not l[9] then edge(ib, ia, cost, l[7], { toZone = l[1] }) end
            end
        end
    end
    -- caminos dentro de las zonas: cada punto es un nodo, unido al siguiente por el propio camino
    LoadRoads()
    for _, r in ipairs(AllRoads()) do
        local prevIndex, prevP
        local raw = r[2]
        for k = 1, #raw - 1, 2 do
            local x, y, inst = QR.HBD:GetWorldCoordinatesFromZone(raw[k], raw[k + 1], r[1])
            if x then
                local i = add({ x = x, y = y, inst = inst, kind = "road", zone = r[1] })
                if prevIndex and prevP.inst == inst then
                    local d = Dist(prevP.x, prevP.y, x, y)
                    edge(prevIndex, i, nil, "road", { dist = d })
                    edge(i, prevIndex, nil, "road", { dist = d })
                end
                prevIndex, prevP = i, pts[i]
            end
        end
    end
    return { pts = pts, edges = edges, key = GraphKey(cfg) }
end

--- Zona del jugador y un punto en ella (0..1): su posicion o las coordenadas dadas en el mapa de esa zona
function Router:PlayerZonePoint(x, y)
    local px, py, map = QR.HBD:GetPlayerZonePosition(true)
    local zone = NormalizeZone(map)
    if not zone then return nil end
    if x and y then return zone, x, y end
    if not px then return nil end
    if zone ~= map then
        local wx, wy, inst = QR.HBD:GetWorldCoordinatesFromZone(px, py, map)
        if not wx then return nil end
        px, py = QR:ZoneCoordsFromWorld(wx, wy, inst, zone, true)
        if not px then return nil end
    end
    return zone, px, py
end

Router.MapName = MapName

---------------------------------------------------------------------------
-- Entradas de mazmorras (Data/Dungeons.lua)
---------------------------------------------------------------------------
--- Nombre de una mazmorra en el idioma del cliente (si el juego lo sabe) o en ingles
local function DungeonName(d)
    local n = GetRealZoneText and d[1] and d[1] > 0 and GetRealZoneText(d[1])
    if type(n) == "string" and n ~= "" then return n end
    return d[2]
end
Router.DungeonName = DungeonName

--- Entrada de una mazmorra por su nombre en ingles exacto de Data/Dungeons.lua (lo usan las guias de mazmorra).
--- Devuelve { name, wx, wy, inst } o nil. Se guarda en cache: los datos no cambian.
local entranceCache = {}
function Router:DungeonEntrance(english)
    if entranceCache[english] ~= nil then return entranceCache[english] or nil end
    local found = false
    for _, e in ipairs(QR.DungeonData or {}) do
        for _, d in ipairs(e[5]) do
            if d[2] == english then
                local wx, wy, inst
                if e[1] then
                    wx, wy = ToHBD(e[2], e[3]); inst = e[1]
                else
                    wx, wy, inst = QR.HBD:GetWorldCoordinatesFromZone(e[2], e[3], e[4])
                end
                if wx then found = { name = DungeonName(d), wx = wx, wy = wy, inst = inst } end
            end
        end
    end
    entranceCache[english] = found
    return found or nil
end

--- Mazmorras cuyo nombre (traducido o en ingles) contiene 'text'. Devuelve { { name, wx, wy, inst, min, max }, ... }
function Router:FindDungeons(text)
    text = (text or ""):lower()
    local out = {}
    for _, e in ipairs(QR.DungeonData or {}) do
        local wx, wy, inst
        if e[1] then
            wx, wy = ToHBD(e[2], e[3]); inst = e[1]
        else
            wx, wy, inst = QR.HBD:GetWorldCoordinatesFromZone(e[2], e[3], e[4])
        end
        for _, d in ipairs(e[5]) do
            local name = DungeonName(d)
            if wx and (text == "" or name:lower():find(text, 1, true) or d[2]:lower():find(text, 1, true)) then
                out[#out + 1] = { name = name, wx = wx, wy = wy, inst = inst, min = d[4], max = d[5], raid = d[3] }
            end
        end
    end
    return out
end

--- Hay que rehacer el grafo (p. ej. tras añadir un camino con /qr road)
function Router:Invalidate()
    graph = nil
    wipe(factorCache)
end

--- Ruta mas rapida desde (sx, sy, sinst) en la zona szone hasta (gx, gy, ginst) en la zona gzone.
--- walkOnly: solo a pie (con los cruces), para comparar con el transporte.
--- Devuelve la lista de tramos { { kind = "walk"|"border"|"flight"|"boat"|..., from, to, extra }, ... } y el coste
function Router:Plan(sx, sy, sinst, szone, gx, gy, ginst, gzone, walkOnly)
    local cfg = QR.db.travel
    local speed = GroundSpeed()
    if cfg.flights and not walkOnly then
        -- continente sin comprobar en un maestro de vuelo (o la ultima lectura salio incompleta): se avisa una vez
        -- por continente y sesion. La ruta solo usa los vuelos confirmados.
        self.hintedCont = self.hintedCont or {}
        for _, inst in ipairs({ sinst, ginst }) do
            if TAXI_CONT_MAP[inst] and not self:TaxiVerified(inst) and not self.hintedCont[inst] then
                self.hintedCont[inst] = true
                QR:Print(string.format(L["I don't know which flights you have in %s yet: talk to a flight master there and routes will use them."],
                    MapName(TAXI_CONT_MAP[inst])))
            end
        end
    end
    if not pathLen then BuildStatic() end
    if not graph or graph.key ~= GraphKey(cfg) then graph = BuildGraph(cfg) end
    local P, E = graph.pts, graph.edges
    P[1] = { x = sx, y = sy, inst = sinst, zone = szone, start = true }
    P[2] = { x = gx, y = gy, inst = ginst, zone = gzone, goal = true }
    local N = #P

    -- Dijkstra (pocos cientos de puntos: lineal es suficiente). Los tramos a pie se calculan al vuelo.
    local dist, prev, done = { [1] = 0 }, {}, {}
    while true do
        local u, best
        for i, d in pairs(dist) do
            if not done[i] and (not best or d < best) then u, best = i, d end
        end
        if not u or u == 2 then break end
        done[u] = true
        local pu = P[u]
        for _, e in ipairs(E[u] or {}) do
            if e[3] == "border" or e[3] == "road" or not walkOnly then
                local cost = e[2] or (e[4].dist / speed + (e[3] == "border" and CROSS_COST or 0))
                local v, nd = e[1], best + cost
                if not dist[v] or nd < dist[v] then dist[v], prev[v] = nd, { u, e } end
            end
        end
        for v = 2, N do
            local pv = P[v]
            if v ~= u and not done[v] and pv.inst == pu.inst then
                local d = Dist(pu.x, pu.y, pv.x, pv.y)
                local f = WalkFactor(pu.zone, pv.zone)
                if f == 1 and pu.zone and pu.zone == pv.zone and roughZone[pu.zone] and d > ROAD_SNAP then f = ROUGH_FACTOR end
                local nd = best + d * f / speed
                if pv.kind == "flightmaster" then nd = nd + TAXI_OVERHEAD end
                if not dist[v] or nd < dist[v] then dist[v], prev[v] = nd, { u, { v, nil, "walk" } } end
            end
        end
    end
    if not dist[2] then return nil end
    local legs, v = {}, 2
    while prev[v] do
        local u, e = prev[v][1], prev[v][2]
        table.insert(legs, 1, { kind = e[3], from = P[u], to = P[v], extra = e[4] })
        v = u
    end
    return legs, dist[2]
end

--- Nombre corto de la zona de un punto: el maestro de vuelo mas cercano ("Ventormenta, Elwynn")
local function NearestNodeName(p)
    local best, bestD
    for id, n in pairs(D.nodes) do
        if n[2] == p.inst then
            local x, y = ToHBD(n[3], n[4])
            local d = Dist(p.x, p.y, x, y)
            if not bestD or d < bestD then best, bestD = n[1], d end
        end
    end
    return best or "?"
end

local KIND_TAKE = { boat = "Take the boat", zeppelin = "Take the zeppelin", airship = "Take the airship" }
local KIND_ICON = { walk = "walk", border = "walk", flight = "Gryphon", boat = "Boat", zeppelin = "Boat", airship = "Boat",
                    tram = "arrow", portal = "arrow", door = "arrow" }
-- texto de cada tipo de cruce (frase entera: cada idioma la construye a su manera)
local CROSS_TEXT = {
    tunnel = "%sGo through the tunnel to|r %s", bridge = "%sCross the bridge to|r %s",
    elevator = "%sTake the elevator to|r %s", gate = "%sGo through the gate to|r %s",
}

-- tranvia y portales
local LINK_TEXT = {
    tram = "%sTake the Deeprun Tram to|r %s", portal = "%sTake the portal to|r %s", door = "%sGo through to|r %s",
}

local function LinkText(leg)
    local T = QR.Skin.TEXT
    return string.format(L[LINK_TEXT[leg.kind] or LINK_TEXT.door], T.warn, T.friendly .. MapName(leg.extra and leg.extra.toZone) .. "|r")
end

local function CrossText(leg)
    local T = QR.Skin.TEXT
    local fmt = CROSS_TEXT[leg.extra and leg.extra.crossing] or "%sWalk into|r %s"
    return string.format(L[fmt], T.warn, T.friendly .. MapName(leg.extra and leg.extra.toZone) .. "|r")
end

Router.ToHBD = ToHBD

---------------------------------------------------------------------------
-- Ruta completa (para dibujarla en el mapa y para la lista de pasos)
--   route.segments[i] = { kind, points = { { inst, x, y }, ... } }   (coordenadas de HereBeDragons)
--   route.steps[i]    = { kind, text, icon }                          (texto de cada etapa del viaje)
-- Todo sale de Data/ (datos propios del addon): no depende de ningun otro addon.
---------------------------------------------------------------------------
local pathPts -- [a][b] = { X1, Y1, ... } recorrido real del vuelo (tablas del juego)

local function FlightPoints(a, b, inst)
    if not pathPts then
        pathPts = {}
        for _, p in ipairs(D.paths) do
            if p[4] then
                pathPts[p[1]] = pathPts[p[1]] or {}
                pathPts[p[1]][p[2]] = p[4]
            end
        end
    end
    local raw = pathPts[a] and pathPts[a][b]
    if not raw then return nil end
    local out = {}
    for k = 1, #raw - 1, 2 do
        local x, y = ToHBD(raw[k], raw[k + 1])
        out[#out + 1] = { inst, x, y }
    end
    return out
end

--- Recorrido del barco desde el muelle 'from' (los datos van del muelle A al B: se invierte si hace falta)
local function SailingPoints(s, from)
    local out = {}
    for _, piece in ipairs(s[7] or {}) do
        local raw = piece[2]
        for k = 1, #raw - 1, 2 do
            local x, y = ToHBD(raw[k], raw[k + 1])
            out[#out + 1] = { piece[1], x, y }
        end
    end
    if #out == 0 then return nil end
    local ax, ay = ToHBD(s[4][2], s[4][3])
    if not (from.inst == s[4][1] and Dist(from.x, from.y, ax, ay) < 60) then
        local rev = {}
        for k = #out, 1, -1 do rev[#rev + 1] = out[k] end
        out = rev
    end
    return out
end

local function BuildRoute(legs, target, px, py, pinst)
    local T = QR.Skin.TEXT
    local route = { segments = {}, steps = {} }
    local i = 1
    while i <= #legs do
        local leg = legs[i]
        local seg = { kind = leg.kind }
        if leg.kind == "walk" or leg.kind == "border" or leg.kind == "road" then
            seg.kind = "walk"
            local fx, fy, finst = leg.from.x, leg.from.y, leg.from.inst
            if leg.from.start then fx, fy, finst = px, py, pinst; seg.fromPlayer = true end
            seg.points = { { finst, fx, fy }, { leg.to.inst, leg.to.x, leg.to.y } }
            route.segments[#route.segments + 1] = seg
            -- una frase entera por caso (cada idioma la construye a su manera: "Ve al", "Gehe zum"...)
            local text
            if leg.kind == "border" then
                text = CrossText(leg)
            elseif leg.to.goal then
                text = string.format(L["%sGo to|r %s"], T.warn, T.friendly .. (target.name or target.questName or "?") .. "|r")
            elseif leg.to.kind == "flightmaster" then
                text = string.format(L["%sGo to the flight master|r (%s)"], T.warn, leg.to.name or "?")
            elseif leg.to.kind == "dock" then
                text = string.format(L["%sGo to the dock|r (%s)"], T.warn, leg.to.sailing and leg.to.sailing[2] or "?")
            end
            -- (ir hasta un cruce no es una etapa: la etapa es el propio cruce)
            if text then route.steps[#route.steps + 1] = { kind = "walk", icon = KIND_ICON.walk, text = text } end
            i = i + 1
        elseif LINK_TEXT[leg.kind] then
            seg.points = { { leg.from.inst, leg.from.x, leg.from.y }, { leg.to.inst, leg.to.x, leg.to.y } }
            route.segments[#route.segments + 1] = seg
            route.steps[#route.steps + 1] = { kind = leg.kind, icon = KIND_ICON[leg.kind], text = LinkText(leg) }
            i = i + 1
        elseif leg.kind == "flight" then
            -- vuelos seguidos: un solo paso en la lista ("Vuela a X"), un trozo de linea por tramo
            local last, stops = leg, 0
            while true do
                local pts = FlightPoints(last.from.nodeId, last.to.nodeId, last.from.inst)
                    or { { last.from.inst, last.from.x, last.from.y }, { last.to.inst, last.to.x, last.to.y } }
                route.segments[#route.segments + 1] = { kind = "flight", points = pts }
                local nxt = legs[i + 1]
                if nxt and nxt.kind == "flight" then last, stops, i = nxt, stops + 1, i + 1 else break end
            end
            local text = string.format(L["%sFly to|r %s"], T.warn, last.to.name or "?")
            if stops > 0 then text = text .. " " .. T.done .. string.format(L["(stops: %d)"], stops) .. "|r" end
            route.steps[#route.steps + 1] = { kind = "flight", icon = KIND_ICON.flight,
                text = string.format(L["%sFlight master|r: %s"], T.friendly, leg.from.name or "?") .. "\n" .. text }
            i = i + 1
        else
            local s = leg.extra and leg.extra.sailing
            seg.points = (s and SailingPoints(s, leg.from))
                or { { leg.from.inst, leg.from.x, leg.from.y }, { leg.to.inst, leg.to.x, leg.to.y } }
            route.segments[#route.segments + 1] = seg
            route.steps[#route.steps + 1] = { kind = leg.kind, icon = KIND_ICON[leg.kind] or "Boat",
                text = T.warn .. L[KIND_TAKE[leg.kind] or "Take the boat"] .. "|r" .. (s and (": " .. s[2]) or "")
                    .. "\n" .. string.format(L["towards %s"], NearestNodeName(leg.to)) }
            i = i + 1
        end
    end
    -- firma de la ruta (texto de sus etapas): si cambia, el destino se actualiza aunque el siguiente punto sea el mismo
    local sig = {}
    for _, st in ipairs(route.steps) do sig[#sig + 1] = st.kind .. ":" .. st.text end
    route.key = table.concat(sig, "|")
    return route
end

local function Flags(legs)
    local transport, border = false, false
    for _, l in ipairs(legs) do
        if l.kind == "border" or l.kind == "road" then border = true elseif l.kind ~= "walk" then transport = true end
    end
    return transport, border
end

--- Si hace falta viajar (transporte o pasos entre zonas), sustituye el destino por el siguiente punto de
--- la ruta: un cruce, el maestro de vuelo o el muelle. La ruta entera va en .route (mapa y lista).
-- Vuelo en curso (se rellenan en OnTakeTaxiNode / OnTaxiStateChanged, mas abajo)
local pending, flight

function Router:Wrap(target)
    if not (target and target.wx) or not QR.db.travel.enabled then return target end
    if UnitOnTaxi and UnitOnTaxi("player") then
        -- En pleno vuelo, "ve al maestro de vuelo" y "vuela a" ya estan hechos: el viaje se calcula desde el
        -- punto de vuelo donde vas a aterrizar (flecha, lineas del mapa y pasos de la lista siguen desde alli)
        local land = flight and flight.destId and NodePoint(flight.destId)
        if not land then
            -- sin saber el destino (vuelo tomado sin pasar por el mapa del addon): lo de antes
            local last = self.lastTravel
            if last and last.final and last.final.questId == target.questId then return last end
            return target
        end
        local key = table.concat({ flight.destId, tostring(target.questId), tostring(target.wx), tostring(target.wy) }, ":")
        if self.taxiWrap and self.taxiWrap.key == key then return self.taxiWrap.result end
        local result = self:WrapFrom(target, land.x, land.y, land.inst, ZoneAt(land.inst, land.x, land.y))
        self.taxiWrap = { key = key, result = result }
        return result
    end
    self.taxiWrap = nil
    self.lastTravel = nil
    local px, py, pinst = QR.HBD:GetPlayerWorldPosition()
    if not px then return target end
    local szone = NormalizeZone(QR.HBD.GetPlayerZone and QR.HBD:GetPlayerZone()) or ZoneAt(pinst, px, py)
    return self:WrapFrom(target, px, py, pinst, szone)
end

--- El viaje hasta target saliendo de (px, py, pinst) en la zona szone: tu posicion o, en vuelo, donde aterrizas
function Router:WrapFrom(target, px, py, pinst, szone)
    local direct = (pinst == target.instance) and Dist(px, py, target.wx, target.wy) or nil
    local gzone = (target.uiMapId and NormalizeZone(target.uiMapId)) or ZoneAt(target.instance, target.wx, target.wy)
    -- cerca y sin montañas en medio (misma zona o frontera abierta): flecha directa
    if direct and direct < MIN_DIRECT and WalkFactor(szone, gzone) == 1 and not (roughZone[szone] and direct > ROAD_SNAP) then
        return target
    end
    local legs, cost = self:Plan(px, py, pinst, szone, target.wx, target.wy, target.instance, gzone)
    if not legs then return target end
    local transport, border = Flags(legs)
    -- el transporte solo si ahorra tiempo frente a ir a pie por los pasos entre zonas
    if transport and pinst == target.instance then
        local wlegs, wcost = self:Plan(px, py, pinst, szone, target.wx, target.wy, target.instance, gzone, true)
        if wlegs and cost > wcost * USE_RATIO then
            legs, cost = wlegs, wcost
            transport, border = Flags(legs)
        end
    end
    if not transport and not border then return target end

    -- siguiente punto de la ruta y lo que se hace alli
    local firstLeg = legs[1]
    local wp, nextLeg, nextIndex
    if firstLeg.kind == "walk" then wp, nextLeg, nextIndex = firstLeg.to, legs[2], 2
    else wp, nextLeg, nextIndex = firstLeg.from, firstLeg, 1 end
    if not nextLeg or wp.goal then return target end
    local T = QR.Skin.TEXT
    local lines, questName, name = {}, nil, wp.name
    if nextLeg.kind == "flight" then
        -- tramos de vuelo seguidos = un solo viaje (el maestro de vuelo hace las escalas)
        local last = nextLeg
        for k = nextIndex + 1, #legs do
            if legs[k].kind == "flight" then last = legs[k] else break end
        end
        lines[1] = string.format(L["%sFlight master|r: %s"], T.friendly, wp.name or "?")
        lines[2] = string.format(L["%sFly to|r %s"], T.warn, last.to.name or "?")
        questName = L["Flight trip"]
    elseif nextLeg.kind == "border" then
        lines[1] = CrossText(nextLeg)
        questName = L["Route on foot"]
        name = MapName(nextLeg.extra and nextLeg.extra.toZone)
    elseif LINK_TEXT[nextLeg.kind] then
        lines[1] = LinkText(nextLeg)
        questName = L["Journey"]
        name = MapName(nextLeg.extra and nextLeg.extra.toZone)
    elseif nextLeg.kind == "road" or nextLeg.kind == "walk" then
        lines[1] = T.warn .. L["Follow the path"] .. "|r"
        questName = L["Route on foot"]
        name = MapName(wp.zone)
    else
        lines[1] = T.warn .. L[KIND_TAKE[nextLeg.kind] or "Take the boat"] .. "|r"
        lines[2] = string.format(L["towards %s"], NearestNodeName(nextLeg.to))
        questName = L["Boat trip"]
        name = name or L["Dock"]
    end
    -- vuelos sin comprobar en este continente: recordarlo en la tarjeta del viaje
    local function unchecked(inst) return TAXI_CONT_MAP[inst] and not self:TaxiVerified(inst) end
    if QR.db.travel.flights and (unchecked(pinst) or unchecked(target.instance)) then
        lines[#lines + 1] = T.done .. L["Flights not checked: talk to a flight master"] .. "|r"
    end
    local travel = {
        kind = "travel", travelKind = nextLeg.kind, final = target,
        questName = questName, name = name or "?", travelLines = lines,
        wx = wp.x, wy = wp.y, instance = wp.inst,
        questId = target.questId,
        route = BuildRoute(legs, target, px, py, pinst),
    }
    self.lastTravel = travel
    return travel
end

---------------------------------------------------------------------------
-- Vuelo en curso: destino y tiempo (pending y flight se declaran antes de Router:Wrap)
---------------------------------------------------------------------------

--- Segundos de un vuelo directo a -> b: lo medido en tus vuelos, la tabla de tiempos (Data/TaxiTimes.lua) o,
--- si no hay, una estimacion por la longitud del recorrido. Devuelve tambien las yardas del tramo.
local function LegTime(a, b)
    if not pathLen then BuildStatic() end
    local l = pathLen[a] and pathLen[a][b]
    if not l and D.nodes[a] and D.nodes[b] then
        l = Dist(D.nodes[a][3], D.nodes[a][4], D.nodes[b][3], D.nodes[b][4]) * 1.25
    end
    local mine = QR.db.travel.times and QR.db.travel.times[a .. "-" .. b]
    local tbl = QR.TaxiTimes and QR.TaxiTimes[a] and QR.TaxiTimes[a][b]
    return mine or tbl or ((l or 0) / (QR.db.travel.taxiSpeed or 32) + 6), l or 0
end

--- Al elegir destino en el maestro de vuelo: recorrido con sus escalas (API clasica del mapa de vuelos, la que
--- funciona en WoW Forever) y tiempo total como Zygor: suma de los tramos directos menos ~2 s por escala.
function Router:OnTakeTaxiNode(slot)
    if not (NumTaxiNodes and TaxiNodeGetType) then return end
    local _, _, pinst = QR.HBD:GetPlayerWorldPosition()
    local bySlot = SlotNodes(pinst)
    local current
    for i = 1, NumTaxiNodes() do
        if TaxiNodeGetType(i) == "CURRENT" then current = bySlot[i] end
    end
    local destId = bySlot[slot]
    -- para volar de A a B hay que tener los dos aprendidos
    local learnedNow = false
    for _, id in ipairs({ current or false, destId or false }) do
        if id and D.nodes[id] and TaxiDB()[id] ~= true then SetKnown(id, true, "vuelo tomado"); learnedNow = true end
    end
    if learnedNow then self:Invalidate() end
    local name = TaxiNodeName and TaxiNodeName(slot)
    local destName = type(name) == "string" and (name:match("^[^,]+") or name) or (destId and D.nodes[destId] and D.nodes[destId][1]) or "?"
    local route = { current }
    if GetNumRoutes and TaxiGetNodeSlot then
        for h = 1, GetNumRoutes(slot) or 0 do
            local id = bySlot[TaxiGetNodeSlot(slot, h, false)]
            if id and id ~= route[#route] then route[#route + 1] = id end
        end
    end
    if destId and route[#route] ~= destId then route[#route + 1] = destId end
    local key = current and destId and (current .. "-" .. destId)
    local whole = key and QR.db.travel.times and QR.db.travel.times[key]
    local total, yards = 0, 0
    if current and #route >= 2 then
        for i = 1, #route - 1 do
            local t, l = LegTime(route[i], route[i + 1])
            total, yards = total + t, yards + l
        end
        total = total - (#route - 2) * 2
    end
    -- destId: punto de vuelo donde se aterriza (en vuelo, la ruta sigue desde ahi)
    pending = { dest = destName, yards = yards, key = key, destId = destId,
                total = whole or (total > 0 and total or nil) }
end

function Router:OnTaxiStateChanged()
    local onTaxi = UnitOnTaxi and UnitOnTaxi("player")
    if onTaxi and not flight then
        flight = pending or { dest = "?", total = nil }
        flight.start = GetTime()
        pending = nil
        QR:Fire("FLIGHT_CHANGED", true)
        -- al despegar: la ruta pasa a salir del punto donde aterrizas (se salta "ve al maestro de vuelo")
        self.taxiWrap = nil
        if QR.Target then QR.Target:Refresh(true) end
    elseif not onTaxi and flight then
        local elapsed = GetTime() - flight.start
        -- aprender: duracion exacta de este trayecto y velocidad media de vuelo
        if elapsed > 10 and flight.key then
            QR.db.travel.times = QR.db.travel.times or {}
            QR.db.travel.times[flight.key] = elapsed
            if flight.yards and flight.yards > 0 then
                local measured = flight.yards / math.max(1, elapsed - 6)
                if measured > 10 and measured < 80 then
                    QR.db.travel.taxiSpeed = (QR.db.travel.taxiSpeed or 32) * 0.7 + measured * 0.3
                end
            end
        end
        flight = nil
        QR:Fire("FLIGHT_CHANGED", false)
        if QR.Target then QR.Target:Refresh(true) end
    end
end

--- nil si no vuelas; si no: destino, segundos restantes, segundos totales (total puede ser nil)
function Router:FlightInfo()
    if not flight then return nil end
    local elapsed = GetTime() - flight.start
    if not flight.total then return flight.dest, nil, nil, elapsed end
    return flight.dest, math.max(0, flight.total - elapsed), flight.total, elapsed
end

function Router:Init()
    D = QR.TravelData
    BuildStatic()
    LoadBorders()
    LoadRoads()
    -- v0.8: la lista antigua de vuelos aprendidos podia contar puntos solo "de paso" (no aprendidos).
    -- Se vacia una vez: se vuelve a llenar bien en cuanto hables con un maestro de vuelo.
    -- v0.8.1: la lectura del mapa de vuelos no seguia la regla de Zygor y pudo marcar vuelos aprendidos como
    -- no aprendidos. Se vacia una vez: se vuelve a llenar bien en cuanto hables con un maestro de vuelo.
    -- v0.8.2: deteccion al estilo ForeverRoute (se lee del juego en cualquier momento): se empieza de cero
    -- v0.8.3: los mapas de zona daban todos los vuelos como descubiertos: se vuelve a leer solo de los continentes
    -- v0.8.4: isUndiscovered tampoco es fiable en los continentes; manda el mapa de vuelos. Se empieza de cero.
    if QR.charDB.knownTaxiVersion ~= 6 and QR.charDB.knownTaxiVersion ~= 7 then
        QR.charDB.knownTaxi, QR.charDB.taxiRecorded, QR.charDB.taxiScanned, QR.charDB.knownTaxiSource = nil, nil, nil, nil
    end
    -- v7: fuera los vuelos que se dieron por aprendidos con GetTaxiNodesForMap (marca no fiable: los daba todos).
    -- Se quedan los del mapa del maestro de vuelo, los de los avisos del juego y los de vuelos hechos.
    if QR.charDB.knownTaxiVersion ~= 7 then
        local known, src = TaxiDB()
        for id in pairs(known) do
            local s = src[id]
            if type(s) == "string" and s:find("^mapa %d") then known[id] = nil; src[id] = nil end
        end
        -- los continentes "comprobados" con la lectura antigua (que podia fallar) se vuelven a comprobar
        QR.charDB.taxiScanned, QR.charDB.taxiPartial = {}, {}
        QR.charDB.knownTaxiVersion = 7
    end
    TaxiDB()
    local f = CreateFrame("Frame")
    for _, e in ipairs({ "TAXIMAP_OPENED", "PLAYER_CONTROL_LOST", "PLAYER_CONTROL_GAINED", "PLAYER_ENTERING_WORLD",
                         "UI_INFO_MESSAGE", "UI_ERROR_MESSAGE", "TAXI_NODE_STATUS_CHANGED" }) do
        pcall(f.RegisterEvent, f, e)
    end
    f:SetScript("OnEvent", function(_, event, a1, a2)
        if event == "TAXIMAP_OPENED" then
            -- cada vez que hablas con un maestro de vuelo: se relee todo el continente (sin comandos)
            Router:OnTaxiMapOpened()
        elseif event == "TAXI_NODE_STATUS_CHANGED" then
            if NumTaxiNodes and NumTaxiNodes() > 0 then Router:OnTaxiMapOpened() end
        elseif event == "UI_INFO_MESSAGE" or event == "UI_ERROR_MESSAGE" then
            local msg = type(a2) == "string" and a2 or a1
            if ERR_NEWTAXIPATH and msg == ERR_NEWTAXIPATH then
                Router:LearnTalkedTaxi("aviso del juego: nueva ruta de vuelo")        -- "Has descubierto una nueva ruta de vuelo"
            elseif ERR_TAXINOPATHS and msg == ERR_TAXINOPATHS then
                Router:LearnTalkedTaxi("aviso del juego: sin rutas desde este maestro") -- este si; ninguno conectado
            end
        else
            C_Timer.After(0.3, function() Router:OnTaxiStateChanged() end)
        end
    end)
    if hooksecurefunc and TakeTaxiNode then
        hooksecurefunc("TakeTaxiNode", function(slot) Router:OnTakeTaxiNode(slot) end)
    end
    -- por si el aviso de despegue no llega: comprobar cada segundo
    C_Timer.NewTicker(1, function() Router:OnTaxiStateChanged() end)
end

QR:RegisterModule("Router", function() Router:Init() end)

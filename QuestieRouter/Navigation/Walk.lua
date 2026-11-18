-- QuestieRouter: rutas a pie por el terreno (rejilla de navegacion).
-- El destino lo sigue eligiendo el planificador / el router (la mision, el cruce, el maestro de vuelo o el muelle);
-- este modulo pide al motor de rutas a pie de QuestieRouter_Nav (copia del de Polestar Nav, que empezo en Shortest
-- Path Forever de Cillian Berragan; GPL-3.0-or-later, ver QuestieRouter_Nav/CREDITS.md) el camino real hasta alli:
-- rodea montañas, entra por las puertas, sigue las carreteras segun el estilo elegido (rapida, equilibrada o solo
-- caminos) y no cruza el mar a nado. La flecha apunta al siguiente punto del camino y el mapa dibuja la linea entera.
-- Sin el motor (addon desactivado, otro continente sin mapa o una busqueda que falla) todo sigue como antes: la
-- flecha apunta recto al destino.

local _, QR = ...

local Walk = {}
QR.Walk = Walk

local NAV_ADDON = "QuestieRouter_Nav"
local NEAR = 35          -- yardas: mas cerca del destino, recto... si no hay un muro en medio (Path.Sight)
local VERY_NEAR = 8      -- yardas: aqui siempre recto
local GOAL_GAP = 4       -- yardas: si el camino acaba mas lejos del destino, la linea y la flecha siguen hasta el
local FLOOR_WAIT = 1.5   -- segundos esperando a que el motor lea el suelo del destino antes de buscar sin altura
local OFF_PATH = 30      -- yardas: si te alejas mas del camino, se vuelve a calcular desde donde estas
local DEST_MOVED = 8     -- yardas: el destino se ha movido (otro spawn): camino nuevo
local AHEAD = 14         -- yardas: la flecha apunta al primer punto del camino a mas de esto
local RETRY = 6          -- segundos antes de volver a intentar un camino que fallo
local PULL = { 15, 40 }  -- yardas: si no hay camino hasta el destino, se prueba hasta un punto asi de antes
local TICK = 0.4

local function Enabled()
    return QR.db and QR.db.enabled and QR.db.travel and QR.db.travel.gridRoutes ~= false
end

--- el motor (carga el addon la primera vez; nil si no se puede)
local ENGINE_RETRY = 30  -- segundos antes de volver a intentar cargar el motor si fallo

function Walk:Engine()
    if self.engine then return self.engine end
    if self.engine == false and GetTime() < (self.engineAt or 0) + ENGINE_RETRY then return nil end
    local A = C_AddOns or {}
    local isLoaded = A.IsAddOnLoaded or _G.IsAddOnLoaded
    local load = A.LoadAddOn or _G.LoadAddOn
    if not (isLoaded and load) then
        self.engine, self.engineAt, self.engineWhy = false, GetTime(), "sin LoadAddOn en este cliente"
        return nil
    end
    if not isLoaded(NAV_ADDON) then
        if InCombatLockdown() then return nil end   -- (se intenta otra vez fuera de combate)
        local okCall, loaded, reason = pcall(load, NAV_ADDON)
        -- desmarcados en la lista de addons (o desmarcados para este personaje): son parte de QuestieRouter y se
        -- cargan bajo demanda, asi que se activan aqui los tres y se prueba otra vez (las rutas a pie se apagan
        -- desde las opciones, no quitando estos addons)
        if okCall and not loaded and reason == "DISABLED" then
            local enable = A.EnableAddOn or _G.EnableAddOn
            if enable then
                for _, name in ipairs({ NAV_ADDON, "QuestieRouter_Nav_EK", "QuestieRouter_Nav_Kalimdor" }) do
                    pcall(enable, name)
                end
                okCall, loaded, reason = pcall(load, NAV_ADDON)
                if not loaded and not self.enableWarned then
                    self.enableWarned = true
                    QR:Print("QuestieRouter_Nav estaba desactivado: lo he activado. Haz /reload para tener las rutas por el camino.")
                end
            end
        end
        if not okCall or not loaded then
            -- reason: DISABLED, MISSING, DEP_MISSING, DEP_DISABLED, INTERFACE_VERSION, CORRUPT, BANNED...
            self.engine, self.engineAt = false, GetTime()
            self.engineWhy = "LoadAddOn: " .. tostring(okCall and (reason or "fallo sin motivo") or loaded)
            return nil
        end
    end
    local E = _G.QuestieRouter_NavEngine
    if not E then
        -- el addon esta cargado pero API.lua no llego a ejecutarse: un error de Lua en sus archivos
        self.engine, self.engineAt = false, GetTime()
        self.engineWhy = "QuestieRouter_Nav cargado pero sin motor (error de Lua al cargar: activa /console scriptErrors 1 y /reload)"
        return nil
    end
    self.engine, self.engineWhy = E, nil
    return E
end

local function Dist(ax, ay, bx, by)
    local dx, dy = ax - bx, ay - by
    return math.sqrt(dx * dx + dy * dy)
end

--- distancia de un punto al segmento ab (en yardas) y la posicion a lo largo de el (0..1)
local function SegDist(px, py, ax, ay, bx, by)
    local dx, dy = bx - ax, by - ay
    local l2 = dx * dx + dy * dy
    local t = l2 > 0 and math.max(0, math.min(1, ((px - ax) * dx + (py - ay) * dy) / l2)) or 0
    return Dist(px, py, ax + t * dx, ay + t * dy), t
end

--- ¿Es el camino guardado el de este destino? (misma posicion: el router crea un objeto nuevo en cada refresco)
local function SameGoal(path, t, pinst)
    return path and t and t.wx and path.inst == pinst and path.inst == t.instance
        and Dist(path.dx, path.dy, t.wx, t.wy) <= 8
end

--- Mientras se calcula el camino del destino nuevo, ¿vale el anterior? Si el destino solo se ha movido un poco
--- (otro spawn de la misma mision, la ruta rehecha...) el principio del camino viejo sigue siendo bueno: mejor eso
--- que volver a la linea recta hasta que llegue el nuevo. (Sin busqueda en marcha, o si fallo, no se usa.)
local function Usable(path, t, pinst, px, py)
    if SameGoal(path, t, pinst) then return true end
    if not (path and t and t.wx and Walk.pending and path.inst == pinst and path.inst == t.instance) then return false end
    local moved = Dist(path.dx, path.dy, t.wx, t.wy)
    return moved <= math.max(60, 0.35 * Dist(px, py, t.wx, t.wy))
end

--- tramo del camino mas cercano al jugador: indice del segmento (i -> i + 1) y distancia
--- La flecha (cada fotograma), el minimapa (cada fotograma) y el mapa del mundo lo piden con la misma posicion: con el
--- mismo camino, la misma posicion y el mismo tramo de inicio el resultado es el mismo, asi que se reutiliza (sin
--- recorrer otra vez el camino).
local nearMemo = {}
function Walk:Nearest(px, py)
    local path = self.path
    if not path then return nil end
    local pts = path.points
    -- se busca desde el ultimo tramo conocido hacia delante (y un poco hacia atras), sin volver al principio
    local from = math.max(1, (path.progress or 1) - 2)
    local m = nearMemo
    if m.path == path and m.px == px and m.py == py and m.from == from then return m.i, m.d end
    local best, bi = nil, nil
    for i = from, #pts - 1 do
        local d = SegDist(px, py, pts[i].x, pts[i].y, pts[i + 1].x, pts[i + 1].y)
        if not best or d < best then best, bi = d, i end
    end
    m.path, m.px, m.py, m.from, m.i, m.d = path, px, py, from, bi, best
    return bi, best
end

--- avanza el progreso del camino hasta el tramo mas cercano al jugador (lo usan la flecha y las lineas: antes solo
--- lo movia la flecha y, con la flecha oculta, la linea salia siempre desde el principio). -> indice del tramo
function Walk:Advance(px, py)
    local path = self.path
    local i = self:Nearest(px, py)
    if i then path.progress = i end
    return i
end

--- el punto al que apunta la flecha: el siguiente punto del camino a mas de AHEAD yardas (nil: recto al destino)
function Walk:Waypoint(px, py, pinst, t)
    local path = self.path
    if not Usable(path, t, pinst, px, py) then return nil end
    local i = self:Advance(px, py)
    if not i then return nil end
    local pts = path.points
    for k = i + 1, #pts do
        if Dist(px, py, pts[k].x, pts[k].y) > AHEAD then return pts[k].x, pts[k].y end
    end
    return nil
end

--- Lo que queda del camino desde el jugador, sin crear tablas (las lineas lo piden en cada fotograma):
--- -> points (los del camino), i (los que quedan son points[i + 1 .. #points]), gx, gy (el final) y addGoal (si hay
--- que añadir el final despues del ultimo punto); nil si no hay camino. Lo que queda es: el jugador,
--- points[i + 1 .. #points] y, con addGoal, (gx, gy). Mismo resultado que Walk:Remaining.
function Walk:RemainingInfo(px, py, pinst, t)
    local path = self.path
    if not Usable(path, t, pinst, px, py) then return nil end
    local i = self:Advance(px, py) or path.progress or 1
    local pts = path.points
    -- el final: el destino de este camino o, con el camino viejo mientras llega el nuevo, el destino actual
    local gx, gy = path.dx, path.dy
    if not SameGoal(path, t, pinst) then gx, gy = t.wx, t.wy end
    local lx, ly = px, py
    if i + 1 <= #pts then lx, ly = pts[#pts].x, pts[#pts].y end
    return pts, i, gx, gy, Dist(lx, ly, gx, gy) > GOAL_GAP
end

--- el camino que dibuja el mapa: los puntos que quedan desde el jugador (nil si no hay)
function Walk:Remaining(px, py, pinst, t)
    local pts, i, gx, gy, addGoal = self:RemainingInfo(px, py, pinst, t)
    if not pts then return nil end
    local out = { { x = px, y = py } }
    for k = i + 1, #pts do out[#out + 1] = pts[k] end
    if addGoal then out[#out + 1] = { x = gx, y = gy } end
    return out
end

function Walk:Clear()
    if self.job and self.engine and self.engine.Cancel then pcall(self.engine.Cancel, self.job) end
    self.job, self.pending = nil, nil
    if self.path then
        self.path = nil
        QR:Fire("WALK_PATH")
    end
end

--- Altura del suelo del destino para el motor: en un edificio hay varias superficies en el mismo punto (planta baja,
--- pisos, tejado) y sin altura el motor puede elegir el tejado y dejar el camino fuera, junto al muro. Se prefiere el
--- suelo interior mas bajo; sin interior, la superficie mas baja que no sea agua. -> z, o nil (sin datos);
--- false mientras el motor aun no ha leido esa zona (se vuelve a mirar en el siguiente tick).
local surf = {}
local function GoalFloor(E, map, x, y)
    if not E.SurfacesAt then return nil end
    local ok, n = pcall(E.SurfacesAt, map, x, y, surf)
    if not ok then return nil end
    if n == nil then return false end
    local indoor, ground
    for i = 1, n do
        local z, m = surf[i], surf[-i] or 0
        local water = m % 2 == 1
        local inside = math.floor(m / 2) % 2 == 1
        if inside and not water and (not indoor or z < indoor) then indoor = z end
        if not water and (not ground or z < ground) then ground = z end
    end
    return indoor or ground
end

--- ¿Se puede ir recto del jugador al destino? (sin muros, acantilados ni entrar en un interior; nil si no se sabe)
local function Straight(E, map, px, py, pz, tx, ty)
    if not (E.Sight and pz) then return nil end
    local ok, r = pcall(E.Sight, map, py, px, pz, ty, tx, nil, UnitFactionGroup("player"))
    if not ok then return nil end
    return r
end

local function PlayerZ()
    local _, _, z = UnitPosition("player")
    return z
end

--- ¿hace falta un camino nuevo? (destino nuevo o movido, o te has salido del camino)
function Walk:Update()
    local t = QR.target
    if not (Enabled() and t and t.wx) or (UnitOnTaxi and UnitOnTaxi("player")) then self:Clear() return end
    local px, py, pinst = QR.HBD:GetPlayerWorldPosition()
    if not px or pinst ~= t.instance then self:Clear() return end
    local dist = Dist(px, py, t.wx, t.wy)
    if dist < VERY_NEAR then self:Clear() return end
    local E = self:Engine()
    if not (E and E.Available and E.Available(pinst)) then
        if dist < NEAR then self:Clear() end
        return
    end
    local pz = PlayerZ()
    -- cerca: recto solo si de verdad se puede ir recto (no a traves de un muro ni hacia dentro de un edificio)
    if dist < NEAR and Straight(E, pinst, px, py, pz, t.wx, t.wy) == true then self:Clear() return end
    local path = self.path
    local need = not SameGoal(path, t, pinst) or Dist(path.dx, path.dy, t.wx, t.wy) > DEST_MOVED
        or (path.style ~= (QR.db.travel.routeStyle or "balanced"))
    if not need then
        local _, d = self:Nearest(px, py)
        need = d and d > OFF_PATH
    end
    if not need or self.pending then return end
    local key = string.format("%d:%.0f:%.0f", pinst, t.wx, t.wy)
    if self.failKey == key and GetTime() < (self.failAt or 0) + RETRY then return end
    if self.tryKey ~= key then self.tryKey, self.try = key, 1 end
    -- el motor usa las coordenadas de UnitPosition (x al norte, y al oeste); HereBeDragons, (x, y) = (oeste, norte)
    local style = QR.db.travel.routeStyle or "balanced"
    -- suelo del destino (planta baja de un edificio mejor que su tejado); si el motor aun lo esta leyendo, se espera
    -- un poco (como mucho FLOOR_WAIT) para no buscar a ciegas
    local gz = GoalFloor(E, pinst, t.wy, t.wx)
    if gz == false then
        if self.floorKey ~= key then self.floorKey, self.floorAt = key, GetTime() end
        if GetTime() - self.floorAt < FLOOR_WAIT then return end
        gz = nil
    end
    self.floorKey, self.floorAt = nil, nil
    -- Intentos, del mas exacto al mas flojo (cada uno solo si el anterior no encontro camino):
    --   1. con la altura del suelo del destino
    --   2. sin altura: el motor prueba cada superficie del punto (con las dos alturas dadas no lo hace, y si el suelo
    --      elegido es un sotano, una cueva debajo o un hueco cerrado, la busqueda fallaba siempre y la flecha iba recta)
    --   3..: el destino acercado hacia el jugador (un punto dentro de una valla, un edificio o una roca, fuera de la malla)
    local try = self.try or 1
    local tx, ty, tz = t.wx, t.wy, gz
    if try == 1 and not gz then try = 2 end
    if try >= 2 then tz = nil end
    local pull = PULL[try - 2]
    if pull then
        local d = Dist(px, py, t.wx, t.wy)
        local k = math.min(pull, d * 0.5) / d
        tx, ty = t.wx + (px - t.wx) * k, t.wy + (py - t.wy) * k
    end
    self.try = try
    local from, to = { x = py, y = px, z = pz }, { x = ty, y = tx, z = tz }
    local opts = { profile = UnitFactionGroup("player"), style = style }
    local token = {}
    self.pending = token
    local ok, job = pcall(E.Find, pinst, from, to, function(points, cost, j)
        if Walk.pending ~= token then return end   -- (una busqueda vieja; puede llegar antes de que Find devuelva)
        Walk.pending, Walk.job = nil, nil
        if not points or #points < 2 then
            Walk.lastFail = { reason = tostring(cost), try = try, at = GetTime() }
            if QR.db.debug then QR:Print(string.format("Walk: sin camino (%s, intento %d)", tostring(cost), try)) end
            -- sin datos del mapa no sirve reintentar con otro punto
            if cost ~= "nodata" and try < 2 + #PULL then
                Walk.try = try + 1
            else
                Walk.failKey, Walk.failAt, Walk.try = key, GetTime(), 1
            end
            return
        end
        Walk.lastFail = nil
        local pts = {}
        for _, p in ipairs(points) do pts[#pts + 1] = { x = p.y, y = p.x } end
        Walk.path = { target = t, inst = pinst, dx = t.wx, dy = t.wy, points = pts, progress = 1, style = style,
                      yards = j and j.yards }
        QR:Fire("WALK_PATH")
    end, opts)
    if ok then
        if self.pending == token then self.job = job end
    else
        self.pending = nil
        self.failKey, self.failAt = key, GetTime()
    end
end

---------------------------------------------------------------------------
-- Resto de tramos a pie de un viaje (despues de bajar del barco, del vuelo, al cruzar a otra zona...): el router los
-- da en linea recta; aqui se cambian por el camino del motor, de uno en uno, y se guardan para no repetirlos.
---------------------------------------------------------------------------
local LEG_CACHE_MAX = 64
Walk.legCache, Walk.legOrder, Walk.legFail = {}, {}, {}

local function LegKey(inst, x1, y1, x2, y2, style)
    return string.format("%d:%.0f:%.0f:%.0f:%.0f:%s", inst, x1 / 4, y1 / 4, x2 / 4, y2 / 4, style)
end

local function Remember(key, pts)
    if not Walk.legCache[key] then
        Walk.legOrder[#Walk.legOrder + 1] = key
        if #Walk.legOrder > LEG_CACHE_MAX then Walk.legCache[table.remove(Walk.legOrder, 1)] = nil end
    end
    Walk.legCache[key] = pts
end

--- cambia los tramos a pie del viaje que ya estan calculados; pide el siguiente que falte. -> true si cambio algo
function Walk:RefineRoute(route)
    local E = self:Engine()
    if not (route and route.segments and E and E.Available) then return false end
    local style = QR.db.travel.routeStyle or "balanced"
    local changed = false
    for _, seg in ipairs(route.segments) do
        local a, b = seg.points and seg.points[1], seg.points and seg.points[#seg.points]
        if seg.kind == "walk" and not seg.fromPlayer and not seg.refined and a and b and a[1] == b[1]
            and #seg.points == 2 and E.Available(a[1]) then
            local key = LegKey(a[1], a[2], a[3], b[2], b[3], style)
            local pts = self.legCache[key]
            if pts then
                seg.points, seg.refined = pts, true
                changed = true
            elseif not self.legPending and not self.legFail[key] then
                -- (coordenadas del motor: x al norte, y al oeste; las de HereBeDragons al reves)
                local token = {}
                self.legPending = token
                local inst = a[1]
                local ok = pcall(E.Find, inst, { x = a[3], y = a[2] }, { x = b[3], y = b[2] }, function(points)
                    if Walk.legPending ~= token then return end
                    Walk.legPending = nil
                    if not points or #points < 2 then Walk.legFail[key] = true return end
                    local out = {}
                    for _, p in ipairs(points) do out[#out + 1] = { inst, p.y, p.x } end
                    -- los extremos exactos del router (el muelle, el maestro de vuelo, el cruce)
                    out[1], out[#out] = { inst, a[2], a[3] }, { inst, b[2], b[3] }
                    Remember(key, out)
                    -- se aplica en el siguiente tick (la ruta puede haberse rehecho mientras tanto)
                end, { profile = UnitFactionGroup("player"), style = style })
                if not ok then self.legPending = nil; self.legFail[key] = true end
            end
        end
    end
    if changed then
        route.canvasCache = nil   -- (MapLines vuelve a pasar los tramos al mapa)
        QR:Fire("WALK_PATH")
    end
    return changed
end

--- /qr walk: por que la flecha va recta o sigue el camino (escribe el estado en el chat)
function Walk:Status()
    local function out(s) QR:Print("Walk: " .. s) end
    local t = QR.target
    out("activado=" .. tostring(Enabled() and true or false) .. ", destino=" .. tostring(t and t.wx and true or false))
    local E = self:Engine()
    if not E then
        out("motor QuestieRouter_Nav NO cargado: " .. tostring(self.engineWhy or "aun no se ha intentado (o estas en combate)"))
        local A = C_AddOns or {}
        local info = A.GetAddOnInfo or _G.GetAddOnInfo
        for _, name in ipairs({ NAV_ADDON, "QuestieRouter_Nav_EK", "QuestieRouter_Nav_Kalimdor" }) do
            local ok, n, _, _, loadable, why = pcall(info or error, name)
            local enabled
            if A.GetAddOnEnableState then
                local okE, v = pcall(A.GetAddOnEnableState, name, UnitName("player"))
                enabled = okE and v or "?"
            end
            out(string.format("  %s: %s, cargable=%s %s, activado=%s", name, ok and tostring(n) or "?",
                tostring(loadable), why and ("(" .. tostring(why) .. ")") or "", tostring(enabled)))
        end
        return
    end
    local px, py, pinst = QR.HBD:GetPlayerWorldPosition()
    out(string.format("mapa=%s, datos=%s, en memoria=%s", tostring(pinst),
        tostring(E.Available and E.Available(pinst) or false),
        E.Resident and tostring(E.Resident(pinst) and true or false) .. (E.Resident(pinst) and "" or " (se carga con la primera ruta)") or "?"))
    if t and t.wx and px then out(string.format("distancia al destino: %.0f yd", Dist(px, py, t.wx, t.wy))) end
    out("buscando=" .. tostring(self.pending ~= nil) .. ", intento=" .. tostring(self.try or 1))
    local path = self.path
    if path then
        local _, d = self:Nearest(px or 0, py or 0)
        out(string.format("camino: %d puntos, del destino actual=%s, a %.0f yd de ti", #path.points,
            tostring(SameGoal(path, t, pinst) and true or false), d or -1))
    else
        out("sin camino")
    end
    local f = self.lastFail
    if f then out(string.format("ultimo fallo: %s (intento %d, hace %.0f s)", f.reason, f.try, GetTime() - f.at)) end
end

function Walk:Init()
    local acc = 0
    local f = CreateFrame("Frame")
    f:SetScript("OnUpdate", function(_, el)
        acc = acc + el
        if acc < TICK then return end
        acc = 0
        local ok, err = pcall(Walk.Update, Walk)
        if not ok and QR.db.debug then QR:Print("Walk: " .. tostring(err)) end
        -- el resto de tramos a pie del viaje (si los hay)
        local t = QR.target
        if Enabled() and t and t.route then
            ok, err = pcall(Walk.RefineRoute, Walk, t.route)
            if not ok and QR.db.debug then QR:Print("Walk: " .. tostring(err)) end
        end
        -- la ruta desde los puntos de paso (Alt + clic en el mapa) hasta la guia: tambien por el terreno
        local via = t and (t.via or (t.final and t.final.via))
        if Enabled() and via and via.route then
            ok, err = pcall(Walk.RefineRoute, Walk, via.route)
            if not ok and QR.db.debug then QR:Print("Walk: " .. tostring(err)) end
        end
    end)
    QR:On("SETTINGS_CHANGED", function()
        if not Enabled() then Walk:Clear() end
        wipe(Walk.legFail)   -- (con otro estilo, los tramos que fallaron se vuelven a intentar)
    end)
    -- cargar el motor un poco despues de entrar (no en el momento de mas carga)
    C_Timer.After(6, function() if Enabled() then Walk:Engine() end end)
end

QR:RegisterModule("Walk", function() Walk:Init() end)

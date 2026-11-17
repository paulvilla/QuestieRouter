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
local TICK = 0.4

local function Enabled()
    return QR.db and QR.db.enabled and QR.db.travel and QR.db.travel.gridRoutes ~= false
end

--- el motor (carga el addon la primera vez; nil si no se puede)
function Walk:Engine()
    if self.engine ~= nil then return self.engine or nil end
    local A = C_AddOns or {}
    local isLoaded = A.IsAddOnLoaded or _G.IsAddOnLoaded
    local load = A.LoadAddOn or _G.LoadAddOn
    if not (isLoaded and load) then self.engine = false return nil end
    if not isLoaded(NAV_ADDON) then
        if InCombatLockdown() then return nil end   -- (se intenta otra vez fuera de combate)
        local ok = load(NAV_ADDON)
        if not ok then self.engine = false return nil end
    end
    self.engine = _G.QuestieRouter_NavEngine or false
    return self.engine or nil
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

--- tramo del camino mas cercano al jugador: indice del segmento (i -> i + 1) y distancia
function Walk:Nearest(px, py)
    local path = self.path
    if not path then return nil end
    local pts = path.points
    local best, bi = nil, nil
    -- se busca desde el ultimo tramo conocido hacia delante (y un poco hacia atras), sin volver al principio
    local from = math.max(1, (path.progress or 1) - 2)
    for i = from, #pts - 1 do
        local d = SegDist(px, py, pts[i].x, pts[i].y, pts[i + 1].x, pts[i + 1].y)
        if not best or d < best then best, bi = d, i end
    end
    return bi, best
end

--- el punto al que apunta la flecha: el siguiente punto del camino a mas de AHEAD yardas (nil: recto al destino)
function Walk:Waypoint(px, py, pinst, t)
    local path = self.path
    if not (path and t and path.inst == pinst and path.target == t) then return nil end
    local i = self:Nearest(px, py)
    if not i then return nil end
    path.progress = i
    local pts = path.points
    for k = i + 1, #pts do
        if Dist(px, py, pts[k].x, pts[k].y) > AHEAD then return pts[k].x, pts[k].y end
    end
    return nil
end

--- el camino que dibuja el mapa: los puntos que quedan desde el jugador (nil si no hay)
function Walk:Remaining(px, py, pinst, t)
    local path = self.path
    if not (path and t and path.inst == pinst and path.target == t) then return nil end
    local i = path.progress or 1
    local out = { { x = px, y = py } }
    for k = i + 1, #path.points do out[#out + 1] = path.points[k] end
    local last = out[#out]
    if Dist(last.x, last.y, path.dx, path.dy) > GOAL_GAP then out[#out + 1] = { x = path.dx, y = path.dy } end
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
    local need = not path or path.target ~= t or Dist(path.dx, path.dy, t.wx, t.wy) > DEST_MOVED
        or (path.style ~= (QR.db.travel.routeStyle or "balanced"))
    if not need then
        local _, d = self:Nearest(px, py)
        need = d and d > OFF_PATH
    end
    if not need or self.pending then return end
    local key = string.format("%d:%.0f:%.0f", pinst, t.wx, t.wy)
    if self.failKey == key and GetTime() < (self.failAt or 0) + RETRY then return end
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
    local from, to = { x = py, y = px, z = pz }, { x = t.wy, y = t.wx, z = gz }
    local opts = { profile = UnitFactionGroup("player"), style = style }
    local token = {}
    self.pending = token
    local ok, job = pcall(E.Find, pinst, from, to, function(points, cost, j)
        if Walk.pending ~= token then return end   -- (una busqueda vieja; puede llegar antes de que Find devuelva)
        Walk.pending, Walk.job = nil, nil
        if not points or #points < 2 then
            Walk.failKey, Walk.failAt = key, GetTime()
            return
        end
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

function Walk:Init()
    local acc = 0
    local f = CreateFrame("Frame")
    f:SetScript("OnUpdate", function(_, el)
        acc = acc + el
        if acc < TICK then return end
        acc = 0
        local ok, err = pcall(Walk.Update, Walk)
        if not ok and QR.db.debug then QR:Print("Walk: " .. tostring(err)) end
    end)
    QR:On("SETTINGS_CHANGED", function() if not Enabled() then Walk:Clear() end end)
    -- cargar el motor un poco despues de entrar (no en el momento de mas carga)
    C_Timer.After(6, function() if Enabled() then Walk:Engine() end end)
end

QR:RegisterModule("Walk", function() Walk:Init() end)

-- QuestieRouter: registro de observaciones del juego (lo que vemos que no cuadra con los datos de las guias).
--
-- Para que mas adelante la gente pueda enviarnos por la web lo que su juego hace distinto de lo que dicen Questie y
-- nuestras guias (misiones que ya no existen, que piden otro nivel o que van en otro punto de la cadena). De momento
-- se apunta:
--   M  (missing) una mision de la guia que el NPC deberia ofrecer (Questie: disponible, y el NPC es quien la da) y
--      no ofrece al hablar con el
--   F  (found)   una mision apuntada antes como M que el NPC si ofrece despues (nivel, cadena... algo cambio)
--   N  (note)    una nota escrita por el jugador (clic derecho en un paso de mision, hecho o por hacer, o en una
--      mision de la lista: "Añadir nota..."), con la posicion de cuando hizo clic derecho. No es una nota personal:
--      es un error de la guia / la mision o un consejo para hacerla, para enviarlo con la exportacion
--
-- FORMATO (version OBS_FORMAT; si se cambia, se sube el numero y Export lo lleva en la cabecera: asi cada envio se
-- lee con su version). Todo en QuestieRouterDB.obs (de la cuenta: todos los personajes):
--
--   obs = {
--     v        = 3,                       -- version del formato
--     sessions = { "s", ... },            -- una por entrada al juego en la que se apunta algo:
--                -- "inicio|build|version del juego|interfaz|QuestieRouter|Questie|QuestieDB|idioma|formato"
--                -- (inicio: GetServerTime() en segundos; build, interfaz: numeros; los demas, texto)
--     chars    = { [ficha] = "raza|clase|faccion|nombre|reino" },   -- ficha aleatoria de 6 caracteres por personaje
--                -- (raza y clase: ids del juego; faccion: A / H; nombre y reino del personaje, para saber en la web
--                -- quien envia cada cosa: premiar lo bueno y frenar a quien envie cosas falsas a proposito)
--     guides   = { "clave de guia", ... },              -- diccionario: las filas llevan el indice
--     rows     = { "fila", ... },                       -- observaciones, de la mas antigua a la mas nueva
--   }
--
--   fila = 21 campos separados por "|"; los numeros enteros en base 36 (b36), vacio = sin dato:
--     1  tipo                 M | F | N
--     2  sesion               b36, indice en sessions
--     3  personaje            ficha (clave de chars)
--     4  primera vez          b36, segundos desde el inicio de la sesion
--     5  ultima vez           b36, segundos desde el inicio de la sesion (cuando se repite)
--     6  veces                b36 (la misma observacion: mismo tipo, personaje, mision, quien y nivel)
--     7  mision               b36, questId
--     8  quien                n<b36> NPC | o<b36> objeto (N: el NPC del paso, si lo tiene)
--     9  nivel del personaje  b36
--     10 mapa                 b36, uiMapID donde esta el jugador (N: cuando hizo clic derecho en el paso)
--     11 x                    b36, posicion en ese mapa * 1000 (0..1000)
--     12 y                    b36
--     13 estado Questie       a disponible | l bloqueada | w nivel bajo | c en curso | d hecha | ? desconocido
--     14 niveles QuestieDB    "<nivel mision>.<nivel requerido>" (b36; nivel negativo: "-" delante)
--     15 anteriores           "g<b36>+,s<b36>-,..." misiones anteriores de QuestieDB: g = hacen falta todas,
--                             s = basta una; + hecha, - no hecha
--     16 lo que ofrecia       "i:<b36>,<b36>,..." ids que da el juego | "t:<b36>,...#<n>" solo nombres (ids de las
--                             de la guia que se reconocen por nombre y #n nombres que no) | "d:<b36>" la abrio directa
--                             | "q:<b36>,..." (N) todas las misiones del paso de la nota
--     17 guia                 b36, indice en guides
--     18 zona Questie         b36, areaId de la zona de la guia (para agrupar)
--     19 paso                 p coger | o hacer | t entregar | h ya hecho (solo N; vacio en M / F)
--     20 nota                 texto de la nota (solo N), con %25 = "%", %7C = "|", %0A = salto de linea
--     21 tipo de nota         e error (algo mal en la guia o en la mision) | c consejo para hacer la mision (solo N)
--
-- Se juntan las observaciones repetidas M / F (campos 1, 3, 7, 8 y 9 iguales en la misma sesion: sube "veces" y
-- "ultima vez"); las notas nunca. Como mucho MAX_ROWS filas: al pasar, se quitan las mas antiguas.
--
-- Historial del formato:
--   1  (2026-11-17) M y F, personajes anonimos (raza|clase|faccion), 18 campos
--   2  (2026-11-17) notas (N), nombre y reino del personaje en chars, campos 19 y 20; la exportacion lleva quien
--      exporta (cuenta Battle.net si hay, personaje y reino)
--   3  (2026-11-17) campo 21: tipo de nota (error / consejo); campo 19 admite h (nota en un paso ya hecho)

local _, QR = ...

local Obs = {}
QR.Obs = Obs

local OBS_FORMAT = 3
local MAX_ROWS = 4000
local B36 = "0123456789abcdefghijklmnopqrstuvwxyz"

--- entero -> base 36 (negativo: "-" delante; nil: vacio)
local function b36(n)
    if n == nil then return "" end
    n = math.floor(n + 0.5)
    if n == 0 then return "0" end
    local neg = n < 0
    if neg then n = -n end
    local out = {}
    while n > 0 do
        local d = n % 36
        table.insert(out, 1, B36:sub(d + 1, d + 1))
        n = (n - d) / 36
    end
    return (neg and "-" or "") .. table.concat(out)
end
Obs.b36 = b36

local function Meta(addon, field)
    local f = (C_AddOns and C_AddOns.GetAddOnMetadata) or _G.GetAddOnMetadata
    if not f then return "" end
    local ok, v = pcall(f, addon, field)
    return (ok and v) and tostring(v):gsub("|", "/") or ""
end

local function Store()
    if not QR.db then return nil end
    local o = QR.db.obs
    if type(o) ~= "table" or o.v ~= OBS_FORMAT then
        -- (otra version del formato: se guarda aparte, sin mezclar, para poder leerla con su version)
        if type(o) == "table" and o.v then
            QR.db.obsOld = QR.db.obsOld or {}
            QR.db.obsOld[#QR.db.obsOld + 1] = o
        end
        o = { v = OBS_FORMAT, sessions = {}, chars = {}, guides = {}, rows = {} }
        QR.db.obs = o
    end
    return o
end

--- sesion de esta entrada al juego (se crea con la primera observacion)
function Obs:Session(o)
    if self.session then return self.session, self.sessionStart end
    local now = GetServerTime and GetServerTime() or time()
    local version, build, _, iface = GetBuildInfo()
    local s = table.concat({ now, build or "", (version or ""):gsub("|", "/"), iface or "", Meta("QuestieRouter", "Version"),
        Meta("Questie", "Version"), Meta("QuestieDB", "Version"), GetLocale and GetLocale() or "", OBS_FORMAT }, "|")
    o.sessions[#o.sessions + 1] = s
    self.session, self.sessionStart = #o.sessions, now
    return self.session, now
end

--- ficha anonima de este personaje (aleatoria, se guarda en sus datos)
function Obs:CharToken(o)
    local c = QR.charDB
    if not c then return "?" end
    if not c.obsToken then
        local t = {}
        for i = 1, 6 do
            local d = math.random(1, 36)
            t[i] = B36:sub(d, d)
        end
        c.obsToken = table.concat(t)
    end
    local race = select(3, UnitRace("player")) or 0
    local class = select(3, UnitClass("player")) or 0
    local fac = (UnitFactionGroup("player") or "?"):sub(1, 1)
    local name = (UnitName("player") or "?"):gsub("|", "")
    local realm = ((GetRealmName and GetRealmName()) or "?"):gsub("|", "")
    o.chars[c.obsToken] = race .. "|" .. class .. "|" .. fac .. "|" .. name .. "|" .. realm
    return c.obsToken
end

local function GuideIndex(o, key)
    if not key then return nil end
    for i, k in ipairs(o.guides) do if k == key then return i end end
    o.guides[#o.guides + 1] = key
    return #o.guides
end

--- texto libre dentro de una fila: sin "|" ni saltos de linea
local function EscapeText(t)
    t = tostring(t or ""):gsub("\r", "")
    return (t:gsub("%%", "%%25"):gsub("|", "%%7C"):gsub("\n", "%%0A"))
end
Obs.EscapeText = EscapeText

--- Posicion y nivel del jugador ahora (para guardarlos al hacer clic derecho en un paso y usarlos al guardar la nota)
function Obs:Snapshot()
    local snap = { level = UnitLevel("player"), at = (GetServerTime and GetServerTime()) or time() }
    if C_Map and C_Map.GetBestMapForUnit then
        snap.map = C_Map.GetBestMapForUnit("player")
        local pos = snap.map and C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(snap.map, "player")
        if pos then snap.x, snap.y = pos.x * 1000, pos.y * 1000 end
    end
    return snap
end

local STATUS_CODE = { available = "a", locked = "l", lowlevel = "w", active = "c", done = "d" }

--- misiones anteriores de QuestieDB y si estan hechas: "g<b36>+,s<b36>-"
local function PrereqState(qid)
    local B = QR.Bridge
    local q = B and B.QuestieDB and B.QuestieDB.QueryQuestSingle
    if not q then return "" end
    local done = Questie and Questie.db and Questie.db.char and Questie.db.char.complete or {}
    local parts = {}
    for _, field in ipairs({ { "preQuestGroup", "g" }, { "preQuestSingle", "s" } }) do
        local ok, list = pcall(q, qid, field[1])
        for _, p in ipairs((ok and type(list) == "table") and list or {}) do
            local id = math.abs(p)
            parts[#parts + 1] = field[2] .. b36(id) .. (done[id] and "+" or "-")
        end
    end
    return table.concat(parts, ",")
end

local function DbLevels(qid)
    local B = QR.Bridge
    local q = B and B.QuestieDB and B.QuestieDB.QueryQuestSingle
    if not q then return "" end
    local okL, ql = pcall(q, qid, "questLevel")
    local okR, rl = pcall(q, qid, "requiredLevel")
    return b36(okL and ql or nil) .. "." .. b36(okR and rl or nil)
end

--- lo que ofrecia el NPC: { mode = "i" | "t" | "d", ids = { [id] = true }, unmatched = n }
local function OfferedText(offer)
    if not offer then return "" end
    local list = {}
    for id in pairs(offer.ids or {}) do list[#list + 1] = id end
    table.sort(list)
    for i, id in ipairs(list) do list[i] = b36(id) end
    local s = (offer.mode or "i") .. ":" .. table.concat(list, ",")
    if offer.mode == "t" and (offer.unmatched or 0) > 0 then s = s .. "#" .. offer.unmatched end
    return s
end

--- Apunta una observacion. kind = "M" | "F" | "N"; info = { questId, giverKind = "n" | "o", giverId, offer, guide,
--- snapshot (Obs:Snapshot: posicion, nivel y hora de otro momento), stepKind ("p" | "o" | "t" | "h"), note (texto),
--- noteType ("e" error | "c" consejo) }
function Obs:Record(kind, info)
    local o = Store()
    if not (o and info and info.questId) then return end
    local session, start = self:Session(o)
    local token = self:CharToken(o)
    local snap = info.snapshot
    local now = ((snap and snap.at) or (GetServerTime and GetServerTime()) or time()) - start
    local level = (snap and snap.level) or UnitLevel("player")
    local giver = (info.giverKind or "n") .. b36(info.giverId)
    -- (la misma observacion en esta sesion: se junta)
    local key = table.concat({ kind, session, token, info.questId, giver, level }, "|")
    self.index = self.index or {}
    local at = kind ~= "N" and self.index[key]   -- (las notas no se juntan)
    if at and o.rows[at] then
        local f = { strsplit("|", o.rows[at]) }
        f[5] = b36(now)
        f[6] = b36((tonumber(f[6], 36) or 1) + 1)
        f[16] = OfferedText(info.offer)   -- (lo ultimo que ofrecia)
        o.rows[at] = table.concat(f, "|")
        return
    end
    local map, x, y = nil, nil, nil
    if snap then
        map, x, y = snap.map, snap.x, snap.y
    elseif C_Map and C_Map.GetBestMapForUnit then
        map = C_Map.GetBestMapForUnit("player")
        local pos = map and C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(map, "player")
        if pos then x, y = pos.x * 1000, pos.y * 1000 end
    end
    local B = QR.Bridge
    local okS, st = pcall(B.QuestStatus, B, info.questId)
    local g = info.guide
    local row = table.concat({
        kind, b36(session), token, b36(now), b36(now), "1", b36(info.questId), giver, b36(level),
        b36(map), b36(x), b36(y), (okS and STATUS_CODE[st]) or "?", DbLevels(info.questId),
        PrereqState(info.questId), OfferedText(info.offer), b36(GuideIndex(o, g and g.key)), b36(g and g.areaId),
        info.stepKind or "", info.note and EscapeText(info.note) or "", info.noteType or "",
    }, "|")
    o.rows[#o.rows + 1] = row
    if kind ~= "N" then self.index[key] = #o.rows end
    if #o.rows > MAX_ROWS then
        local drop = #o.rows - MAX_ROWS
        for _ = 1, drop do table.remove(o.rows, 1) end
        self.index = {}   -- (las posiciones cambiaron: solo se juntan las nuevas)
    end
end

--- Borra todo el registro (observaciones, notas, sesiones, personajes y los de formatos anteriores). /qr obs reset,
--- con ventana de confirmacion. Las marcas de "no la ofrece el NPC" de la guia no se tocan (son de cada personaje).
function Obs:Reset()
    if not QR.db then return end
    QR.db.obs, QR.db.obsOld = nil, nil
    self.session, self.sessionStart, self.index = nil, nil, {}
    QR:Print(QR.L["Observations deleted."])
end

function Obs:AskReset()
    local L = QR.L
    StaticPopupDialogs["QUESTIEROUTER_OBS_RESET"] = StaticPopupDialogs["QUESTIEROUTER_OBS_RESET"] or {
        text = L["Delete all recorded observations and notes? This can't be undone."],
        button1 = YES or "Yes", button2 = NO or "No",
        OnAccept = function() Obs:Reset() end,
        timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
    }
    StaticPopup_Show("QUESTIEROUTER_OBS_RESET")
end

--- Resumen para /qr obs
function Obs:Report()
    local L = QR.L
    local o = Store()
    if not o or #o.rows == 0 then QR:Print(L["No observations recorded yet."]) return end
    local m, f, nn = 0, 0, 0
    for _, r in ipairs(o.rows) do
        local k = r:sub(1, 1)
        if k == "M" then m = m + 1 elseif k == "F" then f = f + 1 elseif k == "N" then nn = (nn or 0) + 1 end
    end
    QR:Print(string.format(L["Observations (format %d): %d rows, %d sessions, %d characters."], o.v, #o.rows,
        #o.sessions, (function() local n = 0 for _ in pairs(o.chars) do n = n + 1 end return n end)()))
    QR:Print(string.format(L["Quests the NPC didn't offer: %d · offered later: %d"], m, f))
    QR:Print(string.format(L["Notes written: %d"], nn))
    -- las ultimas, legibles
    for i = math.max(1, #o.rows - 4), #o.rows do
        local fld = { strsplit("|", o.rows[i]) }
        local qid = tonumber(fld[7], 36)
        local quest = qid and QR.Bridge and QR.Bridge:GetQuest(qid)
        QR:Print(string.format("  %s %s (%d) · %s %d · x%d", fld[1] == "M" and L["missing"] or fld[1] == "N" and L["note"] or L["found"],
            quest and quest.name or ("#" .. tostring(qid)), qid or 0, L["level"], tonumber(fld[9], 36) or 0,
            tonumber(fld[6], 36) or 1))
    end
end

--- Texto para enviar: "QRO<formato>:" + datos comprimidos en base64 (o sin comprimir si el cliente no puede).
--- Aun no tiene boton: queda lista para el envio por la web.
function Obs:Export()
    local o = Store()
    if not o then return nil end
    -- quien exporta: la cuenta de Battle.net (si el cliente la da), el personaje y el reino, y cuando
    local tag = ""
    if BNGetInfo then
        local ok, _, battleTag = pcall(BNGetInfo)
        if ok and battleTag then tag = tostring(battleTag) end
    end
    local region = GetCurrentRegion and GetCurrentRegion() or ""
    local who = table.concat({ EscapeText(tag), EscapeText(UnitName("player") or ""),
        EscapeText(GetRealmName and GetRealmName() or ""), region, (GetServerTime and GetServerTime()) or time(),
        EscapeText(Meta("QuestieRouter", "Version")) }, "|")
    local parts = { "v=" .. o.v, "A:" .. who }
    parts[#parts + 1] = "S:" .. table.concat(o.sessions, "\n")
    local chars = {}
    for k, v in pairs(o.chars) do chars[#chars + 1] = k .. "=" .. v end
    parts[#parts + 1] = "C:" .. table.concat(chars, "\n")
    parts[#parts + 1] = "G:" .. table.concat(o.guides, "\n")
    parts[#parts + 1] = "R:" .. table.concat(o.rows, "\n")
    local raw = table.concat(parts, "\n\30")   -- (separador de bloques: el caracter 30)
    local E = C_EncodingUtil
    if E and E.CompressString and E.EncodeBase64 and Enum and Enum.CompressionMethod then
        local ok, z = pcall(E.CompressString, raw, Enum.CompressionMethod.Deflate)
        if ok and z then
            local ok2, b = pcall(E.EncodeBase64, z)
            if ok2 and b then return "QRO" .. o.v .. "z:" .. b end
        end
    end
    return "QRO" .. o.v .. ":" .. raw
end

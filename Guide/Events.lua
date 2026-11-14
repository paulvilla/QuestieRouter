-- QuestieRouter: guias de eventos del mundo (categoria "Guias de eventos").
--
-- Cada evento tiene secciones; cada seccion es una guia que usa el planificador normal (coger / hacer / entregar)
-- con unos ganchos propios:
--   guide:Prepare()          antes de calcular (p. ej. donde esta la Feria este mes)
--   guide:CanPickup(questId) condicion extra para proponer coger una mision (llevar los objetos, tener los vales...)
--   guide:Visits()           pasos que no son misiones: hablar con un NPC o comprarle algo
--   guide:BannerTexts()      textos del banner (progreso de vales en vez de "Niveles x-y")
--   guide:IdleMessage()      que decir cuando no queda nada que hacer ahora
--
-- Los eventos se activan a mano (active = true) segun van llegando al juego; el resto sale en "Proximamente".
-- Datos sacados de las guias de eventos de Zygor (Forever) y de la base de datos de Questie.

local _, QR = ...
local L = QR.L

local Events = {}
QR.Events = Events
QR.eventGuides = QR.eventGuides or {}   -- secciones de los eventos activos (creada en ZoneGuides.lua)

local TICKET = 19182     -- Darkmoon Faire Prize Ticket
local SAYGE, FLIK = 14822, 14860
local ELWYNN, MULGORE = 12, 215

-- NPCs y objetos de la Feria: la base de datos los tiene en las dos zonas y Questie solo mueve 6 NPCs a la zona
-- de este mes (Sayge, Flik, el profesor Paleo y los objetos de la fortuna se quedarian en las dos)
local FAIRE_NPCS = { 14822, 14828, 14829, 14832, 14833, 14841, 14847, 14860, 14871 }
local FAIRE_OBJECTS = { 180024, 180025, 180055, 180056 }

---------------------------------------------------------------------------
-- Feria de la Luna Negra: entregas que dan vales
---------------------------------------------------------------------------
-- quest -> { npc, item, count, tickets, craft }   craft = objeto fabricado (solo se propone si ya lo llevas)
-- Vales por entrega segun Zygor: 1 / 4 / 8 / 12 / 20 (nivel 1 / 10 / 20 / 30 / 40). Hasta el nivel 30 cada tramo se
-- puede repetir hasta un tope de reputacion (Questie las bloquea al llegar); las de nivel 40 son repetibles siempre.
local TURNINS = {
    -- Chronos (peleteria)
    [7881] = { npc = 14833, item = 2309, count = 3, tickets = 1, craft = true },
    [7882] = { npc = 14833, item = 2314, count = 3, tickets = 4, craft = true },
    [7883] = { npc = 14833, item = 5739, count = 3, tickets = 8, craft = true },
    [7884] = { npc = 14833, item = 8185, count = 1, tickets = 12, craft = true },
    [7885] = { npc = 14833, item = 15564, count = 8, tickets = 20, craft = true },
    [7941] = { npc = 14833, item = 15564, count = 8, tickets = 20, craft = true },
    -- Kerri Hicks (herreria)
    [7889] = { npc = 14832, item = 3240, count = 10, tickets = 1, craft = true },
    [7890] = { npc = 14832, item = 3486, count = 7, tickets = 4, craft = true },
    [7891] = { npc = 14832, item = 3835, count = 3, tickets = 8, craft = true },
    [7892] = { npc = 14832, item = 7945, count = 1, tickets = 12, craft = true },
    [7893] = { npc = 14832, item = 12644, count = 8, tickets = 20, craft = true },
    [7939] = { npc = 14832, item = 12644, count = 8, tickets = 20, craft = true },
    -- Rinling (ingenieria)
    [7894] = { npc = 14841, item = 4363, count = 5, tickets = 1, craft = true },
    [7895] = { npc = 14841, item = 4375, count = 7, tickets = 4, craft = true },
    [7896] = { npc = 14841, item = 9313, count = 36, tickets = 8, craft = true },
    [7897] = { npc = 14841, item = 11590, count = 6, tickets = 12, craft = true },
    [7898] = { npc = 14841, item = 15994, count = 6, tickets = 20, craft = true },
    [7942] = { npc = 14841, item = 15994, count = 6, tickets = 20, craft = true },
    -- Yebb Neblegear (objetos de bichos: se farmean, la guia lleva a por ellos)
    [7899] = { npc = 14829, item = 5134, count = 5, tickets = 1 },
    [7900] = { npc = 14829, item = 11407, count = 5, tickets = 4 },
    [7901] = { npc = 14829, item = 4582, count = 5, tickets = 8 },
    [7902] = { npc = 14829, item = 5117, count = 5, tickets = 12 },
    [7903] = { npc = 14829, item = 11404, count = 10, tickets = 20 },
    [7943] = { npc = 14829, item = 11404, count = 10, tickets = 20 },
    [8222] = { npc = 14829, item = 19933, count = 10, tickets = 20 },
    [8223] = { npc = 14829, item = 19933, count = 10, tickets = 20 },
}

-- Premios de Gelvas Roñas (se canjean vales). Para "comprarlo todo": de mas barato a mas caro, uno cada vez.
local PRIZES = {
    { quest = 7930, cost = 5 },     -- Darkmoon Flower
    { quest = 7931, cost = 5 },     -- Minor Darkmoon Prize
    { quest = 7935, cost = 10 },    -- Last Month's Mutton
    { quest = 7932, cost = 12 },    -- Lesser Darkmoon Prize
    { quest = 7933, cost = 40 },    -- Greater Darkmoon Prize
    { quest = 7934, cost = 50 },    -- Darkmoon Storage Box
    { quest = 7936, cost = 50 },    -- Last Year's Mutton
    { quest = 7940, cost = 1200 },  -- Orb of the Darkmoon
    { quest = 7981, cost = 1200 },  -- Amulet of the Darkmoon
}
local PRIZE_OF = {}
local PRIZES_TOTAL = 0
for _, p in ipairs(PRIZES) do PRIZE_OF[p.quest] = p; PRIZES_TOTAL = PRIZES_TOTAL + p.cost end

local LEVEL_OF = { [1] = 1, [4] = 10, [8] = 20, [12] = 30, [20] = 40 }   -- vales -> nivel requerido

local SAYGE_BUFFS = { [23735] = true, [23736] = true, [23737] = true, [23738] = true,
                      [23766] = true, [23767] = true, [23768] = true, [23769] = true }

---------------------------------------------------------------------------
-- Utilidades
---------------------------------------------------------------------------
-- objetos en las bolsas (WoW Forever: C_Item.GetItemCount; clientes clasicos: GetItemCount)
local ItemCount = (C_Item and C_Item.GetItemCount) or GetItemCount
local function Count(item) return (ItemCount and ItemCount(item, false)) or 0 end
function Events:Tickets() return Count(TICKET) end

local function Bought()
    QR.charDB.eventDone = QR.charDB.eventDone or {}
    return QR.charDB.eventDone
end

--- Nombre corto de un premio ("40 Tickets - Greater Darkmoon Prize" -> "Greater Darkmoon Prize")
local function PrizeName(questId)
    local q = QR.Bridge:GetQuest(questId)
    local n = q and q.name or ("#" .. questId)
    return (n:gsub("^%d+%s*[^%-:]-%s*[%-:]%s*", ""))
end

--- Siguiente premio por comprar (el mas barato que aun no tienes y que tu nivel permite), o nil si ya los tienes todos
function Events:NextPrize()
    local done = Bought()
    local level = UnitLevel("player")
    local blocked
    for _, p in ipairs(PRIZES) do
        if not done[p.quest] then
            local req = QR.Bridge.QuestieDB.QueryQuestSingle(p.quest, "requiredLevel") or 1
            if req <= level then return p end
            blocked = blocked or p
        end
    end
    return blocked
end

--- Vales que faltan para comprar todo lo que queda
function Events:TicketsLeft()
    local done, left = Bought(), 0
    for _, p in ipairs(PRIZES) do if not done[p.quest] then left = left + p.cost end end
    return left
end

--- Beneficio i del jugador: existe, spellId (WoW Forever no tiene UnitBuff: C_UnitAuras; clasicos: UnitBuff)
local function BuffSpellId(i)
    if C_UnitAuras and C_UnitAuras.GetBuffDataByIndex then
        local aura = C_UnitAuras.GetBuffDataByIndex("player", i)
        return aura ~= nil, aura and aura.spellId
    elseif C_UnitAuras and C_UnitAuras.GetAuraDataByIndex then
        local aura = C_UnitAuras.GetAuraDataByIndex("player", i, "HELPFUL")
        return aura ~= nil, aura and aura.spellId
    elseif UnitBuff then
        local name, _, _, _, _, _, _, _, _, spellId = UnitBuff("player", i)
        return name ~= nil, spellId
    end
    return false, nil
end

local function HasSaygeBuff()
    for i = 1, 40 do
        local exists, spellId = BuffSpellId(i)
        if not exists then break end
        if spellId and SAYGE_BUFFS[spellId] then return true end
    end
    return false
end

---------------------------------------------------------------------------
-- Cuando y donde esta la Feria
---------------------------------------------------------------------------
-- Regla de Questie para Classic Era (QuestieEvent.lua): empieza a las 03:00 del lunes siguiente al primer viernes
-- del mes y dura una semana; los meses impares en el Bosque de Elwynn y los pares en Mulgore.
local START_BY_WEEKDAY = { 9, 8, 7, 6, 5, 4, 10 }   -- dia de la semana del dia 1 (1 = domingo) -> lunes de inicio

local function Now()   -- fecha del reino
    if C_DateAndTime and C_DateAndTime.GetCurrentCalendarTime then
        local t = C_DateAndTime.GetCurrentCalendarTime()
        if t and t.year and t.year > 0 then return t.year, t.month, t.monthDay, t.hour end
    end
    local d = date("*t")
    return d.year, d.month, d.day, d.hour
end

local function StartDay(year, month)
    return START_BY_WEEKDAY[date("*t", time({ year = year, month = month, day = 1, hour = 12 })).wday]
end

local function AreaOfMonth(month) return month % 2 == 1 and ELWYNN or MULGORE end

--- Segun el calendario: montada ahora, y la fecha que importa (fin si esta montada, si no la proxima apertura)
local function Calendar()
    local y, m, d, h = Now()
    local s = StartDay(y, m)
    local afterStart = d > s or (d == s and h >= 3)
    local beforeEnd = d < s + 7 or (d == s + 7 and h < 3)
    if afterStart and beforeEnd then
        return true, { year = y, month = m, day = s + 7, area = AreaOfMonth(m) }
    elseif not afterStart then
        return false, { year = y, month = m, day = s, area = AreaOfMonth(m) }
    end
    local ny, nm = y, m + 1
    if nm > 12 then ny, nm = y + 1, 1 end
    return false, { year = ny, month = nm, day = StartDay(ny, nm), area = AreaOfMonth(nm) }
end

local function QuestieEventModule()
    local ok, QE = pcall(QuestieLoader.ImportModule, QuestieLoader, "QuestieEvent")
    if ok and QE and QE.activeQuests then return QE end
end

--- ¿Esta la Feria montada? Questie activa sus misiones solo esa semana; si no se puede saber, el calendario.
function Events:FaireUp()
    local QE = QuestieEventModule()
    if QE and next(QE.activeQuests) ~= nil then return QE.activeQuests[7930] == true end
    return (Calendar())
end

--- Donde esta (o estara) la Feria: 12 Elwynn, 215 Mulgore.
--- Montada: Questie activa la mision de anuncio de un solo bando (7905 Alianza = Elwynn, 7926 Horda = Mulgore)
--- y deja a Gelvas solo en esa zona. Si no, la zona que toca segun el calendario.
function Events:FaireArea()
    local up, when = Calendar()
    if self:FaireUp() then
        local QE = QuestieEventModule()
        if QE then
            local a, h = QE.activeQuests[7905], QE.activeQuests[7926]
            if a and not h then return ELWYNN end
            if h and not a then return MULGORE end
        end
        local npc = QR.Bridge.QuestieDB:GetNPC(14828)
        local spawns = npc and npc.spawns
        if spawns and spawns[MULGORE] and not spawns[ELWYNN] then return MULGORE end
        if spawns and spawns[ELWYNN] and not spawns[MULGORE] then return ELWYNN end
        if up then return when.area end
        local y, m = Now()
        return AreaOfMonth(m)
    end
    return when.area
end

--- Nombre de la zona en el idioma del juego
local function ZoneName(area)
    local map = QR.Bridge:UiMapOf(area)
    local info = map and C_Map.GetMapInfo and C_Map.GetMapInfo(map)
    return (info and info.name) or L[area == MULGORE and "Mulgore" or "Elwynn Forest"]
end

--- "lunes 7/12" (la Feria siempre abre y cierra en lunes a las 03:00)
local function DayText(t)
    local real = date("*t", time({ year = t.year, month = t.month, day = t.day, hour = 12 }))   -- normaliza 35/1 -> 4/2
    local name = CALENDAR_WEEKDAY_NAMES and CALENDAR_WEEKDAY_NAMES[real.wday]
    local text = string.format("%d/%d", real.day, real.month)
    return name and (name:lower() .. " " .. text) or text
end

--- Estado para el menu y el banner: up, zona (areaId y nombre) y texto corto / largo
function Events:FaireStatus()
    local calUp, when = Calendar()
    local st = { up = self:FaireUp() }
    if st.up then
        st.area = self:FaireArea()
        st.zone = ZoneName(st.area)
        st.short = st.zone
        st.long = calUp and string.format(L["Now in %s, until %s at 03:00"], st.zone, DayText(when))
            or string.format(L["Now in %s"], st.zone)
    else
        if calUp then   -- el calendario dice que si y Questie que no: la proxima, el mes que viene
            local y, m = Now()
            local ny, nm = y, m + 1
            if nm > 12 then ny, nm = y + 1, 1 end
            when = { year = ny, month = nm, day = StartDay(ny, nm), area = AreaOfMonth(nm) }
        end
        st.area, st.zone = when.area, ZoneName(when.area)
        st.short = L["not up"]
        st.long = string.format(L["Not up  ·  next: %s in %s"], DayText(when), st.zone)
    end
    return st
end

--- Fija los NPCs y objetos de la Feria a la zona en la que esta (la base de datos los tiene en las dos)
function Events:ApplyFaireArea()
    local area = self:FaireArea()
    for _, id in ipairs(FAIRE_NPCS) do QR.Bridge.npcArea[id] = area end
    for _, id in ipairs(FAIRE_OBJECTS) do QR.Bridge.objectArea[id] = area end
    return area
end

---------------------------------------------------------------------------
-- Secciones de la Feria
---------------------------------------------------------------------------
local function Rows(ids)
    local rows = {}
    for _, id in ipairs(ids) do
        local t, p = TURNINS[id], PRIZE_OF[id]
        local req = (t and LEVEL_OF[t.tickets]) or (p and (QR.Bridge and QR.Bridge.QuestieDB and QR.Bridge.QuestieDB.QueryQuestSingle(id, "requiredLevel"))) or 1
        rows[#rows + 1] = { id, req, req }
    end
    return rows
end

local DMF = { key = "DARKMOON_FAIRE", name = "Darkmoon Faire", active = true,
              Status = function() return Events:FaireStatus() end }

-- comun a todas las secciones de la Feria
local Faire = {}
Faire.__index = Faire

function Faire:Prepare()
    local area = Events:ApplyFaireArea()
    self.areaId = area
    self.zone = area == MULGORE and "Mulgore" or "Elwynn Forest"
end

function Faire:CanPickup(questId)
    local t = TURNINS[questId]
    if t and t.craft then return Count(t.item) >= t.count end
    local p = PRIZE_OF[questId]
    if p then
        local nextPrize = Events:NextPrize()
        return nextPrize == p and Events:Tickets() >= p.cost
    end
    return true
end

--- Nivel de la mision en la guia: Questie pone nivel 60 a todas las de la Feria aunque se hagan desde nivel 1
function Faire:QuestLevel(questId)
    local info = self.info and self.info[questId]
    return info and info.level or nil
end

--- Icono de las lineas de la mision: los canjes de vales son solo comprar (monedas)
function Faire:QuestIcon(questId)
    return PRIZE_OF[questId] and "coin" or nil
end

function Faire:BannerTexts()
    local tickets = Events:Tickets()
    local nextPrize = Events:NextPrize()
    local status = Events:FaireStatus()
    local sub
    if not status.up then
        sub = status.long
    elseif nextPrize then
        sub = string.format(L["%d tickets  ·  next: %s (%d)"], tickets, PrizeName(nextPrize.quest), nextPrize.cost)
    else
        sub = string.format(L["%d tickets  ·  every prize bought"], tickets)
    end
    -- titulo corto (la seccion) para que no llegue al reloj; el evento y su zona van en la linea de arriba
    return "QUESTIEROUTER  /  " .. (L[DMF.name] .. "  ·  " .. status.short):upper(), L[self.titleKey], sub
end

function Faire:IdleMessage()
    if not Events:FaireUp() then
        return L["The Darkmoon Faire is not up right now."] .. "\n" .. Events:FaireStatus().long
    end
    return L[self.idleKey or "Nothing to turn in right now: bring the items for the turn-ins."]
end

function Faire:Visits() return nil end

local function Section(key, titleKey, ids, extra)
    local g = setmetatable({
        key = "EVENT_DMF_" .. key, event = DMF.key, eventName = DMF.name, titleKey = titleKey,
        faction = UnitFactionGroup("player"), zone = "Elwynn Forest", areaId = 12,
        quests = Rows(ids),
    }, Faire)
    -- rango de la seccion: el de sus misiones (el nivel requerido de cada una)
    local lo, hi = 60, 1
    for _, row in ipairs(g.quests) do lo, hi = math.min(lo, row[3]), math.max(hi, row[3]) end
    g.minLevel, g.maxLevel = math.min(lo, hi), hi
    for k, v in pairs(extra or {}) do g[k] = v end
    -- pasos de hablar con un NPC: solo con la Feria montada
    if extra and extra.Visits then
        local visits = extra.Visits
        g.Visits = function(self) if Events:FaireUp() then return visits(self) end end
    end
    return g
end

local function TurninIds(npc)
    local ids = {}
    for id, t in pairs(TURNINS) do if not npc or t.npc == npc then ids[#ids + 1] = id end end
    table.sort(ids, function(a, b)
        if TURNINS[a].tickets ~= TURNINS[b].tickets then return TURNINS[a].tickets < TURNINS[b].tickets end
        return a < b
    end)
    return ids
end

local function BuildFaire()
    local tickets = TurninIds()
    for _, p in ipairs(PRIZES) do tickets[#tickets + 1] = p.quest end
    DMF.sections = {
        -- Vales para todos los premios: todas las entregas (las fabricadas solo si llevas los objetos) y el canje
        Section("TICKETS", "Tickets for every prize", tickets),
        Section("LEATHER", "Chronos: leatherworking", TurninIds(14833)),
        Section("SMITHING", "Kerri Hicks: blacksmithing", TurninIds(14832)),
        Section("ENGINEERING", "Rinling: engineering", TurninIds(14841)),
        Section("FARMING", "Yebb Neblegear: farmed items", TurninIds(14829)),
        Section("FORTUNE", "Sayge's fortune", { 7937, 7938, 7944, 7945 }, {
            idleKey = "You already have Sayge's buff. You can ask for another fortune every 4 hours.",
            Visits = function()
                if HasSaygeBuff() then return nil end
                return { { npc = SAYGE, text = L["Talk to Sayge and choose your fortune buff"] } }
            end,
        }),
        Section("DECKS", "Darkmoon card decks", { 7907, 7927, 7928, 7929 }, {
            idleKey = "Complete a Darkmoon deck (8 cards) and use it to start its quest.",
        }),
        Section("PETS", "Pets: Jubjub and the frogs", { 7946 }, {
            idleKey = "Pets done: Jubjub's egg and Flik's frogs.",
            Visits = function()
                if Count(11027) > 0 and Count(11026) > 0 then return nil end
                return { { npc = FLIK, text = L["Catch Flik and buy his frogs (Wood Frog Box, Tree Frog Box)"] } }
            end,
        }),
    }
end

---------------------------------------------------------------------------
-- Lista de eventos (orden del calendario). active = true: ya esta en el juego y tiene guia.
---------------------------------------------------------------------------
Events.list = {
    DMF,
    { key = "LUNAR_FESTIVAL", name = "Lunar Festival" },
    { key = "LOVE_IS_IN_THE_AIR", name = "Love is in the Air" },
    { key = "CHILDRENS_WEEK", name = "Children's Week" },
    { key = "MIDSUMMER", name = "Midsummer Fire Festival" },
    { key = "HARVEST_FESTIVAL", name = "Harvest Festival" },
    { key = "HALLOWS_END", name = "Hallow's End" },
    { key = "WINTER_VEIL", name = "Feast of Winter Veil" },
}

--- Entradas del menu "Guias de eventos": los activos con sus secciones; despues, "Proximamente" con el resto
function Events:MenuEntries()
    local active = QR.Planner:GetGuide()
    local list = {}
    for _, ev in ipairs(self.list) do
        if ev.active and ev.sections then
            local status = ev.Status and ev.Status()
            local text = L[ev.name]
            if status then
                text = string.format("%s  %s(%s)|r", text, status.up and "|cff7fd17f" or "|cff9a9a9a", status.short)
            end
            list[#list + 1] = { text = text, icon = "Guides", menu = function()
                local sub = {}
                if status then
                    sub[#sub + 1] = { text = status.long, header = true }
                end
                for _, g in ipairs(ev.sections) do
                    sub[#sub + 1] = { text = string.format("[%d-%d] %s", g.minLevel, g.maxLevel, L[g.titleKey]),
                                      checked = g == active, func = function() QR.Planner:SetGuide(g.key) end }
                end
                return sub
            end }
        end
    end
    list[#list + 1] = QR.Menu.SPACER
    list[#list + 1] = { text = L["Coming soon"], header = true }
    for _, ev in ipairs(self.list) do
        if not ev.active then list[#list + 1] = { text = L[ev.name], disabled = true } end
    end
    return list
end

---------------------------------------------------------------------------
-- Registro
---------------------------------------------------------------------------
local function Register(g)
    g.order, g.info = {}, {}
    for i, row in ipairs(g.quests) do
        g.order[row[1]] = i
        g.info[row[1]] = { level = row[2], reqLevel = row[3] }
    end
    QR.eventGuides[#QR.eventGuides + 1] = g
    QR.zoneGuideByKey[g.key] = g
end

QR:RegisterModule("Events", function()
    BuildFaire()
    for _, ev in ipairs(Events.list) do
        if ev.active and ev.sections then for _, g in ipairs(ev.sections) do Register(g) end end
    end
    -- premios canjeados (para "comprarlo todo": no volver a proponer el mismo)
    local f = CreateFrame("Frame")
    f:RegisterEvent("QUEST_TURNED_IN")
    f:SetScript("OnEvent", function(_, _, questId)
        if PRIZE_OF[questId] then Bought()[questId] = true end
    end)
end)

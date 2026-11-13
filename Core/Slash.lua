-- QuestieRouter: comandos de chat (/qr, /questierouter).

local _, QR = ...
local L = QR.L

-- { comando, descripcion (clave de traduccion) }
local HELP = {
    { "/qr",               "enable / disable" },
    { "/qr arrow",         "show / hide the arrow" },
    { "/qr lock",          "lock / unlock the arrow" },
    { "/qr scale <n>",     "arrow scale (0.5 - 2)" },
    { "/qr map",           "lines on the world map" },
    { "/qr minimap",       "lines on the minimap" },
    { "/qr reset",         "move the arrow back to its place" },
    { "/qr info",          "show the current destination" },
    { "/qr guide",         "show / hide the zone guide window" },
    { "/qr zone <text>",   "activate the guide whose zone contains <text> (e.g. /qr zone elwynn)" },
    { "/qr stop",          "remove the guide (back to Questie focus mode)" },
    { "/qr pick",          "choose a zone (window with the zones)" },
    { "/qr options",       "graphics options" },
    { "/qr settings",      "addon panel in Settings > AddOns (changes: /qr settings changes, support: /qr settings support)" },
    { "/qr install",       "open the setup wizard again" },
    { "/qr maplevels",     "save the level range of every zone map (for the guide generator)" },
    { "/qr icon",          "show / hide the minimap button" },
    { "/qr load_es",       "interface language: es, en, fr, de, ru (load_auto = client language)" },
    { "/qr locale",        "current language and missing translations" },
    { "/qr road",          "paths inside a zone: add [x y] | rec | new | undo | list | clear" },
    { "/qr dungeon",       "route to a dungeon entrance: /qr dungeon <name> | stop" },
    { "/qr taxi",          "which flights QuestieRouter thinks you have learned (debug: what the game reports)" },
    { "/qr taxi <name>",   "state of one flight master and where it came from (forget <name>: mark as not learned)" },
}

---------------------------------------------------------------------------
-- Grabar un camino andando (/qr road rec): un punto cada REC_STEP yardas; al parar se quitan los puntos
-- que sobran en los tramos rectos (Douglas-Peucker, tolerancia REC_TOLERANCE yardas)
---------------------------------------------------------------------------
local REC_STEP, REC_TOLERANCE = 25, 8
local rec -- { zone, pts = { x, y, ... } (0..1), world = { { x, y }, ... }, ticker }

local function Simplify(world, tol)
    local keep = { [1] = true, [#world] = true }
    local function dp(a, b)
        local ax, ay, bx, by = world[a][1], world[a][2], world[b][1], world[b][2]
        local dx, dy = bx - ax, by - ay
        local len = math.sqrt(dx * dx + dy * dy)
        local best, idx = 0, nil
        for i = a + 1, b - 1 do
            local px, py = world[i][1] - ax, world[i][2] - ay
            local d = len > 0 and math.abs(px * dy - py * dx) / len or math.sqrt(px * px + py * py)
            if d > best then best, idx = d, i end
        end
        if idx and best > tol then keep[idx] = true; dp(a, idx); dp(idx, b) end
    end
    if #world > 2 then dp(1, #world) end
    return keep
end

--- Guarda el camino grabado (simplificado) en los caminos propios
local function CommitRecording()
    if not rec or #rec.world < 2 then return 0 end
    local keep = Simplify(rec.world, REC_TOLERANCE)
    local pts = {}
    for i = 1, #rec.world do
        if keep[i] then
            pts[#pts + 1] = math.floor(rec.pts[i * 2 - 1] * 10000 + 0.5) / 10000
            pts[#pts + 1] = math.floor(rec.pts[i * 2] * 10000 + 0.5) / 10000
        end
    end
    QR.db.customRoads = QR.db.customRoads or {}
    table.insert(QR.db.customRoads, { rec.zone, pts })
    QR.db.roadOpen = false
    QR.Router:Invalidate()
    return #pts / 2
end

local function RecordTick()
    local wx, wy = QR.HBD:GetPlayerWorldPosition()
    local zone, nx, ny = QR.Router:PlayerZonePoint()
    if not (wx and zone) then return end
    if zone ~= rec.zone then
        -- otra zona: se guarda lo grabado y se sigue en un camino nuevo
        local n = CommitRecording()
        if n > 0 then QR:Print(string.format(L["Path saved in %s (%d points)."], QR.Router.MapName(rec.zone), n)) end
        rec.zone, rec.pts, rec.world = zone, {}, {}
    end
    local last = rec.world[#rec.world]
    if last and math.sqrt((wx - last[1]) ^ 2 + (wy - last[2]) ^ 2) < REC_STEP then return end
    rec.world[#rec.world + 1] = { wx, wy }
    rec.pts[#rec.pts + 1] = nx
    rec.pts[#rec.pts + 1] = ny
end

local function ToggleRecording()
    if rec then
        rec.ticker:Cancel()
        RecordTick()
        local n = CommitRecording()
        QR:Print(string.format(L["Recording stopped. Path saved in %s (%d points)."], QR.Router.MapName(rec.zone), n))
        rec = nil
        if QR.Target then QR.Target:Refresh(true) end
        return
    end
    local zone = QR.Router:PlayerZonePoint()
    if not zone then QR:Print(L["Your position on the map is not available here."]) return end
    rec = { zone = zone, pts = {}, world = {} }
    rec.ticker = C_Timer.NewTicker(0.5, RecordTick)
    RecordTick()
    QR:Print(L["Recording a path: walk along it and type /qr road rec again to finish."])
end

--- /qr dungeon <nombre>: ruta hasta la entrada de una mazmorra
local function DungeonCommand(arg)
    if arg == "stop" then
        QR.Target:SetManual(nil)
        QR:Print(L["Destination removed."])
        return
    end
    local list = QR.Router:FindDungeons(arg)
    if arg == "" or #list == 0 then
        if arg ~= "" then QR:Print(string.format(L["No dungeon matches '%s'."], arg)) end
        local all = QR.Router:FindDungeons("")
        local names = {}
        for _, d in ipairs(all) do names[#names + 1] = d.name end
        QR:Print(L["Dungeons:"] .. " " .. table.concat(names, ", "))
        return
    end
    local d = list[1]
    QR.Target:SetManual({ kind = "dungeon", questId = -100, questName = d.name, name = L["Dungeon entrance"],
        wx = d.wx, wy = d.wy, instance = d.inst })
    QR:Print(string.format(L["Destination: %s."], d.name))
end

--- /qr road: caminos dentro de una zona (se guardan en QuestieRouterDB.customRoads y se usan al momento)
local function RoadCommand(arg)
    local sub, rest = (arg or ""):match("^(%S*)%s*(.-)$")
    QR.db.customRoads = QR.db.customRoads or {}
    local roads = QR.db.customRoads
    local function changed()
        QR.Router:Invalidate()
        if QR.Target then QR.Target:Refresh(true) end
    end
    local function name(zone) return QR.Router.MapName(zone) end
    if sub == "rec" then
        ToggleRecording()
    elseif sub == "add" then
        local x, y = rest:match("([%d.]+)[,%s]+([%d.]+)")
        x, y = tonumber(x), tonumber(y)
        local zone, nx, ny = QR.Router:PlayerZonePoint(x and x / 100, y and y / 100)
        if not zone then QR:Print(L["Your position on the map is not available here."]) return end
        local last = roads[#roads]
        if not (QR.db.roadOpen and last and last[1] == zone) then
            last = { zone, {} }
            roads[#roads + 1] = last
        end
        QR.db.roadOpen = true
        local pts = last[2]
        pts[#pts + 1] = math.floor(nx * 10000 + 0.5) / 10000
        pts[#pts + 1] = math.floor(ny * 10000 + 0.5) / 10000
        QR:Print(string.format(L["Path point %d added in %s (%.1f, %.1f)."], #pts / 2, name(zone), nx * 100, ny * 100))
        changed()
    elseif sub == "new" then
        QR.db.roadOpen = false
        QR:Print(L["The next point starts a new path."])
    elseif sub == "undo" then
        local last = roads[#roads]
        if not last then QR:Print(L["There are no paths of yours."]) return end
        table.remove(last[2]); table.remove(last[2])
        if #last[2] == 0 then table.remove(roads); QR.db.roadOpen = false end
        QR:Print(L["Last path point removed."])
        changed()
    elseif sub == "list" then
        if #roads == 0 then QR:Print(L["There are no paths of yours."]) return end
        for i, r in ipairs(roads) do
            local out = {}
            for k = 1, #r[2] - 1, 2 do out[#out + 1] = string.format("%.1f %.1f", r[2][k] * 100, r[2][k + 1] * 100) end
            QR:Print(string.format("%d. %s: %s", i, name(r[1]), table.concat(out, " > ")))
        end
    elseif sub == "clear" then
        QR.db.customRoads, QR.db.roadOpen = {}, false
        QR:Print(L["Your paths have been deleted."])
        changed()
    else
        QR:Print(L["/qr road add  - add your position to the path (or: /qr road add 45.5 41.3)"])
        QR:Print(L["/qr road rec  - record a path while you walk (again to stop)"])
        QR:Print(L["/qr road new  - the next point starts a new path"])
        QR:Print(L["/qr road undo | list | clear"])
    end
end

local function Toggle(tbl, key, label)
    tbl[key] = not tbl[key]
    QR:Print(label .. ": " .. (tbl[key] and L["|cff33ff33yes|r"] or L["|cffff3333no|r"]))
    QR:Fire("SETTINGS_CHANGED")
end

--- /qr load_xx: guarda el idioma de la interfaz y recarga (los textos se ponen al cargar el addon)
local function LoadLocale(short)
    local code
    if short == "auto" or short == "client" then
        code = nil
    else
        code = QR.LOCALE_SHORT[short]
        if not code then
            QR:Print(string.format(L["Unknown language '%s'. Use: es, en, fr, de, ru or auto."], short))
            return
        end
        if not QR.locales[code] then
            QR:Print(string.format(L["%s is not translated yet."], QR.LOCALE_NAMES[code] or code))
            return
        end
    end
    QR.db.locale = code
    QR:Print(string.format(L["Language: %s. Reloading the interface..."], QR.LOCALE_NAMES[code or QR:ClientLocale()] or "?"))
    ReloadUI()
end

SLASH_QUESTIEROUTER1 = "/qr"
SLASH_QUESTIEROUTER2 = "/questierouter"
SlashCmdList.QUESTIEROUTER = function(msg)
    if not QR.db then return end
    local cmd, arg = (msg or ""):lower():match("^%s*(%S*)%s*(.-)%s*$")

    if cmd == "" then
        QR:SetEnabled(not QR.db.enabled)
    elseif cmd:match("^load_") then
        LoadLocale(cmd:sub(6))
    elseif cmd == "load" then
        LoadLocale(arg)
    elseif cmd == "locale" then
        local missing = QR:MissingTranslations()
        QR:Print(string.format(L["Language: %s (%s) · client: %s"], QR.LOCALE_NAMES[QR.locale] or QR.locale, QR.locale, GetLocale()))
        if QR.locale ~= "enUS" then
            QR:Print(string.format(L["%d texts without translation (shown in English)."], #missing))
            for i = 1, math.min(#missing, 15) do QR:Print("  " .. missing[i]) end
        end
    elseif cmd == "road" then
        RoadCommand(arg)
    elseif cmd == "dungeon" then
        DungeonCommand(arg)
    elseif cmd == "taxi" then
        local sub, rest = arg:match("^(%S*)%s*(.-)$")
        if sub == "debug" then QR.Router:TaxiDebug()
        elseif sub == "map" then QR.Router:TaxiMapReport()
        elseif sub == "forget" and rest ~= "" then QR.Router:TaxiForget(rest)
        elseif arg ~= "" then QR.Router:TaxiNodeReport(arg)
        else QR.Router:ScanKnownTaxi(); QR.Router:TaxiReport() end
    elseif cmd == "arrow" then
        Toggle(QR.db.arrow, "shown", L["Arrow"])
    elseif cmd == "lock" then
        Toggle(QR.db.arrow, "locked", L["Arrow locked"])
    elseif cmd == "map" then
        Toggle(QR.db.lines, "worldmap", L["Map lines"])
    elseif cmd == "minimap" then
        Toggle(QR.db.lines, "minimap", L["Minimap lines"])
    elseif cmd == "scale" then
        local n = tonumber(arg)
        if n and n >= 0.5 and n <= 2 then
            QR.db.arrow.scale = n
            QR:Fire("SETTINGS_CHANGED")
        else
            QR:Print(L["usage: /qr scale 0.5-2"])
        end
    elseif cmd == "reset" then
        QR.db.arrow.point = { "TOP", "UIParent", "TOP", 0, -120 }
        QR:Fire("SETTINGS_CHANGED")
    elseif cmd == "icon" then
        QR.MinimapButton:SetShown(not QR.MinimapButton:IsShown())
    elseif cmd == "pick" then
        QR.ZonePicker:Show()
    elseif cmd == "options" or cmd == "opciones" then
        QR.Options:Toggle()
    elseif cmd == "maplevels" then
        -- rango de niveles de cada zona tal y como lo muestra el mapa del juego (lo usa tools/map_levels.py para
        -- el rango de las guias). Se recorren todos los mapas de tipo zona y se guardan en QuestieRouterDB.mapLevels.
        local out, n = {}, 0
        local ZONE = Enum and Enum.UIMapType and Enum.UIMapType.Zone or 3
        -- diagnostico (por si no sale ninguna): que API hay y que devuelve en zonas conocidas
        local dbg = { hasGetMapLevels = C_Map.GetMapLevels ~= nil, zoneEnum = ZONE, zoneMaps = 0, zeroLevels = 0,
                      types = {}, sample = {}, api = {} }
        for k in pairs(C_Map) do if tostring(k):lower():find("level") then dbg.api[#dbg.api + 1] = tostring(k) end end
        for _, id in ipairs({ 1429, 1411, 1436, 2521 }) do
            local info = C_Map.GetMapInfo(id)
            local r = { info and info.name or "nil", info and info.mapType or -1 }
            if C_Map.GetMapLevels then
                local ok, a, b, c, d = pcall(C_Map.GetMapLevels, id)
                r[3] = ok and tostring(a) .. "," .. tostring(b) .. "," .. tostring(c) .. "," .. tostring(d) or ("error: " .. tostring(a))
            end
            dbg.sample[id] = table.concat(r, " | ", 1, #r)
        end
        for id = 1, 4000 do
            local info = C_Map.GetMapInfo(id)
            if info then dbg.types[info.mapType or -1] = (dbg.types[info.mapType or -1] or 0) + 1 end
            if info and info.mapType == ZONE and C_Map.GetMapLevels then
                dbg.zoneMaps = dbg.zoneMaps + 1
                local ok, lo, hi = pcall(C_Map.GetMapLevels, id)
                if ok and lo and hi and hi > 0 then
                    local area = QR.Bridge.ZoneDB and QR.Bridge.ZoneDB.GetAreaIdByUiMapId and QR.Bridge.ZoneDB:GetAreaIdByUiMapId(id)
                    out[id] = { min = lo, max = hi, areaId = area, name = info.name }
                    n = n + 1
                else
                    dbg.zeroLevels = dbg.zeroLevels + 1
                end
            end
        end
        QR.db.mapLevels = out
        QR.db.mapLevelsDebug = dbg
        QR:Print(string.format(L["Saved the level range of %d zones. Type /reload to write them to disk."], n))
    elseif cmd == "install" or cmd == "instalar" or cmd == "setup" then
        QR.Install:Show()
    elseif cmd == "settings" or cmd == "ajustes" then
        QR.SettingsUI:Open(arg ~= "" and arg or nil)
    elseif cmd == "guide" then
        QR.GuideUI:Toggle()
    elseif cmd == "stop" then
        QR.Planner:SetGuide(nil)
        if QR.Target.manual then QR.Target:SetManual(nil) end
        QR:Print(L["Guide disabled."])
    elseif cmd == "zone" then
        local found
        for _, g in ipairs(QR.zoneGuides) do
            -- se busca en el nombre de la zona en el idioma del cliente, en ingles y en la clave
            local label = (QR.GuideLabel(g) or ""):lower()
            if arg ~= "" and (label:find(arg, 1, true) or g.zone:lower():find(arg, 1, true) or g.key:lower():find(arg, 1, true)) then
                found = g
                break
            end
        end
        if found then
            QR.Planner:SetGuide(found.key)
            QR:Print(string.format(L["Active guide: %s"], found.key))
        else
            QR:Print(string.format(L["No guide matches '%s'."], arg))
        end
    elseif cmd == "info" then
        local t = QR.target
        local guide = QR.Planner:GetGuide()
        if guide then QR:Print(string.format(L["Guide: %s"], guide.key) .. (QR.Planner.plan and QR.Planner.plan.reason and (" · " .. QR.Planner.plan.reason) or "")) end
        if t then
            local where = (t.x and t.y) and string.format(L["(%.1f, %.1f) map %s"], t.x * 100, t.y * 100, tostring(t.uiMapId))
                or string.format(L["(world %.0f, %.0f)"], t.wx or 0, t.wy or 0)
            QR:Print(string.format("[%s] %s -> %s%s %s", tostring(t.questId or "-"), t.questName or "?",
                t.isTurnIn and L["turn in to "] or "", t.name or "?", where))
        else
            QR:Print(L["No destination. Focus a quest in the Questie tracker (focus button)."])
        end
    else
        for _, h in ipairs(HELP) do QR:Print(string.format("%-18s - %s", h[1], L[h[2]])) end
    end
end

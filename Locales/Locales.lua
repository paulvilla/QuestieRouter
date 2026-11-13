-- QuestieRouter: traducciones.
--
-- Cada idioma es un archivo de esta carpeta (enUS.lua, esES.lua, ...) que registra una tabla
--     QR:RegisterLocale("esES", { ["Turn in to %s"] = "Entrega a %s", ... })
-- La clave es SIEMPRE el texto en ingles; enUS.lua contiene todas las claves (es la lista completa
-- de textos del addon). Si a un idioma le falta una clave, se ve el texto en ingles.
--
-- En el codigo se usa  local L = QR.L  y luego  L["Turn in to %s"]. La busqueda se hace en el
-- momento de usarla, asi que vale para textos que se escriben en la interfaz despues de cargar.
-- Las tablas que se crean al cargar el archivo guardan la clave inglesa y se traducen al mostrarlas
-- (L[entry.name]) o se rellenan con QR:OnLocale(fn).
--
-- Idioma: el del cliente (GetLocale) o el elegido con /qr load_es, /qr load_en, ... (se guarda en
-- QuestieRouterDB.locale y se aplica al cargar el addon; por eso el comando recarga la interfaz).
local _, QR = ...

QR.locales = {}
local active = {}

-- L[clave] -> traduccion del idioma activo, o la propia clave (ingles) si no hay traduccion
QR.L = setmetatable({}, {
    __index = function(_, key)
        local v = active[key]
        if v == nil or v == true then return key end
        return v
    end,
    __newindex = function() error("QR.L es de solo lectura: añade los textos en Locales/*.lua", 2) end,
})

-- Idiomas del cliente que tienen traduccion. El resto usa el ingles.
local CLIENT_LOCALE = {
    enUS = "enUS", enGB = "enUS",
    esES = "esES", esMX = "esES",
    frFR = "frFR", deDE = "deDE", ruRU = "ruRU",
}

-- Codigo corto de /qr load_xx -> idioma
QR.LOCALE_SHORT = { en = "enUS", es = "esES", fr = "frFR", de = "deDE", ru = "ruRU" }
QR.LOCALE_NAMES = { enUS = "English", esES = "Español", frFR = "Français", deDE = "Deutsch", ruRU = "Русский" }

function QR:ClientLocale()
    return CLIENT_LOCALE[GetLocale and GetLocale() or "enUS"] or "enUS"
end

QR.locale = QR:ClientLocale()

--- Registra la tabla de un idioma (lo llaman los archivos de esta carpeta al cargar)
function QR:RegisterLocale(code, strings)
    self.locales[code] = strings
    if code == self.locale then active = strings end
end

local callbacks = {}

--- fn(L) se llama ahora y cada vez que cambia el idioma (para tablas que se rellenan al cargar)
function QR:OnLocale(fn)
    callbacks[#callbacks + 1] = fn
    fn(QR.L)
end

--- Activa un idioma. Sin traduccion para ese codigo -> el del cliente -> ingles.
function QR:SetLocale(code)
    if not (code and self.locales[code]) then code = self:ClientLocale() end
    if not self.locales[code] then code = "enUS" end
    self.locale = code
    active = self.locales[code] or {}
    for _, fn in ipairs(callbacks) do
        local ok, err = pcall(fn, QR.L)
        if not ok then print("QuestieRouter locale:", err) end
    end
end

--- Claves de enUS que no estan traducidas en el idioma activo (para /qr locale)
function QR:MissingTranslations(code)
    local base, tbl, missing = self.locales.enUS or {}, self.locales[code or self.locale] or {}, {}
    if (code or self.locale) == "enUS" then return missing end
    for key in pairs(base) do
        if tbl[key] == nil then missing[#missing + 1] = key end
    end
    table.sort(missing)
    return missing
end

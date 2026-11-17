-- QuestieRouter: ventanitas de "objetos activos" y "objetivo activo".
--
--   Objetos activos  botones para USAR los objetos de las misiones activas (los que la mision te da o
--                    pide usar, y cualquier objeto de mision de las bolsas con efecto "Usar").
--                    Primero los de la mision del paso actual.
--   Objetivo activo  botones que SELECCIONAN los bichos del paso actual (los que hay que matar o los que
--                    sueltan el objeto) y el NPC al que hay que coger / entregar. Si lo tienes seleccionado
--                    o bajo el raton, el boton muestra su retrato.
--
-- Son botones seguros (SecureActionButtonTemplate): en combate no se pueden crear, mostrar, ocultar ni
-- cambiar. Los cambios pedidos en combate se aplican al salir de el (PLAYER_REGEN_ENABLED).

local _, QR = ...
local L = QR.L

local Active = {}
QR.ActiveFrames = Active

local MAX_ITEMS = 8

local GetItemSpell = (C_Item and C_Item.GetItemSpell) or _G.GetItemSpell
local GetItemInfo = (C_Item and C_Item.GetItemInfo) or _G.GetItemInfo
local GetItemCount = (C_Item and C_Item.GetItemCount) or _G.GetItemCount
local GetItemCooldown = (C_Container and C_Container.GetItemCooldown) or _G.GetItemCooldown
local GetContainerNumSlots = (C_Container and C_Container.GetContainerNumSlots) or _G.GetContainerNumSlots
local GetContainerItemID = (C_Container and C_Container.GetContainerItemID) or _G.GetContainerItemID

local ENEMY_PLACEHOLDER = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"   -- calavera
local FRIENDLY_PLACEHOLDER = "Interface\\GossipFrame\\AvailableQuestIcon"

---------------------------------------------------------------------------
-- Contenedor con el estilo de la skin
---------------------------------------------------------------------------
local function SavePoint(f, key)
    local point, _, relPoint, x, y = f:GetPoint(1)
    QR.db.activeFrames[key] = { point, "UIParent", relPoint, x, y }
end

local function CreateContainer(name, title, pointKey, sizeKey)
    local S = QR.Skin
    local f = CreateFrame("Frame", name, UIParent)
    -- (como la ventana de la guia: encima del seguimiento de misiones, debajo de la mochila)
    f:SetFrameStrata("MEDIUM")
    f:SetFrameLevel(20)
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self)
        if not QR.db.guideWindow.locked and not InCombatLockdown() then self:StartMoving() end
    end)
    -- tiene botones seguros dentro: en combate no se puede "soltar"; se suelta al terminar el combate
    f:SetScript("OnDragStop", function(self)
        if InCombatLockdown() then self.qrStopPending = true return end
        self:StopMovingOrSizing()
        SavePoint(self, pointKey)
        Active:RequestUpdate() -- recolocar: puede haber pasado a la otra mitad de la pantalla
    end)
    f.pointKey = pointKey
    f.sizeKey = sizeKey
    f.titleKey = (sizeKey == "itemsSize") and "itemsTitle" or "targetsTitle"
    f.card = S:CreateCard(f)
    f.card:SetAllPoints()
    f.card:EnableMouse(false)
    -- el fondo es un marco hijo y se pinta encima de los textos del padre: el titulo va en una capa superior
    f.top = CreateFrame("Frame", nil, f)
    f.top:SetAllPoints()
    f.top:SetFrameLevel(f:GetFrameLevel() + 8)
    f.title = f.top:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    f.title:SetPoint("TOPLEFT", 8, -5)
    f.title:SetText(title)
    local p = QR.db.activeFrames[pointKey]
    f:SetPoint(p[1], UIParent, p[3], p[4], p[5])
    f.buttons = {}
    f:Hide()
    return f
end

local function PaintContainer(f)
    QR.Skin:PaintCard(f.card, "card", 0.95, "list")
    QR.Skin:StyleText(f.title, "eyebrow")
    f.title:SetTextColor(QR.Skin:TextAccent())
    f.title:SetShadowOffset(1, -1)
    f.title:SetShadowColor(0, 0, 0, 1)
end

--- ¿Esta la ventanita en la mitad derecha de la pantalla?
local function OnRightSide(f)
    local left, right = f:GetLeft(), f:GetRight()
    if not left or not right then
        local p = QR.db.activeFrames[f.pointKey]
        return p and p[1]:find("RIGHT") ~= nil
    end
    local scale = f:GetEffectiveScale() / UIParent:GetEffectiveScale()
    return (left + right) / 2 * scale > UIParent:GetWidth() / 2
end

--- Ancla la ventanita por el borde de su lado, para que al cambiar de tamaño crezca hacia el centro
local function AnchorToSide(f, right)
    local top = f:GetTop()
    local edge = right and f:GetRight() or f:GetLeft()
    if not top or not edge then return end
    f:ClearAllPoints()
    f:SetPoint(right and "TOPRIGHT" or "TOPLEFT", UIParent, "BOTTOMLEFT", edge, top)
    SavePoint(f, f.pointKey)
end

--- Botones en fila: en la mitad izquierda crecen hacia la derecha; en la derecha, hacia la izquierda.
--- (Solo fuera de combate: la ventanita tiene botones seguros)
local function Layout(f, count)
    local size = QR.db.activeFrames[f.sizeKey] or QR.db.activeFrames.size or 32
    local right = OnRightSide(f)
    AnchorToSide(f, right)
    -- titulo: arriba, abajo u oculto (cada ventanita por separado)
    local pos = QR.db.activeFrames[f.titleKey] or "TOP"
    local top = (pos == "TOP") and -16 or -6
    for i, b in ipairs(f.buttons) do
        b:SetSize(size, size)
        b:ClearAllPoints()
        local offset = 6 + (i - 1) * (size + 4)
        if right then
            b:SetPoint("TOPRIGHT", f, "TOPRIGHT", -offset, top)
        else
            b:SetPoint("TOPLEFT", f, "TOPLEFT", offset, top)
        end
    end
    f.title:ClearAllPoints()
    f.title:SetShown(pos ~= "HIDDEN")
    local v = (pos == "BOTTOM") and "BOTTOM" or "TOP"
    local y = (pos == "BOTTOM") and 5 or -5
    if right then
        f.title:SetPoint(v .. "RIGHT", -8, y)
        f.title:SetJustifyH("RIGHT")
    else
        f.title:SetPoint(v .. "LEFT", 8, y)
        f.title:SetJustifyH("LEFT")
    end
    f:SetSize(math.max(90, 12 + count * (size + 4) - 4), size + ((pos == "HIDDEN") and 12 or 22))
end

--- Aro redondeado (textura de aro de Fusion cortada en 9 partes); nil si el cliente no corta texturas
local function RoundRing(parent)
    local t = parent:CreateTexture(nil, "OVERLAY", nil, 1)
    t:SetTexture(QR.Skin.MEDIA .. "Textures\\RoundBorderRing.tga")
    if not (t.SetTextureSliceMargins and t.SetTextureSliceMode and Enum and Enum.UITextureSliceMode) then
        t:Hide()
        return nil
    end
    t:SetTextureSliceMargins(12, 12, 12, 12)
    t:SetTextureSliceMode(Enum.UITextureSliceMode.Stretched)
    t:SetPoint("TOPLEFT", -1, 1)
    t:SetPoint("BOTTOMRIGHT", 1, -1)
    return t
end

--- Quita la mascara redondeada de una textura (ventana Objetivo: imagenes cuadradas)
local function Unround(owner, tex)
    if tex and owner.qrMask and owner.qrMasked and owner.qrMasked[tex] then
        tex:RemoveMaskTexture(owner.qrMask)
        owner.qrMasked[tex] = nil
    end
end

--- Borde fino recto (4 lineas de 1 px) para los botones cuadrados
local function Edges(parent)
    local e = {}
    for i, pts in ipairs({ { "TOPLEFT", "TOPRIGHT" }, { "BOTTOMLEFT", "BOTTOMRIGHT" }, { "TOPLEFT", "BOTTOMLEFT" }, { "TOPRIGHT", "BOTTOMRIGHT" } }) do
        local t = parent:CreateTexture(nil, "OVERLAY", nil, 1)
        t:SetColorTexture(1, 1, 1, 1)
        t:SetPoint(pts[1])
        t:SetPoint(pts[2])
        if i <= 2 then t:SetHeight(1) else t:SetWidth(1) end
        e[i] = t
    end
    return e
end

local function ButtonVisuals(b)
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetAllPoints()
    b.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    b.hl = b:CreateTexture(nil, "HIGHLIGHT")
    b.hl:SetAllPoints()
    b.hl:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
    b.hl:SetBlendMode("ADD")
    b.border = b:CreateTexture(nil, "OVERLAY")
    b.border:SetPoint("TOPLEFT", -1, 1)
    b.border:SetPoint("BOTTOMRIGHT", 1, -1)
    b.border:SetColorTexture(0, 0, 0, 0)
    -- esquinas redondeadas como el resto de la skin: imagen y resaltado con la mascara redondeada,
    -- y un aro redondeado por encima de todo (cooldown y modelo 3D incluidos)
    QR.Skin:SetRounded(b, b.icon)
    QR.Skin:SetRounded(b, b.hl)
    b.ringFrame = CreateFrame("Frame", nil, b)
    b.ringFrame:SetAllPoints()
    b.ringFrame:SetFrameLevel(b:GetFrameLevel() + 5)
    b.ring = RoundRing(b.ringFrame)
    if b.ring then b.ring:SetVertexColor(0, 0, 0, 0.85) end
    if b.RegisterForClicks then b:RegisterForClicks("AnyUp", "AnyDown") end
end

---------------------------------------------------------------------------
-- Numero de paso en la esquina de los botones
---------------------------------------------------------------------------
--- Numero (como en la lista de pasos) del primer paso que incluye esa mision; nil si no esta
function Active:StepNumberFor(questId)
    local plan = QR.Planner:IsActive() and QR.Planner.plan
    if not plan or not questId then return nil end
    local h = QR.Steps.History(false)
    local count = h and h.count or 0
    for n, step in ipairs(plan.steps or {}) do
        for _, q in ipairs(step.questIds) do
            if q == questId then return count + n end
        end
    end
end

function Active:CurrentStepNumber()
    local plan = QR.Planner:IsActive() and QR.Planner.plan
    if not plan or not plan.currentStep then return nil end
    local h = QR.Steps.History(false)
    return (h and h.count or 0) + 1
end

--- Circulo oscuro con el numero, arriba a la izquierda del boton (por encima del cooldown)
local function StepBadge(b, number, size)
    if not b.stepFrame then
        b.stepFrame = CreateFrame("Frame", nil, b)
        b.stepFrame:SetFrameLevel(b:GetFrameLevel() + 9) -- por encima del aro
        b.stepBg = b.stepFrame:CreateTexture(nil, "ARTWORK")
        b.stepBg:SetTexture(QR.Skin.MEDIA .. "Textures\\SoftPanelCircle.tga")
        b.stepBg:SetAllPoints()
        b.stepText = b.stepFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        b.stepText:SetPoint("CENTER", 0, 0)
    end
    if not number then b.stepFrame:Hide() return end
    local d = math.max(11, math.floor(size * 0.40))
    b.stepFrame:SetSize(d, d)
    b.stepFrame:ClearAllPoints()
    -- dentro del circulo del boton (antes se salia por la esquina)
    b.stepFrame:SetPoint("TOPLEFT", b, "TOPLEFT", 0, 0)
    b.stepBg:SetVertexColor(0.05, 0.06, 0.06, 0.92)
    QR.Skin:StyleText(b.stepText, "small")
    local font, _, flags = b.stepText:GetFont()
    b.stepText:SetFont(font, math.max(8, d * 0.62), "OUTLINE")
    b.stepText:SetText(number)
    b.stepText:SetTextColor(QR.Skin:TextAccent())
    b.stepFrame:Show()
end

---------------------------------------------------------------------------
-- Objetos activos
---------------------------------------------------------------------------
local function CurrentQuestIds()
    local ids = {}
    local step = QR.Planner:IsActive() and QR.Planner.plan and QR.Planner.plan.currentStep
    if step then for _, q in ipairs(step.questIds) do ids[q] = 1 end end
    if QR.target and QR.target.questId then ids[QR.target.questId] = 1 end
    return ids
end

--- { id, name, texture, priority }
function Active:FindItems()
    local DB = QR.Bridge.QuestieDB
    local current = CurrentQuestIds()
    local wanted = {} -- itemId -> prioridad (1 = mision del paso actual)
    local questOf = {} -- itemId -> mision a la que pertenece
    local function want(id, prio, questId)
        if not wanted[id] or prio < wanted[id] then wanted[id], questOf[id] = prio, questId end
    end
    for questId in QR.Bridge:IterateActive() do
        local prio = current[questId] or 2
        local ok, src = pcall(DB.QueryQuestSingle, questId, "sourceItemId")
        if ok and type(src) == "number" and src > 0 then want(src, prio, questId) end
        local ok2, req = pcall(DB.QueryQuestSingle, questId, "requiredSourceItems")
        if ok2 and type(req) == "number" then req = { req } end
        for _, id in pairs((ok2 and type(req) == "table") and req or {}) do
            if type(id) == "number" then want(id, prio, questId) end
        end
    end
    local found, seen = {}, {}
    local first = _G.KEYRING_CONTAINER or _G.BACKPACK_CONTAINER or 0
    for bag = first, _G.NUM_BAG_FRAMES or 4 do
        for slot = 1, (GetContainerNumSlots(bag) or 0) do
            local id = GetContainerItemID(bag, slot)
            if id and not seen[id] then
                seen[id] = true
                local name, _, _, _, _, _, _, _, _, texture, _, classID = GetItemInfo(id)
                local usable = GetItemSpell(id) ~= nil
                if usable and (wanted[id] or classID == 12) then
                    found[#found + 1] = { id = id, name = name, texture = texture, priority = wanted[id] or 3, questId = questOf[id] }
                end
            end
        end
    end
    table.sort(found, function(a, b) if a.priority ~= b.priority then return a.priority < b.priority end return a.id < b.id end)
    while #found > MAX_ITEMS do table.remove(found) end
    return found
end

local function ItemButton(f, i)
    local b = f.buttons[i]
    if b then return b end
    b = CreateFrame("Button", "QuestieRouterActiveItem" .. i, f, "SecureActionButtonTemplate")
    ButtonVisuals(b)
    -- ventana Objetos: cuadrados como los de Objetivo (icono sin mascara redonda, sin aro, borde fino recto)
    Unround(b, b.icon)
    Unround(b, b.hl)
    if b.ring then b.ring:Hide() end
    b.edgeFrame = CreateFrame("Frame", nil, b)
    b.edgeFrame:SetAllPoints()
    b.edgeFrame:SetFrameLevel(b:GetFrameLevel() + 4)
    b.edges = Edges(b.edgeFrame)
    for _, t in ipairs(b.edges) do t:SetVertexColor(0.55, 0.58, 0.56, 0.9) end
    b:SetAttribute("type1", "item")
    b.count = b:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    b.count:SetPoint("BOTTOMRIGHT", -1, 1)
    b.cd = CreateFrame("Cooldown", nil, b, "CooldownFrameTemplate")
    b.cd:SetAllPoints()
    b:SetScript("OnEnter", function(self)
        if not self.itemId then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetItemByID(self.itemId)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    f.buttons[i] = b
    return b
end

function Active:UpdateItemCooldowns()
    for _, b in ipairs(self.items and self.items.buttons or {}) do
        if b:IsShown() and b.itemId then
            local start, duration, enable = GetItemCooldown(b.itemId)
            if start and duration and duration > 0 and enable ~= 0 then b.cd:SetCooldown(start, duration) else b.cd:Clear() end
            local n = GetItemCount(b.itemId) or 0
            b.count:SetText(n > 1 and n or "")
        end
    end
end

function Active:UpdateItems()
    local f = self.items
    local list = QR.db.activeFrames.items and QR.db.enabled and self:FindItems() or {}
    for i, item in ipairs(list) do
        local b = ItemButton(f, i)
        b.itemId = item.id
        b:SetAttribute("item1", "item:" .. item.id)
        b.icon:SetTexture(item.texture or 134400)
        local num = QR.db.activeFrames.itemsBadge ~= "NONE" and self:StepNumberFor(item.questId) or nil
        StepBadge(b, num, QR.db.activeFrames.itemsSize or 32)
        b:Show()
    end
    for i = #list + 1, #f.buttons do
        f.buttons[i]:Hide()
        f.buttons[i].itemId = nil
    end
    Layout(f, #list)
    PaintContainer(f)
    f:SetShown(#list > 0)
    self:UpdateItemCooldowns()
end

---------------------------------------------------------------------------
-- Objetivo activo
---------------------------------------------------------------------------
--- Un boton por objetivo del paso actual (no por NPC):
---   matar   -> los nombres del bicho (normalmente uno)
---   objeto  -> todos los que lo sueltan, en un solo boton con el icono del objeto
---   NPC     -> a quien coger / entregar
--- entry = { key, names = {...}, name, npcId, itemId, kind = "kill" | "loot" | "friendly", verb, action }
local MAX_ENTRIES = 6

function Active:FindTargets()
    local entries, seenKey = {}, {}
    if QR.target and QR.target.kind == "corpse" then return entries end
    local function push(e)
        if #entries >= MAX_ENTRIES or seenKey[e.key] or #e.names == 0 then return end
        seenKey[e.key] = true
        e.name = e.names[1]
        entries[#entries + 1] = e
    end
    local step = QR.Planner:IsActive() and QR.Planner.plan and QR.Planner.plan.currentStep
    local questId = step and step.kind == "objective" and step.questIds[1]
        or (not step and QR.target and not QR.target.isTurnIn and QR.target.questId)
    if questId then
        local quest = QR.Bridge:GetQuest(questId)
        for idx, o in pairs(quest and quest.Objectives or {}) do
            local done = o.Completed == true or (o.Needed and o.Collected and o.Needed == o.Collected)
            -- "object" son objetos del mundo: no se pueden seleccionar
            if not done and o.Type ~= "object" then
                local hostile, vendors, seenName = {}, {}, {}
                local firstNpc, firstVendor
                for _, sd in pairs(o.spawnList or {}) do
                    -- TooltipKey de Questie: "m_<id>" NPC, "o_<id>" objeto del mundo
                    local npcId = type(sd.TooltipKey) == "string" and tonumber(sd.TooltipKey:match("^m_(%d+)"))
                    if npcId and sd.Name and not seenName[sd.Name] then
                        seenName[sd.Name] = true
                        if o.Type == "item" and not sd.Hostile then
                            vendors[#vendors + 1] = sd.Name
                            firstVendor = firstVendor or npcId
                        else
                            hostile[#hostile + 1] = sd.Name
                            firstNpc = firstNpc or npcId
                        end
                    end
                end
                table.sort(hostile)
                local itemId = o.Type == "item" and o.Id or nil
                if itemId then
                    if #hostile > 0 then
                        push({ key = "loot" .. itemId, names = hostile, npcId = firstNpc, itemId = itemId, kind = "loot", verb = L["Dropped by"] })
                    elseif #vendors > 0 then
                        push({ key = "buy" .. itemId, names = vendors, npcId = firstVendor, itemId = itemId, kind = "friendly", verb = L["Sold by"] })
                    end
                else
                    push({ key = "kill" .. questId .. ":" .. idx, names = hostile, npcId = firstNpc, kind = "kill", verb = L["Kill"] })
                end
            end
        end
    end
    if step and step.kind ~= "objective" and step.npc then
        push({ key = "npc" .. step.npc, names = { step.npc }, npcId = step.npcId, kind = "friendly",
            verb = step.kind == "pickup" and L["Pick up quests"] or L["Turn in"], action = step.kind })
    elseif not step and QR.target and QR.target.isTurnIn and QR.target.name then
        push({ key = "npc" .. QR.target.name, names = { QR.target.name }, npcId = QR.target.npcId, kind = "friendly",
            verb = L["Turn in"], action = "turnin" })
    end
    return entries
end

local GetItemIcon = (C_Item and C_Item.GetItemIconByID) or _G.GetItemIcon


-- Marca encima del objetivo al seleccionarlo desde la ventanita. SetRaidTarget() esta protegida en WoW Forever:
-- se usa el comando de macro /tm dentro de la macro segura del boton. Cada boton tiene su icono (1 estrella,
-- 2 circulo, 3 rombo, 4 triangulo, 5 luna, 6 cuadrado, 7 cruz, 8 calavera): si marcas a otro, lleva otro icono
-- y el anterior conserva el suyo; volver a pulsar el mismo boton no lo cambia.
local function MarkLine(slot)
    if QR.db.activeFrames.markTarget == false then return "" end
    -- /tm quita la marca si ya tiene ese mismo icono: primero se limpia (/tm 0) y luego se pone, asi se queda
    -- puesta por mas veces que se pulse el boton
    return "\n/tm 0\n/tm " .. ((slot - 1) % 8 + 1)
end

--- Macro para pasar al SIGUIENTE bicho con ese nombre (sin /cleartarget: /targetexact con un objetivo del
--- mismo nombre ya seleccionado salta al siguiente). Se usa cuando el seleccionado ya lo ha tocado otro
--- jugador que no esta en tu grupo (no te daria credito).
local function CycleMacro(name, slot, spell)
    local m = "/targetexact " .. name .. "\n/targetexact [dead] " .. name .. "\n/targetexact [dead] " .. name
        .. "\n/cleartarget [dead]" .. MarkLine(slot)
    if spell then m = m .. "\n/cast " .. spell end
    return m
end

local function GetSpellName(id)
        if C_Spell and C_Spell.GetSpellName then return C_Spell.GetSpellName(id) end
        if GetSpellInfo then return (GetSpellInfo(id)) end
    end
local function GetSpellIcon(id)
        if C_Spell and C_Spell.GetSpellTexture then return C_Spell.GetSpellTexture(id) end
        if GetSpellInfo then return (select(3, GetSpellInfo(id))) end
    end

--- Habilidad del clic derecho sobre enemigos (por personaje): nombre o nil
function Active:TargetSpellName()
    local id = QR.charDB.targetSpell
    return id and GetSpellName(id) or nil
end

-- Retratos 2D por nombre: se crean al ver al bicho (seleccion / raton) y se reutilizan
local portraitHolder = CreateFrame("Frame")
portraitHolder:Hide()
local portraits = {}

---------------------------------------------------------------------------
-- Retratos 2D de bichos que aun no has visto: un modelo oculto carga al NPC por su ID, nos dice que
-- modelo usa (GetDisplayInfo) y SetPortraitTextureFromCreatureDisplayID pinta su retrato 2D.
-- Uno a uno en segundo plano; se recuerdan durante la sesion.
---------------------------------------------------------------------------
local displayOf = {}      -- npcId -> displayId (false si no se pudo; se vuelve a intentar pasado un rato)
local failedAt = {}       -- npcId -> GetTime() del ultimo intento fallido
local RETRY_AFTER = 20    -- segundos: un NPC que no estaba en la cache del juego se reintenta (quiza ya lo has visto)

--- Modelo (displayId) de un NPC: el de esta sesion o el guardado (QuestieRouterDB.npcDisplay). Con el
--- displayId el modelo carga siempre, aunque el NPC no este en la cache del juego (lejos, tras /reload...)
-- Version de la cache guardada: las versiones anteriores podian guardar el modelo del NPC anterior
-- (GetDisplayInfo devolvia el modelo viejo cuando el nuevo no estaba en la cache del juego). Al subirla
-- se descarta lo guardado y se vuelve a aprender bien.
local NPC_DISPLAY_VERSION = 2

local function SavedDisplays()
    local db = QR.db
    if db.npcDisplayVersion ~= NPC_DISPLAY_VERSION then
        db.npcDisplay = {}
        db.npcDisplayVersion = NPC_DISPLAY_VERSION
    end
    db.npcDisplay = db.npcDisplay or {}
    return db.npcDisplay
end

--- displayId que muestra ahora un modelo (0 si ninguno)
local function CurrentDisplay(m)
    local ok, d = pcall(m.GetDisplayInfo, m)
    return (ok and type(d) == "number") and d or 0
end

--- Orden: lo aprendido del propio juego (esta sesion o guardado; manda, por si el servidor usa otro modelo)
--- y si no, la tabla incluida en el addon (Data/NpcDisplays.lua, sacada de las bases de datos de servidor
--- como hacen Wowhead / wow.tools). Con la tabla, el retrato y el 3D salen aunque el NPC no se haya visto nunca.
local function KnownDisplay(npcId)
    if not npcId then return nil end
    local d = displayOf[npcId]
    if d then return d end
    d = SavedDisplays()[npcId] or (QR.NpcDisplays and QR.NpcDisplays[npcId])
    if d then displayOf[npcId] = d end
    return d
end

local function RememberDisplay(npcId, d)
    if not (npcId and type(d) == "number" and d > 0) then return end
    displayOf[npcId] = d
    -- solo se guarda lo que no dice ya la tabla del addon (no llenar las SavedVariables)
    local static = QR.NpcDisplays and QR.NpcDisplays[npcId]
    SavedDisplays()[npcId] = (d ~= static) and d or nil
end
local npcPortraits = {}   -- npcId -> textura con su retrato 2D
local displayQueue, loading = {}, nil
local loader
local canDisplayPortrait = type(SetPortraitTextureFromCreatureDisplayID) == "function"

local function EnsureLoader()
    if loader or not canDisplayPortrait then return loader end
    local ok, m = pcall(CreateFrame, "PlayerModel", nil, UIParent)
    if not ok or not m or not m.GetDisplayInfo or not m.SetCreature then canDisplayPortrait = false return nil end
    m:SetSize(64, 64)
    m:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -2000, 2000) -- fuera de la pantalla
    m:Show()
    loader = m
    return m
end

local ProcessDisplayQueue

local function FinishLoad(npcId, displayId)
    if displayId and displayId > 0 then RememberDisplay(npcId, displayId) else displayOf[npcId] = false; failedAt[npcId] = GetTime() end
    if displayId and displayId > 0 then
        local tex = npcPortraits[npcId]
        if not tex then
            tex = portraitHolder:CreateTexture(nil, "ARTWORK")
            npcPortraits[npcId] = tex
        end
        SetPortraitTextureFromCreatureDisplayID(tex, displayId)
        -- si el modelo aun no estaba del todo cargado el retrato sale verde: repetirlo un poco despues
        for _, delay in ipairs({ 0.5, 1.5, 3 }) do
            C_Timer.After(delay, function() SetPortraitTextureFromCreatureDisplayID(tex, displayId) end)
        end
        if Active.targets then
            for _, b in ipairs(Active.targets.buttons) do
                if b:IsShown() and b.entry and b.entry.npcId == npcId and b.ApplyPortrait then b:ApplyPortrait() end
            end
        end
    end
    loading = nil
    ProcessDisplayQueue()
end

ProcessDisplayQueue = function()
    if loading or #displayQueue == 0 then return end
    local m = EnsureLoader()
    if not m then return end
    local npcId = table.remove(displayQueue, 1)
    if displayOf[npcId] then return ProcessDisplayQueue() end
    loading = npcId
    if m.ClearModel then m:ClearModel() end
    -- ClearModel no siempre pone GetDisplayInfo a 0: si el NPC nuevo no esta en la cache del juego,
    -- SetCreature no carga nada y GetDisplayInfo seguiria dando el modelo del NPC anterior
    -- (salia el retrato de otro bicho). Solo vale un displayId distinto del que habia antes.
    local before = CurrentDisplay(m)
    if not pcall(m.SetCreature, m, npcId) then return FinishLoad(npcId, nil) end
    -- el modelo carga de forma asincrona: comprobar unas cuantas veces
    local tries = 0
    local function check()
        if loading ~= npcId then return end
        local d = CurrentDisplay(m)
        if d > 0 and d ~= before then return FinishLoad(npcId, d) end
        tries = tries + 1
        if tries > 20 then return FinishLoad(npcId, nil) end
        C_Timer.After(0.1, check)
    end
    check()
end

--- Pide el retrato 2D de un NPC por su ID (si el cliente lo permite). Tambien sirve para saber su modelo 3D.
local function RequestNpcPortrait(npcId)
    if not npcId or not canDisplayPortrait or npcPortraits[npcId] then return end
    local known = KnownDisplay(npcId)
    if known then return FinishLoad(npcId, known) end
    if displayOf[npcId] == false and GetTime() - (failedAt[npcId] or 0) < RETRY_AFTER then return end
    if loading == npcId then return end
    displayOf[npcId] = nil
    for _, q in ipairs(displayQueue) do if q == npcId then return end end
    displayQueue[#displayQueue + 1] = npcId
    ProcessDisplayQueue()
end

--- Al seleccionar / pasar el raton por un NPC de la ventana: su modelo real sale del propio juego (SetUnit).
--- Si no coincide con el de la tabla (el servidor puede usar otro), se guarda y se repintan 2D y 3D.
local unitProbe
local function LearnFromUnit(unit, npcId)
    if not (npcId and canDisplayPortrait) then return end
    if not unitProbe then
        local ok, m = pcall(CreateFrame, "PlayerModel", nil, UIParent)
        if not ok or not m or not m.SetUnit then return end
        m:SetSize(64, 64)
        m:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -2000, 2000) -- fuera de la pantalla
        m:Show()
        unitProbe = m
    end
    if unitProbe.ClearModel then unitProbe:ClearModel() end
    local before = CurrentDisplay(unitProbe)
    if not pcall(unitProbe.SetUnit, unitProbe, unit) then return end
    local d = CurrentDisplay(unitProbe)
    if d <= 0 or d == before or d == KnownDisplay(npcId) then return end
    RememberDisplay(npcId, d)
    -- repintar el retrato 2D con el modelo bueno
    if npcPortraits[npcId] then SetPortraitTextureFromCreatureDisplayID(npcPortraits[npcId], d) end
    if Active.targets then
        for _, b in ipairs(Active.targets.buttons) do
            if b.entry and b.entry.npcId == npcId then b.modelNpc = nil end
        end
    end
    Active:RequestUpdate()
end

local function TargetButton(f, i)
    local b = f.buttons[i]
    if b then return b end
    b = CreateFrame("Button", "QuestieRouterActiveTarget" .. i, f, "SecureActionButtonTemplate")
    ButtonVisuals(b)
    -- ventana Objetivo: imagenes cuadradas (2D y 3D), borde fino recto
    Unround(b, b.icon)
    Unround(b, b.hl)
    b:SetAttribute("type", "macro")
    -- modelo 3D opcional (Opciones / menu)
    local okModel, model = pcall(CreateFrame, "PlayerModel", nil, b)
    if okModel and model then
        model:SetPoint("TOPLEFT", 1, -1)
        model:SetPoint("BOTTOMRIGHT", -1, 1)
        model:Hide()
        b.model = model
        -- Lejos (otro continente, NPC sin ver) GetDisplayInfo ya da el modelo pero aun no se dibuja nada:
        -- el 3D solo tapa al 2D cuando el juego avisa de que ha terminado de cargar (OnModelLoaded).
        -- Si el cliente no tiene ese aviso, se sigue fiando de GetDisplayInfo como antes.
        if model.HasScript and model:HasScript("OnModelLoaded") then
            b.modelEvents = true
            model:SetScript("OnModelLoaded", function(self)
                local npcId = b.modelNpc
                if not npcId then return end
                b.modelReady = npcId
                -- solo texturas / transparencia (sin atributos seguros): vale tambien en combate
                if self:IsShown() and b.entry and b.entry.npcId == npcId and QR.db.activeFrames.portrait3d then
                    local d = CurrentDisplay(self)
                    if d > 0 and d ~= b.modelStale then
                        RememberDisplay(npcId, d)
                        self:SetAlpha(1)
                        b.icon:Hide()
                        if b.portrait then b.portrait:Hide() end
                    end
                end
            end)
        end
    end
    -- capa superior (por encima del modelo): retrato 2D, insignia y borde fino
    b.top = CreateFrame("Frame", nil, b)
    b.top:SetAllPoints()
    b.top:SetFrameLevel(b:GetFrameLevel() + 3)
    -- la insignia va por delante del aro (capa propia por encima) y asoma un poco por la esquina
    b.badgeFrame = CreateFrame("Frame", nil, b)
    b.badgeFrame:SetAllPoints()
    b.badgeFrame:SetFrameLevel(b:GetFrameLevel() + 8)
    b.badge = b.badgeFrame:CreateTexture(nil, "OVERLAY", nil, 2)
    b.badge:SetPoint("BOTTOMRIGHT", 3, -3)
    b.edges = Edges(b.top)
    if b.ring then
        for _, t in ipairs(b.edges) do t:Hide() end
        b.ringFrame:SetFrameLevel(b.top:GetFrameLevel() + 1)
    end
    -- Tapa de esquinas para el modelo 3D: WoW no deja recortar modelos con mascaras, asi que encima
    -- se pone la mascara redondeada invertida (centro transparente, esquinas opacas) del color del
    -- fondo de la ventanita: lo que sobresale del circulo queda tapado.
    b.cover = b.ringFrame:CreateTexture(nil, "OVERLAY", nil, 0)
    b.cover:SetTexture(QR.Skin.MEDIA .. "Textures\\RoundCornerCover.tga")
    if b.cover.SetTextureSliceMargins and Enum and Enum.UITextureSliceMode then
        b.cover:SetTextureSliceMargins(10, 10, 10, 10)
        b.cover:SetTextureSliceMode(Enum.UITextureSliceMode.Stretched)
    end
    b.cover:SetAllPoints()
    b.cover:Hide()
    b:SetScript("OnEnter", function(self)
        local e = self.entry
        if not e then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        local fr = e.kind == "friendly"
        local item = e.itemId and GetItemInfo(e.itemId)
        GameTooltip:AddLine(item or e.name, fr and 0.44 or 1, fr and 0.84 or 0.5, fr and 0.64 or 0.47)
        GameTooltip:AddLine(e.verb .. ":", 1, 1, 1)
        for _, n in ipairs(e.names) do GameTooltip:AddLine("  " .. n, 0.85, 0.85, 0.85) end
        GameTooltip:AddLine(QR.db.activeFrames.markTarget ~= false and L["Left-click: target and mark"] or L["Left-click: target"], 0.6, 0.6, 0.6)
        if e.kind ~= "friendly" then   -- con un NPC, el clic derecho hace lo mismo que el izquierdo
            local spell = Active:TargetSpellName()
            GameTooltip:AddLine(spell and string.format(L["Right-click: %s"], spell) or L["Right-click: choose an ability in Options"], 0.6, 0.6, 0.6)
            GameTooltip:AddLine(L["Tagged by someone else: click again for another one"], 0.6, 0.6, 0.6)
        end
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    -- Antes del clic (solo fuera de combate, cuando los botones seguros se pueden cambiar): si tu objetivo es
    -- uno de los bichos del boton pero ya es de otro (UnitIsTapDenied), este clic pasa al siguiente en vez de
    -- volver a seleccionar el mas cercano (que seria el mismo).
    b:SetScript("PreClick", function(self, button)
        if InCombatLockdown() then return end
        local e = self.entry
        if not e or e.kind == "friendly" or not self.macro1 then return end
        local right = button == "RightButton"
        local attr = right and "macrotext2" or "macrotext1"
        local m = right and self.macro2 or self.macro1
        if UnitExists("target") and UnitIsTapDenied and UnitIsTapDenied("target") and not UnitIsDead("target") then
            local name = UnitName("target")
            for _, n in ipairs(e.names) do
                if n == name then
                    m = CycleMacro(n, self.slot or 1, right and Active:TargetSpellName() or nil)
                    break
                end
            end
        end
        if self:GetAttribute(attr) ~= m then self:SetAttribute(attr, m) end
    end)
    b.slot = i
    f.buttons[i] = b
    return b
end

local function ReleasePortrait(b)
    local tex = b.portrait
    if tex and b.top and b.top.qrMasked and b.top.qrMasked[tex] then
        tex:RemoveMaskTexture(b.top.qrMask)
        b.top.qrMasked[tex] = nil
    end
    if b.portrait and b.portrait.qrOwner == b then
        b.portrait:Hide()
        b.portrait:SetParent(portraitHolder)
        b.portrait.qrOwner = nil
    end
    b.portrait = nil
end

--- Pone el retrato 2D guardado de alguno de los nombres del boton (si ya se ha visto)
local function ApplyPortrait(b)
    local e = b.entry
    if not e or e.kind == "loot" or (QR.db.activeFrames.portrait3d and b.model and b.model:IsShown() and b.model:GetAlpha() > 0.5) then return end
    local candidates = {}
    for _, n in ipairs(e.names) do if portraits[n] then candidates[#candidates + 1] = portraits[n] end end
    if e.npcId and npcPortraits[e.npcId] then candidates[#candidates + 1] = npcPortraits[e.npcId] end
    for _, tex in ipairs(candidates) do
        if tex then
            if b.portrait ~= tex then
                ReleasePortrait(b)
                if tex.qrOwner and tex.qrOwner ~= b then tex.qrOwner.portrait = nil end
                tex:SetParent(b.top)
                tex:ClearAllPoints()
                tex:SetPoint("TOPLEFT", 1, -1)
                tex:SetPoint("BOTTOMRIGHT", -1, 1)
                tex:SetDrawLayer("ARTWORK")
                tex.qrOwner = b
                b.portrait = tex
                Unround(b.top, tex)
            end
            -- el retrato 2D de Blizzard ya viene en circulo dentro de la textura: se recorta al cuadrado
            -- inscrito (lado = 1/√2 ≈ 0.707 del total) para que llene el marco cuadrado sin esquinas vacias
            tex:SetTexCoord(0.15, 0.85, 0.15, 0.85)
            tex:Show()
            b.icon:Hide()
            return
        end
    end
end

local function PaintTargetButton(b, e)
    local fr = e.kind == "friendly"
    b.ApplyPortrait = ApplyPortrait
    -- (tambien en modo 3D: asi se aprende su modelo y luego carga aunque el NPC este lejos)
    if e.kind ~= "loot" then RequestNpcPortrait(e.npcId) end
    if b.entry and b.entry.key ~= e.key then ReleasePortrait(b) end
    b.entry = e
    b.targetName = e.name
    -- un clic selecciona a cualquiera de los nombres (cada /targetexact que encuentre lo selecciona)
    -- solo vivos: si el seleccionado esta muerto, /targetexact [dead] vuelve a buscar con ese nombre (pasa al
    -- siguiente); los nombres siguientes solo se prueban si aun no hay objetivo vivo; al final, si sigue muerto,
    -- se deselecciona (asi la marca y la habilidad no van a un cadaver)
    local macro = "/cleartarget"
    for i, n in ipairs(e.names) do
        local lines = (i == 1) and ("\n/targetexact " .. n .. "\n/targetexact [dead] " .. n .. "\n/targetexact [dead] " .. n)
            or ("\n/targetexact [noexists][dead] " .. n .. "\n/targetexact [dead] " .. n)
        if #macro + #lines > 210 then break end
        macro = macro .. lines
    end
    macro = macro .. "\n/cleartarget [dead]"
    -- marca encima (/tm con el icono de este boton), justo despues de seleccionar
    macro = macro .. MarkLine(b.slot or 1)
    -- clic izquierdo: seleccionar (y marcar)
    b:SetAttribute("type1", "macro")
    b:SetAttribute("macrotext1", macro)
    -- clic derecho: NPC -> lo mismo que el izquierdo (seleccionar; hablar desde un addon no esta permitido);
    -- enemigo -> seleccionar y lanzar la habilidad elegida
    local right = macro
    if not fr then
        local spell = Active:TargetSpellName()
        if spell then right = macro .. "\n/cast " .. spell end
    end
    b:SetAttribute("type2", "macro")
    b:SetAttribute("macrotext2", right)
    b.macro1, b.macro2 = macro, right   -- las normales (el PreClick las cambia si el bicho ya es de otro)

    -- imagen principal: icono del objeto (nitido) / retrato 2D si ya se vio / icono de espera
    b.icon:Show()
    if e.itemId and GetItemIcon and GetItemIcon(e.itemId) then
        b.icon:SetTexture(GetItemIcon(e.itemId))
        b.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    else
        b.icon:SetTexture(fr and FRIENDLY_PLACEHOLDER or ENEMY_PLACEHOLDER)
        b.icon:SetTexCoord(0, 1, 0, 1)
    end
    -- modelo 3D solo si se ha elegido y no es un objeto
    local use3d = QR.db.activeFrames.portrait3d and b.model and e.npcId and e.kind ~= "loot"
    local loaded = false
    if b.model then
        if use3d then
            if b.modelNpc ~= e.npcId then
                if b.model.ClearModel then b.model:ClearModel() end
                -- antes de poner el nuevo: OnModelLoaded puede llegar al instante si ya estaba cargado
                b.modelReady = nil
                b.modelNpc = e.npcId
                -- con el modelo conocido carga siempre; si no, por el NPC (solo si esta en la cache del juego)
                local disp = KnownDisplay(e.npcId)
                if disp and b.model.SetDisplayInfo then
                    pcall(b.model.SetDisplayInfo, b.model, disp)
                    b.modelStale = nil
                else
                    -- lo que mostraba antes: si GetDisplayInfo sigue dando eso, el NPC nuevo no ha cargado
                    -- (en un reintento del mismo NPC se conserva el valor viejo: el modelo pudo cargar ya bien)
                    if b.modelRetryNpc ~= e.npcId then b.modelStale = CurrentDisplay(b.model) end
                    b.modelRetryNpc = nil
                    pcall(b.model.SetCreature, b.model, e.npcId)
                end
                if b.model.SetPortraitZoom then b.model:SetPortraitZoom(1) end
                b.modelNpc = e.npcId
            end
            local d = CurrentDisplay(b.model)
            local known = d > 0 and d ~= b.modelStale
            if known then RememberDisplay(e.npcId, d) end
            -- con aviso de carga: el 3D solo se ve cuando ha llegado OnModelLoaded; mientras, el 2D
            loaded = known and (not b.modelEvents or b.modelReady == e.npcId)
            if not loaded and not b.modelRetry then
                -- aun no carga (NPC fuera de la cache o modelo lejano): se ve el 2D y se reintenta en un rato
                b.modelRetry = true
                local npcId = e.npcId
                C_Timer.After(3, function()
                    b.modelRetry = nil
                    if b.entry and b.entry.npcId == npcId and not (b.model:GetAlpha() > 0.5) then
                        -- si ya se sabe su modelo y solo falta que termine de dibujarse, no se reinicia
                        -- la carga (se espera a OnModelLoaded); si ni eso, se vuelve a pedir el NPC
                        local cur = CurrentDisplay(b.model)
                        if cur > 0 and cur ~= b.modelStale and b.modelEvents then return end
                        b.modelRetryNpc = b.modelNpc
                        b.modelNpc = nil
                        Active:RequestUpdate()
                    end
                end)
            end
        end
        -- el modelo se queda puesto (invisible mientras carga) para que pueda terminar de cargar
        b.model:SetShown(use3d and true or false)
        b.model:SetAlpha(loaded and 1 or 0)
    end
    if loaded then
        b.icon:Hide()
        if b.portrait then b.portrait:Hide() end
    else
        ApplyPortrait(b)
    end
    -- con modelo 3D el boton es cuadrado (los modelos no se pueden recortar en circulo):
    -- borde fino recto en vez del aro redondeado
    -- siempre cuadrado, tambien el retrato 2D (antes 2D iba en circulo y no siempre se recortaba)
    b.square = true
    if b.cover then b.cover:Hide() end

    -- borde fino: rojo enemigo, verde amistoso
    -- aro redondeado (2D) o borde fino recto (3D, o si el cliente no permite el aro):
    -- rojo enemigo, verde amistoso
    local er, eg, eb = fr and 0.44 or 0.95, fr and 0.84 or 0.38, fr and 0.64 or 0.32
    local useRing = b.ring and not b.square
    if b.ring then b.ring:SetShown(useRing and true or false) end
    for _, t in ipairs(b.edges) do
        t:SetShown(not useRing)
        t:SetVertexColor(er, eg, eb, 0.9)
    end
    if useRing then b.ring:SetVertexColor(er, eg, eb, 0.95) end
    -- insignia: espada (matar) o coger / entregar; los objetos ya llevan su icono como imagen
    local mode = QR.db.activeFrames.targetsBadge or "STEP"
    local bsize = QR.db.activeFrames.targetsSize or 32
    -- numero de paso solo en los objetivos de matar / conseguir; el NPC de coger / entregar no lo lleva
    StepBadge(b, (mode == "STEP" and e.kind ~= "friendly") and Active:CurrentStepNumber() or nil, bsize)
    local badge
    if mode == "ICON" then
        if e.kind == "kill" then badge = QR.Skin.ICON.combat
        elseif e.action == "pickup" then badge = QR.Skin.ICON.accept
        elseif e.action == "turnin" then badge = QR.Skin.ICON.turnin end
    end
    local size = math.floor(bsize * 0.55)
    b.badge:SetSize(size, size)
    b.badge:SetTexture(badge)
    b.badge:SetShown(badge ~= nil)
end

function Active:UpdateTargets()
    local f = self.targets
    local entries = (QR.db.activeFrames.targets and QR.db.enabled) and self:FindTargets() or {}
    for i, e in ipairs(entries) do
        local b = TargetButton(f, i)
        PaintTargetButton(b, e)
        b:Show()
    end
    for k = #entries + 1, #f.buttons do
        local b = f.buttons[k]
        ReleasePortrait(b)
        b:Hide()
        b.targetName, b.entry = nil, nil
    end
    Layout(f, #entries)
    PaintContainer(f)
    f:SetShown(#entries > 0)
end

--- Al seleccionar o pasar el raton por un bicho de la lista: guardar su retrato 2D
--- (solo texturas: se puede tambien en combate)
function Active:PortraitFor(unit)
    local name = UnitExists(unit) and UnitName(unit)
    if not name then return end
    local wanted = false
    -- ID del NPC por su GUID ("Creature-0-...-<npcId>-..."): si es el de un boton, aprender su modelo real
    local guid = UnitGUID and UnitGUID(unit)
    local unitNpc = guid and tonumber(guid:match("^%a+%-%d+%-%d+%-%d+%-%d+%-(%d+)%-"))
    for _, b in ipairs(self.targets.buttons) do
        if b:IsShown() and b.entry and b.entry.kind ~= "loot" then
            for _, n in ipairs(b.entry.names) do if n == name then wanted = true end end
            if unitNpc and b.entry.npcId == unitNpc then LearnFromUnit(unit, unitNpc) end
        end
    end
    if not wanted then return end
    local tex = portraits[name]
    if not tex then
        tex = portraitHolder:CreateTexture(nil, "ARTWORK")
        portraits[name] = tex
    end
    SetPortraitTexture(tex, unit)
    for _, b in ipairs(self.targets.buttons) do
        if b:IsShown() then ApplyPortrait(b) end
    end
end

---------------------------------------------------------------------------
-- Actualizacion (respetando el combate)
---------------------------------------------------------------------------
function Active:Update()
    if InCombatLockdown() then
        self.pending = true
        return
    end
    self.pending = nil
    self:UpdateItems()
    self:UpdateTargets()
end

function Active:RequestUpdate()
    if self.queued then return end
    self.queued = true
    C_Timer.After(0.3, function()
        Active.queued = nil
        Active:Update()
    end)
end

function Active:Init()
    self.items = CreateContainer("QuestieRouterActiveItems", L["ITEMS"], "itemsPoint", "itemsSize")
    self.targets = CreateContainer("QuestieRouterActiveTargets", L["TARGET"], "targetsPoint", "targetsSize")
    local ev = CreateFrame("Frame")
    for _, e in ipairs({ "BAG_UPDATE_DELAYED", "QUEST_LOG_UPDATE", "PLAYER_REGEN_ENABLED", "BAG_UPDATE_COOLDOWN",
                         "PLAYER_TARGET_CHANGED", "UPDATE_MOUSEOVER_UNIT", "GET_ITEM_INFO_RECEIVED" }) do
        pcall(ev.RegisterEvent, ev, e)
    end
    ev:SetScript("OnEvent", function(_, event)
        if event == "BAG_UPDATE_COOLDOWN" then
            Active:UpdateItemCooldowns()
        elseif event == "PLAYER_TARGET_CHANGED" then
            Active:PortraitFor("target")
        elseif event == "UPDATE_MOUSEOVER_UNIT" then
            Active:PortraitFor("mouseover")
        elseif event == "PLAYER_REGEN_ENABLED" then
            for _, c in ipairs({ Active.items, Active.targets }) do
                if c.qrStopPending then
                    c.qrStopPending = nil
                    c:StopMovingOrSizing()
                    SavePoint(c, c.pointKey)
                    Active.pending = true
                end
            end
            if Active.pending then Active:Update() end
        else
            Active:RequestUpdate()
        end
    end)
    QR:On("TARGET_CHANGED", function() Active:RequestUpdate() end)
    QR:On("PLAN_UPDATED", function() Active:RequestUpdate() end)
    QR:On("SETTINGS_CHANGED", function() Active:RequestUpdate() end)
    QR:On("SKIN_CHANGED", function()
        if Active.items:IsShown() then PaintContainer(Active.items) end
        if Active.targets:IsShown() then PaintContainer(Active.targets) end
    end)
    self:Update()
end

QR:RegisterModule("ActiveFrames", function() Active:Init() end)

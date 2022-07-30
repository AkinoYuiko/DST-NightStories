local AddAction = AddAction
local AddComponentAction = AddComponentAction
local AddStategraphActionHandler = AddStategraphActionHandler
GLOBAL.setfenv(1, GLOBAL)

local UpvalueUtil = GlassicAPI.UpvalueUtil

local blink_strfn = ACTIONS.BLINK.strfn
ACTIONS.BLINK.strfn = function(act)
    local blinkstaff = act.invobject == nil or act.invobject.prefab == "orangestaff"
    local doer = act.doer
    if blinkstaff and doer and doer.prefab == "miotan" and doer:HasTag("mio_boosted_task") then
        if doer.replica.inventory:Has("nightmarefuel", 1) then return "FUEL" end
    end
    return blink_strfn(act)
end

NS_ACTIONS = {
    GEMTRADE = Action({priority = 3, mount_valid = true}),
    MIOFUEL = Action({priority = 3, mount_valid = true}),
    NIGHTSWITCH = Action({priority = 1, mount_valid = true}),
    NIGHTSWORD = Action({priority = 2, mount_valid = true}),
    FUELPOCKETWATCH = Action({priority = 3, rmb = true}),
    FRIENDSHIPTOTEM = Action({priority = 3, rmb = true}),
}

NS_ACTIONS.GEMTRADE.str = STRINGS.ACTIONS.GIVE.SOCKET
NS_ACTIONS.NIGHTSWITCH.str = STRINGS.ACTIONS.USEITEM
NS_ACTIONS.NIGHTSWORD.str = STRINGS.ACTIONS.GIVE.SOCKET
NS_ACTIONS.FRIENDSHIPTOTEM.str = STRINGS.ACTIONS.GIVE.SOCKET
NS_ACTIONS.FUELPOCKETWATCH.str = STRINGS.ACTIONS.FUELPOCKETWATCH

NS_ACTIONS.MIOFUEL.stroverridefn = function(act)
    if act.invobject then
        return act.invobject:GetIsWet() and STRINGS.ACTIONS.ADDWETFUEL or STRINGS.ACTIONS.ADDFUEL
    end
end

local GEM_MAP = {
    nightmarefuel = "fuel",
    redgem = "red",
    bluegem = "blue",
    purplegem = "purple",
    yellowgem = "yellow",
    orangegem = "orange",
    greengem = "green",
    opalpreciousgem = "opal",
}
NS_ACTIONS.GEMTRADE.fn = function(act)
    local doer = act.doer
    local target = act.target
    if doer.components.inventory then
        local item = doer.components.inventory:RemoveItem(act.invobject)
        if target.OnGemTrade then
            local gem_type = GEM_MAP[item.prefab]
            if gem_type then
                target:OnGemTrade(gem_type, doer.prefab == "dummy")
            end
        end
        item:Remove()
        return true
    end
end

NS_ACTIONS.NIGHTSWITCH.fn = function(act)
    local doer = act.doer
    local level = doer.level
    if doer.components.inventory then
        local item = doer.components.inventory:RemoveItem(act.invobject)
        if item.prefab == "darkcrystal" then
            doer.level = level + 1
            if doer.level < 2 then
                doer.components.talker:Say(STRINGS.CIVI_LEVELS.FEEL_DARK, 3)
            else
                doer.components.talker:Say(STRINGS.CIVI_LEVELS.ALREADY_DARK, 3)
            end
        elseif item.prefab == "lightcrystal" then
            doer.level = level - 1
            if doer.level > 0 then
                doer.components.talker:Say(STRINGS.CIVI_LEVELS.FEEL_LIGHT, 3)
            else
                doer.components.talker:Say(STRINGS.CIVI_LEVELS.ALREADY_LIGHT, 3)
            end
        end

        doer.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        if doer.applylevelfn ~= nil then
            doer.applylevelfn(doer)
        end
        item:Remove()
        return true
    end
end

scheduler:ExecuteInTime(0, function()
    if rawget(_G, "STRCODE_TALKER") then
        STRCODE_TALKER[STRINGS.CIVI_LEVELS.FEEL_DARK] = "CIVI_LEVELS.FEEL_DARK"
        STRCODE_TALKER[STRINGS.CIVI_LEVELS.ALREADY_DARK] = "CIVI_LEVELS.ALREADY_DARK"
        STRCODE_TALKER[STRINGS.CIVI_LEVELS.FEEL_LIGHT] = "CIVI_LEVELS.FEEL_LIGHT"
        STRCODE_TALKER[STRINGS.CIVI_LEVELS.ALREADY_LIGHT] = "CIVI_LEVELS.ALREADY_LIGHT"
    end
end)

local fuel_action_prefabs = {
    torch = true,
    lighter = true,
    pumpkin_lantern = true,
    ironwind = true, -- Volcano Biome MOD
    purpleamulet = true,
}

for i = 1, 8 do
    fuel_action_prefabs["winter_ornament_light" .. tostring(i)] = true
end

local function use_fuel(item, target, doer)
    local wetmult = item:GetIsWet() and TUNING.WET_FUEL_PENALTY or 1
    local fueled = target.components.fueled
    if fueled then
        fueled:DoDelta(item.components.fuel.fuelvalue * fueled.bonusmult * wetmult, doer)
        if fuel_action_prefabs[target.prefab] then
            doer.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        end
        if fueled.ontakefuelfn then
            fueled.ontakefuelfn(target)
        end
        return true
    elseif target.components.perishable then
        target.components.perishable:SetPercent( target.components.perishable:GetPercent() + item.components.fuel.fuelvalue / TUNING.LANTERN_LIGHTTIME * wetmult )
        return true
    end
end

NS_ACTIONS.MIOFUEL.fn = function(act)
    if act.doer.components.inventory then
        local fuel = act.doer.components.inventory:RemoveItem(act.invobject)
        if fuel then
            if use_fuel(fuel, act.target, act.doer) then
                fuel:Remove()
                return true
            else
                act.doer.components.inventory:GiveItem(fuel)
            end
        end
    end
end

NS_ACTIONS.NIGHTSWORD.fn = function(act)
    local doer = act.doer
    local target = act.target
    if doer.components.inventory then
        local item = doer.components.inventory:RemoveItem(act.invobject)

        target:InitContainer()
        target.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")

        if doer.components.inventory:IsItemEquipped(target) then
            if target.components.container then
                target.components.container:Open(doer)
                target.add_container_event:push()
            end
        end

        target.components.container:GiveItem(item)

        return true
    end
end

local TOTEM_TARGET = {
    darkcrystal = "friendshiptotem_dark",
    lightcrystal = "friendshiptotem_light",
}
NS_ACTIONS.FRIENDSHIPTOTEM.fn = function(act)
    local item = act.invobject
    local totem_prefab = TOTEM_TARGET[item.prefab]
    if totem_prefab then
        if item.components.stackable then
            item.components.stackable:Get():Remove()
        else
            item:Remove()
        end
        local totem = SpawnPrefab(totem_prefab)
        local target = act.target
        local container = target.components.inventoryitem and target.components.inventoryitem:GetContainer()
        local fx = SpawnPrefab("halloween_moonpuff")
        -- fx.AnimState:SetScale(0.6, 0.6, 0.6)
        local x, y, z = target.Transform:GetWorldPosition()
        target:Remove()
        if container then
            container:GiveItem(totem, nil, Vector3(x, y, z))
            fx.Transform:SetPosition(container.inst.Transform:GetWorldPosition())
        else
            totem.Transform:SetPosition(x, y, z)
            fx.Transform:SetPosition(x, y, z)
        end
        return true
    end
end

-- For portable_wardrobe
local changein_fn = ACTIONS.CHANGEIN.fn
ACTIONS.CHANGEIN.fn = function(act, ...)
    if not act.target and act.invobject then
        act.target = act.invobject
    end
    return changein_fn(act, ...)
end

for _, k, v in sorted_pairs(NS_ACTIONS) do
    v.id = k
    AddAction(v)
end

local function fuel_pocket_watch(inst, caster)
    -- print("FuelPocketWatch, GetActionPoint")
    return inst.components.pocketwatch:CastSpell(caster)
end
NS_ACTIONS.FUELPOCKETWATCH.fn = function(act)
    local fuel = act.doer.components.inventory:RemoveItem(act.invobject)
    if fuel then
        if fuel_pocket_watch(act.target, act.doer) then
            fuel:Remove()
            act.doer.components.health:DoDelta(TUNING.HEALTH_FUELPOCKETWATCH_COST, nil, "fuelpocketwatch", true, nil, true)
            return true
        else
            act.doer.components.inventory:GiveItem(fuel)
        end
    end
end

---------------------------------------------------------------------
----------------------- COMPONENT ACTIONS ---------------------------
---------------------------------------------------------------------

local function fuel_action_testfn(target)
    return target:HasTag("CAVE_fueled") or
        target:HasTag("BURNABLE_fueled") or
        target:HasTag("WORMLIGHT_fueled") or
        target:HasTag("TAR_fueled") or -- IA Sea Yard
        fuel_action_prefabs[target.prefab]
end

AddComponentAction("USEITEM", "fuel", function(inst, doer, target, actions, right)
    if doer.prefab == "miotan" and inst.prefab == "nightmarefuel" then
        if fuel_action_testfn(target)
            and (
                not (doer.replica.rider and doer.replica.rider:IsRiding())
                or (target.replica.inventoryitem and target.replica.inventoryitem:IsGrandOwner(doer))
            ) then

            table.insert(actions, NS_ACTIONS.MIOFUEL)
        end
    end
end)

AddComponentAction("USEITEM", "fuelpocketwatch", function(inst, doer, target, actions, right)
    if right and inst.prefab =="nightmarefuel" and doer:HasTag("nightmare_twins")
    and target.prefab == "pocketwatch_recall" and target:HasTag("pocketwatch_inactive") and not target:HasTag("recall_unmarked")
    then
        table.insert(actions, NS_ACTIONS.FUELPOCKETWATCH)
    end
end)

AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if right and target.prefab == "nightpack" and inst:HasTag("nightpackgem") and not doer.replica.rider:IsRiding()
    and not (target:HasTag("nofuelsocket") and inst.prefab == "nightmarefuel")
    then
        table.insert(actions, NS_ACTIONS.GEMTRADE)
    end
end)


AddComponentAction("USEITEM", "nightcrystal", function(inst, doer, target, actions, right)
    if right then
        if target.prefab == "nightsword" then
            if not target:HasTag("crystal_socketed") then
                table.insert(actions, NS_ACTIONS.NIGHTSWORD)
            end
        elseif target.prefab == "friendshipring"
            and not (target.replica.equippable and target.replica.equippable:IsEquipped()) then

            table.insert(actions, NS_ACTIONS.FRIENDSHIPTOTEM)
        end
    end
    -- 这里写新的那部分
end)

local change_tackle_strfn = ACTIONS.CHANGE_TACKLE.strfn
ACTIONS.CHANGE_TACKLE.strfn = function(act)
    local item = (act.invobject and act.invobject:IsValid()) and act.invobject
    return change_tackle_strfn(act) or ((item and item:HasTag("civicrystal")) and ("CRYSTAL"))
end

AddComponentAction("INVENTORY", "nightcrystal", function(inst, doer, actions, right)
    if doer.replica.inventory and not doer.replica.inventory:IsHeavyLifting() then
        local sword = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if sword and sword.prefab == "nightsword" and
            sword.replica.container and sword.replica.container:IsOpenedBy(doer) and
            sword.replica.container:CanTakeItemInSlot(inst)
        then
            table.insert(actions, ACTIONS.CHANGE_TACKLE)
        elseif doer.prefab == "civi" then
            -- if doer.replica.inventory:GetActiveItem() == inst then return end
            if inst.prefab == "darkcrystal" and doer:HasTag("civi_canupgrade") then
                table.insert(actions, NS_ACTIONS.NIGHTSWITCH)
            elseif inst.prefab == "lightcrystal" and doer:HasTag("civi_candegrade") then
                table.insert(actions, NS_ACTIONS.NIGHTSWITCH)
            end
        end
    end
end)

-- Hauntable for Dummy
local COMPONENT_ACTIONS = UpvalueUtil.GetUpvalue(EntityScript.CollectActions, "COMPONENT_ACTIONS")
local SCENE = COMPONENT_ACTIONS.SCENE
local scene_hauntable = SCENE.hauntable
function SCENE.hauntable(inst, doer, actions, ...)
    if doer.prefab == "dummy" and inst:HasTag("nightmare_twins") then
        if inst ~= doer and not (inst:HasTag("playerghost") or inst:HasTag("reviving"))
                and not (inst:HasTag("haunted") or inst:HasTag("catchable")) then
            table.insert(actions, ACTIONS.HAUNT)
        end
    elseif inst:HasTag("nightmare_twins") and doer.prefab ~= "dummy" then
        return
    else
        return scene_hauntable(inst, doer, actions, ...)
    end
end

-- For portable_wardrobe
AddComponentAction("INVENTORY", "wardrobe", function(inst, doer, actions, right)
    if inst:HasTag("wardrobe") and not inst:HasTag("fire") and (right or not inst:HasTag("dressable")) then
        table.insert(actions, ACTIONS.CHANGEIN)
    end
end)

for _, sg in ipairs({"wilson", "wilson_client"}) do
    AddStategraphActionHandler(sg, ActionHandler(NS_ACTIONS.MIOFUEL, "doshortaction"))
    AddStategraphActionHandler(sg, ActionHandler(NS_ACTIONS.GEMTRADE, "doshortaction"))
    AddStategraphActionHandler(sg, ActionHandler(NS_ACTIONS.NIGHTSWORD, "doshortaction"))
    AddStategraphActionHandler(sg, ActionHandler(NS_ACTIONS.NIGHTSWITCH, "domediumaction"))
    AddStategraphActionHandler(sg, ActionHandler(NS_ACTIONS.FUELPOCKETWATCH, "pocketwatch_warpback_pre"))
    AddStategraphActionHandler(sg, ActionHandler(NS_ACTIONS.FRIENDSHIPTOTEM, "doshortaction"))
end

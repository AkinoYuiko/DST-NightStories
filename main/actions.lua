local AddAction = AddAction
local AddComponentAction = AddComponentAction
local AddStategraphActionHandler = AddStategraphActionHandler
GLOBAL.setfenv(1, GLOBAL)

local UpvalueHacker = require("upvaluehacker")

NS_ACTIONS = {
    GEMTRADE = Action({mount_valid = true}),
    MIOFUEL = Action({mount_valid = true}),
    NIGHTSWITCH = Action({mount_valid = true, priority = 1}),
    NIGHTSWORDMAGATAMA = Action({mount_valid = true, priority = 2}),
}

NS_ACTIONS.GEMTRADE.str = STRINGS.ACTIONS.GIVE.SOCKET
NS_ACTIONS.NIGHTSWITCH.str = STRINGS.ACTIONS.USEITEM
NS_ACTIONS.NIGHTSWORDMAGATAMA.str = STRINGS.ACTIONS.GIVE.SOCKET

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
                target:OnGemTrade(gem_type, doer.prefab == "dummy" and gem_type ~= "fuel")
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
        if item.prefab == "darkgem" then
            doer.level = level + 1
            if doer.level < 2 then
                doer.components.talker:Say(STRINGS.CIVI_GEMS.FEEL_DARK, 3)
            else
                doer.components.talker:Say(STRINGS.CIVI_GEMS.ALREADY_DARK, 3)
            end
        elseif item.prefab == "lightgem" then
            doer.level = level - 1
            if doer.level > 0 then
                doer.components.talker:Say(STRINGS.CIVI_GEMS.FEEL_LIGHT, 3)
            else
                doer.components.talker:Say(STRINGS.CIVI_GEMS.ALREADY_LIGHT, 3)
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

local function UseFuel(item, target, doer)
	local wetmult = item:GetIsWet() and TUNING.WET_FUEL_PENALTY or 1
	local fueled = target.components.fueled
	if fueled then
		fueled:DoDelta(item.components.fuel.fuelvalue * fueled.bonusmult * wetmult, doer)
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
			if UseFuel(fuel, act.target, act.doer) then
				fuel:Remove()
				return true
			else
				act.doer.components.inventory:GiveItem(fuel)
			end
		end
	end
end

NS_ACTIONS.NIGHTSWORDMAGATAMA.fn = function(act)
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

for k, v in orderedPairs(NS_ACTIONS) do
    v.id = k
    AddAction(v)
end

---------------------------------------------------------------------
----------------------- COMPONENT ACTIONS ---------------------------
---------------------------------------------------------------------

local function CheckAvailable(target)
	return target:HasTag("CAVE_fueled") or
		target:HasTag("BURNABLE_fueled") or
		target:HasTag("WORMLIGHT_fueled") or
		target:HasTag("TAR_fueled") or -- IA Sea Yard
		target.prefab == "torch" or -- BURNABLE, not accepting
		target.prefab == "lighter" or -- BURNABLE, not accepting
        target.prefab == "pumpkin_lantern" or -- BURNABLE, not accepting
		target.prefab == "ironwind" or -- Volcano Biome MOD
		target.prefab == "purpleamulet"
end

AddComponentAction("USEITEM", "fuel", function(inst, doer, target, actions, right)
	if doer.prefab == "miotan" and inst.prefab == "nightmarefuel" then
		if CheckAvailable(target)
			and (
				not (doer.replica.rider and doer.replica.rider:IsRiding())
				or (target.replica.inventoryitem and target.replica.inventoryitem:IsGrandOwner(doer))
			) then

			table.insert(actions, NS_ACTIONS.MIOFUEL)
		end
	end
end)

AddComponentAction("USEITEM", "nightmagatama", function(inst, doer, target, actions, right)
    if right and target.prefab == "nightsword" and not target:HasTag("nomagatamasocket") then
        table.insert(actions, NS_ACTIONS.NIGHTSWORDMAGATAMA)
    end
end)
AddComponentAction("INVENTORY", "nightmagatama", function(inst, doer, actions, right)
    if doer.replica.inventory and not doer.replica.inventory:IsHeavyLifting() then
        local sword = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if sword and sword.prefab == "nightsword" and
            sword.replica.container and sword.replica.container:IsOpenedBy(doer) and
            sword.replica.container:CanTakeItemInSlot(inst)
        then
            table.insert(actions, ACTIONS.CHANGE_TACKLE)
        end
    end
end)

AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if right and target.prefab == "nightpack" and inst:HasTag("nightpackgem") and not doer.replica.rider:IsRiding()
    and not (target:HasTag("nofuelsocket") and inst.prefab == "nightmarefuel")
    then
        table.insert(actions, 1, NS_ACTIONS.GEMTRADE)
    end
end)

AddComponentAction("INVENTORY", "nightswitch", function(inst, doer, actions, right)
    if doer.prefab ~= "civi" then return end
    if doer.replica.inventory:GetActiveItem() == inst then return end
    if inst.prefab == "darkgem" and doer:HasTag("civi_canupgrade") then
        table.insert(actions, NS_ACTIONS.NIGHTSWITCH)
    elseif inst.prefab == "lightgem" and doer:HasTag("civi_candegrade") then
        table.insert(actions, NS_ACTIONS.NIGHTSWITCH)
    end
end)

local COMPONENT_ACTIONS = UpvalueHacker.GetUpvalue(EntityScript.CollectActions, "COMPONENT_ACTIONS")
local SCENE = COMPONENT_ACTIONS.SCENE

local scene_hauntable = SCENE.hauntable
function SCENE.hauntable(inst, doer, actions, ...)
    if doer.prefab == "dummy" and inst:HasTag("nightmare_twins") and not inst:HasTag("playerghost")
            and not (inst:HasTag("haunted") or inst:HasTag("catchable")) then
        table.insert(actions, ACTIONS.HAUNT)
    else
        return scene_hauntable(inst, doer, actions, ...)
    end
end

for _, sg in ipairs({"wilson", "wilson_client"}) do
	AddStategraphActionHandler(sg, ActionHandler(NS_ACTIONS.MIOFUEL, "doshortaction"))
    AddStategraphActionHandler(sg, ActionHandler(NS_ACTIONS.GEMTRADE, "doshortaction"))
    AddStategraphActionHandler(sg, ActionHandler(NS_ACTIONS.NIGHTSWORDMAGATAMA, "doshortaction"))
    AddStategraphActionHandler(sg, ActionHandler(NS_ACTIONS.NIGHTSWITCH, "domediumaction"))
end

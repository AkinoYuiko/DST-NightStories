local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local MIOFUEL = Action({mount_valid=true})

MIOFUEL.id = "MIOFUEL"

MIOFUEL.stroverridefn = function(act)
	if act.invobject then
		return act.invobject:GetIsWet() and STRINGS.ACTIONS.ADDWETFUEL or STRINGS.ACTIONS.ADDFUEL
	end
end

local function UseFuel(item, target, doer)
	local wetmult = item:GetIsWet() and TUNING.WET_FUEL_PENALTY or 1
	local fueled = target.components.fueled
	if fueled then
		fueled:DoDelta(item.components.fuel.fuelvalue * fueled.bonusmult * wetmult, doer)
		-- _d.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
		if fueled.ontakefuelfn then
			fueled.ontakefuelfn(target)
		end
		return true

	elseif target.components.perishable then
		target.components.perishable:SetPercent( target.components.perishable:GetPercent() + item.components.fuel.fuelvalue / TUNING.LANTERN_LIGHTTIME * wetmult )
		return true

	end
end

MIOFUEL.fn = function(act)
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

ENV.AddAction(MIOFUEL)

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

ENV.AddComponentAction("USEITEM", "fuel", function(inst, doer, target, actions, right)
	if doer.prefab == "miotan" and inst.prefab == "nightmarefuel" then
		if CheckAvailable(target)
			and (
				not (doer.replica.rider and doer.replica.rider:IsRiding())
				or (target.replica.inventoryitem and target.replica.inventoryitem:IsGrandOwner(doer))
			) then

			table.insert(actions, ACTIONS.MIOFUEL)
		end
	end
end)

local handler = ActionHandler(ACTIONS.MIOFUEL, "doshortaction")
ENV.AddStategraphActionHandler("wilson", handler)
ENV.AddStategraphActionHandler("wilson_client", handler)

local TUNING = GLOBAL.TUNING
local FUELTYPE = GLOBAL.FUELTYPE
local ACTIONS = GLOBAL.ACTIONS
local Action = GLOBAL.Action
local ActionHandler = GLOBAL.ActionHandler

local MIOFUEL = Action({mount_valid=true})
local MIOWETFUEL = Action({mount_valid=true})

MIOFUEL.id = "MIOFUEL"
MIOWETFUEL.id = "MIOWETFUEL"

MIOFUEL.str = ACTIONS.ADDFUEL.str
MIOWETFUEL.str = ACTIONS.ADDWETFUEL.str

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

MIOFUEL.fn = function(act)
	local _d = act.doer
	local _t = act.target
    local fuel = _d.components.inventory and _d.components.inventory:RemoveItem(act.invobject)
    local wetmult = fuel:GetIsWet() and 0.7 or 1
    if fuel then
		if fuel.prefab == "nightmarefuel" and _d.prefab == "miotan" and CheckAvailable(_t) then
			if _t.components.fueled then
				_t.components.fueled:DoDelta(fuel.components.fuel.fuelvalue * _t.components.fueled.bonusmult * wetmult )
				-- _d.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
				if _t.components.fueled.ontakefuelfn ~= nil then
			    	_t.components.fueled.ontakefuelfn(_t)
			    end
			elseif _t.components.perishable then
				_t.components.perishable:SetPercent( _t.components.perishable:GetPercent() + fuel.components.fuel.fuelvalue/TUNING.LANTERN_LIGHTTIME * wetmult )
			end
			fuel:Remove()
			return true
		else
			_d.components.inventory:GiveItem(fuel)
        end
    end
end

MIOWETFUEL.fn = MIOFUEL.fn

AddAction(MIOFUEL)
AddAction(MIOWETFUEL)

function SetupActionNFuel(inst,doer,target,actions,right)
	if not (doer.prefab == "miotan" and inst.prefab == "nightmarefuel" ) then return end
	local _t = target
	local _add = false
    if CheckAvailable(_t) and (not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
      or (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer))) then
		table.insert(actions, inst:GetIsWet() and ACTIONS.MIOWETFUEL or ACTIONS.MIOFUEL)
	end
end

AddComponentAction("USEITEM", "fuel", SetupActionNFuel)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.MIOFUEL, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.MIOFUEL, "doshortaction"))

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.MIOWETFUEL, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.MIOWETFUEL, "doshortaction"))
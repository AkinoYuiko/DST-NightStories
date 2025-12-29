local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local foodvalue = {
	health = 10,
	sanity = 10,
	hunger = 15,
}

FOODTYPE.NIGHTMAREFUEL = "NIGHTMAREFUEL"
local Eater = require("components/eater")
local prefers_to_eat = Eater.PrefersToEat
function Eater:PrefersToEat(food)
	if food and food.components.nightfuel and self.inst:HasTag("nightfueleater") then
		return true
	end
	return prefers_to_eat(self, food)
end

local SCALE = 0.4
local function oneaten(food, eater)
	if eater.prefab == "miotan" and eater.StartBoost then
		eater:StartBoost(food.components.fuel.fuelvalue)
		local fx = SpawnPrefab("statue_transition")
		if fx then
			fx.entity:SetParent(eater.entity)
			fx.Transform:SetScale(SCALE, SCALE, SCALE)
		end
		eater.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
	end
end

local FUEL_PREFAB_MULT = {
	["nightmarefuel"] = 1,
	["horrorfuel"] = 2,
}

for prefab, mult in pairs(FUEL_PREFAB_MULT) do
	AddPrefabPostInit(prefab, function(inst)
		inst:AddTag("fuelpocketwatch_fuel")
		if not TheWorld.ismastersim then
			return
		end
		inst:AddComponent("edible")
		inst.components.edible.healthvalue = foodvalue.health * mult
		inst.components.edible.sanityvalue = foodvalue.sanity * mult
		inst.components.edible.hungervalue = foodvalue.hunger * mult
		inst.components.edible.foodtype = FOODTYPE.NIGHTMAREFUEL
		inst.components.edible:SetOnEatenFn(oneaten)

		inst:AddComponent("nightfuel")
	end)
end

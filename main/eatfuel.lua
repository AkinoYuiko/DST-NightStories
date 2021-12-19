local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

FOODTYPE.NIGHTFUEL = "NIGHTFUEL"
local eater = require "components/eater"
eater.SetCanEatNightmareFuel = function(self)
	table.insert(self.preferseating, FOODTYPE.NIGHTFUEL)
	table.insert(self.caneat, FOODTYPE.NIGHTFUEL)
	if not self.inst:HasTag(FOODTYPE.NIGHTFUEL.."_eater") then
		self.inst:AddTag(FOODTYPE.NIGHTFUEL.."_eater")
	end
end

AddPrefabPostInit("nightmarefuel", function(inst)
	if not TheWorld.ismastersim then return end
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = 10
	inst.components.edible.sanityvalue = 10
	inst.components.edible.hungervalue = 15
	inst.components.edible.foodtype = FOODTYPE.NIGHTFUEL
end)
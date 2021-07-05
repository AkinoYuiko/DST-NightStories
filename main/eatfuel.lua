local _G = GLOBAL

AddPrefabPostInit("nightmarefuel", function(inst)
	if inst.components.edible == nil then
		inst:AddComponent("edible")
		if inst.components.edible then
			inst.components.edible.healthvalue = 10
			inst.components.edible.sanityvalue = 10
			inst.components.edible.hungervalue = 15
			inst.components.edible.foodtype = _G.FOODTYPE.NIGHTFUEL
		end
	end
end)

_G.FOODTYPE.NIGHTFUEL = "NIGHTFUEL"
AddComponentPostInit("eater", function(self)
    function self:SetCanEatNightmareFuel()
        table.insert(self.preferseating, _G.FOODTYPE.NIGHTFUEL)
        table.insert(self.caneat, _G.FOODTYPE.NIGHTFUEL)
        if not self.inst:HasTag(_G.FOODTYPE.NIGHTFUEL.."_eater") then
            self.inst:AddTag(_G.FOODTYPE.NIGHTFUEL.."_eater")
        end
    end
end)


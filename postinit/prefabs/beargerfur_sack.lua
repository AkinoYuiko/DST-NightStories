local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("beargerfur_sack", function(inst)
	if not TheWorld.ismastersim then return end
	if inst.components.preserver then
		inst.components.preserver:SetPerishRateMultiplier(0)
	end
end)

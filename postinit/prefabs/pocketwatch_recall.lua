local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("pocketwatch_recall", function(inst)
	if not TheWorld.ismastersim then return end
	inst:AddComponent("fuelpocketwatch")
end)

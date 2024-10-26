local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("multiplayer_portal_moonrock", function(inst)
	if not TheWorld.ismastersim then return end

	inst:AddComponent("prototyper")
	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.MOONORB_LOW

end)

PROTOTYPER_DEFS.multiplayer_portal_moonrock = PROTOTYPER_DEFS.moonrockseed

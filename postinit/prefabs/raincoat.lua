local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("raincoat", function(inst)
	if not TheWorld.ismastersim then return end

	GlassicAPI.SetFloatData(inst, { bank = "torso_rain", anim = "anim" })
end)

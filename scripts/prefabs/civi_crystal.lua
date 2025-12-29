local assets = {
	Asset("ANIM", "anim/civi_crystal.zip"),
}
local function MakeCrystal(colour)
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank("civi_crystal")
		inst.AnimState:SetBuild("civi_crystal")
		inst.AnimState:PlayAnimation(colour)

		-- inst:AddTag("molebait")
		-- inst:AddTag("quakedebris")

		inst:AddTag("civicrystal")
		-- inst:AddTag("reloaditem_crystal")

		MakeInventoryFloatable(inst, "small", 0.05)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

		inst:AddComponent("inventoryitem")

		inst:AddComponent("inspectable")

		inst:AddComponent("nightcrystal")

		-- inst:DoTaskInTime(0, function(inst)
		--	 inst.drawnameoverride = rawget(_G, "EncodeStrCode") and EncodeStrCode({content = "NAMES." .. string.upper(inst.prefab)})
		-- end)
		if rawget(_G, "EncodeDrawNameCode") then
			EncodeDrawNameCode(inst)
		end

		return inst
	end

	return Prefab(colour .. "crystal", fn, assets)
end
return MakeCrystal("dark"), MakeCrystal("light")

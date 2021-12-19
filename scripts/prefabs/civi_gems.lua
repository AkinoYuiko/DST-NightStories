local assets=
{
    Asset("ANIM", "anim/civi_gems.zip"),
}
local function buildgem(colour)
	local function fn()
	    local inst = CreateEntity()

	    inst.entity:AddTransform()
	    inst.entity:AddAnimState()
	    inst.entity:AddSoundEmitter()
	    inst.entity:AddNetwork()

	    MakeInventoryPhysics(inst)

	    inst.AnimState:SetBank("civi_gems")
	    inst.AnimState:SetBuild("civi_gems")
	    inst.AnimState:PlayAnimation(colour.."gem_idle")

	    inst:AddTag("molebait")
	    inst:AddTag("quakedebris")

	    MakeInventoryFloatable(inst, "small", 0.10, 0.80)


	    inst.entity:SetPristine()

		if not TheWorld.ismastersim then
	        return inst
	    end

		inst:AddComponent("stackable")
	    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	    inst:AddComponent("inventoryitem")

		inst:AddComponent("inspectable")

	    inst:AddComponent("nightswitch")

		return inst
	end

    return Prefab(colour.."gem", fn, assets)

end
return buildgem("dark"),
		buildgem("light")

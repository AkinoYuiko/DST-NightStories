local assets=
{
    Asset("ANIM", "anim/civi_magatamas.zip"),
}
local function buildmagatama(colour)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("civi_magatamas")
        inst.AnimState:SetBuild("civi_magatamas")
        inst.AnimState:PlayAnimation(colour)

        MakeInventoryFloatable(inst, "small", 0.05)


        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

        inst:AddComponent("inventoryitem")

        inst:AddComponent("inspectable")

        inst:DoTaskInTime(0, function(inst)
            inst.drawnameoverride = rawget(_G, "EncodeStrCode") and EncodeStrCode({content = "NAMES." .. string.upper(inst.prefab)})
        end)

        return inst
    end

    return Prefab(colour.."magatama", fn, assets)

end
return buildmagatama("dark"),
        buildmagatama("light")

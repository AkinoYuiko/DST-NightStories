local assets =
{
    Asset("ANIM", "anim/ns_spices.zip"),
}

local function MakeSpice(name)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("spices")
        inst.AnimState:SetBuild("spices")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:OverrideSymbol("swap_spice", "ns_spices", name)

        inst:AddTag("spice")

        MakeInventoryFloatable(inst, "med", nil, 0.7)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")

        MakeHauntableLaunch(inst)

        inst:DoTaskInTime(0, function(inst)
            inst.drawnameoverride = rawget(_G, "EncodeStrCode") and EncodeStrCode({content = "NAMES." .. string.upper(inst.prefab)})
        end)

        return inst
    end

    return Prefab(name, fn, assets)
end

return MakeSpice("spice_cactus")

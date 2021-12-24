local wrap_assets =
{
    Asset("ANIM", "anim/portable_wardrobe_wrap.zip"),
}

local portable_assets =
{
    -- Asset("ANIM", "anim/nope_again.zip"),
}

local wrap_prefabs =
{

}

local portable_prefabs =
{

}

local function Consume(inst)
    if inst.components.stackable:IsStack() then
        inst.components.stackable:Get():Remove()
    else
        inst:Remove()
    end
end

local function common_fn(anim, should_sink)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(anim)
    inst.AnimState:SetBuild(anim)
    inst.AnimState:PlayAnimation("idle")

    if not should_sink then
        MakeInventoryFloatable(inst, "med", nil, 0.6)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("wardrobe")
    inst.components.wardrobe:SetCanBeShared(true)
    local ApplySkins = inst.components.wardrobe.ApplySkins
    inst.components.wardrobe.ApplySkins = function(...)
        inst:Consume()
        return ApplySkins(...)
    end

    inst:AddComponent("inventoryitem")
    if should_sink then
        inst.components.inventoryitem:SetSinks(true)
    end

    inst:AddComponent("inspectable")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst.Consume = Consume

    return inst
end

local function wrap_fn()
    local inst = common_fn("portable_wardrobe_wrap", true)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    return inst
end

return Prefab("portable_wardrobe_wrap", wrap_fn, wrap_assets, wrap_prefabs)
        -- Prefab("portable_wardrobe_item", portable_fn, assets.portable, prefabs.portable)

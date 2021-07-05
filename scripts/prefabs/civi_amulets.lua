local assets =
{
    Asset( "ANIM", "anim/civi_amulets.zip"),
    Asset( "ANIM", "anim/torso_civiamulets.zip"),
}

local function onequip_light(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "torso_civiamulets", "blueamulet")
    -- if owner.components.combat ~= nil then
    --     owner.components.combat.externaldamagemultipliers:SetModifier(inst,1.2,"darkamulet")
    -- end
    if inst.components.fueled then
        inst.components.fueled:StartConsuming()
    end
end

local function onunequip_light(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    -- if owner.components.combat ~= nil then
    --     owner.components.combat.externaldamagemultipliers:RemoveModifier(inst,"darkamulet")
    -- end
    if inst.components.fueled then
        inst.components.fueled:StopConsuming()
    end
end

local function onequip_dark(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "torso_civiamulets", "purpleamulet")
    if owner.components.combat ~= nil then
        owner.components.combat.externaldamagemultipliers:SetModifier(inst,1.2,"darkamulet")
    end
    if inst.components.fueled then
        inst.components.fueled:StartConsuming()
    end
end

local function onunequip_dark(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
	if owner.components.combat ~= nil then
        owner.components.combat.externaldamagemultipliers:RemoveModifier(inst,"darkamulet")
    end
    if inst.components.fueled then
        inst.components.fueled:StopConsuming()
    end
end

local function fn_dark()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("civi_amulets")
    inst.AnimState:SetBuild("civi_amulets")
    inst.AnimState:PlayAnimation("darkamulet")

    inst.foleysound = "dontstarve/movement/foley/jewlery"

    -- local swap_data = {sym_build = "swap_realnightsword", sym_name = "swap_machete", bank = "realnightsword"}

    MakeInventoryFloatable(inst, "med", nil, 0.6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.dapperness = -TUNING.DAPPERNESS_MED
    inst.components.equippable:SetOnEquip(onequip_dark)
    inst.components.equippable:SetOnUnequip(onunequip_dark)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled:InitializeFuelLevel(360)
    inst.components.fueled:SetDepletedFn(inst.Remove)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled.accepting = true

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem.imagename = "darkamulet"
    -- inst.components.inventoryitem.atlasname = resolvefilepath("images/inventoryimages/civi_amulets.xml")

    -- if TUNING.GEARPLAN ~= 2 then inst:DoTaskInTime(0, inst.Remove) end

    return inst
end

local function fn_light()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("civi_amulets")
    inst.AnimState:SetBuild("civi_amulets")
    inst.AnimState:PlayAnimation("lightamulet")

    inst.foleysound = "dontstarve/movement/foley/jewlery"

    -- local swap_data = {sym_build = "swap_realnightsword", sym_name = "swap_machete", bank = "realnightsword"}

    MakeInventoryFloatable(inst, "med", nil, 0.6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    -- inst.components.equippable.dapperness = -TUNING.DAPPERNESS_MED
    inst.components.equippable:SetOnEquip(onequip_light)
    inst.components.equippable:SetOnUnequip(onunequip_light)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled:InitializeFuelLevel(240)
    inst.components.fueled:SetDepletedFn(inst.Remove)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled.accepting = false

    inst:AddComponent("inventoryitem")

    -- if TUNING.GEARPLAN ~= 2 then inst:DoTaskInTime(0, inst.Remove) end

    return inst
end

return Prefab("darkamulet", fn_dark, assets),
        Prefab("lightamulet", fn_light, assets)

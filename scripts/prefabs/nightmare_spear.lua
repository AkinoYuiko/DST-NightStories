local easing = require("easing")

local assets =
{
    Asset("ANIM", "anim/nightmare_spear.zip"),
}

local function onattack(inst)
    local max_hits = 39 -- 20*2-1, let total fuel be 200% of the max fuel.
    if inst.components.fueled ~= nil then
        local fueled = inst.components.fueled
        local new_percent = fueled:GetPercent() + (max_hits - inst.total_hits) / (max_hits * 20) -- 1/20 is 5%, fuel regen of the first hit.
        fueled:SetPercent(math.min(1, new_percent))
    end
    inst.total_hits = math.min(max_hits, inst.total_hits + 1)
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "nightmare_spear", "swap_nightmare_spear")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onload(inst,data)
    if data and data.total_hits > 0 then
        inst.total_hits = data.total_hits
    end
end

local function onsave(inst,data)
    data.total_hits = inst.total_hits
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("nightmare_spear")
    inst.AnimState:SetBuild("nightmare_spear")
    inst.AnimState:PlayAnimation("idle")

    -- inst:AddTag("shadow")
    inst:AddTag("sharp")
    inst:AddTag("weapon")
    inst:AddTag("shadow_item")

    local swap_data = {sym_build = "nightmare_spear", sym_name = "swap_nightmare_spear"}
    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.4, 1.1}, true, -9, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -------

    inst:AddComponent("fueled")
    inst.components.fueled.period = TUNING.NIGHTMARE_SPEAR_PERIOD
    inst.components.fueled:InitializeFuelLevel(TUNING.NIGHTMARE_SPEAR_FUELTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)
    inst.components.fueled:StartConsuming()

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.NIGHTMARE_SPEAR_DAMAGE)
    inst.components.weapon:SetOnAttack(onattack)
    inst.total_hits = 0

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.dapperness = TUNING.CRAZINESS_MED

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("nightmare_spear", fn, assets)

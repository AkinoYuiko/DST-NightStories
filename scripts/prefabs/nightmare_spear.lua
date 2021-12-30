local assets =
{
    Asset("ANIM", "anim/nightmare_spear.zip"),
    -- Asset("ANIM", "anim/swap_nightmare_spear.zip"),
}

local function onattack(inst)
  if inst.components.fueled ~= nil then
    local _f = inst.components.fueled
    local _p = _f:GetPercent()
    _f:SetPercent( math.min( 1, (_p + ( math.max(0,((15 - inst._hits )/150))))))
    -- if inst._hits <15 then print(inst._hits..", ".._p) end
  end
  inst._hits = inst._hits + 1
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
  if data ~= nil and data._hits ~= nil then
    inst._hits = data._hits
  end
end

local function onsave(inst,data)
  data._hits = inst._hits >= 0 and inst._hits or nil
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
    inst.components.fueled:InitializeFuelLevel(15)
    inst.components.fueled:SetDepletedFn(inst.Remove)
    inst.components.fueled:StartConsuming()

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(68)
    inst.components.weapon:SetOnAttack(onattack)
    inst._hits = 0

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem.imagename = "nightmare_spear"
    -- inst.components.inventoryitem.atlasname = resolvefilepath("images/inventoryimages/nightmare_spear.xml")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.dapperness = TUNING.CRAZINESS_MED

    MakeHauntableLaunch(inst)

    inst:DoTaskInTime(0, function(inst)
        inst.drawnameoverride = rawget(_G, "EncodeStrCode") and EncodeStrCode({content = "NAMES." .. string.upper(inst.prefab)})
    end)

    return inst
end

return Prefab("nightmare_spear", fn, assets)

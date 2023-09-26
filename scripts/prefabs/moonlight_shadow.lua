local assets =
{
    Asset("ANIM", "anim/sword_lunarplant.zip"),
}

local prefabs =
{
    "moonlight_shadow_blade_fx",
    "hitsparks_fx",
}

local function set_fx_owner(inst, owner)
    if inst._fxowner ~= nil and inst._fxowner.components.colouradder ~= nil then
        inst._fxowner.components.colouradder:DetachChild(inst.blade1)
        inst._fxowner.components.colouradder:DetachChild(inst.blade2)
    end
    inst._fxowner = owner
    if owner ~= nil then
        inst.blade1.entity:SetParent(owner.entity)
        inst.blade2.entity:SetParent(owner.entity)
        inst.blade1.Follower:FollowSymbol(owner.GUID, "swap_object", nil, nil, nil, true, nil, 0, 3)
        inst.blade2.Follower:FollowSymbol(owner.GUID, "swap_object", nil, nil, nil, true, nil, 5, 8)
        inst.blade1.components.highlightchild:SetOwner(owner)
        inst.blade2.components.highlightchild:SetOwner(owner)
        if owner.components.colouradder ~= nil then
            owner.components.colouradder:AttachChild(inst.blade1)
            owner.components.colouradder:AttachChild(inst.blade2)
        end
    else
        inst.blade1.entity:SetParent(inst.entity)
        inst.blade2.entity:SetParent(inst.entity)
        --For floating
        inst.blade1.Follower:FollowSymbol(inst.GUID, "swap_spear", nil, nil, nil, true, nil, 0, 3)
        inst.blade2.Follower:FollowSymbol(inst.GUID, "swap_spear", nil, nil, nil, true, nil, 5, 8)
        inst.blade1.components.highlightchild:SetOwner(inst)
        inst.blade2.components.highlightchild:SetOwner(inst)
    end
end

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_sword_lunarplant", inst.GUID, "sword_lunarplant")
    else
        owner.AnimState:OverrideSymbol("swap_object", "sword_lunarplant", "swap_sword_lunarplant")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    set_fx_owner(inst, owner)
    if inst.components.container then
        inst.components.container:Open(owner)
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
    set_fx_owner(inst, nil)
    if inst.components.container then
        inst.components.container:Close()
    end
end

local function auto_refill(inst, owner, item_type)
    local inv = owner.components.inventory
    local container = inst.components.container
    local hat = inv and inv:GetEquippedItem(EQUIPSLOTS.HEAD)
    local hat_container = hat and hat.prefab == "alterguardianhat" and hat.components.container
    local item_fn = function(item) return item.prefab == item_type end
    if not container:Has(item_type, 1) then
        local new_item = inv and inv:FindItem(item_fn)
        if new_item then
            inv:RemoveItem(new_item, true)
            container:GiveItem(new_item)
        elseif hat_container then
            local new_hat_item = hat_container:FindItem(item_fn)
            if new_hat_item then
                hat_container:RemoveItem(new_hat_item, true)
                container:GiveItem(new_hat_item)
            end
        end
    end
end

local function try_consume(inst, chance, item_type)
    if math.random() < chance then
        inst.components.container:ConsumeByName(item_type, 1)
    end
end

local function try_consume_and_refill(inst, owner, item_prefab, chance)
    try_consume(inst, chance, item_prefab)
    auto_refill(inst, owner, item_prefab)
end

local function attacker_testfn(attacker, target)
    return attacker and (attacker.components.health == nil or not attacker.components.health:IsDead())
        and target and target ~= attacker and target:IsValid()
end

local function target_testfn(target)
    return (target.components.health == nil or not target.components.health:IsDead()) and
        (target:HasTag("spiderden") or target:HasTag("wooden") or not target:HasTag("structure")) and
        not target:HasTag("wall")
end

local function get_attacker_mult(attacker)
    local base_mult = TUNING.MOONLIGHT_SHADOW.CONSUME_RATE.MOONGLASS.MULT
    local damagemult = attacker.components.combat.damagemultiplier or 1
    damagemult = math.min(2, damagemult)
    damagemult = math.max(1, damagemult)
    local electricmult = attacker.components.electricattacks and 1.5 or 1
    return base_mult * damagemult * electricmult
end

local function onattack_moonglass(inst, attacker, target)
    if attacker_testfn(attacker, target) then
        local moonglass_rate = TUNING.MOONLIGHT_SHADOW.CONSUME_RATE.MOONGLASS.BASE
        if target_testfn(target) then
            moonglass_rate = moonglass_rate * get_attacker_mult(attacker)
            SpawnPrefab("glash"):SetTarget(attacker, target)
        end
        try_consume_and_refill(inst, attacker, "moonglass", moonglass_rate)
    end
end

local function onattack_none(inst, attacker, target)
    if attacker_testfn(attacker, target) and math.random() < TUNING.MOONLIGHT_SHADOW.CONSUME_RATE.NONE then
        if attacker.components.talker then
            attacker.components.talker:Say(STRINGS.ANNOUNCE_GLASSIC_BROKE, nil, true)
        end
        if inst.components.inventoryitem.owner then
            inst.components.inventoryitem.owner:PushEvent("toolbroke", { tool = inst })
        end
        inst.components.container:Close()
        inst.components.container:DropEverything()
        inst:Remove()
    end
end

local function on_frag_change(inst, data)
    if data and data.item and data.item.prefab == "moonglass" then
        inst.components.weapon:SetDamage(TUNING.MOONLIGHT_SHADOW.DAMAGE.MOONGLASS)
        inst.components.weapon:SetOnAttack(onattack_moonglass)
        inst:AddTag("ignore_planar_entity")

    else

        inst.components.weapon:SetDamage(TUNING.MOONLIGHT_SHADOW.DAMAGE.NONE)
        inst.components.weapon:SetOnAttack(onattack_none)
        inst:RemoveTag("ignore_planar_entity")
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sword_lunarplant")
    inst.AnimState:SetBuild("sword_lunarplant")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetSymbolBloom("pb_energy_loop01")
    inst.AnimState:SetSymbolLightOverride("pb_energy_loop01", .5)
    inst.AnimState:SetLightOverride(.1)

    inst:AddTag("sharp")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")


    inst:AddComponent("floater")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then

        return inst
    end

    local frame = math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1
    inst.AnimState:SetFrame(frame)
    inst.blade1 = SpawnPrefab("moonlight_shadow_blade_fx")
    inst.blade2 = SpawnPrefab("moonlight_shadow_blade_fx")
    inst.blade2.AnimState:PlayAnimation("swap_loop2", true)
    inst.blade1.AnimState:SetFrame(frame)
    inst.blade2.AnimState:SetFrame(frame)
    set_fx_owner(inst, nil)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("sword_lunarplant")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("moonlight_shadow")
    inst.components.container.canbeopened = false

    inst:ListenForEvent("itemget", on_frag_change)
    inst:ListenForEvent("itemlose", on_frag_change)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.GLASSCUTTER.DAMAGE)
    inst.components.weapon:SetOnAttack(onattack_none)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    inst.drawnameoverride = rawget(_G, "EncodeStrCode") and EncodeStrCode({content = "NAMES.MOONLIGHT_SHADOW"})

    return inst
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddFollower()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.AnimState:SetBank("sword_lunarplant")
    inst.AnimState:SetBuild("sword_lunarplant")
    inst.AnimState:PlayAnimation("swap_loop1", true)
    inst.AnimState:SetSymbolBloom("pb_energy_loop01")
    inst.AnimState:SetSymbolLightOverride("pb_energy_loop01", .5)
    inst.AnimState:SetLightOverride(.1)

    inst:AddComponent("highlightchild")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("colouradder")

    inst.persists = false

    return inst
end

return Prefab("moonlight_shadow", fn, assets, prefabs),
    Prefab("moonlight_shadow_blade_fx", fxfn, assets)

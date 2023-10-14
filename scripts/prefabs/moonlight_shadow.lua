local assets =
{
    Asset("ANIM", "anim/sword_lunarplant.zip"),
    Asset("ANIM", "anim/inventory_fx_moonlight.zip"),
}

local prefabs =
{
    "sword_lunarplant_blade_fx",
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

local function on_stop_floating(inst)
    inst.blade1.AnimState:SetFrame(0)
    inst.blade2.AnimState:SetFrame(0)
    inst:DoTaskInTime(0, function(inst)
        inst.AnimState:PushAnimation("idle")
    end) --#V2C: #HACK restore the looping anim, timing issues
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

local function update_base_damage(inst)
    if inst.components.finiteuses:GetUses() == 0 then
        inst.components.weapon:SetDamage(TUNING.MOONLIGHT_SHADOW.DAMAGE.EMPTY)
        inst:RemoveTag("ignore_planar_entity")
    else
        inst:AddTag("ignore_planar_entity")
        if inst.buffed_atks > 0 then
            inst.components.weapon:SetDamage(TUNING.MOONLIGHT_SHADOW.DAMAGE.BUFFED)
        else
            inst.components.weapon:SetDamage(TUNING.MOONLIGHT_SHADOW.DAMAGE.CHARGED)
        end
    end
end

local function set_buffed_atks(inst, amount)
    inst.buffed_atks = math.clamp(amount, 0, TUNING.MOONLIGHT_SHADOW.MAX_USES)
    if inst.buffed_atks > 0 then
        inst.is_buffed:set(true)
    else
        inst.is_buffed:set(false)
    end
    update_base_damage(inst)
end

local function get_current_battery(inst)
    return inst.components.container:GetItemInSlot(1)
end

local function auto_refill(inst, prev_item_prefab)
    if not inst.components.container:IsEmpty() then
        return
    end
    local owner = inst.components.inventoryitem.owner
    local inv = owner.components.inventory
    local container = inst.components.container
    local hat = inv and inv:GetEquippedItem(EQUIPSLOTS.HEAD)
    local hat_container = hat and hat.prefab == "alterguardianhat" and hat.components.container
    local item_fn = function(item) return item.prefab == prev_item_prefab end
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

local function get_attacker_mult(attacker)
    -- local base_mult = TUNING.MOONLIGHT_SHADOW.CONSUME_RATE.MOONGLASS.MULT
    local damagemult = attacker.components.combat.damagemultiplier or 1
    damagemult = math.clamp(damagemult, 1, 2)
    local electricmult = attacker.components.electricattacks and 0.5 or 0
    return 0.5 * (damagemult + 1) + electricmult
end

local function can_consume_battery(inst)
    local current_item = get_current_battery(inst)
    if not current_item then
        return
    end
    local power = TUNING.MOONLIGHT_SHADOW.BATTERIES[current_item.prefab]
    -- total is max uses
    return inst.components.finiteuses.total - inst.components.finiteuses:GetUses() >= power
end

local function charge_with_item(inst, battery, amount)
    amount = amount or 1
    local power = TUNING.MOONLIGHT_SHADOW.BATTERIES[battery.prefab]
    inst.components.finiteuses:Repair(power * amount)
    local buff_atks = TUNING.MOONLIGHT_SHADOW.BUFFS[battery.prefab]
    if buff_atks then
        set_buffed_atks(inst, inst.buffed_atks + buff_atks * amount)
    end
end

local function try_consume_battery(inst)
    local current_item = get_current_battery(inst)
    if not current_item then
        return
    end
    -- total is max uses
    if inst.components.finiteuses.total - inst.components.finiteuses:GetUses() >= TUNING.MOONLIGHT_SHADOW.BATTERIES[current_item.prefab] then
        inst:ChargeWithItem(current_item)
        if current_item.components.stackable then
            current_item.components.stackable:Get():Remove()
        else
            current_item:Remove()
        end
        auto_refill(inst, current_item.prefab)
        return true
    end
end

local function do_consume(inst, attacker)
    local mult = get_attacker_mult(attacker)
    inst.components.finiteuses:Use(mult)
    set_buffed_atks(inst, inst.buffed_atks - mult)
    try_consume_battery(inst)
end

local function target_testfn(target)
    return (target.components.health == nil or not target.components.health:IsDead()) and
        (target:HasTag("spiderden") or target:HasTag("wooden") or not target:HasTag("structure")) and
        not target:HasTag("wall")
end

local function onbreak(inst, owner)
    if owner.components.talker then
        owner.components.talker:Say(STRINGS.ANNOUNCE_GLASSIC_BROKE, nil, true)
    end
    if inst.components.inventoryitem.owner then
        inst.components.inventoryitem.owner:PushEvent("toolbroke", { tool = inst })
    end
    inst.components.container:Close()
    inst.components.container:DropEverything()
    inst:Remove()
end

local function onattack(inst, attacker, target)
    if inst.components.finiteuses:GetUses() == 0 then
        if math.random() < TUNING.MOONLIGHT_SHADOW.CONSUME_RATE.NONE then
            onbreak(inst, attacker)
        end
    else
        do_consume(inst, attacker)
        if target_testfn(target) then
            SpawnPrefab("glash"):SetTarget(attacker, target, inst.buffed_atks > 0)
        end
    end
end

local function cancel_charge_task(inst)
    if inst.try_charge_task then
        inst.try_charge_task:Cancel()
        inst.try_charge_task = nil
    end
end

local function try_charge_task(inst)
    try_consume_battery(inst)
    if not can_consume_battery(inst) then
        cancel_charge_task(inst)
    end
end

local function on_frag_change(inst, data)
    cancel_charge_task(inst)
    if data and data.item then
        -- inst:AddTag("ignore_planar_entity")
        try_consume_battery(inst)
        if can_consume_battery(inst) then
            inst.try_charge_task = inst:DoPeriodicTask(1, try_charge_task)
        end
    -- else
        -- inst:RemoveTag("ignore_planar_entity")
    end
end

local function onload(inst, data)
    if data and data.buffed_atks then
        set_buffed_atks(inst, data.buffed_atks)
    end
end

local function onsave(inst, data)
    data.buffed_atks = inst.buffed_atks > 0 and inst.buffed_atks
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    -- inst.entity:AddSoundEmitter()

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

    local SWAP_DATA = { bank = "sword_lunarplant", sym_build = "sword_lunarplant", sym_name = "swap_sword_lunarplant" }
    MakeInventoryFloatable(inst, "med", 0.05, {1, 0.4, 1}, true, -17.5, SWAP_DATA)

    inst.entity:SetPristine()

    inst.is_buffed = net_bool(inst.GUID, "moonlight_shadow_buffed", "moonlight_shadow_buffed")

    if not TheWorld.ismastersim then
        return inst
    end

    local frame = math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1
    inst.AnimState:SetFrame(frame)
    inst.blade1 = SpawnPrefab("sword_lunarplant_blade_fx")
    inst.blade2 = SpawnPrefab("sword_lunarplant_blade_fx")
    inst.blade2.AnimState:PlayAnimation("swap_loop2", true)
    inst.blade1.AnimState:SetFrame(frame)
    inst.blade2.AnimState:SetFrame(frame)
    set_fx_owner(inst, nil)
    inst:ListenForEvent("floater_stopfloating", on_stop_floating)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("sword_lunarplant")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("moonlight_shadow")
    inst.components.container.canbeopened = false

    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(0)

    inst:ListenForEvent("itemget", on_frag_change)
    inst:ListenForEvent("itemlose", on_frag_change)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.MOONLIGHT_SHADOW.MAX_USES)
    inst.components.finiteuses:SetUses(TUNING.MOONLIGHT_SHADOW.MAX_USES)
    inst.components.finiteuses:SetIgnoreCombatDurabilityLoss(true) -- We'll handle this ourselfs
    inst:ListenForEvent("percentusedchange", update_base_damage)
    -- inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.MOONLIGHT_SHADOW.DAMAGE.EMPTY)
    inst.components.weapon:SetOnAttack(onattack)

    inst.buffed_atks = 0

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst.ChargeWithItem = charge_with_item

    inst.drawnameoverride = rawget(_G, "EncodeStrCode") and EncodeStrCode({content = "NAMES.MOONLIGHT_SHADOW"})

    return inst
end

return Prefab("moonlight_shadow", fn, assets, prefabs)

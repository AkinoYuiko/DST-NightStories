local assets =
{
    Asset("ANIM", "anim/whip.zip"),
    Asset("ANIM", "anim/swap_whip.zip"),
}

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_whip", inst.GUID, "swap_whip")
        owner.AnimState:OverrideItemSkinSymbol("whipline", skin_build, "whipline", inst.GUID, "swap_whip")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_whip", "swap_whip")
        owner.AnimState:OverrideSymbol("whipline", "swap_whip", "whipline")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
end

local function get_dummy_mult(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    return owner and owner.prefab == "dummy" and 1.5 or 1
end

local function onattack(inst, attacker, target)
    if target and target:IsValid() then
        if target.SoundEmitter then
            target.SoundEmitter:PlaySound(inst.skin_sound_small or "dontstarve/common/whip_small")
        end
        -- chain_target
        TheWorld.components.horrorchainmanager:AddMember(target, TUNING.HORRORCHAIN_DRUATION * get_dummy_mult(inst))
        -- target hit fx
        local fx = SpawnPrefab("wanda_attack_pocketwatch_old_fx")

        local x, y, z = target.Transform:GetWorldPosition()
        local radius = target:GetPhysicsRadius(.5)
        local angle = (inst.Transform:GetRotation() - 90) * DEGREES
        fx.Transform:SetPosition(x + math.sin(angle) * radius, 0, z + math.cos(angle) * radius)
    end

end

local function on_broken(inst)
    local equippable = inst.components.equippable
    if equippable ~= nil then
        inst.AnimState:PlayAnimation("broken")

        if equippable:IsEquipped() then
            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
            if owner ~= nil then
                local data =
                {
                    prefab = inst.prefab,
                    equipslot = equippable.equipslot,
                }
                if owner.components.inventory ~= nil then
                    local item = owner.components.inventory:Unequip(equippable.equipslot)
                    if item ~= nil then
                        owner.components.inventory:GiveItem(item, nil, owner:GetPosition())
                    end
                end
                inst:RemoveComponent("equippable")
                -- SetIsBroken(inst, true)
                -- owner:PushEvent("umbrellaranout", data)
                return
            end
        end
        inst:RemoveComponent("equippable")
        -- SetIsBroken(inst, true)
        inst:AddTag("broken")
        -- inst.components.inspectable.nameoverride = "BROKEN_FORGEDITEM"
    end
end

local function setup_equippable(inst)
    inst:AddComponent("equippable")
    inst.components.equippable.dapperness = -TUNING.DAPPERNESS_MED
    -- inst.components.equippable.is_magic_dapperness = true
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable:SetOnEquipToModel(OnEquipToModel)
end

local function on_repaired(inst)
    if inst.components.equippable == nil then
        setup_equippable(inst)
        inst.AnimState:PlayAnimation("idle")
        -- SetIsBroken(inst, false)
        inst:RemoveTag("broken")
        inst.components.inspectable.nameoverride = nil
    end
end

local function OnLoadPass()

end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("whip")
    inst.AnimState:SetBuild("whip")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("chain_horror") -- ?
    inst:AddTag("shadow_item")
    inst:AddTag("show_broken_ui")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    --shadowlevel (from shadowlevel component) added to pristine state for optimization
    inst:AddTag("shadowlevel")

    MakeInventoryFloatable(inst, "med", nil, 0.9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.HORRORCHAIN_DAMAGE)
    inst.components.weapon:SetRange(TUNING.HORRORCHAIN_RANGE)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.HORRORCHAIN_USES)
    inst.components.finiteuses:SetUses(TUNING.HORRORCHAIN_USES)
    -- inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("whip")

    setup_equippable(inst)

    inst:AddComponent("planardamage")
    inst.components.planardamage:SetBaseDamage(TUNING.HORRORCHAIN_DAMAGE_PLANAR)

    inst:AddComponent("shadowlevel")
    inst.components.shadowlevel:SetDefaultLevel(TUNING.HORRORCHAIN_SHADOW_LEVEL)

    MakeForgeRepairable(inst, FORGEMATERIALS.VOIDCLOTH, nil, on_repaired)
    inst.components.finiteuses:SetOnFinished(on_broken)

    MakeHauntableLaunch(inst)

    inst.OnLoadPass = OnLoadPass

    return inst
end

local function fx_fn()

end

return Prefab("horrorchain", fn, assets)

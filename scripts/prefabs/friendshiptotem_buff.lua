-------------------------------------------------------------------------
-------------------------- dark totem functions -------------------------
-------------------------------------------------------------------------

local function attack_attach(inst, target)
    if target.components.combat then
        target.components.combat.externaldamagemultipliers:SetModifier(inst, TUNING.BUFF_ATTACK_MULTIPLIER, "friendshiptotem_dark")
    end
end

local function attack_detach(inst, target)
    if target.components.combat then
        target.components.combat.externaldamagemultipliers:RemoveModifier(inst, "friendshiptotem_dark")
    end
end
-------------------------------------------------------------------------
------------------------- light totem functions -------------------------
-------------------------------------------------------------------------
local function get_aura_rate(inst)
    local aura_delta = 0
    local sanity = inst.components.sanity
    if sanity then
        if not sanity.sanity_aura_immune then
            local x, y, z = inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, TUNING.SANITY_AURA_SEACH_RANGE, { "sanityaura" }, { "FX", "NOCLICK", "DECOR","INLIMBO" })
            for i, v in ipairs(ents) do
                if v.components.sanityaura ~= nil and v ~= inst then
                    local is_aura_immune = false
                    if sanity.sanity_aura_immunities ~= nil then
                        for tag, _ in pairs(sanity.sanity_aura_immunities) do
                            if v:HasTag(tag) then
                                is_aura_immune = true
                                break
                            end
                        end
                    end

                    if not is_aura_immune then
                        local aura_val = v.components.sanityaura:GetAura(inst)
                        aura_val = (aura_val < 0 and (sanity.neg_aura_absorb > 0 and sanity.neg_aura_absorb * -aura_val or aura_val) * sanity.neg_aura_mult or aura_val)
                        aura_delta = aura_delta + ((aura_val < 0 and sanity.neg_aura_immune) and 0 or aura_val)
                    end
                end
            end
        end

        local mount = inst.components.rider:IsRiding() and inst.components.rider:GetMount() or nil
        if mount ~= nil and mount.components.sanityaura ~= nil then
            local aura_val = mount.components.sanityaura:GetAura(inst)
            aura_val = (aura_val < 0 and (sanity.neg_aura_absorb > 0 and sanity.neg_aura_absorb * -aura_val or aura_val) * sanity.neg_aura_mult or aura_val)
            aura_delta = aura_delta + ((aura_val < 0 and sanity.neg_aura_immune) and 0 or aura_val)
        end
    end
    return aura_delta < 0 and 0.5 or 2
end

local function sanity_attach(inst, target)
    if target.components.sanity then
        target.components.sanity.neg_aura_modifiers:SetModifier(inst, get_aura_rate(target), "friendshiptotem_light")
    end
end

local function sanity_detach(inst, target)
    if target.components.sanity then
        target.components.sanity.neg_aura_modifiers:RemoveModifier(inst, "friendshiptotem_light")
    end
end

-------------------------------------------------------------------------
----------------------- Prefab building functions -----------------------
-------------------------------------------------------------------------

local function OnTimerDone(inst, data)
    if data.name == "buffover" then
        inst.components.debuff:Stop()
    end
end

local function MakeBuff(name, onattachedfn, onextendedfn, ondetachedfn, duration, priority, prefabs)
    local function OnAttached(inst, target)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)

        -- target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_BUFF_"..string.upper(name), priority = priority })
        if onattachedfn ~= nil then
            onattachedfn(inst, target)
        end
    end

    local function OnExtended(inst, target)
        inst.components.timer:StopTimer("buffover")
        inst.components.timer:StartTimer("buffover", duration)

        -- target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_BUFF_"..string.upper(name), priority = priority })
        if onextendedfn ~= nil then
            onextendedfn(inst, target)
        end
    end

    local function OnDetached(inst, target)
        if ondetachedfn ~= nil then
            ondetachedfn(inst, target)
        end

        -- target:PushEvent("foodbuffdetached", { buff = "ANNOUNCE_DETACH_BUFF_"..string.upper(name), priority = priority })
        inst:Remove()
    end

    local function fn()
        local inst = CreateEntity()

        if not TheWorld.ismastersim then
            -- Not meant for client!
            inst:DoTaskInTime(0, inst.Remove)
            return inst
        end

        inst.entity:AddTransform()

        --[[Non-networked entity]]
        --inst.entity:SetCanSleep(false)
        inst.entity:Hide()
        inst.persists = false

        inst:AddTag("CLASSIFIED")

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(OnAttached)
        inst.components.debuff:SetDetachedFn(OnDetached)
        inst.components.debuff:SetExtendedFn(OnExtended)
        inst.components.debuff.keepondespawn = true

        inst:AddComponent("timer")
        inst.components.timer:StartTimer("buffover", duration)
        inst:ListenForEvent("timerdone", OnTimerDone)

        return inst
    end

    return Prefab("buff_"..name, fn, nil, prefabs)
end

return MakeBuff("friendshiptotem_dark", attack_attach, nil, attack_detach, 1, 1),
       MakeBuff("friendshiptotem_light", sanity_attach, nil, sanity_detach, 1, 1)

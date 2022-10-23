local Utils = require "ns_utils"

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

local function sanity_attach(inst, target)
    if target.components.sanity then
        target.components.sanity.neg_aura_modifiers:SetModifier(inst, Utils.GetAuraRate(target), "friendshiptotem_light")
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

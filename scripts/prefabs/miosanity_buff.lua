local BUFF_DURATION = 30
local BUFF_TICK_RATE = 2
local BUFF_TICK_VALUE = 1

local function OnTick(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
            if target.components.sanity ~= nil then
                target.components.sanity:DoDelta(BUFF_TICK_VALUE)
            end
    else
        inst.components.debuff:Stop()
    end
end

local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst.task = inst:DoPeriodicTask(BUFF_TICK_RATE, OnTick, nil, target)
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "regenover" then
        inst.components.debuff:Stop()
    end
end

local function OnExtended(inst, target)
    if (inst.components.timer:GetTimeLeft("regenover") or 0) < BUFF_DURATION then
        inst.components.timer:StopTimer("regenover")
        inst.components.timer:StartTimer("regenover", BUFF_DURATION)
    end
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = inst:DoPeriodicTask(BUFF_TICK_RATE, OnTick, nil, target)
    end
end

local function fn()
    local inst = CreateEntity()

    if not TheWorld.ismastersim then
        --Not meant for client!
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
    inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("regenover", BUFF_DURATION)
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("buff_miosanity", fn)

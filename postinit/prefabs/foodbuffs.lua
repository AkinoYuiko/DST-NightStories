local AddPrefabPostInitAny = AddPrefabPostInitAny
GLOBAL.setfenv(1, GLOBAL)

local function timer_fn(base_fn, buff_timer)
    return function(inst, target)
        FunctionOrValue(base_fn, inst, target)

        local duration = inst.components.timer:GetTimeLeft(buff_timer)

        if target and target.prefab == "civi" then
            local level_mult = 1 + target.level * 0.25

            inst.components.timer:StopTimer(buff_timer)
            inst.components.timer:StartTimer(buff_timer, duration * level_mult)
        end
    end
end

local known_buff_timers = {"buffover", "regenover"}
AddPrefabPostInitAny(function(inst)
    if not TheWorld.ismastersim then return end

    local debuff = inst.components.debuff
    if debuff and inst.components.timer then
        for _, buff_timer in ipairs(known_buff_timers) do
            if inst.components.timer.timers[buff_timer] then
                local onattachedfn = debuff.onattachedfn
                if onattachedfn then
                    debuff:SetAttachedFn(timer_fn(onattachedfn, buff_timer))
                end
                local onextendedfn = debuff.onextendedfn
                if onextendedfn then
                    debuff:SetExtendedFn(timer_fn(onextendedfn, buff_timer))
                end
            end
        end
    end
end)

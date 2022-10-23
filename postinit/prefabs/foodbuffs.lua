local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local function timer_fn(base_fn, name, duration)
    return function(inst, target)
        FunctionOrValue(base_fn, inst, target)

        if target and target.prefab == "civi" then
            local level_mult = 1 + target.level * 0.25

            inst.components.timer:StopTimer(name)
            inst.components.timer:StartTimer(name, duration * level_mult)
        end
    end
end

local function hack_fn(name, timer_name, duration)
    return function(inst)

        if not TheWorld.ismastersim then return end

        local Debuff = inst.components.debuff
        if Debuff then
            local onattachedfn = Debuff.onattachedfn
            local onextendedfn = Debuff.onextendedfn

            if onattachedfn then
                Debuff:SetAttachedFn(timer_fn(onattachedfn, timer_name or "buffover", duration))
            end

            if onextendedfn then
                Debuff:SetExtendedFn(timer_fn(onextendedfn, timer_name or "buffover", duration))
            end
        end
    end
end

local buffs ={
    buffover =
    {
        -- Warly's foodbuffs
        buff_attack = TUNING.BUFF_ATTACK_DURATION,
        buff_playerabsorption = TUNING.BUFF_PLAYERABSORPTION_DURATION,
        buff_workeffectiveness = TUNING.BUFF_WORKEFFECTIVENESS_DURATION,
        buff_moistureimmunity = TUNING.BUFF_MOISTUREIMMUNITY_DURATION,
        buff_electricattack = TUNING.BUFF_ELECTRICATTACK_DURATION,
        buff_sleepresistance = TUNING.SLEEPRESISTBUFF_TIME,
        -- Other Potions
        wintersfeastbuff = TUNING.WINTERSFEASTBUFF.DURATION_GAIN_BASE,
        -- halloweenpotion
        halloweenpotion_embers = TUNING.HALLOWEENPOTION_FIREFX_DURATION,
        halloweenpotion_sparks = TUNING.HALLOWEENPOTION_FIREFX_DURATION,
    },
    regenover =
    {
        -- jellybeans
        healthregenbuff = TUNING.JELLYBEAN_DURATION,
        -- halloweenpotion
        halloweenpotion_health_small = TUNING.SEG_TIME * 2,
        halloweenpotion_health_large = TUNING.SEG_TIME * 2,
        halloweenpotion_sanity_small = TUNING.SEG_TIME * 2,
        halloweenpotion_sanity_large = TUNING.SEG_TIME * 2,
        halloweenpotion_bravery_small = TUNING.TOTAL_DAY_TIME * .5,
        halloweenpotion_bravery_large = TUNING.TOTAL_DAY_TIME * .75,
        -- tillweedsalve_buff
        tillweedsalve_buff = TUNING.TILLWEEDSALVE_DURATION,
        -- sweettea_buff
        sweettea_buff = TUNING.SWEETTEA_DURATION,
    }

}

for timer, data in pairs(buffs) do
    for buff, duration in pairs(data) do
        AddPrefabPostInit(buff, hack_fn(buff, timer, duration))
    end
end

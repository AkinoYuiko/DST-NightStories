local function get_rate_from_table(t)
    local rate = 0
    local time = GetTime() - 1

    local j = 1
    for i = 1, #t do
        local val = t[i]
        if val.time < time then
            t[i] = nil
        else
            rate = rate + val.amount
            if i ~= j then
                t[j] = val
                t[i] = nil
            end
            j = j + 1
        end
    end

    return rate
end

local function table_insert_rate(t, amount)
    t[#t + 1] = {amount = amount, time = GetTime()}
end

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

local function target_testfn(target)
    if not target then return end
    if (not TheNet:GetPVPEnabled()) and target:HasTag("player") then return end
    return target:IsValid() and
        (target.components.health == nil or not target.components.health:IsDead()) and
        (target:HasTag("spiderden") or target:HasTag("wooden") or not target:HasTag("structure")) and
        not target:HasTag("wall")
end

local function do_glash_attack(attacker, target)
    local glash = SpawnPrefab("glash")
    glash.entity:SetParent(attacker.entity)
    local prev_damagemultiplier = attacker.components.combat.damagemultiplier
    attacker.components.combat.damagemultiplier = math.max(1, (prev_damagemultiplier or 1))
    attacker.components.combat:DoAttack(target, glash)
    attacker.components.combat.damagemultiplier = prev_damagemultiplier
end

return {
    GetRateFromTable = get_rate_from_table,
    TableInsertRate = table_insert_rate,
    GetAuraRate = get_aura_rate,
    TargetTestFn = target_testfn,
    DoGlashAttack = do_glash_attack,
}

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

return get_aura_rate

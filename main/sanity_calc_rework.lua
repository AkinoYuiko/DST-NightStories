local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local easing = require("easing")
local SourceModifierList = require("util/sourcemodifierlist")

local LIGHT_SANITY_DRAINS =
{
	[SANITY_MODE_INSANITY] = {
		DAY = TUNING.SANITY_DAY_GAIN,
		NIGHT_LIGHT = TUNING.SANITY_NIGHT_LIGHT,
		NIGHT_DIM = TUNING.SANITY_NIGHT_MID,
		NIGHT_DARK = TUNING.SANITY_NIGHT_DARK,
	},
	[SANITY_MODE_LUNACY] = {
		DAY = TUNING.SANITY_LUNACY_DAY_GAIN,
		NIGHT_LIGHT = TUNING.SANITY_LUNACY_NIGHT_LIGHT,
		NIGHT_DIM = TUNING.SANITY_LUNACY_NIGHT_MID,
		NIGHT_DARK = TUNING.SANITY_LUNACY_NIGHT_DARK,
	},
}


ENV.AddComponentPostInit("sanity", function(self)
    local SANITYRECALC_MUST_TAGS = { "sanityaura" }
    local SANITYRECALC_CANT_TAGS = { "FX", "NOCLICK", "DECOR","INLIMBO" }
    function self:Recalc(dt)
        local dapper_delta = 0
        if self.dapperness_mult ~= 0 then
            local total_dapperness = self.dapperness
            for k, v in pairs(self.inst.components.inventory.equipslots) do
                local equippable = v.components.equippable
                if equippable ~= nil and (not self.only_magic_dapperness or equippable.is_magic_dapperness) then
                    total_dapperness = total_dapperness + equippable:GetDapperness(self.inst, self.no_moisture_penalty)
                end
            end
    
            total_dapperness = total_dapperness * self.dapperness_mult
            dapper_delta = total_dapperness * TUNING.SANITY_DAPPERNESS
        end
    
        local moisture_delta = self.no_moisture_penalty and 0 or easing.inSine(self.inst.components.moisture:GetMoisture(), 0, TUNING.MOISTURE_SANITY_PENALTY_MAX, self.inst.components.moisture:GetMaxMoisture())
    
        local light_sanity_drain = LIGHT_SANITY_DRAINS[self.mode]
        local light_delta = 0
    
        if not self.light_drain_immune then
            if TheWorld.state.isday and not TheWorld:HasTag("cave") then
                light_delta = light_sanity_drain.DAY
            else
                local lightval = CanEntitySeeInDark(self.inst) and .9 or self.inst.LightWatcher:GetLightValue()
                light_delta =
                    (   (lightval > TUNING.SANITY_HIGH_LIGHT and light_sanity_drain.NIGHT_LIGHT) or
                        (lightval < TUNING.SANITY_LOW_LIGHT and light_sanity_drain.NIGHT_DARK) or
                        light_sanity_drain.NIGHT_DIM
                    ) * self.night_drain_mult
            end
        end
    
        local aura_delta = 0
        if not self.sanity_aura_immune then
            local x, y, z = self.inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, TUNING.SANITY_AURA_SEACH_RANGE, SANITYRECALC_MUST_TAGS, SANITYRECALC_CANT_TAGS)
            for i, v in ipairs(ents) do
                if v.components.sanityaura ~= nil and v ~= self.inst then
                    local is_aura_immune = false
                    if self.sanity_aura_immunities ~= nil then
                        for tag, _ in pairs(self.sanity_aura_immunities) do
                            if v:HasTag(tag) then
                                is_aura_immune = true
                                break
                            end
                        end
                    end
    
                    if not is_aura_immune then
                        local aura_val = v.components.sanityaura:GetAura(self.inst)
                        aura_val = (aura_val < 0 and (self.neg_aura_absorb > 0 and self.neg_aura_absorb * -aura_val or aura_val) * self:GetAuraMultipliers() or aura_val)
                        -- changed part begin --
                        local _inv = self.inst.components.inventory and self.inst.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.BODY)
                        local aura_amulet_mult = _inv ~= nil and (_inv.prefab == "lightamulet" and (aura_val < 0 and 0.5 or 2)) or 1
                        aura_val = aura_val * aura_amulet_mult
                        -- changed part end --
                        aura_delta = aura_delta + ((aura_val < 0 and self.neg_aura_immune) and 0 or aura_val)
                    end
                end
            end
        end
    
        local mount = self.inst.components.rider:IsRiding() and self.inst.components.rider:GetMount() or nil
        if mount ~= nil and mount.components.sanityaura ~= nil then
            local aura_val = mount.components.sanityaura:GetAura(self.inst)
            aura_val = (aura_val < 0 and (self.neg_aura_absorb > 0 and self.neg_aura_absorb * -aura_val or aura_val) * self:GetAuraMultipliers() or aura_val)
            -- changed part begin --
            local _inv = self.inst.components.inventory and self.inst.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.BODY)
            local aura_amulet_mult = _inv ~= nil and (_inv.prefab == "lightamulet" and (aura_val < 0 and 0.5 or 2)) or 1
            aura_val = aura_val * aura_amulet_mult
            -- changed part end --
            aura_delta = aura_delta + ((aura_val < 0 and self.neg_aura_immune) and 0 or aura_val)
        end
    
        self:RecalcGhostDrain()
        local ghost_delta = TUNING.SANITY_GHOST_PLAYER_DRAIN * self.ghost_drain_mult
    
        self.rate = dapper_delta + moisture_delta + light_delta + aura_delta + ghost_delta + self.externalmodifiers:Get()
    
        if self.custom_rate_fn ~= nil then
            --NOTE: dt param was added for wormwood's custom rate function
            --      dt shouldn't have been applied to the return value yet
            self.rate = self.rate + self.custom_rate_fn(self.inst, dt)
        end
    
        self.rate = self.rate * self.rate_modifier
        self.ratescale =
            (self.rate > .2 and RATE_SCALE.INCREASE_HIGH) or
            (self.rate > .1 and RATE_SCALE.INCREASE_MED) or
            (self.rate > .01 and RATE_SCALE.INCREASE_LOW) or
            (self.rate < -.3 and RATE_SCALE.DECREASE_HIGH) or
            (self.rate < -.1 and RATE_SCALE.DECREASE_MED) or
            (self.rate < -.02 and RATE_SCALE.DECREASE_LOW) or
            RATE_SCALE.NEUTRAL
    
        --print (string.format("dapper: %2.2f light: %2.2f TOTAL: %2.2f", dapper_delta, light_delta, self.rate*dt))
        self:DoDelta(self.rate * dt, true)
    end
end)
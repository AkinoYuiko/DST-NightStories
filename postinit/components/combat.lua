local Combat = require("components/combat")
local _DoAttack = Combat.DoAttack
local CHAIN_MUST_TAGS = { "chain" }
function Combat:DoAttack(target, weapon, ...)
    if target == nil then
        target = self.target
    end

    if target:HasTag("chain") then
        local x, y, z = target.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, TUNING.CHAIN_RANGE, CHAIN_MUST_TAGS)
        for _, ent in ipairs(ents) do
            if ent ~= target then
                local _CanHitTarget = self.CanHitTarget
                self.CanHitTarget = function()
                    return _CanHitTarget(self, target, weapon)
                end
                _DoAttack(self, ent, ...)
                self.CanHitTarget = _CanHitTarget
            end
        end
    end

    return _DoAttack(self, target, weapon, ...)
end

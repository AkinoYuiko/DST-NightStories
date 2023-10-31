GLOBAL.setfenv(1, GLOBAL)

local Combat = require("components/combat")
local do_attack = Combat.DoAttack
local CHAIN_MUST_TAGS = { "horrorchain" }
function Combat:DoAttack(target, weapon, ...)
    if target == nil then
        target = self.target
    end

    if target:HasTag("horrorchain") then
        print("SHABI", target)
        local x, y, z = target.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, TUNING.HORRORCHAIN_DIST, CHAIN_MUST_TAGS)
        for _, ent in ipairs(ents) do
            if ent ~= target then
                print("sb", ent)
                local _CanHitTarget = self.CanHitTarget
                self.CanHitTarget = function()
                    return _CanHitTarget(self, target, weapon)
                end
                do_attack(self, ent, weapon, ...)
                self.CanHitTarget = _CanHitTarget
            end
        end
    end

    return do_attack(self, target, weapon, ...)
end

GLOBAL.setfenv(1, GLOBAL)

local GLASH_PREFABS = {
    glash = true,
    gflash = true,
    alterguardianhat_projectile = true,
}

local Combat = require("components/combat")
local do_attack = Combat.DoAttack
function Combat:DoAttack(target, weapon, ...)
    if target == nil then
        target = self.target
    end

    if TheWorld.components.horrorchainmanager:HasMember(target) and not GLASH_PREFABS[self.inst.prefab] then -- glash should NOT trigger chain attack.
        local ents = TheWorld.components.horrorchainmanager:GetNearbyMembers(target)
        for _, ent in ipairs(ents) do
            if ent ~= target then
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

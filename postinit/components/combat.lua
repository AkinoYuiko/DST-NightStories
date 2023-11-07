GLOBAL.setfenv(1, GLOBAL)

local GLASH_PREFABS = {
    glash = true,
    gflash = true,
    alterguardianhat_projectile = true,
}

local Combat = require("components/combat")

local function is_invalid_weapon(weapon)
    return weapon and not weapon.components.weapon
end

local do_attack = Combat.DoAttack
local function do_attack_with_check(self, target, weapon, ...)
    if not is_invalid_weapon(weapon) then
        return do_attack(self, target, weapon, ...)
    end
end

function Combat:DoAttack(target, weapon, ...)
    if target == nil then
        target = self.target
    end

    local main_attack = do_attack(self, target, weapon, ...)
    
    if TheWorld.components.horrorchainmanager:HasMember(target) and not GLASH_PREFABS[self.inst.prefab] then -- glash should NOT trigger chain attack.
        local ents = TheWorld.components.horrorchainmanager:GetNearbyMembers(target)
        for _, ent in ipairs(ents) do
            if ent ~= target then
                local can_hit_target = self.CanHitTarget
                self.CanHitTarget = function()
                    return can_hit_target(self, target, weapon)
                end
                do_attack_with_check(self, ent, weapon, ...)
                self.CanHitTarget = can_hit_target
            end
        end
    end

    return main_attack
end

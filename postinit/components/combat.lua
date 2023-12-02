GLOBAL.setfenv(1, GLOBAL)

local DISABLED_WEAPONS =
{
    glash = true,
    alterguardianhat = true,
}

local DISABLED_ENTITIES =
{
    alterguardianhat_projectile = true
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

local function launching_projectile_testfn(weapon, projectile)
    return weapon and projectile == nil
        and (weapon.components.projectile
            or weapon.components.complexprojectile
            or weapon.components.weapon:CanRangedAttack())
end

function Combat:DoAttack(target, weapon, projectile, ...)
    if target == nil then
        target = self.target
    end

    local main_attack = do_attack(self, target, weapon, projectile, ...)
 
    if launching_projectile_testfn(weapon, projectile) then
        return main_attack
    elseif weapon and DISABLED_WEAPONS[weapon.prefab] then
        return main_attack
    elseif DISABLED_ENTITIES[self.inst.prefab] then
        return main_attack
    end
    
    if TheWorld.components.horrorchainmanager:HasMember(target) then
        local ents = TheWorld.components.horrorchainmanager:GetNearbyMembers(target)
        for _, ent in ipairs(ents) do
            if ent ~= target then
                local can_hit_target = self.CanHitTarget
                self.CanHitTarget = function()
                    return can_hit_target(self, target, weapon)
                end
                do_attack_with_check(self, ent, weapon, projectile, ...)
                self.CanHitTarget = can_hit_target
            end
        end
    end

    return main_attack
end

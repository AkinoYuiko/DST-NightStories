GLOBAL.setfenv(1, GLOBAL)

local PlanarEntity = require("components/planarentity")
local AbsorbDamage = PlanarEntity.AbsorbDamage

function PlanarEntity:AbsorbDamage(damage, attacker, weapon, spdmg, ...)
    -- print(attacker)
    if (attacker and attacker:HasTag("ignore_planar_entity")) or (weapon and weapon:HasTag("ignore_planar_entity")) then
        return damage, spdmg
    end
    return AbsorbDamage(self, damage, attacker, weapon, spdmg, ...)
end

NS_PLANARENTITY_HACKING = true

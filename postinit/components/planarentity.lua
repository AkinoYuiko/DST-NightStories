GLOBAL.setfenv(1, GLOBAL)

local PlanarEntity = require("components/planarentity")
local AbsorbDamage = PlanarEntity.AbsorbDamage

local function check_tag(attacker, weapon)
    local TAG = "ignore_planar_entity"
    if attacker and attacker:HasTag(TAG) then
        return true
    elseif weapon and weapon:HasTag(TAG) then
        return true
    end
end

function PlanarEntity:AbsorbDamage(damage, attacker, weapon, spdmg, ...)
    if check_tag(attacker, weapon) then
        return damage, spdmg
    end
    return AbsorbDamage(self, damage, attacker, weapon, spdmg, ...)
end

NS_PLANARENTITY_HACKING = true

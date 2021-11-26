local AddComponentAction = AddComponentAction
GLOBAL.setfenv(1, GLOBAL)

local function BlackHoleOnTarget(inst, doer, target, actions, right)
    if inst.prefab ~= "blackholestaff" then return end
    if right then
        if target and target == doer or ( target:HasTag("_inventoryitem") and
        not (
          target:HasTag("INLIMBO") or
          target:HasTag("NOCLICK") or
          target:HasTag("catchable") or
          target:HasTag("fire") or
          target:HasTag("minesprung") or
          target:HasTag("mineactive") or
          target:HasTag("smallcreature")
        )) then
        	table.insert(actions, ACTIONS.CASTSPELL)
        end
    end
end

AddComponentAction("EQUIPPED", "spellcaster", BlackHoleOnTarget)

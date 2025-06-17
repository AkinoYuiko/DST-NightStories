local AddComponentAction = AddComponentAction
GLOBAL.setfenv(1, GLOBAL)

local TARGET_NOT_TAGS = {"INLIMBO", "NOCLICK", "catchable", "fire", "minesprung", "mineactive", "smallcreature"}
local function target_test_fn(target)
	return target:HasTag("_inventoryitem") and not target:HasAnyTag(TARGET_NOT_TAGS)
end

AddComponentAction("EQUIPPED", "spellcaster", function(inst, doer, target, actions, right)
	if inst.prefab ~= "blackholestaff" then return end
	if right then
		if target and target == doer or target_test_fn(target) then
			table.insert(actions, ACTIONS.CASTSPELL)
		end
	end
end)

local TARGET_STATE_TAGS = {"flight", "invisible", "nospellcasting"}
local SpellCaster = require("components/spellcaster")
local can_cast = SpellCaster.CanCast
function SpellCaster:CanCast(doer, target, pos, ...)
	if self.inst.prefab == "blackholestaff" then
		if target == nil then
			if pos == nil then
				return self.canusefrominventory
			end

			if self.canuseonpoint then
				local px, py, pz = pos:Get()
				return TheWorld.Map:IsAboveGroundAtPoint(px, py, pz, self.canuseonpoint_water) and not TheWorld.Map:IsGroundTargetBlocked(pos)
			elseif self.canuseonpoint_water then
				return TheWorld.Map:IsOceanAtPoint(pos:Get()) and not TheWorld.Map:IsGroundTargetBlocked(pos)
			else
				return false
			end
		elseif target:IsInLimbo()
			or not target.entity:IsVisible()
			or (target.components.health ~= nil and target.components.health:IsDead() and not self.canuseondead)
			or (target.sg ~= nil and (
					target.sg.currentstate.name == "death" or
					target.sg:HasAnyStateTag(TARGET_STATE_TAGS)
				)) then
			return false
		else
			return target == doer or target_test_fn(target)
		end
	else
		return can_cast(self, doer, target, pos, ...)
	end
end

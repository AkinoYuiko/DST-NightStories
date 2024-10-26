local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

-- [[ Reset Insight ]] --
local SkillTreeUpdater = require("components/skilltreeupdater")
local deactivate_skill = SkillTreeUpdater.DeactivateSkill
function SkillTreeUpdater:DeactivateSkill(...)
	local prev = self.skilltree.skip_validation
	self:SetSkipValidation(true)
	deactivate_skill(self, ...)
	self:SetSkipValidation(prev)
end

local SKILLTREE_DEFS = require("prefabs/skilltree_defs").SKILLTREE_DEFS
for char in pairs(SKILLTREE_DEFS) do
	AddPrefabPostInit(char, function(inst)
		inst:AddTag("skilltree_characters")
	end)
end

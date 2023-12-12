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

local SKILLTREE_CHARACTERS = {
    "wilson",
    "woodie",
    "wolfgang",
    "wormwood",
}
for _, char in ipairs(SKILLTREE_CHARACTERS) do
    AddPrefabPostInit(char, function(inst)
        inst:AddTag("skilltree_characters")
    end)
end

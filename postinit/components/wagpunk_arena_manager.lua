-- local AddPrefabPostInit = AddPrefabPostInit
---@diagnostic disable-next-line
GLOBAL.setfenv(1, GLOBAL)

local WagpunkArenaManager = require("components/wagpunk_arena_manager")
local add_wagboss_defeated_recipes = WagpunkArenaManager.AddWagbossDefeatedRecipes
function WagpunkArenaManager:AddWagbossDefeatedRecipes()
	add_wagboss_defeated_recipes(self)
	if self.workstation then
		self.workstation.components.craftingstation:LearnItem("lunarshadow", "lunarshadow")
	end
end

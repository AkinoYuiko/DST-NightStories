GLOBAL.setfenv(1, GLOBAL)

local NS_SPICES = {
	SPICE_CACTUS = {},
	SPICE_MOONGLASS = {
		oneatenfn = function(_inst, eater)
			eater:AddDebuff("buff_glash", "buff_glash")
		end,
	},
}

require("cooking")
local spicedfoods = require("spicedfoods")
local UpvalueUtil = GlassicAPI.UpvalueUtil

local SPICES = UpvalueUtil.GetUpvalue(GenerateSpicedFoods, "SPICES")
if not SPICES then
	print("U GOT NOPED SO HARD GAGAGA")
	return
end -- :angri:
shallowcopy(NS_SPICES, SPICES)

GenerateSpicedFoods(require("preparedfoods"))
GenerateSpicedFoods(require("preparedfoods_warly"))

for _, recipe in pairs(spicedfoods) do
	if NS_SPICES[recipe.spice] ~= nil then
		AddCookerRecipe("portablespicer", recipe)
		if recipe.basename == "voltgoatjelly" then -- WX78
			TUNING.WX78_CHARGING_FOODS[recipe.name] = 1
		end
	end
end

------------------------------------------------

local anim_state_override_symbol = AnimState.OverrideSymbol
function AnimState:OverrideSymbol(symbol, override_build, override_symbol, ...)
	if symbol == "swap_garnish" and override_build == "spices" and NS_SPICES[override_symbol:upper()] then
		override_build = "ns_spices"
	end
	return anim_state_override_symbol(self, symbol, override_build, override_symbol, ...)
end

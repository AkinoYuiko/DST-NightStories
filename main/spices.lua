local ENV = env
GLOBAL.setfenv(1, GLOBAL)

NS_SPICES = {
    SPICE_CACTUS = {}
}

require("cooking")
local spicedfoods = require("spicedfoods")
local UpvalueHacker = require("upvaluehacker")

local SPICES = UpvalueHacker.GetUpvalue(GenerateSpicedFoods, "SPICES")
if not SPICES then print("U GOT NOPED SO HARD GAGAGA") return end  -- :angri:
shallowcopy(NS_SPICES, SPICES)

GenerateSpicedFoods(require("preparedfoods"))
GenerateSpicedFoods(require("preparedfoods_warly"))

for _, recipe in pairs(spicedfoods) do
    if NS_SPICES[recipe.spice] then
        AddCookerRecipe("portablespicer", recipe)
    end
end

------------------------------------------------

local OverrideSymbol = AnimState.OverrideSymbol
AnimState.OverrideSymbol = function(self, symbol, override_build, override_symbol, ...)
    if symbol == "swap_garnish" and override_build == "spices" and NS_SPICES[override_symbol:upper()] then
        override_build = "ns_spices"
    end
    return OverrideSymbol(self, symbol, override_build, override_symbol, ...)
end

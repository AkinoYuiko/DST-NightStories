local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local TRADERS_ACCEPTING_WHOLE_STACKS = {
	["pigking"] = true,
	["birdcage"] = true,
	["antlion"] = true,
}

local Trader = require("components/trader")
local AcceptGift = Trader.AcceptGift
function Trader:AcceptGift(giver, item, count)
	if TRADERS_ACCEPTING_WHOLE_STACKS[self.inst.prefab] then
		count = item and item.components.stackable and item.components.stackable.stacksize or count
	end
	return AcceptGift(self, giver, item, count)
end

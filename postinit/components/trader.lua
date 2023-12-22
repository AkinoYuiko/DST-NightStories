local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local Trader = require("components/trader")
local AcceptGift = Trader.AcceptGift
function Trader:AcceptGift(giver, item, count)
    if self.inst.prefab == "pigking" and item and item.components.tradable and item.components.tradable.goldvalue then
        count = item.components.stackable and item.components.stackable.stacksize
    end
    return AcceptGift(self, giver, item, count)
end

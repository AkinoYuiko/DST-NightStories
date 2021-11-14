local NS_STACK_SIZES =
{
    TUNING.STACK_SIZE_PLUSITEM,
    TUNING.STACK_SIZE_MEDITEM,
    TUNING.STACK_SIZE_SMALLITEM,
    TUNING.STACK_SIZE_LARGEITEM,
    TUNING.STACK_SIZE_TINYITEM,
}
local NS_STACK_SIZE_CODES = table.invert(NS_STACK_SIZES)

local Stackable = require "components/stackable_replica"
Stackable.SetMaxSize = function(self, maxsize)
    self._maxsize:set(NS_STACK_SIZE_CODES[maxsize] - 1)
end

Stackable.MaxSize = function(self)
    return NS_STACK_SIZES[self._maxsize:value() + 1]
end
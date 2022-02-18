GLOBAL.setfenv(1, GLOBAL)

local Stackable = require("components/stackable_replica")
local STACK_SIZES = require("upvalueutil").GetUpvalue(Stackable.MaxSize, "STACK_SIZES")
STACK_SIZES[#STACK_SIZES + 1] = TUNING.STACK_SIZE_PLUSITEM

local STACK_SIZE_CODES = table.invert(STACK_SIZES)
function Stackable:SetMaxSize(maxsize)
    self._maxsize:set(STACK_SIZE_CODES[maxsize] - 1)
end

function Stackable:MaxSize()
    return STACK_SIZES[self._maxsize:value() + 1]
end

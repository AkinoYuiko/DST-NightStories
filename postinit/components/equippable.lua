GLOBAL.setfenv(1, GLOBAL)

local Equippable = require("components/equippable")
local get_dapperness = Equippable.GetDapperness
function Equippable:GetDapperness(owner, ignore_wetness, ...)
	local dapperness = get_dapperness(self, owner, ignore_wetness, ...)
	local mult = 1
	if owner and owner:HasDebuff("buff_friendshiptotem_light") then
		mult =  dapperness > 0 and 2 or 0.5
	end
	return dapperness * mult
end

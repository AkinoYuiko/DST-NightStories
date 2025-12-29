-- local AddComponentPostInit = AddComponentPostInit
local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local Moisture = require("components/moisture")
local MoistureReplica = require("components/moisture_replica")

AddPrefabPostInit("player_classified", function(inst)
	inst._moisture_rate = net_float(inst.GUID, "moisture._moisture_rate")
end)

function MoistureReplica:GetMoistureRate()
	if self.inst.components.moisture then
		return self.inst.components.moisture:_GetMoistureRateAssumingRain()
	elseif self.inst.player_classified then
		return self.inst.player_classified._moisture_rate:value()
	else
		return 0
	end
end

local moisutre_update = Moisture.OnUpdate
function Moisture:OnUpdate(...)
	moisutre_update(self, ...)
	local rate = self:_GetMoistureRateAssumingRain()
	if self.inst.player_classified then
		self.inst.player_classified._moisture_rate:set(rate)
	end
end

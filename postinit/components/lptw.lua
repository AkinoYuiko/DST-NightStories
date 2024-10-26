GLOBAL.setfenv(1, GLOBAL)

local LunarPlant_Tentacle_Weapon = require("components/lunarplant_tentacle_weapon")
function LunarPlant_Tentacle_Weapon:OnRemoveFromEntity()
	self.inst:RemoveEventCallback("equipped", self._equipped_callback)
	self.inst:RemoveEventCallback("unequipped", self._unequipped_callback)
	if self.owner then
		self.inst:RemoveEventCallback("onattackother", self._on_attack, self.owner)
		self.inst:RemoveEventCallback("onremove", self._erase_owner, self.owner)
	end
end

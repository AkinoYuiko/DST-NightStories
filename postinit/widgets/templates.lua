GLOBAL.setfenv(1, GLOBAL)

local TEMPLATES = require("widgets/redux/templates")

local MakeUIStatusBadge = TEMPLATES.MakeUIStatusBadge
function TEMPLATES.MakeUIStatusBadge(_status_name, c, ...)
	-- print("TEMPLATES.MakeUIStatusBadge", _status_name, c)
	local status = MakeUIStatusBadge(_status_name, c, ...)
	local ChangeCharacter = status.ChangeCharacter
	status.ChangeCharacter = function(self, character, ...)
		-- print("status.ChangeCharacter", _status_name, character)
		if character == "dummy" then
			if _status_name == "sanity" then
				self:Hide()
				return
			elseif _status_name == "health" then
				self.status_icon:SetTexture("images/hud/dummy_status_health.xml", "status_" .. _status_name .. ".tex")
				return
			end
		end
		self:Show()
		return ChangeCharacter(self, character, ...)
	end
	if c ~= nil then
		status:ChangeCharacter(c)
	end
	return status
end

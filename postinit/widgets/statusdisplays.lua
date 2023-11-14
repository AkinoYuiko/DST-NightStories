GLOBAL.setfenv(1, GLOBAL)

-- Dummy Badge --
local StatusDisplays = require("widgets/statusdisplays")
function StatusDisplays:HideDummyBrain()
    if self.owner and self.owner.prefab == "dummy" then
        if self.brain then self.brain:Hide() end
        if self.moisturemeter then self.moisturemeter:SetPosition(0, -40, 0) end
    end
end
StatusDisplays:HideDummyBrain()
local set_ghost_mode = StatusDisplays.SetGhostMode
function StatusDisplays:SetGhostMode(...)
    set_ghost_mode(self, ...)
    self:HideDummyBrain()
end

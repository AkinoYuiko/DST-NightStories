GLOBAL.setfenv(1, GLOBAL)

local ForgeRepair = require("components/forgerepair")
local on_repair = ForgeRepair.OnRepair
function ForgeRepair:OnRepair(target, doer)
    if on_repair(self, target, doer) then return true end
    local success
    if target.components.perishable ~= nil then
        if target.components.perishable:GetPercent() < 1 then
            target.components.perishable:SetPercent(1)
            success = true
        end
    end

    if success then
        if self.inst.components.finiteuses ~= nil then
            self.inst.components.finiteuses:Use(1)
        elseif self.inst.components.stackable ~= nil then
            self.inst.components.stackable:Get():Remove()
        else
            self.inst:Remove()
        end

        if self.onrepaired ~= nil then
            self.onrepaired(self.inst, target, doer)
        end
        return true
    end
end

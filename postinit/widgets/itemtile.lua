local UIAnim = require "widgets/uianim"
local FX =
{
    L = "inventory_fx_moonlight",
    S = "inventory_fx_shadow",
}

local function update_fx(self, var, bank_and_build)
    if self.item[var]:value() then
        if not self.itemtile_fx then
            self.itemtile_fx = self.image:AddChild(UIAnim())
            self.itemtile_fx:GetAnimState():SetBank(bank_and_build)
            self.itemtile_fx:GetAnimState():SetBuild(bank_and_build)
            self.itemtile_fx:GetAnimState():PlayAnimation("idle", true)
            self.itemtile_fx:GetAnimState():SetTime(math.random() * self.itemtile_fx:GetAnimState():GetCurrentAnimationTime())
            self.itemtile_fx:SetScale(.25)
            self.itemtile_fx:GetAnimState():AnimateWhilePaused(false)
            self.itemtile_fx:SetClickable(false)
        end
    else
        if self.itemtile_fx then
            self.itemtile_fx:Kill()
            self.itemtile_fx = nil
        end
    end
end

local function update_meter(self)
    if self.item.buffed:value() and not self.item.replica.container:IsEmpty() then
        self.bg:Hide()
        self.percent:Hide()
        self.spoilage:Hide()
    else
        self.percent:Show()
        self:Refresh()
    end
end

AddClassPostConstruct("widgets/itemtile", function(self)
    if self.item.prefab == "moonlight_shadow"then
        update_fx(self,"buffed",FX.L)
        update_meter(self)
        self.inst:ListenForEvent("moonlight_shadow.buffdirty", function()
            update_fx(self,"buffed",FX.L)
            update_meter(self)
        end, self.item)
        self.inst:ListenForEvent("itemget", function() update_meter(self) end, self.item)
        self.inst:ListenForEvent("itemlose", function() update_meter(self) end, self.item)

    elseif self.item.prefab == "friendshiptotem_dark" then
        update_fx(self,"toggled",FX.S)
        self.inst:ListenForEvent("friendshiptotem.toggledirty", function()
            update_fx(self,"toggled",FX.S)
        end, self.item)
    elseif self.item.prefab == "friendshiptotem_light"then
        update_fx(self,"toggled",FX.L)
        self.inst:ListenForEvent("friendshiptotem.toggledirty", function()
            update_fx(self,"toggled",FX.L)
        end, self.item)
    end
end)

local UIAnim = require "widgets/uianim"

local function update_moonlight_shadow_fx(self)
    if self.item.is_buffed:value() then
        if not self.moonlight_shadow_fx then
            self.moonlight_shadow_fx = self.image:AddChild(UIAnim())
            self.moonlight_shadow_fx:GetAnimState():SetBank("inventory_fx_moonlight")
            self.moonlight_shadow_fx:GetAnimState():SetBuild("inventory_fx_moonlight")
            self.moonlight_shadow_fx:GetAnimState():PlayAnimation("idle", true)
            self.moonlight_shadow_fx:GetAnimState():SetTime(math.random() * self.moonlight_shadow_fx:GetAnimState():GetCurrentAnimationTime())
            self.moonlight_shadow_fx:SetScale(.25)
            self.moonlight_shadow_fx:GetAnimState():AnimateWhilePaused(false)
            self.moonlight_shadow_fx:SetClickable(false)
        end
    else
        if self.moonlight_shadow_fx then
            self.moonlight_shadow_fx:Kill()
            self.moonlight_shadow_fx = nil
        end
    end
end

AddClassPostConstruct("widgets/itemtile", function(self)
    if self.item.prefab ~= "moonlight_shadow" then
        return
    end

    update_moonlight_shadow_fx(self)
    self.inst:ListenForEvent("moonlight_shadow_buffed", function()
        update_moonlight_shadow_fx(self)
    end, self.item)
end)

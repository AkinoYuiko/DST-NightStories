----------------------------------------------------------------------------------------
--This is for Island Adventures
----------------------------------------------------------------------------------------
local AddClassPostConstruct = AddClassPostConstruct
GLOBAL.setfenv(1, GLOBAL)

if require("nsutils/check_ia") then

    local UIAnim = require("widgets/uianim")

    ----------------------------------------------------------------------------------------
    local DummyBadge = require("widgets/dummybadge")

    local _OnUpdate = DummyBadge.OnUpdate
    function DummyBadge:OnUpdate(...)
        _OnUpdate(self, ...)

        local poison = self.owner.ispoisoned or (self.owner.player_classified and self.owner.player_classified.ispoisoned:value())

        if self.poison ~= poison then
            self.poison = poison
            if poison then
                self.poisonanim:GetAnimState():PlayAnimation("activate")
                self.poisonanim:GetAnimState():PushAnimation("idle", true)
                self.poisonanim:Show()
            else
                self.owner.SoundEmitter:PlaySound("ia/common/antivenom_use")
                self.poisonanim:GetAnimState():PlayAnimation("deactivate")
            end
        end
    end

    ----------------------------------------------------------------------------------------
    --Try to initialise all functions locally outside of the post-init so they exist in RAM only once
    ----------------------------------------------------------------------------------------
    local function widgethealth(widget)
        widget.poisonanim = widget.underNumber:AddChild(UIAnim())
        widget.poisonanim:GetAnimState():SetBank("poison")
        widget.poisonanim:GetAnimState():SetBuild("poison_meter_overlay")
        widget.poisonanim:GetAnimState():PlayAnimation("deactivate")
        widget.poisonanim:Hide()
        widget.poisonanim:SetClickable(false)
        widget.poison = false -- So it doesn't trigger on load
    end
    AddClassPostConstruct("widgets/dummybadge", widgethealth)

end

local AddPrefabPostInit = AddPrefabPostInit
local AddClassPostConstruct = AddClassPostConstruct
GLOBAL.setfenv(1, GLOBAL)

local ROSE_NAME = "rose"
local rewardtable =
{
    "miotan", 
    "dummy"
}
local nightmare_prefabs =
{
    "crawlinghorror",
    "terrorbeak",
    "swimminghorror",
}

for _, prefab in ipairs(nightmare_prefabs) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then return end

        local oldOnKilledByOther = inst.components.combat.onkilledbyother
        inst.components.combat.onkilledbyother = function(inst, attacker)
            if attacker and table.contains(rewardtable, attacker.prefab) and attacker.components.sanity then
                attacker.components.sanity:DoDelta((inst.sanityreward or TUNING.SANITY_SMALL) * 0.5)
            else
                oldOnKilledByOther(inst, attacker)
            end
        end
    end)
end

local function new_onpickedfn(inst, picker)
    local pos = inst:GetPosition()

    if picker then
        if picker.components.sanity and not picker:HasTag("plantkin") and not picker:HasTag("nm_breaker") then -- changed part from original fn
            picker.components.sanity:DoDelta(TUNING.SANITY_TINY)
        end

        if inst.animname == ROSE_NAME and
            picker.components.combat and
            not (picker.components.inventory and picker.components.inventory:EquipHasTag("bramble_resistant")) then
            picker.components.combat:GetAttacked(inst, TUNING.ROSE_DAMAGE)
            picker:PushEvent("thorns")
        end
    end

    if not inst.planted then
        TheWorld:PushEvent("beginregrowth", inst)
    end

    inst:Remove()

    TheWorld:PushEvent("plantkilled", { doer = picker, pos = pos }) --this event is pushed

end

AddPrefabPostInit("flower", function(inst)
    if not TheWorld.ismastersim then return end

    if inst.components.pickable then
        inst.components.pickable.onpickedfn = new_onpickedfn
    end
end)

local function new_onpickedfn_evil(inst, picker)
    if picker and picker.components.sanity and not picker:HasTag("nm_breaker") then
        picker.components.sanity:DoDelta(-TUNING.SANITY_TINY)
    end
    inst:Remove()
end

AddPrefabPostInit("flower_evil", function(inst)
    if not TheWorld.ismastersim then return end

    if inst.components.pickable then
        inst.components.pickable.onpickedfn = new_onpickedfn_evil
    end
end)

AddClassPostConstruct("widgets/statusdisplays", function(self)
    self.HideDummyBrain = function(self)
        if self.owner and self.owner.prefab == "dummy" then
            if self.brain then self.brain:Hide() end
            if self.moisturemeter then self.moisturemeter:SetPosition(0, -40, 0) end
        end
    end
    self:HideDummyBrain()

    local SetGhostMode = self.SetGhostMode
    self.SetGhostMode = function(self, ghostmode)
        SetGhostMode(self, ghostmode)
        self:HideDummyBrain()
    end
end)

local CHAIN_TAG = "horrorchain"

local HorrorChainManager = Class(function(self, inst)
    self.inst = inst
    -- [member: EntityScript]: Periodic
    self.members = {}
    -- [member: EntityScript]: EntityScript
    self.fxs = {}

    self._remove_member = function(target) self:RemoveMember(target) end
end)

local function create_fx(self, target)
    if not self.fxs[target] then
        local SCALE = 0.25
        local fx = SpawnPrefab("deer_ice_fx")
        fx.Transform:SetPosition(0, 3, 0)
        fx.AnimState:SetScale(SCALE, SCALE, SCALE)
        target:AddChild(fx)
        self.fxs[target] = fx
    end
end

local function remove_fx(self, target)
    if self.fxs[target] then
        self.fxs[target]:Remove()
        self.fxs[target] = nil
    end
end

local function cancel_existing_timer(self, target)
    self.members[target]:Cancel()
end

function HorrorChainManager:AddMember(target, duration, force_override_timer)
    -- Refresh timer only on existing member
    if self:HasMember(target) then
        if force_override_timer or self:GetMemberTimeRemaining(target) < duration then
            cancel_existing_timer(self, target)
            self.members[target] = target:DoTaskInTime(duration, self._remove_member)
        end
    else
        target:AddTag(CHAIN_TAG)
        create_fx(self, target)
        self.members[target] = target:DoTaskInTime(duration, self._remove_member)
        target:ListenForEvent("remove", self._remove_member)
    end
end

function HorrorChainManager:RemoveMember(target)
    if not self:HasMember(target) then
        return
    end

    cancel_existing_timer(self, target)
    target:RemoveTag(CHAIN_TAG)
    remove_fx(self, target)
    self.members[target] = nil
    target:RemoveEventCallback("remove", self._remove_member)
end

function HorrorChainManager:HasMember(target)
    return self.members[target]
end

function HorrorChainManager:GetMemberTimeRemaining(target)
    return GetTaskRemaining(self.members[target])
end

function HorrorChainManager:OnSave()
    local members = {}
    local references = {}
    for member, task in pairs(self.members) do
        members[member.GUID] = GetTaskRemaining(task)
        table.insert(references, member.GUID)
    end
    return { members = members }, references
end

-- function HorrorChainManager:OnLoad()

-- end

function HorrorChainManager:LoadPostPass(newents, save_data)
    if save_data and save_data.members then
        for member, remaining_time in pairs(save_data.members) do
            if newents[member] then
                self:AddMember(newents[member].entity, remaining_time)
            end
        end
    end
end

function HorrorChainManager:GetNearbyMembers(member)
    if self:HasMember(member) then
        local x, y, z = member.Transform:GetWorldPosition()
        return TheSim:FindEntities(x, y, z, TUNING.HORRORCHAIN_DIST, { CHAIN_TAG })
    end
    return {}
end

return HorrorChainManager

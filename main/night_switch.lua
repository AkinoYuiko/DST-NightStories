local AddAction = AddAction
local AddComponentAction = AddComponentAction
local AddPrefabPostInit = AddPrefabPostInit
local AddStategraphActionHandler = AddStategraphActionHandler
GLOBAL.setfenv(1, GLOBAL)

local NIGHTSWITCH = Action({mount_valid=true, priority = 1})

NIGHTSWITCH.id = "NIGHTSWITCH"
NIGHTSWITCH.str = STRINGS.ACTIONS.USEITEM
NIGHTSWITCH.fn = function(act)
    local doer = act.doer
    local level = doer.level
    if doer.components.inventory then
        local item = doer.components.inventory:RemoveItem(act.invobject)
        if item.prefab == "darkgem" then
            doer.level = level + 1
            if doer.level < 2 then
                doer.components.talker:Say(STRINGS.CIVI_GEMS.FEEL_DARK, 3)
            else
                doer.components.talker:Say(STRINGS.CIVI_GEMS.ALREADY_DARK, 3)
            end
        elseif item.prefab == "lightgem" then
            doer.level = level - 1
            if doer.level > 0 then
                doer.components.talker:Say(STRINGS.CIVI_GEMS.FEEL_LIGHT, 3)
            else
                doer.components.talker:Say(STRINGS.CIVI_GEMS.ALREADY_LIGHT, 3)
            end
        end



        doer.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        if doer.applylevelfn ~= nil then doer.applylevelfn(doer) end
        item:Remove()
        return true
    end
end

AddAction(NIGHTSWITCH)
AddComponentAction("INVENTORY", "nightswitch", function(inst, doer, actions, right)
    if doer.prefab ~= "civi" then return end
    if doer.replica.inventory:GetActiveItem() == inst then return end
    if inst.prefab == "darkgem" and doer:HasTag("civi_canupgrade") then
        table.insert(actions, ACTIONS.NIGHTSWITCH)
    elseif inst.prefab == "lightgem" and doer:HasTag("civi_candegrade") then
        table.insert(actions, ACTIONS.NIGHTSWITCH)
    end
end)
for _, stage in ipairs({"wilson", "wilson_client"}) do
    AddStategraphActionHandler(stage, ActionHandler(NIGHTSWITCH, "domediumaction"))
end
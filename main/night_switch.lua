local Action = GLOBAL.Action
local ACTIONS = GLOBAL.ACTIONS
local ActionHandler = GLOBAL.ActionHandler
local STRINGS = GLOBAL.STRINGS
local TUNING = GLOBAL.TUNING

local NIGHTSWITCH = Action({mount_valid=true, priority = 1})

NIGHTSWITCH.id = "NIGHTSWITCH"

NIGHTSWITCH.str = STRINGS.ACTIONS.USEITEM

NIGHTSWITCH.fn = function(act)
    local _d = act.doer
    local level = _d.level
    if _d.components.inventory then
        local _i = _d.components.inventory:RemoveItem(act.invobject)
        if _i.prefab == "darkgem" then
            _d.level = level + 1
            if _d.level < 2 then
                _d.components.talker:Say(STRINGS.CIVI_GEMS.FEEL_DARK, 3)
            else
                _d.components.talker:Say(STRINGS.CIVI_GEMS.ALREADY_DARK, 3)
            end
        elseif _i.prefab == "lightgem" then
            _d.level = level - 1
            if _d.level > 0 then
                _d.components.talker:Say(STRINGS.CIVI_GEMS.FEEL_LIGHT, 3)
            else
                _d.components.talker:Say(STRINGS.CIVI_GEMS.ALREADY_LIGHT, 3)
            end
        end



        _d.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        if _d.applylevelfn ~= nil then _d.applylevelfn(_d) end
        _i:Remove()
        return true
    end
end

AddAction(NIGHTSWITCH)

function SetupActionNightSwitch(inst, doer, actions, right)
    if doer.prefab ~= "civi" then return end
    if doer.replica.inventory:GetActiveItem() == inst then return end
    if inst.prefab=="darkgem" and doer:HasTag("civi_canupgrade") then
        table.insert(actions, ACTIONS.NIGHTSWITCH)
    elseif inst.prefab=="lightgem" and doer:HasTag("civi_candegrade") then
        table.insert(actions, ACTIONS.NIGHTSWITCH)
    end
end

AddComponentAction("INVENTORY","nightswitch",SetupActionNightSwitch)

AddStategraphActionHandler("wilson", ActionHandler(NIGHTSWITCH, "domediumaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(NIGHTSWITCH, "domediumaction"))
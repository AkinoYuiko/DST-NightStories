local _G = GLOBAL
local Action = _G.Action
local ACTIONS = _G.ACTIONS
local ActionHandler = _G.ActionHandler
local STRINGS = _G.STRINGS
local TUNING = _G.TUNING

local LOTUSSWITCH = Action({priority=-1})

LOTUSSWITCH.id = "LOTUSSWITCH"

LOTUSSWITCH.str = STRINGS.ACTIONS.USEITEM

LOTUSSWITCH.fn = function(act)
    local _d = act.doer
    local _t = act.target
    if _d.components.inventory then
        local _i = _d.components.inventory:RemoveItem(act.invobject)

        -- add efx
        local _e = _t.components.inventoryitem and _t.components.inventoryitem.owner or _t
        if _e ~= nil then
            -- _G.SpawnPrefab("halloween_moonpuff").Transform:SetPosition(_e:GetPosition():Get())
                local _fx = _G.SpawnPrefab("explode_reskin")
                _fx.Transform:SetPosition(_e.Transform:GetWorldPosition())
                _fx.scale_override = 1.7 * _e:GetPhysicsRadius(0.5)
        end

        -- do mutate or repair
        if _i.prefab == "darkgem" and _t.prefab ~= "darklotus" then
            if _t.components.halloweenmoonmutable ~= nil then
                _t.components.halloweenmoonmutable:Mutate("darklotus")
            end
        elseif _i.prefab == "lightgem" and _t.prefab ~= "lightlotus" then
            if _t.components.halloweenmoonmutable ~= nil then
                _t.components.halloweenmoonmutable:Mutate("lightlotus")
            end
        elseif _i.prefab == "darkgem" and _t.prefab == "darklotus" then
            if _t.components.finiteuses then _t.components.finiteuses:SetPercent(1) end
        elseif _i.prefab == "lightgem" and _t.prefab == "lightlotus" then
            if _t.components.finiteuses then _t.components.finiteuses:SetPercent(1) end
        end

        _i:Remove()
        return true
    end
end

AddAction(LOTUSSWITCH)

function SetupActionLotusSwitch(inst,doer,target,actions,right)
    if not (target.prefab == "nightsword" or target.prefab == "darklotus" or target.prefab == "lightlotus" )then return end
    table.insert(actions, ACTIONS.LOTUSSWITCH)
end

AddComponentAction("USEITEM","nightswitch",SetupActionLotusSwitch)



AddStategraphActionHandler("wilson", ActionHandler(LOTUSSWITCH, "domediumaction"))

AddStategraphActionHandler("wilson_client", ActionHandler(LOTUSSWITCH, "domediumaction"))

AddPrefabPostInit("nightsword",function(inst)
    if not _G.TheWorld.ismastersim then return inst end
    if not inst.components.halloweenmoonmutable then
        inst:AddComponent("halloweenmoonmutable")
        inst.components.halloweenmoonmutable:SetPrefabMutated("glasscutter")
    end
end)

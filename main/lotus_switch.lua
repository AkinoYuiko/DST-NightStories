local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local LOTUSSWITCH = Action({priority=-1})

LOTUSSWITCH.id = "LOTUSSWITCH"
LOTUSSWITCH.str = STRINGS.ACTIONS.USEITEM
LOTUSSWITCH.fn = function(act)
    local doer = act.doer
    local target = act.target
    if doer.components.inventory then
        local item = doer.components.inventory:RemoveItem(act.invobject)

        -- add efx
        local entity = target.components.inventoryitem and target.components.inventoryitem.owner or target
        if entity then
            local fx = SpawnPrefab("explode_reskin")
            fx.Transform:SetPosition(entity.Transform:GetWorldPosition())
            fx.scale_override = 1.7 * entity:GetPhysicsRadius(0.5)
        end

        -- do mutate or repair
        if item.prefab == "darkgem" and target.prefab ~= "darklotus" then
            if target.components.halloweenmoonmutable then
                target.components.halloweenmoonmutable:Mutate("darklotus")
            end
        elseif item.prefab == "lightgem" and target.prefab ~= "lightlotus" then
            if target.components.halloweenmoonmutable then
                target.components.halloweenmoonmutable:Mutate("lightlotus")
            end
        elseif item.prefab == "darkgem" and target.prefab == "darklotus" then
            if target.components.finiteuses then target.components.finiteuses:SetPercent(1) end
        elseif item.prefab == "lightgem" and target.prefab == "lightlotus" then
            if target.components.finiteuses then target.components.finiteuses:SetPercent(1) end
        end

        item:Remove()
        return true
    end
end

ENV.AddAction(LOTUSSWITCH)

ENV.AddComponentAction("USEITEM", "nightswitch", function(inst, doer, target, actions, right)
    if not (target.prefab == "nightsword" or target.prefab == "darklotus" or target.prefab == "lightlotus" )then return end
    table.insert(actions, ACTIONS.LOTUSSWITCH)
end)

ENV.AddStategraphActionHandler("wilson", ActionHandler(LOTUSSWITCH, "domediumaction"))
ENV.AddStategraphActionHandler("wilson_client", ActionHandler(LOTUSSWITCH, "domediumaction"))

ENV.AddPrefabPostInit("nightsword", function(inst)
    if not TheWorld.ismastersim then return inst end
    if not inst.components.halloweenmoonmutable then
        inst:AddComponent("halloweenmoonmutable")
        inst.components.halloweenmoonmutable:SetPrefabMutated("glasscutter")
    end
end)

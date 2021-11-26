local AddAction = AddAction
local AddComponentAction = AddComponentAction
local AddPrefabPostInit = AddPrefabPostInit
local AddStategraphActionHandler = AddStategraphActionHandle
GLOBAL.setfenv(1, GLOBAL)

local GEMTRADE = Action({mount_valid=true})

GEMTRADE.id = "GEMTRADE"
GEMTRADE.str = STRINGS.ACTIONS.GIVE.SOCKET
GEMTRADE.fn = function(act)
    local doer = act.doer
    local target = act.target
    if doer.components.inventory then
        local item = doer.components.inventory:RemoveItem(act.invobject)
        local IsDummy = doer.prefab == "dummy" and true or nil
        if target.OnGemTrade then 
            if item.prefab == "nightmarefuel" then target.OnGemTrade(target, "fuel") end
            if item.prefab == "redgem" then target.OnGemTrade(target, "red", IsDummy) end
            if item.prefab == "bluegem" then target.OnGemTrade(target, "blue", IsDummy) end
            if item.prefab == "purplegem" then target.OnGemTrade(target, "purple", IsDummy) end
            if item.prefab == "yellowgem" then target.OnGemTrade(target, "yellow", IsDummy) end
            if item.prefab == "orangegem" then target.OnGemTrade(target, "orange", IsDummy) end
            if item.prefab == "greengem" then target.OnGemTrade(target, "green", IsDummy) end
            if item.prefab == "opalpreciousgem" then target.OnGemTrade(target, "opal", IsDummy) end
        end
        item:Remove()
        return true
    end
end

AddAction(GEMTRADE)
AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if target.prefab == "nightpack" and target:HasTag("nofuelsocket") and inst.prefab == "nightmarefuel" then return end
    if doer.replica.rider:IsRiding() and target.prefab == "nightpack" and target.components.inventoryitem and target.components.inventoryitem.owner ~= doer then return end 
    if right and inst:HasTag("nightpackgem")  and target.prefab == "nightpack" then
        table.insert(actions, 1, ACTIONS.GEMTRADE)
    end
end)
for _, stage in ipairs({"wilson", "wilson_client"}) do
    AddStategraphActionHandler(stage, ActionHandler(GEMTRADE, "doshortaction"))
end

local nightpack_gems = {
    "nightmarefuel",
    "redgem",
    "bluegem",
    "purplegem",
    "yellowgem",
    "orangegem",
    "greengem",
    "opalpreciousgem",
}
for _, prefab in ipairs(nightpack_gems) do
    AddPrefabPostInit(prefab, function(inst) inst:AddTag("nightpackgem") end)
end

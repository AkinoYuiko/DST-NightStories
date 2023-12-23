local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("antlion", function(inst)
    if not TheWorld.ismastersim then return end

    local on_given_item = inst.components.trader.onaccept
    inst.components.trader.onaccept = function(inst, giver, item)
        inst.itemstacksize = item and item.components.stackable and item.components.stackable.stacksize or 1
        on_given_item(inst, giver, item)
    end

    local give_reward = inst.GiveReward
    inst.GiveReward = function(inst)
        local pendingrewarditem = inst.pendingrewarditem
        local tributer = inst.tributer
        if pendingrewarditem then
            for k = 1, inst.itemstacksize do
                inst.pendingrewarditem = pendingrewarditem
                inst.tributer = tributer
                give_reward(inst)
            end
        end
        inst.itemstacksize = nil
    end
end)

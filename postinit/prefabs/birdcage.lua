local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local GetUpvalue = GlassicAPI.UpvalueUtil.GetUpvalue
local SetUpvalue = GlassicAPI.UpvalueUtil.SetUpvalue

AddPrefabPostInit("birdcage", function(inst)
    if not TheWorld.ismastersim then return end

    local digest_food = GetUpvalue(inst.components.trader.onaccept, "DigestFood")
    SetUpvalue(inst.components.trader.onaccept, "DigestFood", function(_inst, food)
        local stacksize = food and food.components.stackable and food.components.stackable.stacksize or 1
        for k = 1, stacksize do
            digest_food(_inst, food)
        end
    end)
end)

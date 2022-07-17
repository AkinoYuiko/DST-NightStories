local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

FOODTYPE.NIGHTFUEL = "NIGHTFUEL"
local Eater = require("components/eater")
function Eater:SetCanEatNightmareFuel()
    table.insert(self.preferseating, FOODTYPE.NIGHTFUEL)
    table.insert(self.caneat, FOODTYPE.NIGHTFUEL)
    if not self.inst:HasTag(FOODTYPE.NIGHTFUEL.."_eater") then
        self.inst:AddTag(FOODTYPE.NIGHTFUEL.."_eater")
    end
end

local SCALE = 0.4
local function oneaten(food, eater)
    if eater.prefab == "miotan" and eater.StartBoost then
        eater:StartBoost(TUNING.LARGE_FUEL)
        local fx = SpawnPrefab("statue_transition")
        if fx then
            fx.entity:SetParent(eater.entity)
            fx.Transform:SetScale(SCALE, SCALE, SCALE)
        end
        eater.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
        -- eater:AddDebuff("buff_miosanity", "buff_miosanity")
    end
end

AddPrefabPostInit("nightmarefuel", function(inst)
    if not TheWorld.ismastersim then return end
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 10
    inst.components.edible.sanityvalue = 0
    inst.components.edible.hungervalue = 15
    inst.components.edible.foodtype = FOODTYPE.NIGHTFUEL
    inst.components.edible:SetOnEatenFn(oneaten)

    inst:AddComponent("fuelpocketwatch")
end)

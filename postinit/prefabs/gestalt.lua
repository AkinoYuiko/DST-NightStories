local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local GESTALT_PREFABS =
{
    "gestalt",
    "gestalt_guard"
}

for _, prefab in ipairs(GESTALT_PREFABS) do
    AddPrefabPostInit("gestalt", function(inst)
        if not TheWorld.ismastersim then return end

        local retarget = inst.components.combat.targetfn
        inst.components.combat:SetRetargetFunction(1, function(_inst)
            local target = retarget(inst)
            if target and target.components.debuffable and target.components.debuffable:HasDebuff("buff_moonglass") then
                return
            end
            return target
        end)
    end)
end

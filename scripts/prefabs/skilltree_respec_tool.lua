local WILSON_BUILDER_TAG =
{
    "alchemist",
    "gem_alchemistI",
    "gem_alchemistII",
    "gem_alchemistIII",
    "ick_alchemistI",
    "ick_alchemistII",
    "ick_alchemistIII",
    "ore_alchemistI",
    "ore_alchemistII",
    "ore_alchemistIII",
}

local function reset_skill_tree(player)
    if player then
        local skilltreeupdater = player.components.skilltreeupdater
        local prev = skilltreeupdater.skilltree.skip_validation
        skilltreeupdater:SetSkipValidation(true)
        local skilldefs = require("prefabs/skilltree_defs").SKILLTREE_DEFS[player.prefab]
        if skilldefs then
            for skill, data in pairs(skilldefs) do
                skilltreeupdater:DeactivateSkill(skill)
            end
            skilltreeupdater:AddSkillXP(-skilltreeupdater:GetSkillXP())
        end
        skilltreeupdater:SetSkipValidation(prev)

        for _, tag in ipairs(WILSON_BUILDER_TAG) do
            player:RemoveTag(tag)
        end

        player:PushEvent("unlockrecipe")

        if player.components.beard then -- for wilson
            player.components.beard:UpdateBeardInventory()
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    inst:AddTag("CLASSIFIED")

    --[[Non-networked entity]]
    inst.persists = false

    --Auto-remove if not spawned by builder
    inst:DoTaskInTime(0, inst.Remove)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.OnBuiltFn = function(inst, builder)
        reset_skill_tree(builder)
    end

    return inst
end

return Prefab("skilltree_respec_tool", fn)

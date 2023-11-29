local RECIPE_BUILDER_TAG_LOOKUP =
{
    "alchemist",
    "balloonomancer",
    "battlesinger",
    "bookbuilder",
    "clockmaker",
    "elixirbrewer",
    "gem_alchemistI",
    "gem_alchemistII",
    "gem_alchemistIII",
    "ghostlyfriend",
    "handyperson",
    "ick_alchemistI",
    "ick_alchemistII",
    "ick_alchemistIII",
    "leifidolcrafter",
    "masterchef",
    "merm_builder",
    "ore_alchemistI",
    "ore_alchemistII",
    "ore_alchemistIII",
    "pebblemaker",
    "pinetreepioneer",
    "plantkin",
    "saplingcrafter",
    "berrybushcrafter",
    "juicyberrybushcrafter",
    "reedscrafter",
    "lureplantcrafter",
    "syrupcrafter",
    "carratcrafter",
    "lightfliercrafter",
    "fruitdragoncrafter",
    "professionalchef",
    "pyromaniac",
    "shadowmagic",
    "skill_wilson_allegiance_lunar",
    "skill_wilson_allegiance_shadow",
    "spiderwhisperer",
    "strongman",
    "upgrademoduleowner",
    "valkyrie",
    "werehuman",
    "wolfgang_coach",
    "wolfgang_dumbbell_crafting",
    "woodcarver1",
    "woodcarver2",
    "woodcarver3",
}

local function reset_skill_tree(player)
    if player then
        local skilltreeupdater = player.components.skilltreeupdater
        skilltreeupdater.skilltree.skip_validation = true
        local skilldefs = require("prefabs/skilltree_defs").SKILLTREE_DEFS[player.prefab]
        if skilldefs then
            for skill, data in pairs(skilldefs) do
                skilltreeupdater:DeactivateSkill(skill)
            end
            skilltreeupdater:AddSkillXP(-skilltreeupdater:GetSkillXP())
        end
        skilltreeupdater.skilltree.skip_validation = nil

        for _, tag in ipairs(RECIPE_BUILDER_TAG_LOOKUP) do
            player:RemoveTag(tag)
        end

        player:PushEvent("unlockrecipe")
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

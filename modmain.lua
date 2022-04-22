local main_files = {
    "assets",
    "actions",
    "tuning",
    "strings",

    -- "add_stack_size",

    "crystal_sword",
    "gem_pack",
    "prefabskin",
    "recipes",
    "sanity_rework",
    "widgets",

    "eatfuel",
    "sanity_reward",
    "tradefuel",

    "hack_templates",
    "only_dazui",
    "staff_action",
    "tools_mutable",

    "spices",

    "dummybadge_poison",    -- IA
}

for _, v in ipairs(main_files) do
    modimport("main/"..v)
end

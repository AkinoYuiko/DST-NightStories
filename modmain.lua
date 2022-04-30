local main_files = {
    "assets",
    "tuning",
    "strings",

    "actions",

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

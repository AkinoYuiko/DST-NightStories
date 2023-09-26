local main_files = {
    "assets",
    "tuning",
    "strings",

    "actions",
    "clothing",
    "containerwidgets",
    "prefabskin",
    "recipes",
    "widgets",
    "spices",

    "sanity_rework",
    "sanity_reward",

    "hack_templates",
}

for _, v in ipairs(main_files) do
    modimport("main/"..v)
end

local postinits =
{
    -- components
    "components/spellcaster",
    "components/planarentity",
    -- prefabs
    "prefabs/alterguardian_hat_equipped",
    "prefabs/foodbuffs",
    "prefabs/gems",
    "prefabs/nightmarefuel",
    "prefabs/nightsword",
    "prefabs/orangestaff",
    "prefabs/pigking",
    "prefabs/raincoat",
    "prefabs/sculptingtable",
    -- root
    "only_dazui",
    "tools_mutable",
}
for index, files in pairs(postinits) do
    modimport("postinit/".. files)
end

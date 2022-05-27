local main_files = {
    "assets",
    "tuning",
    "strings",

    "actions",
    "clothing",
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
    components =
    {
        "spellcaster",
    },
    prefabs =
    {
        "alterguardian_hat_equipped",
        "gems",
        "nightmarefuel",
        "nightsword",
        "pigking",
        "sculptingtable",
    },
    "only_dazui",
    "tools_mutable",
}
for index, files in pairs(postinits) do
    if type(files) == "table" then
        for _, file in ipairs(files) do
            modimport("postinit/".. index .. "/" .. file)
        end
    else
        modimport("postinit/".. files)
    end
end

local main_files = {
    "assets",
    "tuning",
    "strings",

    "actions",
    "prefabskin",
    "recipes",
    "widgets",
    "spices",

    "sanity_rework",
    "sanity_reward",

    "hack_templates",
    "dummybadge_poison",    -- IA
}

for _, v in ipairs(main_files) do
    modimport("main/"..v)
end

local postinit_files =
{
    components =
    {
        "spellcaster",
    },
    prefabs =
    {
        "gems",
        "nightmarefuel",
        "nightsword",
        "pigking",
    },
    "only_dazui",
    "tools_mutable",
}
for index, files in pairs(postinit_files) do
    if type(files) == "table" then
        for _, file in ipairs(files) do
            modimport("postinit/".. index .. "/" .. file)
        end
    else
        modimport("postinit/".. files)
    end

end

local main = {
    -- high priority
    "assets",
    "tuning",
    "strings",
    -- medium priority
    "actions",
    "clothing",
    "containerwidgets",
    "prefabskin",
    "recipes",
    "spices",
    -- low priority
}

for i = 1, #main do
    modimport("main/"..main[i])
end

local postinit =
{
    -- components
    "components/bundler",
    "components/combat",
    "components/lptw",
    "components/moisture",
    "components/planarentity",
    "components/sanity",
    "components/skilltreeupdater",
    "components/spellcaster",
    -- prefabs
    "prefabs/alterguardianhat",
    "prefabs/flower",
    "prefabs/foodbuffs",
    "prefabs/gems",
    "prefabs/gestalt",
    "prefabs/nightmarecreatures",
    "prefabs/nightmarefuel",
    "prefabs/nightsword",
    "prefabs/orangestaff",
    "prefabs/pigking",
    "prefabs/punchingbag",
    "prefabs/raincoat",
    "prefabs/sculptingtable",
    "prefabs/world",
    -- widgets
    "widgets/itemtile",
    "widgets/statusdisplays",
    "widgets/templates",
    -- root
    "only_dazui",
    "tools_mutable",
}
for i = 1, #postinit do
    modimport("postinit/"..postinit[i])
end

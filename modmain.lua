Assets = {}
PrefabFiles = {
	"civi",
    "civi_amulets",
    "civi_gems",
    "civi_magatamas",
    "nightpack",

    "miotan",
    "lantern_mio_fx",

    "dummy",
    "dummy_books",
    "blackholestaff",
    "nightmare_spear",
    "nightmarecreature_checker",

    "ns_spices",

    "ns_skins",
}
-- ThePlayer.AnimState:OverrideSymbol("swap_object","nightstick_crystal","swap_nightstick")
GlassicAPI.InitCharacterAssets("miotan", "FEMALE", Assets)
GlassicAPI.InitCharacterAssets("dummy", "FEMALE", Assets)
GlassicAPI.InitCharacterAssets("civi", "MALE", Assets)

GlassicAPI.InitMinimapAtlas("ns_minimap", Assets)
GlassicAPI.RegisterItemAtlas("ns_inventoryimages", Assets)
GlassicAPI.RegisterItemAtlas("hud/nightmaretab", Assets)

local main_files = {
    'actions',
    "tuning",
    "strings",

    "add_stack_size",

    "gem_nightsword",
    "gem_pack",
    "prefabskin",
    "recipes",
    "sanity_recalc",
    "widgets",

	"eatfuel",
	"sanity_reward",
	"tradefuel",

	"only_dazui",
	"staff_action",
    "tools_mutable",

    "spices",
}

for _, v in ipairs(main_files) do
    modimport("main/"..v)
end

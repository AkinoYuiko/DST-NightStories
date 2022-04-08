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

    "ns_spices",
    "ns_skins",

    "portable_wardrobe",
}

GlassicAPI.InitCharacterAssets("miotan", "FEMALE", Assets, true)
GlassicAPI.InitCharacterAssets("dummy", "FEMALE", Assets, true)
GlassicAPI.InitCharacterAssets("civi", "MALE", Assets, true)

GlassicAPI.InitMinimapAtlas("ns_minimap", Assets)
GlassicAPI.RegisterItemAtlas("ns_inventoryimages", Assets)
GlassicAPI.RegisterItemAtlas("hud/nightmaretab", Assets)
GlassicAPI.RegisterItemAtlas("hud/dummy_status_health", Assets)

local main_files = {
    'actions',
    "tuning",
    "strings",

    "add_stack_size",

    "gem_nightsword",
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
}

for _, v in ipairs(main_files) do
    modimport("main/"..v)
end


local IA_MODNAMES = {
    "workshop-1467214795",
    "IslandAdventures"
}
local IA_FANCY_NAME = "Island Adventures"

local function IsIA(modname, moddata)
    return table.contains(IA_MODNAMES, modname)
        or moddata.modinfo and moddata.modinfo.name == IA_FANCY_NAME
end

local function HasIA()
    for modname, moddata in pairs(GLOBAL.KnownModIndex.savedata.known_mods) do
        if IsIA(modname, moddata) and GLOBAL.KnownModIndex:IsModEnabledAny(modname) then
            return true
        end
    end
end

if HasIA() then
    modimport("main/dummybadge_poison")
end

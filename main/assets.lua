Assets = {
    Asset("SOUNDPACKAGE", "sound/nightstories.fev"),
}
PrefabFiles = {
    "civi",
    "civi_crystal",
    "civi_amulets",     -- nouse anymore
    "civi_gems",        -- nouse anymore
    "civi_magatamas",   -- nouse anymore
    "nightpack",
    "friendshipring",
    "friendshiptotem_buff",

    "miotan",
    "lantern_mio_fx",

    "dummy",
    "dummy_books",
    "blackholestaff",
    "nightmare_spear",

    "ns_spices",
    "ns_skins",
    "wx78_potato",

    "portable_wardrobe",
    "chesspiece_headuck",
}

GlassicAPI.InitCharacterAssets("miotan", "FEMALE", Assets, true)
GlassicAPI.InitCharacterAssets("dummy", "FEMALE", Assets, true)
GlassicAPI.InitCharacterAssets("civi", "MALE", Assets, true)

GlassicAPI.InitMinimapAtlas("ns_minimap", Assets)
GlassicAPI.RegisterItemAtlas("ns_inventoryimages", Assets)
GlassicAPI.RegisterItemAtlas("hud/nightmaretab", Assets)
GlassicAPI.RegisterItemAtlas("hud/dummy_status_health", Assets)

-- table.insert(Assets, Asset("ANIM", "anim/wx78_potato.zip"))

Assets = {
    Asset("SOUNDPACKAGE", "sound/nightstories.fev"),
}
PrefabFiles = {
    "civi",
    "civi_crystal",
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

    "battleruinshat",
    "portable_wardrobe",
    "chesspiece_headuck",
    "book_wetness",

    "glassicflash",
    "glash",
    -- "glassiccutter",
    "moonglasshammer",
    "moonglasspickaxe",
    "moonlight_shadow",
}



GlassicAPI.InitCharacterAssets("miotan", "FEMALE", Assets)
GlassicAPI.InitCharacterAssets("dummy", "FEMALE", Assets)
GlassicAPI.InitCharacterAssets("civi", "DUCK", Assets)

GlassicAPI.InitMinimapAtlas("ns_minimap", Assets)

GlassicAPI.RegisterItemAtlas("ns_inventoryimages", Assets)
GlassicAPI.RegisterItemAtlas("hud/nightmaretab", Assets)
GlassicAPI.RegisterItemAtlas("hud/dummy_status_health", Assets)

Assets = {
    Asset("SOUNDPACKAGE", "sound/nightstories.fev"),
    Asset("ANIM", "anim/glash_fx.zip"), -- GLASH FX FOR ROD OF GLASS AND RING OF FRIENDSHIP.
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

    "glash",
    "moonglasshammer",
    "moonglasspickaxe",
    "moonlight_shadow",
    "moonlight_buff",

    "horrorchain",

    "cookgift",
}



GlassicAPI.InitCharacterAssets("miotan", "FEMALE", Assets)
GlassicAPI.InitCharacterAssets("dummy", "FEMALE", Assets)
GlassicAPI.InitCharacterAssets("civi", "DUCK", Assets)

GlassicAPI.InitMinimapAtlas("ns_minimap", Assets)

GlassicAPI.RegisterItemAtlas("ns_inventoryimages", Assets)
GlassicAPI.RegisterItemAtlas("hud/nightmaretab", Assets)
GlassicAPI.RegisterItemAtlas("hud/dummy_status_health", Assets)

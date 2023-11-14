Assets = {
    Asset("SOUNDPACKAGE", "sound/nightstories.fev"),
    Asset("ANIM", "anim/glash_fx.zip"), -- GLASH FX FOR ROD OF GLASS AND RING OF FRIENDSHIP.
}

PrefabFiles = {
    "battleruinshat",
    "blackholestaff",
    "book_wetness",
    "chesspiece_headuck",
    "civi_crystal",
    "civi",
    "cookpackage",
    "dummy_books",
    "dummy",
    "nightpack",
    "friendshipring",
    "friendshiptotem_buff",
    "glash",
    -- "glassiccutter",
    -- "glassicflash",
    "horrorchain",
    "lantern_mio_fx",
    "lunarplanthat_trans_fx",
    "miotan",
    "moonglasshammer",
    "moonglasspickaxe",
    "moonlight_buff",
    "moonlight_shadow",
    "nightmare_spear",
    "ns_skins",
    "ns_spices",
    "portable_wardrobe",
}

GlassicAPI.InitCharacterAssets("miotan", "FEMALE", Assets)
GlassicAPI.InitCharacterAssets("dummy", "FEMALE", Assets)
GlassicAPI.InitCharacterAssets("civi", "DUCK", Assets)

GlassicAPI.InitMinimapAtlas("ns_minimap", Assets)

GlassicAPI.RegisterItemAtlas("ns_inventoryimages", Assets)
GlassicAPI.RegisterItemAtlas("hud/nightmaretab", Assets)
GlassicAPI.RegisterItemAtlas("hud/dummy_status_health", Assets)

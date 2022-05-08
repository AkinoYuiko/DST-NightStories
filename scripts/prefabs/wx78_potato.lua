return CreatePrefabSkin("wx78_potato", {
    base_prefab = "wx78",
    type = "base",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/wx78_potato.zip" ),
        Asset( "PKGREF", "anim/dynamic/wx78_potato.dyn" ),
        -- Asset( "ANIM", "anim/wx78_potato.zip" ),
        -- Asset( "ANIM", "anim/ghost_wx78_potato_build.zip" ),
        Asset( "ATLAS", "bigportraits/wx78_potato.xml")
    },
    skins = { normal_skin = "wx78_potato", ghost_skin = "ghost_wx78_build" },
    bigportrait = { build = "bigportrait/wx78_potato.xml", symbol = "wx78_potato_oval.tex"},
    skin_tags = { "WX78", "BASE"},
    build_name_override = "wx78_potato",
    rarity = "Glassic",
})

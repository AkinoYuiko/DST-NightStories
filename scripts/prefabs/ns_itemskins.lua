local prefabs = {}

table.insert(prefabs, CreatePrefabSkin("armorskeleton_none", {
	base_prefab = "armorskeleton",
	type = "item",
    rarity = "Glassic",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/armorskeleton_none.zip" ),
        Asset( "PKGREF", "anim/dynamic/armorskeleton_none.dyn" ),
    },
    init_fn = function(inst) armorskeleton_init_fn(inst, "armorskeleton_none") end,
	skin_tags = { "ARMORSKELETON" },
}))

table.insert(prefabs, CreatePrefabSkin("skeletonhat_glass", {
	base_prefab = "skeletonhat",
	type = "item",
	rarity = "Glassic",
	assets = {
		Asset( "DYNAMIC_ANIM", "anim/dynamic/skeletonhat_glass.zip" ),
		Asset( "PKGREF", "anim/dynamic/skeletonhat_glass.dyn" ),
	},
	init_fn = function(inst) skeletonhat_init_fn(inst, "skeletonhat_glass") end,
	skin_tags = { "SKELETONHAT" },
}))

table.insert(prefabs, CreatePrefabSkin("lantern_mio", {
    base_prefab = "lantern",
    type = "item",
    rarity = "Reward",
    build_name_override = "lantern_mio",
    assets = {
        Asset( "ANIM", "anim/lantern_mio.zip" ),
        Asset( "ANIM", "anim/swap_lantern_mio.zip" ),
        Asset( "INV_IMAGE", "lantern_mio_lit" ),
        Asset( "INV_IMAGE", "lantern_mio" ),
    },
    init_fn = function(inst) lantern_mio_init_fn(inst, "lantern_mio") end,
    skin_tags = { "LANTERN" },
    -- prefabs = { "lantern_crystal_fx_held", "lantern_crystal_fx_ground", },
    -- fx_prefab = { "lantern_crystal_fx_held", "lantern_crystal_fx_ground", },
    -- release_group = 95,
}))

table.insert(prefabs, CreatePrefabSkin("yellowamulet_heart", {
	base_prefab = "yellowamulet",
	type = "item",
    rarity = "Glassic",
    build_name_override = "yellowamulet_heart",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/yellowamulet_heart.zip" ),
        Asset( "PKGREF", "anim/dynamic/yellowamulet_heart.dyn" ),
    },
    init_fn = function(inst) yellowamulet_init_fn(inst, "yellowamulet_heart") end,
	skin_tags = { "YELLOWAMULET"},
}))

table.insert(prefabs, CreatePrefabSkin("greenamulet_heart", {
	base_prefab = "greenamulet",
	type = "item",
    rarity = "Glassic",
    build_name_override = "greenamulet_heart",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/greenamulet_heart.zip"),
        Asset( "PKGREF", "anim/dynamic/greenamulet_heart.dyn"),
    },
    init_fn = function(inst) greenamulet_init_fn(inst, "greenamulet_heart") end,
	skin_tags = { "GREENAMULET" },
}))

table.insert(prefabs, CreatePrefabSkin("raincoat_peggy", {
	base_prefab = "raincoat",
	type = "item",
    rarity = "Glassic",
    build_name_override = "raincoat_peggy",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/raincoat_peggy.zip"),
        Asset( "PKGREF", "anim/dynamic/raincoat_peggy.dyn"),
    },
    init_fn = function(inst) raincoat_init_fn(inst, "raincoat_peggy") end,
	skin_tags = { "RAINCOAT" },
}))

table.insert(prefabs, CreatePrefabSkin("dragonflychest_gingerbread", {
	base_prefab = "dragonflychest",
	type = "item",
    rarity = "Glassic",
    build_name_override = "dragonflychest_gingerbread",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/dragonflychest_gingerbread.zip"),
        Asset( "PKGREF", "anim/dynamic/dragonflychest_gingerbread.dyn"),
    },
    init_fn = function(inst) GlassicAPI.BasicInitFn(inst, "dragonflychest_gingerbread") end,
	skin_tags = { "DRAGONFLYCHEST" },
}))

table.insert(prefabs, CreatePrefabSkin("meatrack_rice", {
	base_prefab = "meatrack",
	type = "item",
    rarity = "Glassic",
    build_name_override = "meatrack_hermit",
    assets = {
        -- Asset( "DYNAMIC_ANIM", "anim/dynamic/dragonflychest_gingerbread.zip"),
        -- Asset( "PKGREF", "anim/dynamic/dragonflychest_gingerbread.dyn"),
    },
    init_fn = function(inst)
        inst.AnimState:SetBank("meatrack_hermit")
        GlassicAPI.BasicInitFn(inst, "meatrack_rice", "meatrack_hermit")
    end,
	skin_tags = { "DRAGONFLYCHEST" },
}))

return unpack(prefabs)

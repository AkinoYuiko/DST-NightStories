local prefabs = {}

table.insert(prefabs, CreatePrefabSkin("armorskeleton_none", {
    base_prefab = "armorskeleton",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset("DYNAMIC_ANIM", "anim/dynamic/armorskeleton_none.zip"),
        Asset("PKGREF", "anim/dynamic/armorskeleton_none.dyn"),
    },
    init_fn = function(inst)
        inst.foleysound = nil
        ns_equipment_init_fn(inst, "armorskeleton_none")
    end,
    skin_tags = {"ARMORSKELETON"},
}))

table.insert(prefabs, CreatePrefabSkin("skeletonhat_glass", {
    base_prefab = "skeletonhat",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset("DYNAMIC_ANIM", "anim/dynamic/skeletonhat_glass.zip"),
        Asset("PKGREF", "anim/dynamic/skeletonhat_glass.dyn"),
    },
    init_fn = function(inst) ns_equipment_init_fn(inst, "skeletonhat_glass") end,
    skin_tags = {"SKELETONHAT"},
}))

table.insert(prefabs, CreatePrefabSkin("lantern_mio", {
    base_prefab = "lantern",
    type = "item",
    rarity = "Reward",
    assets = {
        Asset("DYNAMIC_ANIM", "anim/dynamic/lantern_mio.zip"),
        Asset("PKGREF", "anim/dynamic/lantern_mio.dyn"),
    },
    prefabs = {"lantern_mio_fx_held", "lantern_mio_fx_ground"},
    init_fn = function(inst) ns_lantern_init_fn(inst, "lantern_mio", {"firefly"}, Vector3(67, -7, 0), {195 / 255, 190 / 255, 120 / 255}) end,
    skin_tags = {"LANTERN"},
    fx_prefab = {"lantern_mio_fx_held", "lantern_mio_fx_ground"},
}))

table.insert(prefabs, CreatePrefabSkin("yellowamulet_heart", {
    base_prefab = "yellowamulet",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset("DYNAMIC_ANIM", "anim/dynamic/yellowamulet_heart.zip"),
        Asset("PKGREF", "anim/dynamic/yellowamulet_heart.dyn"),
    },
    init_fn = function(inst) ns_equipment_init_fn(inst, "yellowamulet_heart", { bank = "amulets", anim = "yellowamulet" }) end,
    skin_tags = {"YELLOWAMULET"},
}))

table.insert(prefabs, CreatePrefabSkin("greenamulet_heart", {
    base_prefab = "greenamulet",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset("DYNAMIC_ANIM", "anim/dynamic/greenamulet_heart.zip"),
        Asset("PKGREF", "anim/dynamic/greenamulet_heart.dyn"),
    },
    init_fn = function(inst) ns_equipment_init_fn(inst, "greenamulet_heart", { bank = "amulets", anim = "greenamulet" }) end,
    skin_tags = {"GREENAMULET"},
}))

table.insert(prefabs, CreatePrefabSkin("raincoat_peggy", {
    base_prefab = "raincoat",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset("DYNAMIC_ANIM", "anim/dynamic/raincoat_peggy.zip"),
        Asset("PKGREF", "anim/dynamic/raincoat_peggy.dyn"),
    },
    init_fn = function(inst) ns_equipment_init_fn(inst, "raincoat_peggy", { bank = "torso_rain", anim = "anim" }) end,
    skin_tags = {"RAINCOAT"},
}))

table.insert(prefabs, CreatePrefabSkin("dragonflychest_gingerbread", {
    base_prefab = "dragonflychest",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset("DYNAMIC_ANIM", "anim/dynamic/dragonflychest_gingerbread.zip"),
        Asset("PKGREF", "anim/dynamic/dragonflychest_gingerbread.dyn"),
    },
    init_fn = function(inst) GlassicAPI.BasicInitFn(inst, "dragonflychest_gingerbread") end,
    skin_tags = {"DRAGONFLYCHEST"},
}))

table.insert(prefabs, CreatePrefabSkin("meatrack_hermit_red", {
    base_prefab = "meatrack",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset("DYNAMIC_ANIM", "anim/dynamic/meatrack_hermit_red.zip"),
        Asset("PKGREF", "anim/dynamic/meatrack_hermit_red.dyn"),
    },
    init_fn = function(inst)
        inst.AnimState:SetBank("meatrack_hermit")
        GlassicAPI.BasicInitFn(inst, "meatrack_hermit_red")
    end,
    skin_tags = {"MEATRACK"},
}))

table.insert(prefabs, CreatePrefabSkin("meatrack_hermit_white", {
    base_prefab = "meatrack",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset("DYNAMIC_ANIM", "anim/dynamic/meatrack_hermit_white.zip"),
        Asset("PKGREF", "anim/dynamic/meatrack_hermit_white.dyn"),
    },
    init_fn = function(inst)
        inst.AnimState:SetBank("meatrack_hermit")
        GlassicAPI.BasicInitFn(inst, "meatrack_hermit_white")
    end,
    skin_tags = {"MEATRACK"},
}))

table.insert(prefabs, CreatePrefabSkin("hivehat_pigcrown", {
    base_prefab = "hivehat",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset("DYNAMIC_ANIM", "anim/dynamic/hivehat_pigcrown.zip"),
        Asset("PKGREF", "anim/dynamic/hivehat_pigcrown.dyn"),
    },
    init_fn = function(inst) ns_equipment_init_fn(inst, "hivehat_pigcrown") end,
    skin_tags = {"HIVEHAT"},
}))

table.insert(prefabs, CreatePrefabSkin("hivehat_pigcrown_willow", {
    base_prefab = "hivehat",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset("DYNAMIC_ANIM", "anim/dynamic/hivehat_pigcrown_willow.zip"),
        Asset("PKGREF", "anim/dynamic/hivehat_pigcrown_willow.dyn"),
    },
    init_fn = function(inst) ns_equipment_init_fn(inst, "hivehat_pigcrown_willow") end,
    skin_tags = {"HIVEHAT"},
}))

table.insert(prefabs, CreatePrefabSkin("eyebrellahat_peggy", {
    base_prefab = "eyebrellahat",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset("DYNAMIC_ANIM", "anim/dynamic/eyebrellahat_peggy.zip"),
        Asset("PKGREF", "anim/dynamic/eyebrellahat_peggy.dyn"),
    },
    init_fn = function(inst) ns_equipment_init_fn(inst, "eyebrellahat_peggy") end,
    skin_tags = {"EYEBRELLAHAT"},
}))

table.insert(prefabs, CreatePrefabSkin("alterguardianhat_finger", {
    base_prefab = "alterguardianhat",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset("DYNAMIC_ANIM", "anim/dynamic/alterguardianhat_finger.zip"),
        Asset("PKGREF", "anim/dynamic/alterguardianhat_finger.dyn"),
    },
    init_fn = function(inst) ns_equipment_init_fn(inst, "alterguardianhat_finger") end,
    skin_tags = {"ALTERGUARDIANHAT"},
}))

return unpack(prefabs)

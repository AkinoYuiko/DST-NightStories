GLOBAL.setfenv(1, GLOBAL)

ns_equipment_init_fn = function(inst, skinname, swap_data)
    if swap_data then
        GlassicAPI.SetFloatData(inst, swap_data)
    end
    GlassicAPI.BasicInitFn(inst, skinname)
end

-- Civi
local armor_skeleton_clear_fn = armorskeleton_clear_fn
function armorskeleton_clear_fn(inst)
    inst.foleysound = "dontstarve/movement/foley/bone"
    armor_skeleton_clear_fn(inst)
end

-- Mio
-- fix lantern reskin in inventory
local old_lantern_init_fn = lantern_init_fn
lantern_init_fn = function(inst, ...)
    local ret = { old_lantern_init_fn(inst, ...) }
    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
    end
    return unpack(ret)
end

local old_lantern_clear_fn = lantern_clear_fn
lantern_clear_fn = function(inst, ...)
    local ret = { old_lantern_clear_fn(inst, ...) }
    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName()
    end
    return unpack(ret)
end

-- yellowamulet
if not rawget(_G, "yellowamulet_clear_fn") then
    yellowamulet_clear_fn = function(inst)
        GlassicAPI.SetFloatData(inst, { bank = "amulets", anim = "yellowamulet" })
        basic_clear_fn(inst, "amulets")
    end
    GlassicAPI.SetOnequipSkinItem("yellowamulet", {"swap_body", "swap_body", "torso_amulets"})
end

-- lantern
ns_lantern_init_fn = function(inst, skinname, ...)
    inst.skinname = skinname
    local skin_build = inst:GetSkinBuild()
    lantern_init_fn(inst, skin_build, ...)
end


-- Dummy
-- Green Amulet
if not rawget(_G, "greenamulet_clear_fn") then
    greenamulet_clear_fn = function(inst)
        GlassicAPI.SetFloatData(inst, { bank = "amulets", anim = "greenamulet" })
        basic_clear_fn(inst, "amulets")
    end
    GlassicAPI.SetOnequipSkinItem("greenamulet", {"swap_body", "swap_body", "torso_amulets"})
end

-- Raincoat
if not rawget(_G, "raincoat_clear_fn") then
    raincoat_clear_fn = function(inst)
        GlassicAPI.SetFloatData(inst, { bank = "torso_rain", anim = "anim" })
        basic_clear_fn(inst, "torso_rain")
    end
    GlassicAPI.SetOnequipSkinItem("raincoat", {"swap_body", "swap_body", "torso_rain"})
end

-- Meat Rack --
local _meatrack_clear_fn = meatrack_clear_fn
meatrack_clear_fn = function(inst)
    inst.AnimState:SetBank("meat_rack")
    return _meatrack_clear_fn(inst)
end

-- Bee Queen Crown --
if not rawget(_G, "hivehat_clear_fn") then
    hivehat_clear_fn = function(inst)
        inst.AnimState:SetBuild("hat_hive")
        if not TheWorld.ismastersim then return end
        inst.components.inventoryitem:ChangeImageName()
    end
    -- GlassicAPI.SetOnequipSkinItem("hivehat", {"swap_body", "swap_body", "hat_hive"})
end

GlassicAPI.SkinHandler.AddModSkins({
    -- Civi
    civi = {
        "civi_none"
    },
    armorskeleton = {
        { name = "armorskeleton_none", exclusive_char = "civi" },
    },
    skeletonhat = {
        { name = "skeletonhat_glass", exclusive_char = "civi" },
    },
    -- Mio
    miotan = {
        "miotan_none",
        "miotan_classic"
    },
    lantern = {
        { name = "lantern_mio", exclusive_char = "miotan" }
    },
    -- nightstick = {
    --     { name = "nightstick_crystal", exclusive_char = "miotan" }
    -- },
    yellowamulet = {
        { name = "yellowamulet_heart", exclusive_char = "miotan" }
    },
    -- Dummy
    dummy = {
        "dummy_none"
    },
    greenamulet = {
        { name = "greenamulet_heart", exclusive_char = "dummy" }
    },
    raincoat = {
        { name = "raincoat_peggy", exclusive_char = "dummy" }
    },
    eyebrellahat = {
        { name = "eyebrellahat_peggy", exclusive_char = "dummy" }
    },
    -- Common
    dragonflychest = { "dragonflychest_gingerbread" },
    meatrack = { "meatrack_hermit_red", "meatrack_hermit_white" },
    hivehat = { "hivehat_pigcrown", "hivehat_pigcrown_willow" },
    alterguardianhat = { "alterguardianhat_finger" },
    wx78 = {
        "wx78_potato",
    }
})

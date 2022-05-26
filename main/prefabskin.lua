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
local _lantern_init_fn = lantern_init_fn
lantern_init_fn = function(inst, ...)
    local ret = { _lantern_init_fn(inst, ...) }
    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
    end
    return unpack(ret)
end

local _lantern_clear_fn = lantern_clear_fn
lantern_clear_fn = function(inst, ...)
    local ret = { _lantern_clear_fn(inst, ...) }
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

-- Black Lotus --
local function nightsword_update_image(inst, state)
    local skin_build = "nightsword_lotus"
    state = state and ("_" .. state) or ""
    inst.components.inventoryitem:ChangeImageName(skin_build .. state)

    inst.AnimState:PlayAnimation("idle" .. state)

    if inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem.owner
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_nightmaresword" .. state, inst.GUID, "swap_nightmaresword" .. state)
    end

    GlassicAPI.SetFloatData(inst, { sym_build = skin_build, sym_name = "swap_nightmaresword" .. state, anim = "idle" .. state})
    GlassicAPI.UpdateFloaterAnim(inst)
end

local LOTUS_STATES = {
    darkcrystal = "dark",
    lightcrystal = "light",
}
local function nightsword_socketed_crystal(inst)
    nightsword_update_image(inst, LOTUS_STATES[inst.socketed_crystal])
end

ns_nightsword_init_fn = function(inst, skinname)
    if not TheWorld.ismastersim then return end

    local ret = { nightsword_init_fn(inst, skinname) }

    nightsword_socketed_crystal(inst)
    inst:ListenForEvent("equipped", nightsword_socketed_crystal)
    inst:ListenForEvent("itemget", nightsword_socketed_crystal)
    inst:ListenForEvent("itemlose", nightsword_socketed_crystal)
    return unpack(ret)
end

local _nightsword_clear_fn = nightsword_clear_fn
nightsword_clear_fn = function(inst)
    inst.AnimState:PlayAnimation("idle")
    GlassicAPI.SetFloatData(inst, {sym_build = "swap_nightmaresword", bank = "nightmaresword"})
    inst:RemoveEventCallback("equipped", nightsword_socketed_crystal)
    inst:RemoveEventCallback("itemget", nightsword_socketed_crystal)
    inst:RemoveEventCallback("itemlose", nightsword_socketed_crystal)
    return unpack({ _nightsword_clear_fn(inst) })
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
    nightsword = {
        { name = "nightsword_lotus", exclusive_char = "civi" },
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
    -- yellowamulet = {
    --     { name = "yellowamulet_heart", exclusive_char = "miotan" }
    -- },
    -- Dummy
    dummy = {
        "dummy_none"
    },
    -- greenamulet = {
    --     { name = "greenamulet_heart", exclusive_char = "dummy" }
    -- },
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

GLOBAL.setfenv(1, GLOBAL)
local CHARACTER_EXCLUSIVE_SKINS = {}

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
    GlassicAPI.SetOnequipSkinItem("hivehat", {"swap_body", "swap_body", "hat_hive"})
end

local function does_character_have_skin(skin_name, character_prefab)
    if GlassicAPI.SkinHandler.is_valid_mod_skin(skin_name) then
        local characters = CHARACTER_EXCLUSIVE_SKINS[skin_name]
        if characters then
            if character_prefab then
                return table.contains(characters, character_prefab)
            end
        end
    end
    return true
end

local DefaultSkinSelectionPopup = require("screens/redux/defaultskinselection")
local DefaultSkinSelectionPopup_GetSkinsList = DefaultSkinSelectionPopup.GetSkinsList
DefaultSkinSelectionPopup.GetSkinsList = function(self, ...)
    local player_prefab = self.character
    local check_ownership = InventoryProxy.CheckOwnership
    InventoryProxy.CheckOwnership = function(self, name, ...)
        if not does_character_have_skin(name, player_prefab) then
            return false
        end
        return check_ownership(self, name, ...)
    end
    local ret = { DefaultSkinSelectionPopup_GetSkinsList(self, ...) }
    InventoryProxy.CheckOwnership = check_ownership
    return unpack(ret)
end

local function set_exclusive_to(skin, char)
    local characters = type(char) ~= "table" and {char} or char
    CHARACTER_EXCLUSIVE_SKINS[skin] = characters

    local function test_fn(skin_name, userid)
        local player = GlassicAPI.SkinHandler.GetPlayerFromID(userid)
        if player then
            local chars = CHARACTER_EXCLUSIVE_SKINS[skin_name]
            if chars then
                print("Skin Test Fn", skin_name, player)
                return table.contains(chars, player.prefab)
            end
        end
        return true
    end

    GlassicAPI.SkinHandler.SetTestFn(skin, test_fn)
end

GlassicAPI.SkinHandler.AddModSkins({
    -- Civi
    civi = { "civi_none" },
    armorskeleton = { "armorskeleton_none" },
    skeletonhat = { "skeletonhat_glass" },
    -- Mio
    miotan = { "miotan_none", "miotan_classic" },
    lantern = { "lantern_mio" },
    yellowamulet = { "yellowamulet_heart" },
    -- Dummy
    dummy = { "dummy_none" },
    greenamulet = { "greenamulet_heart" },
    raincoat = { "raincoat_peggy" },
    eyebrellahat = { "eyebrellahat_peggy" },
    -- Common
    dragonflychest = { "dragonflychest_gingerbread" },
    meatrack = { "meatrack_hermit_red", "meatrack_hermit_white" },
    hivehat = { "hivehat_pigcrown", "hivehat_pigcrown_willow" },
    alterguardianhat = { "alterguardianhat_finger" },
    wx78 = { "wx78_potato" }
})

set_exclusive_to("armorskeleton_none", "civi")
set_exclusive_to("skeletonhat_glass", "civi")
set_exclusive_to("lantern_mio", "miotan")
set_exclusive_to("yellowamulet_heart", "miotan")
set_exclusive_to("greenamulet_heart", "dummy")
set_exclusive_to("raincoat_peggy", "dummy")
set_exclusive_to("eyebrellahat_peggy", "dummy")

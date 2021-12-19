if GLOBAL.TheNet:GetIsClient() or GLOBAL.TheNet:GetIsServer() then return end

PrefabFiles = {
    "civi",
    "miotan",
    "dummy",
}

Assets = {
    Asset( "ATLAS", "bigportraits/civi_none.xml" ),
    Asset( "ATLAS", "images/names_civi.xml" ),
    Asset( "ATLAS", "images/avatars/avatar_civi.xml" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_civi.xml" ),
    Asset( "ATLAS", "images/avatars/self_inspect_civi.xml" ),
    Asset( "ATLAS", "images/saveslot_portraits/civi.xml" ),

    Asset( "ATLAS", "bigportraits/miotan.xml" ),
    Asset( "ATLAS", "bigportraits/miotan_none.xml" ),
    Asset( "ATLAS", "bigportraits/miotan_classic.xml" ),
    Asset( "ATLAS", "images/names_miotan.xml" ),
    Asset( "ATLAS", "images/avatars/avatar_miotan.xml" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_miotan.xml" ),
    Asset( "ATLAS", "images/avatars/self_inspect_miotan.xml" ),
    Asset( "ATLAS", "images/saveslot_portraits/miotan.xml" ),

    Asset( "ATLAS", "bigportraits/dummy.xml" ),
    Asset( "ATLAS", "bigportraits/dummy_none.xml" ),
    Asset( "ATLAS", "images/names_dummy.xml" ),
    Asset( "ATLAS", "images/avatars/avatar_dummy.xml" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_dummy.xml" ),
    Asset( "ATLAS", "images/avatars/self_inspect_dummy.xml" ),
    Asset( "ATLAS", "images/saveslot_portraits/dummy.xml" ),
}

AddModCharacter("miotan", "FEMALE")
AddModCharacter("dummy", "FEMALE")
AddModCharacter("civi", "MALE")

modimport("main/tuning.lua")
modimport("main/strings.lua")

local SkinHandler = require("skinhandler")
SkinHandler.AddModSkins({
    civi = {
        is_char = true,
        "civi_none"
    },
    miotan = {
        is_char = true,
        "miotan_none",
        "miotan_classic"
    },
    dummy = {
        is_char = true,
        "dummy_none"
    },
})

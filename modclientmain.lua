if not GLOBAL.IsInFrontEnd() then return end

PrefabFiles = {
	"ns_skins",
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

	Asset( "ATLAS", "images/hud/dummy_status_health.xml" ),

}

AddModCharacter("miotan", "FEMALE")
AddModCharacter("dummy", "FEMALE")
AddModCharacter("civi", "MALE")

modimport("main/tuning")
modimport("main/strings")

modimport("main/clothing")
modimport("main/prefabskin")

modimport("postinit/widgets/templates")

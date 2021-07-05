Assets = {}
PrefabFiles = {
	"civi",
    "civi_amulets",
    "civi_gems",
    "nightpack",

    "miotan",
    
    "dummy",
    "dummy_books",
    "blackholestaff",
    "nightmare_spear",

    "ns_itemskins",
}

GlassicAPI.InitCharacterAssets("miotan", "FEMALE", Assets)
GlassicAPI.InitMinimapAtlas("miotan_minimap", Assets)
GlassicAPI.RegisterItemAtlas("miotan_inventoryimages", Assets)

GlassicAPI.InitCharacterAssets("dummy", "FEMALE", Assets)
GlassicAPI.InitMinimapAtlas("dummy_minimap", Assets)
GlassicAPI.RegisterItemAtlas("dummy_inventoryimages", Assets)
GlassicAPI.RegisterItemAtlas("hud/nightmaretab", Assets)

GlassicAPI.InitCharacterAssets("civi", "MALE", Assets)
GlassicAPI.InitMinimapAtlas("civi_minimap", Assets)
GlassicAPI.RegisterItemAtlas("civi_inventoryimages", Assets)

local main_files = {
    "tuning",
    "strings",

    "gem_nightsword",
    "gem_socket",
    "night_switch",
    "prefabskin",
    "recipes",
    "sanity_calc_rework",
    "widgets",

	"eatfuel",
	"fuelactions",
	"sanity_reward",
	"tradefuel",

	"only_dazui",
	"staff_action",
}

for _, v in ipairs(main_files) do
    modimport("main/"..v)
end

-- temp code for fish farm in IA
AddPrefabPostInit("fish_farm", function(inst)

    inst.current_volume = GLOBAL.net_tinybyte(inst.GUID, "current_volume")

    if not GLOBAL.TheWorld.ismastersim then return end

    inst.current_volume:set(inst.components.breeder.volume)
    inst:ListenForEvent("vischange", function(inst)
        inst.current_volume:set(inst.components.breeder.volume)
    end)

end)
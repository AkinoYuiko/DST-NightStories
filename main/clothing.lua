local Assets = Assets
GLOBAL.setfenv(1, GLOBAL)

local function add_clothing(name, data, test_fn)
	if test_fn == nil then
		test_fn = true
	end

	table.insert(Assets, Asset("DYNAMIC_ANIM", "anim/dynamic/".. name ..".zip"))
	table.insert(Assets, Asset("PKGREF", "anim/dynamic/".. name ..".dyn"))

	CLOTHING[name] = data
	GlassicAPI.SkinHandler.AddModSkin(name, test_fn)
end

local clothing =
{
	body_sleepgown_green_grass =
	{
		type = "body",
		skin_tags = { "CLOTHING_BODY", "CLOTHING", "GREEN", },
		symbol_overrides = { "torso", "torso_pelvis", "arm_upper", "skirt", },
		torso_tuck = "skirt",
		rarity = "Glassic",
		-- marketable = false,
		-- release_group = 7,
	},
}
-- add_clothing("body_sleepgown_green_grass", clothing["body_sleepgown_green_grass"])

local STRINGS = GLOBAL.STRINGS
local strings = {
    NAMES = 
    {
        CIVI = "Civi",
        LIGHTAMULET = "Light Amulet",
        DARKAMULET = "Dark Amulet",
        NIGHTPACK = "Night Backpack",
        DARKGEM = "Dark Gem",
        LIGHTGEM = "Light Gem",

        MIOTAN = "Mio",

        DUMMY = "Dummy",
        BLACKHOLESTAFF = "Blackhole Staff",
        BOOK_HARVEST = "Season of Harvest",
        BOOK_TOGGLEDOWNFALL = "Love of Rain",
        NIGHTMARE_SPEAR = "Nightmare Spear",

        -- PROPSIGN = "Prop Sign"
    },
    RECIPE_DESC =
    {
        REDGEM = "Change ice into fire.",
        BLUEGEM = "Change fire into ice.",
        NIGHTPACK = "Dark away.",
        DARKAMULET = "Powerful but dark.",
        LIGHTAMULET = "Keep away from dark things.",
        DARKGEM = "Upgrades!",
        LIGHTGEM = "Degrades!",

        BLACKHOLESTAFF = "Absorb everything!",
        BOOK_HARVEST = "Should help you harvest!",
        BOOK_TOGGLEDOWNFALL = "/toggledownfall",
        NIGHTMARE_SPEAR = "Disappear in a moment.",
        -- PROPSIGN = STRINGS.CHARACTERS.GENERIC.DESCRIBE.HOMESIGN.GENERIC

    },
    SKIN_NAMES = 
    {
        civi_none = "Civi",
        armorskeleton_none = "Emperor's Formal",
	    skeletonhat_glass = "Crystal Skull",

        miotan_classic = "Classic",
        miotan_none = "Mio",
        nightstick_crystal = "Mahou Shoujo Star",
        lantern_mio = "Camping Lamp",
        yellowamulet_heart = "Glowing Heart",

        dummy_none = "Dummy",
        greenamulet_heart = "Green Heart",
        raincoat_peggy = "Peggy's Raincoat",

        dragonflychest_gingerbread = STRINGS.SKIN_NAMES.treasurechest_gingerbread,
        meatrack_rice = "Hermit's Meat Rack",
        hivehat_pigcrown = "Royal Crown",
        hivehat_pigcrown_willow = "Dark Crown",
    },
    SKIN_DESCRIPTIONS = 
    {
        civi_none = "Civi can control magic, turning lights into darks, or turning darks into lights.",
        miotan_classic = "Mio's V1 skin!",
        miotan_none = "Mio cames from another world, where nightmare is everywhere.",
        dummy_none = "Another girl comes from nightmare's world.",

    },
	TABS = 
	{
		["dummytab"] = "Nightmare"
	},
    CIVI_GEMS = 
    {
        FEEL_DARK = "I felt the dark.",
        ALREADY_DARK = "I've already in the dark.",
        FEEL_LIGHT = "I felt the light.",
        ALREADY_LIGHT = "I've already in the light.",
    },
    CHARACTERS =
    {
        GENERIC =
        {
            DESCRIBE =
            {
                NIGHTPACK = "It seems to need some glowing materials.",
                DARKAMULET = "I can feel the darkness coming.",
                LIGHTAMULET = "I can feel the darkness away.",
                DARKGEM = "Get closer to dark!",
                LIGHTGEM = "Get closer to light!",
                
                BLACKHOLESTAFF = "???",
                BOOK_HARVEST = "H-A-R-V-E-S-T!",
                BOOKTOGGLE_DOWNFALL = "/toggledownfall",
                NIGHTMARE_SPEAR = "It looks like breaking.",
            }
        },
        CIVI = require("speech_civi"),
	    MIOTAN = require("speech_miotan"),
        -- MIOTAN = require("speech_miotan")
    },
    -- character
    CHARACTER_NAMES = 
    {
        civi = "Civi",
        miotan = "Mio",
        dummy = "Dummy",
    },
    CHARACTER_TITLES = 
    {
        civi = "Mogician of Light and Dark",
        miotan = "The Nightmare Eater",
        dummy = "The Nightmare Breaker",
    },
    CHARACTER_ABOUTME = 
    {
        civi = "Civi can control magic, turning lights into darks, or turning darks into lights.",
        miotan = "Mio cames from another world, where nightmare is everywhere.",
        dummy = "Dummy also comes from the nightmare world. She is Mio's sister.",
    },
    CHARACTER_DESCRIPTIONS = 
    {
        civi = "*Travel between light and dark.\n*Can control nightmare.",
        miotan = "*World treats her differently.\n*Friend of nightmare.",
        dummy = "* Unfriendly to people.\n* Friend of nightmare.\n* Forgive.",
    },
    CHARACTER_QUOTES = 
    {
        civi = "\"Get close to Nightmare!\"",
        miotan = "\"If I could eat nightmare!\"",
        dummy = "\"No one plays with me...\"",
    },
    CHARACTER_BIOS = 
    {
        civi = {
            { title = "Birthday", desc = "Feb 25" },
            { title = "Favorite Food", desc = "Lv.0 - "..STRINGS.NAMES.BONESOUP.."\nLv.1 - "..STRINGS.NAMES.MEATBALLS.."\nLv.2 - "..STRINGS.NAMES.VOLTGOATJELLY },
            -- { title = "Secret Knowledge", desc = "While toiling away in his home laboratory late one night, Wilson was startled to hear a voice on the radio speaking directly to him. At first he feared he'd gone mad from too many late nights of experiments and accidentally-inhaled chemical fumes, but the voice assured him that it was no mere figment of the imagination. In fact, the voice had a proposition for him: if Wilson would build a machine according to their specifications, then he would be rewarded with secret knowledge, the likes of which no one had ever seen. Casting aside his better judgement (after all, what harm could come from making a vague bargain with a mysterious disembodied voice?) Wilson threw himself into constructing the machine. When at long last it was finally completed, the gentleman scientist had a moment of hesitation... a moment that might have saved him from his impending fate, had he been just a bit stronger of will. But at the voice's insistence, Wilson flipped the switch and activated his creation... and was never seen again.\nWell, at least not in this world." },
        },
		miotan =
		{
			{ title = "Birthday", desc = "July 17" },
	    	{ title = "Favorite Food", desc = "None" },
	    },
		dummy = {
			{ title = "Birthday", desc = "July 17" },
			{ title = "Favorite Food", desc = STRINGS.NAMES.NIGHTMAREPIE },
		},
    },
    CHARACTER_SURVIVABILITY = 
    {
        civi = STRINGS.CHARACTER_SURVIVABILITY.wilson,
        miotan = STRINGS.CHARACTER_SURVIVABILITY.wortox,
        dummy = STRINGS.CHARACTER_SURVIVABILITY.wes,
    },
}

-- GlassicAPI.MergeStringsToGLOBAL(require("speech_wortox"), strings.CHARACTERS.MIOTAN, true)
GlassicAPI.MergeStringsToGLOBAL(require("speech_wortox"), strings.CHARACTERS.MIOTAN, true)
GlassicAPI.MergeStringsToGLOBAL(strings)
GlassicAPI.MergeTranslationFromPO(MODROOT.."languages")

GLOBAL.UpdateCiviStrings = function()
    local file, errormsg = GLOBAL.io.open(MODROOT .. "scripts/speech_civi.lua", "w")
    if not file then print("Can't update " .. MODROOT .. "scripts/speech_civi.lua", "\n", tostring(errormsg)) return end
    GlassicAPI.MergeSpeechFile(require("speech_civi"), file)
    local file, errormsg = GLOBAL.io.open(MODROOT .. "languages/strings.pot", "w")
    if not file then print("Can't generate " .. MODROOT .. "languages/strings.pot", "\n", tostring(errormsg)) return end
    GlassicAPI.MakePOTFromStrings(file, strings)
end
-- GLOBAL.UpdateCiviStrings()

GLOBAL.UpdateMioStrings = function()
    local file, errormsg = GLOBAL.io.open(MODROOT .. "scripts/speech_miotan.lua", "w")
    if not file then print("Can't update " .. MODROOT .. "scripts/speech_miotan.lua", "\n", tostring(errormsg)) return end
    GlassicAPI.MergeSpeechFile(require("speech_miotan"), file, "speech_wortox")
    local file, errormsg = GLOBAL.io.open(MODROOT .. "languages/strings.pot", "w")
    if not file then print("Can't generate " .. MODROOT .. "languages/strings.pot", "\n", tostring(errormsg)) return end
    GlassicAPI.MakePOTFromStrings(file, strings)
end

GLOBAL.UpdateDummyStrings = function()
    -- local file, errormsg = GLOBAL.io.open(MODROOT .. "scripts/speech_dummy.lua", "w")
    -- if not file then print("Can't update " .. MODROOT .. "scripts/speech_dummy.lua", "\n", tostring(errormsg)) return  end
    -- GlassicAPI.MergeSpeechFile(require("speech_dummy"), file, "speech_wickerbottom")
    local file, errormsg = GLOBAL.io.open(MODROOT .. "languages/strings.pot", "w")
    if not file then print("Can't generate " .. MODROOT .. "languages/strings.pot", "\n", tostring(errormsg)) return end
    GlassicAPI.MakePOTFromStrings(file, strings)
end

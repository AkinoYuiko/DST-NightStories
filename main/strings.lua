local MODROOT = MODROOT
GLOBAL.setfenv(1, GLOBAL)

local strings = {
    ACTIONS =
    {
        FUELPOCKETWATCH = "Hack",
    },
    UI = {
        CRAFTING =
        {
            RECIPEACTION =
            {
                SOULSPLIT = "Split"
            }
        }
    },
    NAMES =
    {
        CIVI = "Civi",
        LIGHTAMULET = "Light Amulet",
        DARKAMULET = "Dark Amulet",
        NIGHTPACK = "Night Pack",
        NIGHTPACK_RED = "Red Night Pack",
        NIGHTPACK_BLUE = "Blue Night Pack",
        NIGHTPACK_PURPLE = "Purple Night Pack",
        NIGHTPACK_YELLOW = "Yellow Night Pack",
        NIGHTPACK_ORANGE = "Orange Night Pack",
        NIGHTPACK_GREEN = "Green Night Pack",
        NIGHTPACK_OPAL = "Opal Night Pack",
        -- NIGHTPACK_DARK = "Dark Night Pack",
        -- NIGHTPACK_LIGHT = "Light Night Pack",
        NIGHTPACK_FUEL = "Night Pack",
        DARKGEM = "Dark Gem",
        LIGHTGEM = "Light Gem",
        DARKMAGATAMA = "Dark Magatama",
        LIGHTMAGATAMA = "Light Magatama",

        MIOTAN = "Mio",
        FUELPOCKETWATCH = "hacking Backtrek Watch",

        DUMMY = "Dummy",
        LOSE_SANITY = "the lost of sanity",
        BLACKHOLESTAFF = "Blackhole Staff",
        BOOK_HARVEST = "Season of Harvest",
        BOOK_TOGGLEDOWNFALL = "Love of Rain",
        NIGHTMARE_SPEAR = "Nightmare Spear",

        SPICE_CACTUS = "Cactus Powder",
        SPICE_CACTUS_FOOD = "Cactus {food}",

        PORTABLE_WARDROBE_WRAP = "Magic Dress",
        PORTABLE_WARDROBE_ITEM = "Portable Wardrobe",
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

        DARKMAGATAMA = "Into Dark!",
        LIGHTMAGATAMA = "Into Light!",

        BLACKHOLESTAFF = "Absorb everything!",
        BOOK_HARVEST = "Should help you harvest!",
        BOOK_TOGGLEDOWNFALL = "/toggledownfall",
        NIGHTMARE_SPEAR = "Disappear in a moment.",

        SPICE_CACTUS = "Make sanity great again.",
        PORTABLE_WARDROBE_WRAP = "Convenient for dressing up.",
        PORTABLE_WARDROBE_ITEM = "Convenient for dressing up a lot.",

    },
    SKIN_NAMES =
    {
        civi_none = "Civi",
        armorskeleton_none = "Emperor's Formal",
        skeletonhat_glass = "Crystal Skull",

        miotan_classic = "Classic",
        miotan_none = "Mio",
        -- nightstick_crystal = "Mahou Shoujo Star",
        lantern_mio = "Camping Lamp",
        yellowamulet_heart = "Glowing Heart",

        dummy_none = "Dummy",
        greenamulet_heart = "Green Heart",
        raincoat_peggy = "Peggy's Raincoat",

        dragonflychest_gingerbread = STRINGS.SKIN_NAMES.treasurechest_gingerbread,
        meatrack_hermit_red = "Hermit's Meat Rack",
        meatrack_hermit_white = "Hermit's Meat Rack",
        hivehat_pigcrown = "Royal Crown",
        hivehat_pigcrown_willow = "Dark Crown",

        eyebrellahat_peggy = "Peggy's Eyebrella",
        alterguardianhat_finger = "Crossed Fingers",
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
        dummytab = "Nightmare",
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
                NIGHTPACK =
                {
                    GENERIC = "It seems to need some glowing materials.",
                    RED = "It shines red.",
                    BLUE = "It shines blue.",
                    PURPLE = "It shines purple.",
                    YELLOW = "It shines yellow.",
                    GREEN = "It shines green.",
                    ORANGE = "It shines orange.",
                    OPAL = "It shines!",
                    FUEL = "It doesn't shine.",
                },
                DARKAMULET = "I can feel the darkness coming.",
                LIGHTAMULET = "I can feel the darkness away.",
                DARKGEM = "Get closer to dark!",
                LIGHTGEM = "Get closer to light!",

                DARKMAGATAMA = "Make THE sword to the dark.",
                LIGHTMAGATAMA = "Make THE sword to the light.",

                BLACKHOLESTAFF = "???",
                BOOK_HARVEST = "H-A-R-V-E-S-T!",
                BOOK_TOGGLEDOWNFALL = "/toggledownfall",
                NIGHTMARE_SPEAR = "It looks like breaking.",

                SPICE_CACTUS = "Make sanity great again.",
                PORTABLE_WARDROBE_WRAP = "Dress up anytime.",
                PORTABLE_WARDROBE_ITEM = "Dress up anywhere.",

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
        dummy = "*Unfriendly to people.\n*Friend of nightmare.\n*Forgive.",
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

-- if not rawget(_G, "GlassicAPI") then return end

GlassicAPI.MergeStringsToGLOBAL(strings)
GlassicAPI.MergeStringsToGLOBAL(require("speech_wortox"), STRINGS.CHARACTERS.MIOTAN, true)
GlassicAPI.MergeTranslationFromPO(MODROOT.."languages")

local function MergeCharacterSpeech(char)
    local file, errormsg = io.open(MODROOT .. "scripts/speech_"..char..".lua", "w")
    if not file then print("Can't update " .. MODROOT .. "scripts/speech_" .. char .. ".lua" .. "\n" .. tostring(errormsg)) return end
    -- GlassicAPI.MergeSpeechFile(require("speech_"..char), file)
    GlassicAPI.MergeSpeechFile(STRINGS.CHARACTERS[string.upper(char)], file)
end

UpdateNsStrings = function(update_speech)
    if update_speech then
        MergeCharacterSpeech("miotan")
        -- MergeCharacterSpeech("dummy")
        MergeCharacterSpeech("civi")
    end
    local file, errormsg = io.open(MODROOT .. "languages/strings.pot", "w")
    if not file then print("Can't generate " .. MODROOT .. "languages/strings.pot" .. "\n" .. tostring(errormsg)) return end
    GlassicAPI.MakePOTFromStrings(file, strings)
end

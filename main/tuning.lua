-- Civi
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.CIVI = {}

TUNING.CIVI_HUNGER = 175
TUNING.CIVI_SANITY = 175
TUNING.CIVI_HEALTH = 175

-- Mio
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.MIOTAN = {
    "nightmarefuel",
    "nightmarefuel",
    "nightmarefuel",
    "nightmarefuel"
}
TUNING.MIOTAN_HUNGER = 100
TUNING.MIOTAN_SANITY = 100
TUNING.MIOTAN_HEALTH = 100

-- Dummy
local STRINGS = GLOBAL.STRINGS
-- Custom speech strings
STRINGS.CHARACTERS.DUMMY = require "speech_wickerbottom"
STRINGS.CHARACTER_SURVIVABILITY.dummy = STRINGS.CHARACTER_SURVIVABILITY.wortox

-- starting info --
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.DUMMY={}
TUNING.DUMMY_HUNGER = 150
TUNING.DUMMY_SANITY = 200
TUNING.DUMMY_HEALTH = 150

-- book --
STRINGS.CHARACTERS.DUMMY.ANNOUNCE_TOOMANYBIRDS = STRINGS.CHARACTERS.WICKERBOTTOM.ANNOUNCE_TOOMANYBIRDS
STRINGS.CHARACTERS.DUMMY.ANNOUNCE_WAYTOOMANYBIRDS = STRINGS.CHARACTERS.WICKERBOTTOM.ANNOUNCE_WAYTOOMANYBIRDS

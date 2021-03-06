local wilson_attack = 34

-- Civi --
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.CIVI = {}

TUNING.CIVI_BASE_STATUS = 175
TUNING.CIVI_HEALTH = TUNING.CIVI_BASE_STATUS
TUNING.CIVI_HUNGER = TUNING.CIVI_BASE_STATUS
TUNING.CIVI_SANITY = TUNING.CIVI_BASE_STATUS

TUNING.CIVI_BASE_SANITY_MULT = 0.75

TUNING.TOTEM_BUFF_RANGE = 15

-- Mio --
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.MIOTAN = {
    "nightmarefuel",
    "nightmarefuel",
    "nightmarefuel",
    "nightmarefuel"
}
TUNING.MIOTAN_STATUS = 100
TUNING.MIOTAN_HEALTH = TUNING.MIOTAN_STATUS
TUNING.MIOTAN_HUNGER = TUNING.MIOTAN_STATUS
TUNING.MIOTAN_SANITY = TUNING.MIOTAN_STATUS

TUNING.MIOTAN_SANITY_DAPPERNESS = - 1/18
TUNING.MIOTAN_SANITY_NIGHT_MULT = - TUNING.WENDY_SANITY_MULT
TUNING.MIOTAN_SANITY_MULT = TUNING.WENDY_SANITY_MULT

TUNING.MIOTAN_STALE_HUNGER_RATE = -0.5
TUNING.MIOTAN_STALE_HEALTH_RATE = 0
TUNING.MIOTAN_SPOILED_HUNGER_RATE = -1
TUNING.MIOTAN_SPOILED_HUNGER_RATE = -0.5

TUNING.MIOTAN_BOOST_ABSORPTION = 0.6
TUNING.MIOTAN_BOOST_MINTEMP = 10
TUNING.MIOTAN_RUN_SPEED = TUNING.WILSON_RUN_SPEED * 1.25
-- Dummy --
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.DUMMY = {}
TUNING.DUMMY_HEALTH = 200
TUNING.DUMMY_HUNGER = 150
TUNING.DUMMY_SANITY = TUNING.DUMMY_HEALTH
TUNING.DUMMY_DAMAGE_MULT = 0.75

TUNING.DUMMY_NIGHT_SANITY_MULT = 0
TUNING.DUMMY_SANITY_MULT = 0.5
TUNING.DUMMY_SANITY_AURA = 0.33

TUNING.NIGHTMARE_SPEAR_DAMAGE = wilson_attack * 2
TUNING.SANITY_LARGER = 40
-- spice_cactus --
TUNING.SPICE_MULTIPLIERS.SPICE_CACTUS = {
    SANITY = 1
}

TUNING.PORTABLE_WARDROBE_USES = 10
TUNING.HEALTH_FUELPOCKETWATCH_COST = -30

TUNING.BLACKHOLESTAFF_USES = 5

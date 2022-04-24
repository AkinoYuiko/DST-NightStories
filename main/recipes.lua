local AddRecipe = GlassicAPI.AddRecipe
local SortAfter = GlassicAPI.SortAfter
local SortBefore = GlassicAPI.SortBefore
local NoSearch = GlassicAPI.NoSearch
local AddDeconstructRecipe = AddDeconstructRecipe
local AddPlayerPostInit = AddPlayerPostInit
GLOBAL.setfenv(1, GLOBAL)

GlassicAPI.AddTech("FRIENDSHIPRING")
GlassicAPI.MergeTechBonus("MOONORB_UPGRADED", "FRIENDSHIPRING", 2)
GlassicAPI.MergeTechBonus("MOON_ALTAR_FULL", "FRIENDSHIPRING", 2)
GlassicAPI.MergeTechBonus("OBSIDIAN_BENCH", "FRIENDSHIPRING", 2)

STRINGS.NAMES.CIVI_REDGEM = STRINGS.NAMES.REDGEM
STRINGS.NAMES.CIVI_BLUEGEM = STRINGS.NAMES.BLUEGEM
STRINGS.NAMES.CIVI_DARKCRYSTAL = STRINGS.NAMES.DARKCRYSTAL
STRINGS.NAMES.CIVI_LIGHTCRYSTAL = STRINGS.NAMES.LIGHTCRYSTAL
STRINGS.NAMES.DUMMY_NIGHTMAREFUEL = STRINGS.NAMES.NIGHTMAREFUEL

--------------------
------- Civi -------
--------------------
local IsIA = require("nsutils/check_ia")
local RING_INGREDIENT =
{
    [true]  = "obsidian",
    [false] = "moonrocknugget",
}

-- 红宝石 --
AddRecipe("civi_redgem", {Ingredient("bluegem", 1), Ingredient("nightmarefuel", 1)}, TECH.CELESTIAL_ONE, {nounlock = true, nochar = true, builder_tag = "ns_builder_civi", product = "redgem"})
NoSearch("civi_redgem")

-- 蓝宝石 --
AddRecipe("civi_bluegem", {Ingredient("redgem", 1), Ingredient("nightmarefuel", 1)}, TECH.CELESTIAL_ONE, {nounlock = true, nochar = true, builder_tag = "ns_builder_civi", product = "bluegem"})
SortAfter("civi_bluegem", "civi_redgem")
NoSearch("civi_bluegem")

-- 黑水晶
AddRecipe("darkcrystal", {Ingredient("purplegem", 1), Ingredient("nightmarefuel", 4)}, TECH.NONE, {nomods = true, builder_tag = "ns_builder_civi", no_deconstruction = true})
SortAfter("darkcrystal", "purplegem")

-- 白水晶
AddRecipe("lightcrystal", {Ingredient("purplegem", 1), Ingredient("nightmarefuel", 4)}, TECH.NONE, {nomods = true, builder_tag = "ns_builder_civi", no_deconstruction = true})
SortAfter("lightcrystal", "darkcrystal")

-- 影背包 --
AddRecipe("nightpack", {Ingredient("darkcrystal", 1), Ingredient("lightcrystal", 1), Ingredient("nightmarefuel", 5)}, TECH.CELESTIAL_ONE, {nounlock = true, builder_tag = "ns_builder_civi"})
SortBefore("nightpack", "civi_redgem")

-- 友爱戒指
AddRecipe("friendshipring", {Ingredient(RING_INGREDIENT[IsIA], 4), Ingredient("nightmarefuel", 4)}, { FRIENDSHIPRING = 2 }, {nounlock = true, builder_tag = "ns_builder_civi"})
-- SortAfter("friendshipring", "nightpack")

-- 注能图腾
AddDeconstructRecipe("friendshiptotem_dark", {Ingredient(RING_INGREDIENT[IsIA], 4), Ingredient("nightmarefuel", 4), Ingredient("darkcrystal", 1)})
AddDeconstructRecipe("friendshiptotem_light", {Ingredient(RING_INGREDIENT[IsIA], 4), Ingredient("nightmarefuel", 4), Ingredient("lightcrystal", 1)})

---------------------
------- Dummy -------
---------------------

-- 灵魂剥离 --
AddRecipe("dummy_nightmarefuel", {Ingredient(CHARACTER_INGREDIENT.HEALTH, 20, nil, nil, "decrease_sanity.tex")}, TECH.NONE, {nomods = true, builder_tag = "ns_builder_dummy", product = "nightmarefuel", actionstr = "SOULSPLIT"})
NoSearch("dummy_nightmarefuel")
-- 暗影破碎者 --
AddRecipe("nightmare_spear", {Ingredient("nightmarefuel", 1)}, TECH.NONE, {builder_tag = "ns_builder_dummy", no_deconstruction = true, sg_state = "domediumaction"})

-- 收获的季节 --
AddRecipe("book_harvest", {Ingredient("papyrus", 2), Ingredient(CHARACTER_INGREDIENT.HEALTH, 15, nil, nil, "decrease_sanity.tex")}, TECH.SCIENCE_TWO, {builder_tag = "ns_builder_dummy"})

-- 雨神的眷恋 --
AddRecipe("book_toggledownfall", {Ingredient("papyrus", 2), Ingredient(CHARACTER_INGREDIENT.HEALTH, 30, nil, nil, "decrease_sanity.tex")}, TECH.MAGIC_THREE, {builder_tag = "ns_builder_dummy"})

-- 黑洞法杖 --
AddRecipe("blackholestaff", {Ingredient("livinglog", 2), Ingredient("orangegem", 2), Ingredient("nightmarefuel", 4)}, TECH.ANCIENT_FOUR, {nounclock = true, builder_tag = "ns_builder_dummy"})

---------------------
------- Other -------
---------------------

-- 仙人掌粉 --
AddRecipe("spice_cactus", {Ingredient("cactus_meat", 2), Ingredient("cactus_flower", 1)}, TECH.FOODPROCESSING_ONE, {nounlock = true, numtogive = 2, nochar = true, builder_tag = "professionalchef", no_deconstruction = true})
SortAfter("spice_cactus", "spice_salt")

-- 便携衣柜 & 魔法礼装 --
AddRecipe("portable_wardrobe_wrap", {Ingredient("giftwrap", 1), Ingredient("nightmarefuel",1)}, TECH.MAGIC_THREE, {no_deconstruction = true}, {"MAGIC"})
AddRecipe("portable_wardrobe_item", {Ingredient("portable_wardrobe_wrap", 3), Ingredient("boards", 4)}, TECH.MAGIC_THREE, {no_deconstruction = true}, {"MAGIC"})

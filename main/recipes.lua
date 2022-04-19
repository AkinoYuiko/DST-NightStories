local AddRecipe = GlassicAPI.AddRecipe
local SortAfter = GlassicAPI.SortAfter
GLOBAL.setfenv(1, GLOBAL)

STRINGS.NAMES.CIVI_REDGEM = STRINGS.NAMES.REDGEM
STRINGS.NAMES.CIVI_BLUEGEM = STRINGS.NAMES.BLUEGEM
STRINGS.NAMES.CIVI_DARKAMULET = STRINGS.NAMES.DARKAMULET
STRINGS.NAMES.CIVI_LIGHTAMULET = STRINGS.NAMES.LIGHTAMULET
STRINGS.NAMES.CIVI_DARKMAGATAMA = STRINGS.NAMES.DARKMAGATAMA
STRINGS.NAMES.CIVI_LIGHTMAGATAMA = STRINGS.NAMES.LIGHTMAGATAMA
STRINGS.NAMES.DUMMY_NIGHTMAREFUEL = STRINGS.NAMES.NIGHTMAREFUEL

-- 黑宝石 --
AddRecipe("darkgem", {Ingredient("purplegem", 1), Ingredient("nightmarefuel", 4)}, TECH.NONE, {builder_tag = "ns_builder_civi", no_deconstruction = true})
SortAfter("darkgem", "purplegem")

-- 白宝石 --
AddRecipe("lightgem", {Ingredient("purplegem", 1), Ingredient("nightmarefuel", 4)}, TECH.NONE, {builder_tag = "ns_builder_civi", no_deconstruction = true})
SortAfter("lightgem", "darkgem")

-- 红宝石 --
AddRecipe("civi_redgem", {Ingredient("bluegem", 1), Ingredient("nightmarefuel", 1)}, TECH.CELESTIAL_ONE, {nounlock = true, builder_tag = "ns_builder_civi", image = "redgem.tex", product = "redgem"})

-- 蓝宝石 --
AddRecipe("civi_bluegem", {Ingredient("redgem", 1), Ingredient("nightmarefuel", 1)}, TECH.CELESTIAL_ONE, {nounlock = true, builder_tag = "ns_builder_civi", image = "bluegem.tex", product = "bluegem"})

-- 黑暗护符 --
AddRecipe("civi_darkamulet", {Ingredient("moonrocknugget", 3), Ingredient("nightmarefuel", 3), Ingredient("darkgem", 1)}, TECH.CELESTIAL_ONE, {nomods = true, nounlock = true, builder_tag = "ns_builder_civi", image ="darkamulet.tex", product = "darkamulet"})
AddRecipe("darkamulet", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 3), Ingredient("darkgem", 1)}, TECH.ANCIENT_TWO, {nounlock = true})

-- 光明护符 --
AddRecipe("civi_lightamulet", {Ingredient("moonrocknugget", 3), Ingredient("nightmarefuel", 3), Ingredient("lightgem", 1)}, TECH.CELESTIAL_ONE, {nomods = true, nounlock = true, builder_tag = "ns_builder_civi", image = "lightamulet.tex", product ="lightamulet"})
AddRecipe("lightamulet", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 3), Ingredient("lightgem", 1)}, TECH.ANCIENT_TWO, {nounlock = true})

-- 黑勾玉 --
AddRecipe("darkmagatama", {Ingredient("darkgem", 1), Ingredient("nightmarefuel", 1)}, TECH.CELESTIAL_ONE, {nounlock = true, no_deconstruction = true})

AddRecipe("civi_darkmagatama", {Ingredient("darkgem", 1), Ingredient("nightmarefuel", 1)}, TECH.MAGIC_THREE, {nomods = true, builder_tag = "ns_builder_civi", image = "darkmagatama.tex", product = "darkmagatama"})
SortAfter("civi_darkmagatama", "nightsword", "MAGIC")

-- 白勾玉 --
AddRecipe("lightmagatama", {Ingredient("lightgem", 1), Ingredient("nightmarefuel", 1)}, TECH.CELESTIAL_ONE, {nounlock = true, no_deconstruction = true})

AddRecipe("civi_lightmagatama", {Ingredient("lightgem", 1), Ingredient("nightmarefuel", 1)}, TECH.MAGIC_THREE, {nomods = true, builder_tag = "ns_builder_civi", image = "lightmagatama.tex", product = "lightmagatama"})
SortAfter("civi_lightmagatama", "civi_darkmagatama")

-- 影背包 --
AddRecipe("nightpack", {Ingredient("darkgem", 1), Ingredient("lightgem", 1), Ingredient("nightmarefuel", 5)}, TECH.CELESTIAL_ONE, {nounlock = true, builder_tag = "ns_builder_civi"})

-- 灵魂剥离 --
AddRecipe("dummy_nightmarefuel", {Ingredient(CHARACTER_INGREDIENT.HEALTH, 20, nil, nil, "decrease_sanity.tex")}, TECH.NONE, {builder_tag = "ns_builder_dummy", product = "nightmarefuel", actionstr = "SOULSPLIT"})

-- 暗影破碎者 --
AddRecipe("nightmare_spear", {Ingredient("nightmarefuel", 1)}, TECH.NONE, {builder_tag = "ns_builder_dummy", no_deconstruction = true, sg_state = "domediumaction"})

-- 收获的季节 --
AddRecipe("book_harvest", {Ingredient("papyrus", 2), Ingredient(CHARACTER_INGREDIENT.HEALTH, 15, nil, nil, "decrease_sanity.tex")}, TECH.SCIENCE_TWO, {builder_tag = "ns_builder_dummy"})

-- 雨神的眷恋 --
AddRecipe("book_toggledownfall", {Ingredient("papyrus", 2), Ingredient(CHARACTER_INGREDIENT.HEALTH, 30, nil, nil, "decrease_sanity.tex")}, TECH.MAGIC_THREE, {builder_tag = "ns_builder_dummy"})

-- 黑洞法杖 --
AddRecipe("blackholestaff", {Ingredient("livinglog", 2), Ingredient("orangegem", 2), Ingredient("nightmarefuel", 4)}, TECH.ANCIENT_FOUR, {nounclock = true, builder_tag = "ns_builder_dummy"})

-- 仙人掌粉 --
AddRecipe("spice_cactus", {Ingredient("cactus_meat", 2), Ingredient("cactus_flower", 1)}, TECH.FOODPROCESSING_ONE, {nounlock = true, numtogive = 2, nochar = true, builder_tag = "professionalchef"})
SortAfter("spice_cactus", "spice_salt")

-- 便携衣柜 & 魔法礼装 --
AddRecipe("portable_wardrobe_wrap", {Ingredient("giftwrap", 1), Ingredient("nightmarefuel",1)}, TECH.MAGIC_THREE, nil, {"MAGIC"})
AddRecipe("portable_wardrobe_item", {Ingredient("portable_wardrobe_wrap", 3), Ingredient("boards", 4)}, TECH.MAGIC_THREE, nil, {"MAGIC"})

local AddRecipe2 = AddRecipe2
local AddCharacterRecipe = AddCharacterRecipe
GLOBAL.setfenv(1, GLOBAL)

STRINGS.NAMES.CIVI_REDGEM = STRINGS.NAMES.REDGEM
STRINGS.NAMES.CIVI_BLUEGEM = STRINGS.NAMES.BLUEGEM
STRINGS.NAMES.CIVI_DARKAMULET = STRINGS.NAMES.DARKAMULET
STRINGS.NAMES.CIVI_LIGHTAMULET = STRINGS.NAMES.LIGHTAMULET
STRINGS.NAMES.CIVI_DARKMAGATAMA = STRINGS.NAMES.DARKMAGATAMA
STRINGS.NAMES.CIVI_LIGHTMAGATAMA = STRINGS.NAMES.LIGHTMAGATAMA
STRINGS.NAMES.DUMMY_NIGHTMAREFUEL = STRINGS.NAMES.NIGHTMAREFUEL

-- 黑宝石 --
AddCharacterRecipe("darkgem", {Ingredient("purplegem", 1), Ingredient("nightmarefuel", 4)}, TECH.NONE, {builder_tag = "ns_builder_civi", no_deconstruction = true}, {"MODS"})
GlassicAPI.SortAfter("darkgem", "purplegem", "REFINE")

-- 白宝石 --
AddCharacterRecipe("lightgem", {Ingredient("purplegem", 1), Ingredient("nightmarefuel", 4)}, TECH.NONE, {builder_tag = "ns_builder_civi", no_deconstruction = true}, {"MODS" })
GlassicAPI.SortAfter("lightgem", "darkgem", "REFINE")

-- 红宝石 --
AddCharacterRecipe("civi_redgem", {Ingredient("bluegem", 1), Ingredient("nightmarefuel", 1)}, TECH.CELESTIAL_ONE, {nounlock = true, builder_tag = "ns_builder_civi", image = "redgem.tex", product = "redgem"}, {"CRAFTING_STATION" })

-- 蓝宝石 --
AddCharacterRecipe("civi_bluegem", {Ingredient("redgem", 1), Ingredient("nightmarefuel", 1)}, TECH.CELESTIAL_ONE, {nounlock = true, builder_tag = "ns_builder_civi", image = "bluegem.tex", product = "bluegem"}, {"CRAFTING_STATION"})

-- 黑暗护符 --
AddCharacterRecipe("civi_darkamulet", {Ingredient("moonrocknugget", 3), Ingredient("nightmarefuel", 3), Ingredient("darkgem", 1)}, TECH.CELESTIAL_ONE, {nounlock = true, builder_tag = "ns_builder_civi", image ="darkamulet.tex", product = "darkamulet"}, {"CRAFTING_STATION", "MODS"})

AddRecipe2("darkamulet", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 3), Ingredient("darkgem", 1)}, TECH.ANCIENT_TWO, {nounlock = true}, {"MODS"})

-- 光明护符 --
AddCharacterRecipe("civi_lightamulet", {Ingredient("moonrocknugget", 3), Ingredient("nightmarefuel", 3), Ingredient("lightgem", 1)}, TECH.CELESTIAL_ONE, {nounlock = true, builder_tag = "ns_builder_civi", image = "lightamulet.tex", product ="lightamulet"}, {"CRAFTING_STATION", "MODS"})

AddRecipe2("lightamulet", {Ingredient("moonrocknugget", 3), Ingredient("nightmarefuel", 3), Ingredient("lightgem", 1)}, TECH.ANCIENT_TWO, {nounlock = true}, {"MODS"})

-- 黑勾玉 --
AddRecipe2("darkmagatama", {Ingredient("darkgem", 1), Ingredient("nightmarefuel", 1)}, TECH.CELESTIAL_ONE, {nounlock = true, no_deconstruction = true}, {"MODS"})
-- AllRecipes["civi_darkmagatama"].sortkey = AllRecipes["purplegem"].sortkey + 0.1

AddCharacterRecipe("civi_darkmagatama", {Ingredient("darkgem", 1), Ingredient("nightmarefuel", 1)}, TECH.MAGIC_THREE, {builder_tag = "ns_builder_civi", image = "darkmagatama.tex", product = "darkmagatama"})
GlassicAPI.SortAfter("civi_darkmagatama", "nightsword", "MAGIC")

-- 白勾玉 --
AddRecipe2("lightmagatama", {Ingredient("lightgem", 1), Ingredient("nightmarefuel", 1)}, TECH.CELESTIAL_ONE, {nounlock = true, no_deconstruction = true}, {"MODS"})

AddCharacterRecipe("civi_lightmagatama", {Ingredient("lightgem", 1), Ingredient("nightmarefuel", 1)}, TECH.MAGIC_THREE, {builder_tag = "ns_builder_civi", image = "lightmagatama.tex", product = "lightmagatama"})
GlassicAPI.SortAfter("civi_lightmagatama", "civi_darkmagatama", "MAGIC")

-- 影背包 --
AddCharacterRecipe("nightpack", {Ingredient("darkgem", 1), Ingredient("lightgem", 1), Ingredient("nightmarefuel", 5)}, TECH.CELESTIAL_ONE, {nounlock = true, builder_tag = "ns_builder_civi"}, {"CRAFTING_STATION", "MODS"})

-- 灵魂剥离 --
AddCharacterRecipe("dummy_nightmarefuel", {Ingredient(CHARACTER_INGREDIENT.HEALTH, 20, nil, nil, "decrease_sanity.tex")}, TECH.NONE, {builder_tag = "ns_builder_dummy", product = "nightmarefuel", actionstr = "SOULSPLIT"})

-- 暗影破碎者 --
AddCharacterRecipe("nightmare_spear", {Ingredient("nightmarefuel", 1)}, TECH.NONE, {builder_tag = "ns_builder_dummy", no_deconstruction = true, sg_state = "domediumaction"}, {"MODS"})

-- 收获的季节 --
AddCharacterRecipe("book_harvest", {Ingredient("papyrus", 2), Ingredient(CHARACTER_INGREDIENT.HEALTH, 15, nil, nil, "decrease_sanity.tex")}, TECH.SCIENCE_TWO, {builder_tag = "ns_builder_dummy"}, {"MODS"})

-- 雨神的眷恋 --
AddCharacterRecipe("book_toggledownfall", {Ingredient("papyrus", 2), Ingredient(CHARACTER_INGREDIENT.HEALTH, 30, nil, nil, "decrease_sanity.tex")}, TECH.MAGIC_THREE, {builder_tag = "ns_builder_dummy"}, {"MODS"})

-- 黑洞法杖 --
AddCharacterRecipe("blackholestaff", {Ingredient("livinglog", 2), Ingredient("orangegem", 2), Ingredient("nightmarefuel", 4)}, TECH.ANCIENT_FOUR, {nounclock = true, builder_tag = "ns_builder_dummy"}, {"CRAFTING_STATION", "MODS"})

-- 仙人掌粉 --
AddRecipe2("spice_cactus", {Ingredient("cactus_meat", 2), Ingredient("cactus_flower", 1)}, TECH.FOODPROCESSING_ONE, {nounlock = true, numtogive = 2, builder_tag = "professionalchef"}, {"MODS"})

-- 便携衣柜 & 魔法礼装 --
AddRecipe2("portable_wardrobe_wrap", {Ingredient("giftwrap", 1), Ingredient("nightmarefuel",1)}, TECH.MAGIC_THREE, nil, {"MAGIC"})

AddRecipe2("portable_wardrobe_item", {Ingredient("portable_wardrobe_wrap", 3), Ingredient("boards", 4)}, TECH.MAGIC_THREE, nil, {"MAGIC"})

local ENV = env
GLOBAL.setfenv(1, GLOBAL)
local AddRecipe = ENV.AddRecipe
local AddRecipeTab = ENV.AddRecipeTab
-- 黑宝石 --
AddRecipe("civi_darkgem",
{Ingredient("purplegem", 1),Ingredient("nightmarefuel", 4)},
RECIPETABS.REFINE, TECH.NONE, nil, nil, nil, nil, "nightmaregem", nil, "darkgem.tex",nil,"darkgem")
AllRecipes["civi_darkgem"].sortkey = AllRecipes["purplegem"].sortkey + 0.1
STRINGS.NAMES.CIVI_DARKGEM = STRINGS.NAMES.DARKGEM

-- 白宝石 --
AddRecipe("civi_lightgem",
{Ingredient("purplegem", 1),Ingredient("nightmarefuel", 4)},
RECIPETABS.REFINE, TECH.NONE, nil, nil, nil, nil, "nightmaregem", nil, "lightgem.tex",nil,"lightgem" )
AllRecipes["civi_lightgem"].sortkey = AllRecipes["civi_darkgem"].sortkey + 0.1
STRINGS.NAMES.CIVI_LIGHTGEM = STRINGS.NAMES.LIGHTGEM

-- 红宝石 --
AddRecipe("civi_redgem",
{Ingredient("bluegem", 1),Ingredient("nightmarefuel", 1)},
RECIPETABS.CELESTIAL, TECH.CELESTIAL_ONE, nil, nil, true,nil, "nightmaregem", nil, "redgem.tex", nil, "redgem")
STRINGS.NAMES.CIVI_REDGEM = STRINGS.NAMES.REDGEM

-- 蓝宝石 --
AddRecipe("civi_bluegem",
{Ingredient("redgem", 1),Ingredient("nightmarefuel", 1)},
RECIPETABS.CELESTIAL, TECH.CELESTIAL_ONE, nil, nil, true,nil, "nightmaregem", nil, "bluegem.tex",nil, "bluegem" )
STRINGS.NAMES.CIVI_BLUEGEM = STRINGS.NAMES.BLUEGEM

-- 黑暗护符 --
AddRecipe("civi_darkamulet",
{Ingredient("moonrocknugget", 3), Ingredient("nightmarefuel", 3), Ingredient("darkgem",1)},
RECIPETABS.CELESTIAL, TECH.CELESTIAL_ONE, nil, nil, true, nil, "nightmaregem", nil, "darkamulet.tex", nil, "darkamulet")
STRINGS.NAMES.CIVI_DARKAMULET = STRINGS.NAMES.DARKAMULET

AddRecipe("darkamulet",
{Ingredient("thulecite", 2), Ingredient("nightmarefuel", 3), Ingredient("darkgem",1)},
RECIPETABS.ANCIENT, TECH.ANCIENT_TWO,  nil, nil, true)
AllRecipes["darkamulet"].sortkey = AllRecipes["greenamulet"].sortkey + 0.1

-- 光明护符 --
AddRecipe("civi_lightamulet",
{Ingredient("moonrocknugget", 3), Ingredient("nightmarefuel", 3), Ingredient("lightgem",1)},
RECIPETABS.CELESTIAL, TECH.CELESTIAL_ONE, nil, nil, true, nil, "nightmaregem", nil, "lightamulet.tex", nil, "lightamulet")
STRINGS.NAMES.CIVI_LIGHTAMULET = STRINGS.NAMES.LIGHTAMULET

AddRecipe("lightamulet",
{Ingredient("thulecite", 2), Ingredient("nightmarefuel", 3), Ingredient("lightgem",1)},
RECIPETABS.ANCIENT, TECH.ANCIENT_TWO,  nil, nil, true)
AllRecipes["lightamulet"].sortkey = AllRecipes["darkamulet"].sortkey + 0.1

-- 影背包 --
AddRecipe("nightpack",
-- AddRecipe("glowingbackpack",
{Ingredient("darkgem", 1), Ingredient("lightgem",1),Ingredient("nightmarefuel", 5)},
RECIPETABS.CELESTIAL, TECH.CELESTIAL_ONE, nil, nil, true, nil, "nightmaregem")

-- Dummy Tab --
local dummytab = AddRecipeTab("nightmaretab", 100, "images/hud/nightmaretab.xml", "nightmaretab.tex", "nm_breaker")
STRINGS.TABS["nightmaretab"] = STRINGS.TABS["dummytab"]

-- 灵魂剥离 --
AddRecipe("dummy_nightmarefuel",
{Ingredient(CHARACTER_INGREDIENT.SANITY, 20)},
dummytab, TECH.NONE, nil, nil, nil, nil, "nm_breaker", nil, "nightmarefuel.tex",nil ,"nightmarefuel")
STRINGS.NAMES.DUMMY_NIGHTMAREFUEL = STRINGS.NAMES.NIGHTMAREFUEL

-- 暗影破碎者 --
AddRecipe("nightmare_spear",
{Ingredient("nightmarefuel", 1)},
dummytab, TECH.NONE, nil, nil, nil, nil, "nm_breaker", nil, "nightmare_spear.tex" )

-- 黑洞法杖 --
AddRecipe("blackholestaff",
{Ingredient("livinglog", 2), Ingredient("orangegem", 2),Ingredient("nightmarefuel", 4)},
RECIPETABS.ANCIENT, TECH.ANCIENT_FOUR, nil, nil, true, nil, "nm_breaker", nil, "blackholestaff.tex" )
AllRecipes["blackholestaff"].sortkey = AllRecipes["greenstaff"].sortkey + 0.1

-- 收获的季节 --
AddRecipe("book_harvest",
{Ingredient("papyrus", 2), Ingredient(CHARACTER_INGREDIENT.SANITY, 15)},
dummytab, TECH.SCIENCE_TWO, nil, nil, nil, nil,"nm_breaker", nil, "book_harvest.tex")

-- 雨神的眷恋 --
AddRecipe("book_toggledownfall",
{Ingredient("papyrus", 2), Ingredient(CHARACTER_INGREDIENT.SANITY, 30)},
dummytab, TECH.MAGIC_THREE, nil, nil, nil, nil,"nm_breaker", nil, "book_toggledownfall.tex")

ENV.AddStategraphPostInit("wilson", function(sg)
    local old_handler = sg.actionhandlers[ACTIONS.BUILD].deststate
    sg.actionhandlers[ACTIONS.BUILD].deststate = function(inst, action)
        -- if not inst.sg:HasStateTag("busy") then
        if action.recipe and action.recipe == "nightmare_spear" and action.doer and action.doer.prefab == "dummy" then
            return "domediumaction"
        else
            return old_handler(inst, action)
        end
        -- end
    end
end)


-- non-exclusive recipes --
AddRecipe("propsign", 
{Ingredient("log", 1), Ingredient("twigs", 1)}, 
RECIPETABS.MAGIC, TECH.MAGIC_THREE)


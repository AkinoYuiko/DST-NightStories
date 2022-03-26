version = "1.26.3"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = "丁香女子学校"
description = locale == "zh" and "[版本: " .. version .. [[]

更新内容:
- 使用 GlassicAPI.SortRecipeToTarget 调整配方排序。

- 更新配方“灵魂剥离”的动作文本。
- 更新适配 Glassic API。
- 所有配方适配新版本。
- 增加人物专属合成栏的图标。

“黑夜将至，你准备好了吗？”
]] or "[Version: " .. version .. [[]

Changelog:
- Use GlassicAPI.SortRecipeToTarget for recipe sorting.

- Update actionstr for Dummy's recipe.
- Update for Glassic API.
- Update for the new version of DST.
- Add characters' crafting menu icon.

"Night is coming, aren't you ready yet?"
]]

forumthread = ""
api_version = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

priority = 25
mod_dependencies = {
    {
        workshop = "workshop-2521851770",    -- Glassic API
        ["GlassicAPI"] = false,
        ["Glassic API - DEV"] = true
    },
}
folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
    name = name .. " - DEV"
end

configuration_options = {}

version = "1.26.6"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = "丁香女子学校"
description = locale == "zh" and "[版本: " .. version .. [[]

更新内容:
- Dummy Badge 兼容 Island Adventures 的中毒状态。
- 调整了暗影破碎枪的耐久计算机制和更新耐久显示的频率。

- 修复一些配方问题。
- 使用 GlassicAPI.SortBefore 和 GlassicAPI.SortAfter 调整配方排序。
- 更新配方“灵魂剥离”的动作文本。
- 更新适配 Glassic API。
- 所有配方适配新版本。
- 增加人物专属合成栏的图标。

“黑夜将至，你准备好了吗？”
]] or "[Version: " .. version .. [[]

Changelog:
- Update DummyBadge for Island Adventures.
- Update Nightmare Spear's fueled logic.

- Fix issues with recipes.
- Use GlassicAPI.SortAfter for recipe sorting.
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

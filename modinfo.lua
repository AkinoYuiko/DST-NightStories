version = "1.0.2"
-- basic info --
name = locale == "zh" and "暗夜故事集(角色篇)" or "Characters of Night Stories"
author = locale == "zh" and "丁香女子学校" or "Civi, Tony, Lssss, kengyou_lei"
description = locale == "zh" and "[版本: "..version..[[]

更新内容: 
- 合并了一些文件

- 修改了影背包的交互代码
- 合并自以下三个创意工坊MOD: 848543526, 1105844780, 1840586628
]] or "[Version: "..version..[[]

Changelog: 
- Mixed inventoryimages tex

- Changed part of Night Backpack's interaction.
- From these workshop items: 848543526, 1105844780, 1840586628
]]

forumthread = ""
api_version = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
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

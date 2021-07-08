version = "1.2.4"
-- basic info --
name = locale == "zh" and "暗夜故事集(角色篇)" or "Characters of Night Stories"
author = locale == "zh" and "丁香女子学校" or "Civi, Tony, Lssss, kengyou_lei"
description = locale == "zh" and "[版本: "..version..[[]

更新内容: 
- 修复一个崩溃问题.
- 修复影背包图片显示问题.

- 更新适配新版本 Glassic API.

]] or "[Version: "..version..[[]

Changelog: 
- Fixed crash with Night Backpack.
- Fixed display issue with Night Backpack.

- Updated for new version of Glassic API.

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

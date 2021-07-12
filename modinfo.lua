version = "1.6.1"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = locale == "zh" and "丁香女子学校" or "Civi, Tony, Lssss, kengyou_lei"
description = locale == "zh" and "[版本: "..version..[[]

更新内容: 
- 新增了一部分语言文本.

- 新增一个晨星皮肤（澪专属）.
- 移除澪的提灯皮肤.

]] or "[Version: "..version..[[]

Changelog:
- Added some new strings.

- Added a new item skin for Mio.
- Removed Lantern skin from Mio.

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

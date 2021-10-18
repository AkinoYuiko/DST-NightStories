version = "1.15.3"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = "丁香女子学校"
description = locale == "zh" and "[版本: "..version..[[]

更新内容:
- 修复澪与猪王交易时可能导致崩溃的一个问题.

- 修复水面上的影背包显示位置不正确的问题.
- 调整影背包（橙）的拾取速度.
- 影背包 (黄) 基础持续时间提升到3.6天.
- 影背包插上不同宝石后显示不同的名字以区分.

]] or "[Version: "..version..[[]

Changelog:
- Fix a crash when Mio trading with Pig King.

- Fix an issue about anim of floating Night Pack.
- Adjust pick-up speed for Night Pack (Orange).
- Night Pack (Yellow) lasts from 2.4 to 3.6 days.
- Gem-socked Night Pack shows different names.

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

version = "1.18.3"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = "丁香女子学校"
description = locale == "zh" and "[版本: " .. version .. [[]

更新内容:
- 所有动作合并到一个文件.
- 修复黑暗护符充能时声音缺失的问题.

- 澪交换燃料采用新的兼容性写法.
- 影刀移除容器属性的等待时间增加至2s.

]] or "[Version: " .. version .. [[]

Changelog:
- All actions in one file.
- Fix missing sound on fueling Dark Amulet.

- Tweak "tradefuel" to improve compatibility.
- Increase time to remove "container" for Dark Sword to 2s (Orig is 1s).
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

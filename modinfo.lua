version = "1.20.4"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = "丁香女子学校"
description = locale == "zh" and "[版本: " .. version .. [[]

更新内容:
- 修复一个崩溃.

- 修复救赎之心救赎达米时没有触发效果的问题.
- 澪和达米死亡时会留下一个噩梦燃料，而不是骨架.
- 修复作祟相关的问题.
- 达米现在可以作祟活着的澪或者达米.

]] or "[Version: " .. version .. [[]

Changelog:
- Fix crash on using pocketwatch_revive.

- Fix issue on reviving Dummy.
- Mio and Dummy leaves a nightmarefuel instead of bone on death.
- Fix issues with haunt.
- Dummy is now able to haunt Mio or Dummy.
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

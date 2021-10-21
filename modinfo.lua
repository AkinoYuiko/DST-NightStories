version = "1.16.3"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = "丁香女子学校"
description = locale == "zh" and "[版本: "..version..[[]

更新内容:
- 优化仙人掌粉的贴图.

- 优化代码写法.
- 修复仙人掌粉引起卡顿的问题.
- 新道具: 仙人掌粉 (大厨专属)

]] or "[Version: "..version..[[]

Changelog:
- Rework texture of spice_cactus.

- Update due to stupid tuni.
- Fix an isuue that cactus powder causing lag.
- New item: Cactus powder (exclusive to Warly).
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

version = "1.11.3"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = "丁香女子学校"
description = locale == "zh" and "[版本: "..version..[[]

更新内容:
- 修复了一个贴图错误.

- 稍微修改了角色动画包.
- 稍微修改了粒子特效的大小.
- 给野营灯皮肤新增粒子特效.

]] or "[Version: "..version..[[]

Changelog:
- Fixed a texture issue.

- Modified characters' anim pack.
- Increased FX size.
- Added FX for Camping Lamp.

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

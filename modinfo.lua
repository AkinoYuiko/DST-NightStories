version = "1.3.3"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = locale == "zh" and "丁香女子学校" or "Civi, Tony, Lssss, kengyou_lei"
description = locale == "zh" and "[版本: "..version..[[]

更新内容: 
- 调整影背包切换状态的代码.

- 月岛药可以把金质工具变为玻璃工具.
- 重做黑洞法杖的图标和动画.
- 影背包代码重写.

]] or "[Version: "..version..[[]

Changelog: 
- Update nightpack's code on switching states.

- Mutatable golden tools.
- Reworked blackholestaff's anim and image.
- Reworked nightpack's code.

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

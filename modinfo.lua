version = "1.17"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = "丁香女子学校"
description = locale == "zh" and "[版本: "..version..[[]

更新内容:
- 新增黑/白勾玉 (天体科技制作).
- 黑/白勾玉的堆叠数量为 8.
- 黑/白勾玉代替原先的黑白宝石插入影刀.
- 黑/白宝石移除可插入影刀的功能.

]] or "[Version: "..version..[[]

Changelog:
- Add Dark & Light Magatamas (Under Celestial Techs.).
- Dark & Light Magatamas' max stack size is 8.
- Dark & Light Magatamas can be socketed into Dark Sword.
- Dark & Light Gems can nolonger be socketed into Dark Sword.
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

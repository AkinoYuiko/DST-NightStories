version = "1.6.4"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = locale == "zh" and "丁香女子学校" or "Civi, Tony, Lssss, kengyou_lei"
description = locale == "zh" and "[版本: "..version..[[]

更新内容:
- 澪现在可以在充能状态下自动对宝石影刀进行补充.

- 修复晨星皮肤在水面切换皮肤时显示不正常的问题.
- 修复充能状态下澪不会降背包内噩梦燃料干燥的问题.
- 新增了一部分语言文本.
- 新增一个晨星皮肤（澪专属）.
- 移除澪的提灯皮肤.

]] or "[Version: "..version..[[]

Changelog:
- Mio is now able to auto-fill dark/light gems into socketed-nightsword during boosting time.

- Fixed issue where reskinning Morning Star doesn't show correct anim on floating.
- Fixed issue where Nightmare Fuels wouldn't dry in the packback when Mio is during boost time.
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

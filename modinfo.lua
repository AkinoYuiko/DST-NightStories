version = "1.24.5"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = "丁香女子学校"
description = locale == "zh" and "[版本: " .. version .. [[]

更新内容:
- 重命名 UpvalueHacker 为 UpvalueUtil。

- 重命名 OnSkinChange 为 OnReskinFn。
- 修复和澪的精神速率有关的问题。
- 修复达米被大月灵打死时会被同时治疗的问题。
- 澪现在可以使用噩梦燃料充能彩灯。

“黑夜将至，你准备好了吗？”
]] or "[Version: " .. version .. [[]

Changelog:
- Rename UpvalueHacker as UpvalueUtil.

- Rename OnSkinChange as OnReskinFn.
- Fix a bug for Mio's sanity rate.
- Fix Dummy getting healing by gestalts when dying.
- Mio can refuel Winter Lights.

"Night is coming, aren't you ready yet?"
]]

forumthread = ""
api_version = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true

icon_atlas = "images/modicon.xml"
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

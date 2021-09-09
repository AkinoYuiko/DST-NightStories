version = "1.14.5"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = "丁香女子学校"
description = locale == "zh" and "[版本: "..version..[[]

更新内容:
- 更新Sanity组件.

- 达米捡花/恶魔花不会影响精神值.
- 更新了部分语言文本.
- 修复部分皮肤在水上换皮肤丢失模型的问题.
- 重写了部分皮肤代码.
- 更新澪填燃料的动作.

]] or "[Version: "..version..[[]

Changelog:
- Update Sanity component.

- Dummy's sanity will no longer be affected by picking flowers or evil flowers.
- Update some strings.
- Fixed issue where body items missing floating anims on reskinned.
- Rework "prefabskin.lua".
- Update Mio's fuel action.

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

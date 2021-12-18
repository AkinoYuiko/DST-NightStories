version = "1.19.5"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = "丁香女子学校"
description = locale == "zh" and "[版本: " .. version .. [[]

更新内容:
- 修复达米使用启迪之冠的激活问题.

- 补全达米因精神清空的死亡讯息.
- 提高兼容性.
- 修复客户端没有隐藏SanityBadge的问题.
- 重写达米相关代码, 达米现在血量和精神值合并, 上限为250.

]] or "[Version: " .. version .. [[]

Changelog:
- Fix Enlightened Crown not deactive on losing sanity for Dummy.

- Fix missing death message for losing sanity.
- Improve compatibility with DST-Fixed.
- Fix SanityBadge not hidden on client side.
- Rework Dummy. She now uses her Sanity as Health, and has a new max to 250.
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

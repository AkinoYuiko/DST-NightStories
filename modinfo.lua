version = "1.21.7"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = "丁香女子学校"
description = locale == "zh" and "[版本: " .. version .. [[]

更新内容:
- 修复澪和达米死亡时可能产生多个噩梦燃料的问题.

- 修复烧毁的便携式衣柜可回收的问题.
- 修复了生成pot时包含多余文本的问题.
- 更新了部分翻译文本.
- 更新了便携式衣柜的放置间隔.
- 更新了部分文本.
- 新增道具【魔术礼装】(暗影操纵仪解锁).
- 新增道具【便携式衣柜】(暗影操纵仪解锁).
]] or "[Version: " .. version .. [[]

Changelog:
- Fix issue that Mio or Dummy would leave more than 1 nightmare fuel on death.

- Fix issue that burnt portable wardrobe is disassemble.
- Fix issue when generating .POT files.
- Update translate strings.
- Update deploy spacing for portable wardrobe.
- Update strings.
- New item "Magic Dress".
- New item "Portable Wardrobe".
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

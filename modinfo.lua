local function zheng(zh, en)
    local LOC = {
        zh = zh,
        zht = zh,
    }
    return LOC[locale] or en
end

version = "1.47.3"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 修复锁链标记的攻击逻辑中存在的问题。

- 修复一处拼写错误。
- 调整月影为不可分解。
- 调整了月影的数值、能源耐久和获得方式。
- 调整了恐惧锁链的数值。
- 修改了月光粉的外观。
]], [[
- Fix issue where main target should be attacked before other chained targets.

- Fix a typo.
- Moonlight Shadow is no longer deconstructable.
- Change damage, repair value and recipe of Moonlight Shadow.
- Change damage of Horror Chain.
- Moonlight Powder has new outlook.
]])
description = zheng("版本: ", "Version: ") .. version ..
    zheng("\n\n更新内容:\n", "\n\nChangelog:\n") .. changelog .. "\n" ..
    zheng("“黑夜将至，你准备好了吗？”", "\"Night is coming, aren't you ready yet?\"")

priority = 25

api_version = 10
dst_compatible = true
all_clients_require_mod = true

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

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

server_filter_tags = {
    "night_stories",
    "night stories",
}

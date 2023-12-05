local function zheng(zh, en)
    local LOC = {
        zh = zh,
        zht = zh,
    }
    return LOC[locale] or en
end

version = "1.52.6"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 拳击袋显示优化：显示同一帧内受到的伤害总额。

版本更新历史：
- 修复一个攻击判定问题。
- 调整了远程武器攻击锁链目标的行为逻辑。
- 修复启迪之冠在月光粉BUFF期间仍然会触发的问题。
- 调整了月光粉的代码逻辑。
- 新增只有拥有技能树的四名角色可以重置洞察。
- 新增一种快捷重置洞察的方法（详见合成菜单-角色栏）。
]], [[
- Punching Bag shows damage taken in one frame each time.

Version Change Notes:
- Fix issue with attacking rule.
- Tweak ranged weapon behaviors on attacking chained target.
- Fix issue where Enlightened Crown may trigger gestalts when Lunar Powder activated.
- Tweak code logic for Lunar Powder.
- Only characters with skill trees can reset insight.
- Add a quick way to reset insight (See Crafting Menu - Character Filter).
]])
description = zheng("版本: ", "Version: ") .. version ..
    zheng("\n\n本次更改内容:\n", "\n\nChange:\n") .. changelog .. "\n" ..
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

local function zheng(zh, en)
    local LOC = {
        zh = zh,
        zht = zh,
    }
    return LOC[locale] or en
end

version = "1.53.3.4"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 修复一处潜在的崩溃。

最近更新：
- 月亮入侵或月亮风暴期间猪王给月亮碎片。
- 修复几处逻辑错误。
- 修正亮茄尖刺球棒数值设置错误的问题。
- 新道具：亮茄尖刺球棒。
- 亮茄尖刺球棒：基础攻击力34，位面伤害17，保质期10天，基础伤害随时间下降。
]], [[
- Fix a potential crash.

Recent Changes:
- Pig King rewards Moon Shard during Moonstorm.
- Fix some potential issue.
- Fix a typo with damage of Brightshade Spike Bat.
- New Item: Brightshade Spike Bat.
- Brightshade Spike Bat: Base Damage 34, Planar Damage 17, Durability 10 days. Base damage reduces by freshness.
]])
description = zheng("版本: ", "Version: ") .. version ..
    zheng("\n\n本次更新:\n", "\n\nChanges:\n") .. changelog .. "\n" ..
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

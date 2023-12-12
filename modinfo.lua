local function zheng(zh, en)
    local LOC = {
        zh = zh,
        zht = zh,
    }
    return LOC[locale] or en
end

version = "1.53"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 新道具：亮茄尖刺球棒。
- 亮茄尖刺球棒：基础攻击力34，位面伤害17，保质期10天，基础伤害随时间下降。
]], [[
- New Item: Brightshade Spike Bat.
- Brightshade Spike Bat: Base Damage 34, Planar Damage 17, Durability 10 days. Base damage reduces by freshness.
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

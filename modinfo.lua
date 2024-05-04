local function zheng(zh, en)
    local LOC = {
        zh = zh,
        zht = zh,
    }
    return LOC[locale] or en
end

version = "1.55.1"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 调整了澪的自动充能机制。

最近更新：
- 猪王不再提供【月亮碎片】。
- 月亮传送门可制作部分配方。
- 移除配方【亮茄尖刺球棒】。
- 调整配方【月光粉】。
- 皮肤适配【姜饼箱妈妈】。
]], [[
- Change how Mio's auto-refueling works.

Recent Changes:
- Pig King no longer rewards Moon Shards.
- Set the Celestial Portal as prototyper.
- Remove Recipe: Brightshade Spike Bat.
- Tweak Recipe: Lunar Powder.
- Bug fixes.
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

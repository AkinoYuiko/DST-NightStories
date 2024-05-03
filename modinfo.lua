local function zheng(zh, en)
    local LOC = {
        zh = zh,
        zht = zh,
    }
    return LOC[locale] or en
end

version = "1.55"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 移除配方【亮茄尖刺球棒】。
- 调整配方【月光粉】。
- 月亮传送门可制作部分配方。
- 皮肤适配【姜饼箱妈妈】。
]], [[
- Remove Recipe: Brightshade Spike Bat.
- Tweak Recipe: Lunar Powder.
- Set the Celestial Portal as prototyper.
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

local function zheng(zh, en)
    local LOC = {
        zh = zh,
        zht = zh,
    }
    return LOC[locale] or en
end

version = "1.56.4"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 调整【月光粉】配方。

最近更新：
- Civi 可以通过阴郁回旋镖附加恐惧锁链效果。
- Civi 新增两种转换配方。
- 重写了【月影】切换机制。
]], [[
- Tweak recipe for Lunar Powder.

Recent Changes:
- Civi can attach "horror chain" effect on targets hit by Gloomerang.
- Add two new recipes for Civi.
- Rework the way Lunar Shadow switches state.
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

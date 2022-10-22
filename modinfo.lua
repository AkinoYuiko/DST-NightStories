local function zheng(a, b)
    return (locale == "zh" or locale == "zht") and a or b
end

version = "1.36.2"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Azur Circle")
changelog = zheng([[
- Civi的等级会影响他获得BUFF时的持续时间。

- 澪的自动充能对懒人护符生效。
- 新道具：【THE 潮涌】。从【实用求雨仪式】和【控温学】升级而来。
]], [[
- Civi's level now affects duration when he gets debuffed.

- Mio can now trigger auto refuel to The Lazy Forager.
- New Item: The Wetness. A book upgraded from Practical Rain Rituals and Tempering Temperatures.
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

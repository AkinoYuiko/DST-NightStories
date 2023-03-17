local function zheng(a, b)
    return (locale == "zh" or locale == "zht") and a or b
end

version = "1.39.2"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Azur Circle")
changelog = zheng([[
- 修复影背包缺失图片的问题。

- 修复一处拼写错误。
- 从【Glassic API】中迁移了道具和皮肤。
]], [[
- Fix missing image for Night Pack.

- Fix a typo.
- Merge example items and skins from "Glassic API".
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

local function zheng(a, b)
    return (locale == "zh" or locale == "zht") and a or b
end

version = "1.38.4"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Azur Circle")
changelog = zheng([[
- 修复影背包不能用燃料充能的问题。

- 修复注能光明图腾效果错误的问题。
- 移除一处多余的debug信息。
- 修复一处崩溃。
- 为Civi重写了食物buff模块。
- 为澪添加了与纯净恐惧相关的特性。
]], [[
- Fix bug where Night Pack doesn't accept fuel.

- Fix issue where Charged Light Totem has wrong effects.
- Remove some debug info.
- Fix a crash.
- Refactor foodbuffs for Civi.
- Add compatibility for Mio with Pure Horror.
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

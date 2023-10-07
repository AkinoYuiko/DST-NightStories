local function zheng(zh, en)
    local LOC = {
        zh = zh,
        zht = zh,
    }
    return LOC[locale] or en
end

version = "1.43.1"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 修复一处崩溃。

- 月影更改了充能系统。
- 使用【月亮碎片】、【注能月亮碎片】、【纯净辉煌】为月影提供能量。
]], [[
- Fix a crash.

- Rework battery system for Moonlight Shadow.
- Use Moon Glass, Charged Moon Glass or Pure Brilliance as battery for Moonlight Shadow.
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

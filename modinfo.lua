local function loc(t)
    t.zht = t.zht or t.zh
    return t[locale] or t.en
end

local function zh_en(a, b)
    return loc({
        zh = a,
        en = b
    })
end

version = "1.30.10"
-- basic info --
name = zh_en("暗夜故事集", "Night Stories")
author = zh_en("丁香女子学校", "Civi, Tony, LSSSS")
changelog = zh_en([[
- 修复雨衣缺少SetOnequipSkinItem的问题。

- 调整了部分代码的位置。
- 调整了部分配方的顺序。
- 更新了“皇帝的新衣”的静态材质和图标。
- 修复入侵溯源表动作文本丢失的问题。
- 土豆。
- 更改澪皮肤的格式为dyn。
]], [[
- Fix missing SetOnequipSkinItem for Rain Coat.

- Tweak code structure.
- Tweak some recipe sorting.
- Tweak idle anim and icon for skin "Emperor's Formal".
- Fix missing string for action "Hack" into Backtrek Watch.
- Potato.
- Tweak Mio's skin texture to dyn.
]])
description = zh_en("版本: ", "Version: ") .. version ..
    zh_en("\n\n更新内容:\n", "\n\nChangelog:\n") .. changelog .. "\n" ..
    zh_en("“黑夜将至，你准备好了吗？”", "\"Night is coming, aren't you ready yet?\"")

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

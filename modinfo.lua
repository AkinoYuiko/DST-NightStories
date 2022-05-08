local function loc(t)
    t.zhr = t.zh
    t.zht = t.zht or t.zh
    t.ch = t.ch or t.zh
    return t[locale] or t.en
end

local function zh_en(a, b)
    return loc({
        zh = a,
        en = b
    })
end

version = "1.30.4"
version_compatible = "1.30.2"
-- basic info --
name = zh_en("暗夜故事集", "Night Stories")
author = zh_en("丁香女子学校", "Civi, Tony, LSSSS")
description = zh_en(
    -- zh
"版本: " .. version .. "\n\n" .. [[更新内容:
- 更新了“皇帝的新衣”的静态材质和图标。

- 修复入侵溯源表动作文本丢失的问题。
- 土豆。
- 更改澪皮肤的格式为dyn。

“黑夜将至，你准备好了吗？”]],
    -- en
"Version: " .. version .. "\n\n" ..[[Changelog:
- Tweak idle anim and icon for skin "Emperor's Formal".

- Fix missing string for action "Hack" into Backtrek Watch.
- Potato.
- Tweak Mio's skin texture to dyn.

"Night is coming, aren't you ready yet?"]]
)

forumthread = ""
api_version = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

priority = 25
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

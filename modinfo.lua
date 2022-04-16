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

version = "1.27.2"
-- basic info --
name = zh_en("暗夜故事集", "Night Stories")
author = zh_en("丁香女子学校", "Civi, Tony, LSSSS")
description = zh_en(
    -- zh
"[版本: " .. version .. [[]

更新内容:
- 澪现在不会自动充能船灯了（岛屿冒险MOD）。

- 更新 modinfo 的多语言文本功能。
- 修复澪的自动充能对 Island Adventures 的船装备不生效的问题。
- 使用 GlassicAPI.AddRecipe 改善配方标签管理。

“黑夜将至，你准备好了吗？”]],
    -- en
"[Version: " .. version .. [[]

Changelog:
- Mio now won't do auto-refuel to boat lamp in IA.

- Update LOC fn in modinfo.
- Fix issue that Mio's auto-refuel not working for boat equiment in Island Adventures.
- Use GlassicAPI.AddRecipe for better recipe-init.

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

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

version = "1.35.7.1"
version_compatible = "1.35.7"
-- basic info --
name = zh_en("暗夜故事集", "Night Stories")
author = zh_en("丁香女子学校", "Civi, Tony, LSSSS")
changelog = zh_en([[
- 移除旧版本的兼容性代码。
- 兼容书籍图层修复更新。

- 新增一些文本。
- 调整橙影背包和黑洞法杖的拾取逻辑。
- 修复了一些拼写错误。
- 达米的书同时适配现版本和测试版。
]], [[
- Add some string texts.
- Now compatible with book layer fix update.

- Tweak pickup logic for Orange Night Pack and Blackhole Staff.
- Remove backward compatible codes.
- Fix a typo with chs translation.
- Dummy's books are now compatible with both Release and Beta versions.
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

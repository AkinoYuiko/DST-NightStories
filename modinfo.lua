local function zheng(a, b)
    return (locale == "zh" or locale == "zht") and a or b
end

version = "1.37.5"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Azur Circle")
changelog = zheng([[
- 调整了部分语言文本。

- 降低角色音量。
- 战斗皇冠兼容麦斯威尔更新。
- 澪的自动充能对魔术师高礼帽有效。
- 添加角色声音。
]], [[
- Slightly tweak some string texts.

- Descease character sound volume.
- Make Battle Crown compatible with Maxwell Update.
- Auto Refuel now works for Magician's Top Hat.
- Add character sound.
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

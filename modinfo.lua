local function zheng(zh, en)
    local LOC = {
        zh = zh,
        zht = zh,
    }
    return LOC[locale] or en
end

version = "1.51.8"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 修复月影的图标和动画问题。

- 月影新造型（临时）
- 月影现在可以手动改变形态了（物品栏按住ALT）。
- 调整了澪吃燃料的动作优先级。
- 新皮肤：莫西鸭魔杖。
- 达米的仪表盘适配酸雨。
- 月光粉可以保护玩家免收月灵攻击。
- 新皮肤：麋鹿鸭手杖。
]], [[
- Fix issue for image and anim of Lunar Shadow.

- New icon and anim for Lunar Shadow (TEMP).
- Lunar Shadow can switch state in inventory(HOLDING ALT).
- Tweak action priority of Mio-Eating-Fuel.
- New skin: Mossia Staff.
- Dummy's Health-Sanity Meter fit for acid rain.
- Rename: Moonlight Powder -> Lunar Powder.
- Lunar Powder protects players from gestalt's attack.
- New skin: Mossling Cane.
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

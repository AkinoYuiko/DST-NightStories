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

version = "1.29"
-- basic info --
name = zh_en("暗夜故事集", "Night Stories")
author = zh_en("丁香女子学校", "Civi, Tony, LSSSS")
description = zh_en(
    -- zh
"[版本: " .. version .. [[]

更新内容:
- 使用白水晶可以给友爱戒指注能，将注能光明图腾放在地上，可以降低负面精神光环对玩家的影响，并增强正面精神光环对玩家的影响。
- 使用黑水晶可以给友爱戒指注能，将注能黑暗图腾放在地上，可以提高附近人物的攻击力。
- 装备友爱戒指后，吃恢复类食物时，可以广域化给附近其他角色，但恢复效果会根据受益人数衰减。
- 黑水晶代替原来黑宝石、黑勾玉的功能，即人物升级、嵌入武器。
- 白水晶代替原来白宝石、白勾玉的功能，即人物升级、嵌入武器。
- 新道具：黑水晶、白水晶、友爱戒指、注能黑暗图腾、注能光明图腾。
- 新增配方：黑水晶、白水晶、光暗投影仪。
- 移除配方：黑宝石、白宝石、黑勾玉、白勾玉、黑暗护符、光明护符。

“黑夜将至，你准备好了吗？”]],
    -- en
"[Version: " .. version .. [[]

Changelog:
- Charged Ring of Friendship can buff nearby players when on ground, replace Dark/Light Amulet.
- Equipping Ring of Friendship allows you to buff nearby players when eating food.
- Dark/Light Crystal replace Dark/Light Gem/Magatama's function.
- New items: Dark Crystal, Light Cystal, Ring of Friendship, Charged Ring of Friendship.
- New recipes: Dark Crystal, Light Crystal.
- Remove recipes: Dark Gem, Light Gem, Dark Magatama, Light Magatama, Dark Amulet, Light Amulet.

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

local function zheng(zh, en)
    local LOC = {
        zh = zh,
        zht = zh,
    }
    return LOC[locale] or en
end

version = "1.46.5"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 修复恐惧锁链攻击动作不正确的问题。

- 调整了恐惧锁链的音效。
...
- 新道具：恐惧锁链
  标记一个目标，再次攻击时，对附近所有拥有该标记的目标造成伤害。
  恐惧锁链受到虚空风帽的加成。
]], [[
- Fix issue where attacking anim for Horror Chain is incorrect.

- Tweak hit sound for Horror Chain.
...
- New Item: Horror Chain
  Tag a target. When attacking targets with tag, deal same attack to nearby targets with the tag.
  Gets bonus by Void Cowl.
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

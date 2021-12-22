version = "1.20.12"
version_compatible = "1.20.11"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = "丁香女子学校"
description = locale == "zh" and "[版本: " .. version .. [[]

更新内容:
- 调整了部分翻译文本.

- 修复达米不能从其他玩家身上获取San的问题.
- 调整了部分参数.
- 优化代码格式.
- 修复蒜粉可以降低达米精神消耗的问题.
- 达米传送时的无敌不会保护掉San了.
- 更新了澪的一部分模型贴图.
- 修复影灯附近有达米时不强制刷尖嘴的问题.
- 修复一个崩溃.
- 修复若干问题.
- 修复达米在附近时敲远古矿不是必出尖嘴的问题.
- 修复一个崩溃.
- 修复救赎之心救赎达米时没有触发效果的问题.
- 澪和达米死亡时会留下一个噩梦燃料，而不是骨架.
- 修复作祟相关的问题.
- 达米现在可以作祟活着的澪或者达米.
]] or "[Version: " .. version .. [[]

Changelog:
- Update some transalte strings.

- Fix issue that Dummy can not drain sanity from other players.
- Tweak tuning.
- Formating codes.
- Fix Dummy's sanity change affecting by absorption.
- Dummy will now lose sanity on teleporting.
- Update Mio's anim tex.
- Fix nightmare lights not spawning nightmarebeak when nearby Dummy.
- Fix crash with only_dazui.
- Fix several issues.
- Fix not spawning nightmarebeak on statueruins finished when nearby Dummy.
- Fix crash on using pocketwatch_revive.
- Fix issue on reviving Dummy.
- Mio and Dummy leaves a nightmarefuel instead of bone on death.
- Fix issues with haunt.
- Dummy is now able to haunt Mio or Dummy.
]]

forumthread = ""
api_version = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
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

configuration_options = {}

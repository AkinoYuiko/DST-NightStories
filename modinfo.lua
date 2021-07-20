version = "1.7.3"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = locale == "zh" and "丁香女子学校" or "Civi, Tony, Lssss, kengyou_lei"
description = locale == "zh" and "[版本: "..version..[[]

更新内容:
- 更新适配新的 UpvalueHacker.

- 更新适配 Glassic API.
- 新皮肤高清化, 增加暗黑配色版本.
- 新增一个蜂王冠皮肤 (素材来自于哈姆雷特, 未高清)

]] or "[Version: "..version..[[]

Changelog:
- Update for new UpvalueHacker.

- Update for new version of Glassic API.
- HD Royal Crown for Bee Queen Crown.
- Added Dark style version.
- Added a new skin for Bee Queen Crown (From Hamlet, not HD).

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

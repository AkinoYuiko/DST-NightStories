version = "1.24"
-- basic info --
name = locale == "zh" and "暗夜故事集" or "Night Stories"
author = "丁香女子学校"
description = locale == "zh" and "[版本: " .. version .. [[]

更新内容:
- 澪现在可以使用噩梦燃料充能彩灯。

“黑夜将至，你准备好了吗？”
]] or "[Version: " .. version .. [[]

Changelog:
- Remove prefabs' drawnameoverride.

- Tweak some code format.
- Update for a new version of Glassic API.
- Improve code performance for Mio.
- Tweak some code format.
- Fix action behavior on Blackhole Staff.
- Fix issue that Mio or Dummy can be haunted by non-Dummy players.
- Change string text of hacking Backtrek Watch.
- Mio and Dummy can hack Backtrek Watch with Nightmare Fuel.

"Night is coming, aren't you ready yet?"
]]

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

configuration_options = {}

local function zheng(zh, en)
	local LOC = {
		zh = zh,
		zht = zh,
	}
	return LOC[locale] or en
end

version = "1.59.1"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Ducklantis")
-- stylua: ignore
changelog = zheng([[
- 达米的梦魇之力命中附加3秒恐惧锁链
- 澪可用噩梦燃料或纯粹恐惧修复达米的书籍

最近更新：
- 【启迪之冠】隐藏彩蛋移除虚影生成
]], [[
- Dummy's Power of Nightmare now applies Horror Chain for 3 seconds on hit
- Mio can repair Dummy's books with Nightmare Fuel or Pure Horror

Recent Changes:
- Enlightened Crown prevents new ambient Gestalts from spawning under certain conditions
]])
description = zheng("版本: ", "Version: ")
	.. version
	.. zheng("\n\n本次更新:\n", "\n\nChanges:\n")
	.. changelog
	.. "\n"
	.. zheng("“黑夜将至，你准备好了吗？”", '"Night is coming, aren\'t you ready yet?"')

priority = 25

api_version = 10
dst_compatible = true
all_clients_require_mod = true

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

mod_dependencies = {
	{
		workshop = "workshop-2521851770", -- Glassic API
		["GlassicAPI"] = false,
		["Glassic API - DEV"] = true,
	},
}
folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
	name = name .. " - DEV"
end

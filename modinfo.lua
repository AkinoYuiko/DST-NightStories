local function zheng(zh, en)
	local LOC = {
		zh = zh,
		zht = zh,
	}
	return LOC[locale] or en
end

version = "1.56.9"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 修复部分皮肤问题

最近更新：
- 让达米的血量显示兼容新版本游戏
- 修复奖励数量计算错误的问题。
- 猪王代码适配最新更新。
- 调整【月光粉】配方。
- Civi 可以通过阴郁回旋镖附加恐惧锁链效果。
- Civi 新增两种转换配方。
- 重写了【月影】切换机制。
- 修复配方相关的一处错误。
]], [[
- Fix skin issue

Recent Changes:
- Make dummy's health badge compatible with new version of the game
- Fix issue that the amount of Pig King's rewards is wrong.
- Make compatibility with latest release.
- Tweak recipe for Lunar Powder.
- Civi can attach "horror chain" effect on targets hit by Gloomerang.
- Add two new recipes for Civi.
- Rework the way Lunar Shadow switches state.
- Fix a typo in recipes.
]])
description = zheng("版本: ", "Version: ") .. version ..
	zheng("\n\n本次更新:\n", "\n\nChanges:\n") .. changelog .. "\n" ..
	zheng("“黑夜将至，你准备好了吗？”", "\"Night is coming, aren't you ready yet?\"")

priority = 25

api_version = 10
dst_compatible = true
all_clients_require_mod = true

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

mod_dependencies = {
	{
		workshop = "workshop-2521851770",  -- Glassic API
		["GlassicAPI"] = false,
		["Glassic API - DEV"] = true
	},
}
folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
	name = name .. " - DEV"
end

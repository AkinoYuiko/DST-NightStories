local function zheng(zh, en)
	local LOC = {
		zh = zh,
		zht = zh,
	}
	return LOC[locale] or en
end

version = "1.57.3"
-- basic info --
name = zheng("暗夜故事集", "Night Stories")
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 收获的季节兼容新版晾肉架。
- 晾肉架格子接受堆叠。

近期更新：
- 启迪之冠的精神回复速率受天体珠宝的数量加成。
- 修复一处计算逻辑错误。
- 鸟笼兼容官方更新。
- 暂时禁用了本模组的晾肉架皮肤。
- 玻璃工具变成可解锁制作了。
]], [[
- The book "Season of Harvest" is now compatible with renewed Meatrack.
- Meatrack accepts stacking.

Recent changes:
- Enlightened Crown gains a dapperness multiplier that depends on the amount of Celestial Jewel.
- Fix a logic issue with calc.
- Make Bird Cage compatible with recent official update.
- Temporaryily diable skins for Meatrack.
- Moon Glass tools now become unlockable.
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

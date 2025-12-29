local WILSON_SKILL_TAGS = {
	"alchemist",
	"gem_alchemistI",
	"gem_alchemistII",
	"gem_alchemistIII",
	"ick_alchemistI",
	"ick_alchemistII",
	"ick_alchemistIII",
	"ore_alchemistI",
	"ore_alchemistII",
	"ore_alchemistIII",
}

local WILLOW_SKILL_TAGS = {
	"controlled_burner",
	"ember_master",
}

local ALIGN_TAGS = {
	"player_shadow_aligned",
	"player_luanr_aligned",
}

local function reset_skill_tree(player)
	if player then
		local skilltreeupdater = player.components.skilltreeupdater
		local prev = skilltreeupdater.skilltree.skip_validation
		skilltreeupdater:SetSkipValidation(true)
		local skilldefs = require("prefabs/skilltree_defs").SKILLTREE_DEFS[player.prefab]
		if skilldefs then
			for skill, data in pairs(skilldefs) do
				skilltreeupdater:DeactivateSkill(skill)
			end
			skilltreeupdater:AddSkillXP(-skilltreeupdater:GetSkillXP())
		end
		skilltreeupdater:SetSkipValidation(prev)

		-- WILSON
		for _, tag in ipairs(WILSON_SKILL_TAGS) do
			player:RemoveTag(tag)
		end

		if player.components.beard then -- for wilson
			player.components.beard:UpdateBeardInventory()
		end

		-- WILLOW :angri:
		for _, tag in ipairs(WILLOW_SKILL_TAGS) do
			player:RemoveTag(tag)
		end
		for _, tag in ipairs(ALIGN_TAGS) do
			player:RemoveTag(tag)
		end

		if player.updatelighters then
			player:updatelighters()
		end
		if player.updateembers then
			player:updateembers()
		end
		if player.bigbernies then
			for bern, val in pairs(player.bigbernies) do
				bern:onLeaderChanged(player)
			end
		end

		local damagetyperesist = player.components.damagetyperesist
		if damagetyperesist then
			damagetyperesist:RemoveResist("lunar_aligned", player, "willow_allegiance_lunar")
			damagetyperesist:RemoveResist("shadow_aligned", player, "willow_allegiance_shadow")
		end
		local damagetypebonus = player.components.damagetypebonus
		if damagetypebonus then
			damagetypebonus:RemoveBonus("shadow_aligned", player, "willow_allegiance_lunar")
			damagetypebonus:RemoveBonus("lunar_aligned", player, "willow_allegiance_shadow")
		end

		-- Refresh Crafting Menu
		player:PushEvent("unlockrecipe")
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()

	inst:AddTag("CLASSIFIED")

	--[[Non-networked entity]]
	inst.persists = false

	--Auto-remove if not spawned by builder
	inst:DoTaskInTime(0, inst.Remove)

	if not TheWorld.ismastersim then
		return inst
	end

	inst.OnBuiltFn = function(inst, builder)
		reset_skill_tree(builder)
	end

	return inst
end

return Prefab("skilltree_respec_tool", fn)

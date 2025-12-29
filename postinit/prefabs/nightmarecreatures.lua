local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local nightmare_prefabs = {
	"crawlinghorror",
	"terrorbeak",
	"oceanhorror",
	"swimminghorror", -- IA
}

local function sanity_reward_postinit(inst)
	if not TheWorld.ismastersim then
		return
	end

	local on_killed_by_other = inst.components.combat.onkilledbyother
	inst.components.combat.onkilledbyother = function(inst, attacker)
		if attacker and attacker:HasTag("nightmare_twins") and attacker.components.sanity then
			attacker.components.sanity:DoDelta((inst.sanityreward or TUNING.SANITY_SMALL) * 0.5)
		else
			on_killed_by_other(inst, attacker)
		end
	end
end

for _, prefab in ipairs(nightmare_prefabs) do
	AddPrefabPostInit(prefab, sanity_reward_postinit)
end

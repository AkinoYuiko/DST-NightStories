local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local GESTALT_PREFABS = {
	"gestalt",
	"gestalt_guard",
	"gestalt_guard_evolved",
}

local function postinit(inst)
	if not TheWorld.ismastersim then
		return
	end

	local retarget = inst.components.combat.targetfn
	inst.components.combat:SetRetargetFunction(1, function(_inst)
		local target = retarget(inst)
		if target and target.components.debuffable and target.components.debuffable:HasDebuff("buff_glash") then
			return
		end
		return target
	end)
end

for _, gestalt in ipairs(GESTALT_PREFABS) do
	AddPrefabPostInit(gestalt, postinit)
end

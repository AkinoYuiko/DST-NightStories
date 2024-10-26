local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local function onpickedfn_flower(inst, picker)
	local pos = inst:GetPosition()

	if picker then
		if picker.components.sanity and not picker:HasTag("plantkin") and not picker:HasTag("ns_builder_dummy") then -- changed part from original fn
			picker.components.sanity:DoDelta(TUNING.SANITY_TINY)
		end

		if inst.animname == "rose" and
			picker.components.combat and
			not (picker.components.inventory and picker.components.inventory:EquipHasTag("bramble_resistant")) and not picker:HasTag("shadowminion") then
			picker.components.combat:GetAttacked(inst, TUNING.ROSE_DAMAGE)
			picker:PushEvent("thorns")
		end
	end

	TheWorld:PushEvent("plantkilled", { doer = picker, pos = pos }) --this event is pushed in other places too
end

local FLOWERS =
{
	"flower",
	"flower_rose",
	"planted_flower",
}

for _, prefab in ipairs(FLOWERS) do
	AddPrefabPostInit(prefab, function(inst)
		if not TheWorld.ismastersim then return end

		if inst.components.pickable then
			inst.components.pickable.onpickedfn = onpickedfn_flower
		end
	end)
end

AddPrefabPostInit("flower_evil", function(inst)
	if not TheWorld.ismastersim then return end

	if inst.components.pickable then
		local onpickedfn_evil = inst.components.pickable.onpickedfn
		inst.components.pickable.onpickedfn = function(_inst, _picker)
			return _picker and not _picker:HasTag("ns_builder_dummy") and onpickedfn_evil(_inst, _picker)
		end
	end
end)

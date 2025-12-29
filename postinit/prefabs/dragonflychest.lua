local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local function push_event(inst)
	inst:PushEvent("dragonflychest_upgraded")
end

AddPrefabPostInit("dragonflychest", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	local upgradeable = inst.components.upgradeable
	local _OnUpgrade = upgradeable.onupgradefn

	local function OnUpgrade(inst, performer, upgraded_from_item)
		_OnUpgrade(inst, performer, upgraded_from_item)
		if upgraded_from_item then
			inst:DoTaskInTime(6 * FRAMES, push_event)
		else
			push_event(inst)
		end
	end
	upgradeable:SetOnUpgradeFn(OnUpgrade)

	local _OnLoad = inst.OnLoad
	inst.OnLoad = function(inst, data, newents)
		if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
			OnUpgrade(inst)
		end
	end
end)

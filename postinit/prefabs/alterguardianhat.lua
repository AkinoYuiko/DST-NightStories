local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("alterguardianhat", function(inst)
	if not TheWorld.ismastersim then return end

	if inst.components.equippable then
		local onequip = inst.components.equippable.onequipfn
		-- local onunequip = inst.components.equippable.onunequipfn

		inst.components.equippable:SetOnEquip(function(_inst, _owner)
			onequip(_inst, _owner)
			inst:RemoveEventCallback("onattackother", inst.alterguardian_spawngestalt_fn, _owner)
			local prev_spawn_fn = inst.alterguardian_spawngestalt_fn

			inst.alterguardian_spawngestalt_fn = function(__owner, __data)
				if not (__owner.components.debuffable and __owner.components.debuffable:HasDebuff("buff_moonglass")) then
					prev_spawn_fn(__owner, __data)
				end
			end
			inst:ListenForEvent("onattackother", inst.alterguardian_spawngestalt_fn, _owner)

		end)

	end
end)

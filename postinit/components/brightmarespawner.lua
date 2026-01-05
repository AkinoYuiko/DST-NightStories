local UpvalueUtil = GlassicAPI.UpvalueUtil
local AddComponentPostInit = AddComponentPostInit
GLOBAL.setfenv(1, GLOBAL)

AddComponentPostInit("brightmarespawner", function(self, inst)
	for _, fn in ipairs(inst.event_listeners["ms_playerjoined"][inst]) do
		local path = "OnSanityModeChanged.Start.UpdatePopulation.TrySpawnGestaltForPlayer.GetGestaltSpawnType"
		local get_gestalt_spawn_type, index, scope_fn = UpvalueUtil.GetUpvalue(fn, path)
		if get_gestalt_spawn_type then
			print("Hacking:", get_gestalt_spawn_type)
			debug.setupvalue(scope_fn, index, function(player, pt, ...)
				local gestalt = get_gestalt_spawn_type(player, pt, ...)
				if gestalt == "gestalt_guard_evolved" then
					local _evolved_spawn_pool, index, scope_fn = UpvalueUtil.GetUpvalue(self.OnSave, "_evolved_spawn_pool")
					if player and player.components.inventory and player.components.inventory:EquipHasTag("lunarseedmaxed") then
						local crown = player.components.inventory.equipslots[EQUIPSLOTS.HEAD]
						if crown and crown.components.container:Has("lunar_seed", 100) then
							gestalt = "gestalt"
							if type(_evolved_spawn_pool) == "number" then
								_evolved_spawn_pool = _evolved_spawn_pool + 1
								debug.setupvalue(scope_fn, index, _evolved_spawn_pool)
							end
						end
					end
				end
				return gestalt
			end)
			break
		end
	end
end)

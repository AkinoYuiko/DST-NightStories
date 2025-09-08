local UpvalueUtil = GlassicAPI.UpvalueUtil
local AddComponentPostInit = AddComponentPostInit
GLOBAL.setfenv(1, GLOBAL)

AddComponentPostInit("brightmarespawner", function(self, inst)
	for _, fn in ipairs(inst.event_listeners["ms_playerjoined"][inst]) do
		local path = "OnSanityModeChanged.Start.UpdatePopulation.TrySpawnGestaltForPlayer.GetGestaltSpawnType"
		local get_gestalt_spawn_type = UpvalueUtil.GetUpvalue(fn, path)
		if get_gestalt_spawn_type then
			print("Hacking:", get_gestalt_spawn_type)
			local function GetGestaltSpawnType(player, pt, ...)
				local type = get_gestalt_spawn_type(player, pt, ...)
				-- print("Gestalt Type:", type)
				if type == "gestalt_guard_evolved" then

					local _evolved_spawn_pool = UpvalueUtil.GetUpvalue(get_gestalt_spawn_type, "_evolved_spawn_pool")
					if player and player.components.inventory and player.components.inventory:EquipHasTag("lunarseedmaxed") then
						local crown = player.components.inventory.equipslots[EQUIPSLOTS.HEAD]
						if crown and crown.components.container:Has("lunar_seed", 200) then
							type = "gestalt"
							if type(_evolved_spawn_pool) == "number" then
								print("_evolved_spawn_pool", _evolved_spawn_pool)
								_evolved_spawn_pool = _evolved_spawn_pool + 1
								UpvalueUtil.SetUpvalue(get_gestalt_spawn_type, "_evolved_spawn_pool")
							end
							print("Gestalt OVERRIDE!")
						end
					end
				end
				return type
			end
			UpvalueUtil.SetUpvalue(fn, path, GetGestaltSpawnType)
			break
		end
	end
end)

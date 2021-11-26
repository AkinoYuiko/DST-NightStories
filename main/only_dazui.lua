local UpvalueHacker = require("upvaluehacker")
local AddComponentPostInit = AddComponentPostInit
GLOBAL.setfenv(1, GLOBAL)
AddComponentPostInit("shadowcreaturespawner", function(self, inst)
    for _, fn in ipairs(inst.event_listeners["ms_playerjoined"][inst]) do
        local path = "Start.UpdatePopulation.StartSpawn.UpdateSpawn.SpawnLandShadowCreature"
        local SpawnLandShadowCreature = UpvalueHacker.GetUpvalue(fn, path)
        if SpawnLandShadowCreature then
            -- print("setting SpawnLandShadowCreature")
            UpvalueHacker.SetUpvalue(fn, path, function(player)
                return SpawnPrefab(
                    player.prefab == "dummy" and "terrorbeak" or
                    player.components.sanity:GetPercent() < .1 and
                    math.random() < TUNING.TERRORBEAK_SPAWN_CHANCE and
                    "terrorbeak" or
                    "crawlinghorror"
                )
            end)
            break
        end
    end
end)

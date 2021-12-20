local UpvalueHacker = require("upvaluehacker")
local AddComponentPostInit = AddComponentPostInit
local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)
AddComponentPostInit("shadowcreaturespawner", function(self, inst)
    for _, fn in ipairs(inst.event_listeners["ms_playerjoined"][inst]) do
        local path = "Start.UpdatePopulation.StartSpawn.UpdateSpawn.SpawnLandShadowCreature"
        local SpawnLandShadowCreature = UpvalueHacker.GetUpvalue(fn, path)
        if SpawnLandShadowCreature then
            -- print("setting SpawnLandShadowCreature")
            UpvalueHacker.SetUpvalue(fn, path, function(player, ...)
                return SpawnPrefab(
                    player.spawnlandshadow_fn ~= nil and player.spawnlandshadow_fn(player, ...) or
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



local function get_nearby_dummy(inst)
    if not inst then return end
    for _, v in ipairs(AllPlayers) do
        if inst:GetDistanceSqToInst(v) < 3600 and v:HasTag("nightmarebreaker") then
            return "nightmarebeak"
        end
    end
    return "crawlingnightmare"
end

local nightmarecreature_table = {
    "nightmarefissure",
    "nightmarelight",
}
for _, prefab in ipairs(nightmarecreature_table) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then return end
        inst.components.childspawner.childname = get_nearby_dummy
    end)
end
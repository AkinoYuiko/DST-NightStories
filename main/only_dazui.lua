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
            return true
        end
    end
    return
end

local function check_dummy_spawn_beak(inst)
    if get_nearby_dummy(inst) then
        return "nightmarebeak"
    else
        return "crawlingnightmare"
    end
end

local nightmarecreature_table = {
    "nightmarefissure",
    "nightmarelight",
}
-- for _, prefab in ipairs(nightmarecreature_table) do
--     AddPrefabPostInit(prefab, function(inst)
--         if not TheWorld.ismastersim then return end
--         inst.components.childspawner.childname = check_dummy_spawn_beak(inst)
--     end)
-- end
local ChildSpawner = require "components/childspawner"
local DoSpawnChild = ChildSpawner.DoSpawnChild
ChildSpawner.DoSpawnChild = function(self, ...)
    local childname = self.childname
    if table.contains(nightmarecreature_table, self.inst.prefab) and childname == "crawlingnightmare" then
        self.childname = check_dummy_spawn_beak(self.inst)
    end
    local rt = DoSpawnChild(self, ...)
    self.childname = childname
    return rt
end


local function OnWorkFinished(inst)
    inst.components.lootdropper:DropLoot(inst:GetPosition())

    local fx = SpawnAt("collapse_small", inst)
    fx:SetMaterial("rock")

    if TheWorld.state.isnightmarewild and math.random() <= .3 then
        -- Changed Part Start --
        SpawnAt((get_nearby_dummy(inst) or math.random() < .5) and "nightmarebeak" or "crawlingnightmare", inst)
        -- Changed Part End --
    end

    inst:Remove()
end

local statueruins = {
    "ruins_statue_head",
    "ruins_statue_head_nogem",
    "ruins_statue_mage",
    "ruins_statue_mage_nogem",
}
for _, prefab in ipairs(statueruins) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then return end
        if inst.components.workable then
            inst.components.workable:SetOnFinishCallback(OnWorkFinished)
        end
    end)
end
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

local function get_nearby_dummy(inst, disq)
    if not inst or type(disq) ~= "number" then return end
    for _, v in ipairs(AllPlayers) do
        if inst:GetDistanceSqToInst(v) < (disq * disq) and v:HasTag("nightmarebreaker") then
            return true
        end
    end
    return
end

local function check_dummy_spawn_beak(inst)
    if get_nearby_dummy(inst, 120) then
        return "nightmarebeak"
    else
        return "crawlingnightmare"
    end
end

local ChildSpawner = require("components/childspawner")
local do_spawn_child = ChildSpawner.DoSpawnChild
function ChildSpawner:DoSpawnChild(target, prefab, ...)
    if self.childname == "crawlingnightmare" then
        return do_spawn_child(self, target, check_dummy_spawn_beak(self.inst), ...)
    end
    return do_spawn_child(self, target, prefab, ...)
end

local function on_work_finished(inst)
    inst.components.lootdropper:DropLoot(inst:GetPosition())

    local fx = SpawnAt("collapse_small", inst)
    fx:SetMaterial("rock")

    if TheWorld.state.isnightmarewild and math.random() <= .3 then
        -- Changed Part Start --
        SpawnAt((get_nearby_dummy(inst, 30) or math.random() < .5) and "nightmarebeak" or "crawlingnightmare", inst)
        -- Changed Part End --
    end

    inst:Remove()
end

local STATUERUINS = {
    "ruins_statue_head",
    "ruins_statue_head_nogem",
    "ruins_statue_mage",
    "ruins_statue_mage_nogem",
}
local function statueruins_postinit(inst)
    if not TheWorld.ismastersim then return end
    if inst.components.workable then
        inst.components.workable:SetOnFinishCallback(on_work_finished)
    end
end
for _, prefab in ipairs(STATUERUINS) do
    AddPrefabPostInit(prefab, statueruins_postinit)
end

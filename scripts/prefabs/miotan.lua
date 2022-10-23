local MakePlayerCharacter = require("prefabs/player_common")

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
    Asset("SOUND", "sound/miotan.fsb"),

    Asset("ANIM", "anim/miotan.zip"),
    Asset("ANIM", "anim/ghost_miotan_build.zip"),
}

local prefabs = {
    "nightmarefuel",
    "pandorachest_reset",
    "statue_transition",
}

local start_inv = {}

for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.MIOTAN
end
prefabs = FlattenTree({ prefabs, start_inv }, true)


local SHADOWCREATURE_MUST_TAGS = { "shadowcreature", "_combat", "locomotor" }
local SHADOWCREATURE_CANT_TAGS = { "INLIMBO", "notaunt" }
local function on_read_fn(inst, book)
    if inst.components.sanity:IsInsane() then

        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 16, SHADOWCREATURE_MUST_TAGS, SHADOWCREATURE_CANT_TAGS)

        if #ents < TUNING.BOOK_MAX_SHADOWCREATURES then
            TheWorld.components.shadowcreaturespawner:SpawnShadowCreature(inst)
        end
    end
end

local FUELTYPE = "nightmarefuel"
local function set_moisture(table)
    for _, v in pairs(table) do
        if (v.prefab == FUELTYPE or
            (v.components.equippable and v.components.equippable:IsEquipped()))
                and v.components.inventoryitem
                and v.components.inventoryitem:IsWet()
                then
            v.components.inventoryitemmoisture:SetMoisture(0)
        end
    end
end

local function find_nightmarefuel(item)
    return item.prefab == FUELTYPE
end

local function dry_equipment(inst)
    local inv = inst.components.inventory
    if not inv then return end

    for _, item in ipairs(inv:FindItems(find_nightmarefuel)) do
        if item.components.inventoryitem and item.components.inventoryitem:IsWet() then
            item.components.inventoryitemmoisture:SetMoisture(0)
        end
    end

    local eslots = inv.equipslots
    if eslots then set_moisture(eslots) end

    local boat = inst.components.sailor and inst.components.sailor:GetBoat()
    if boat then
        local boatinv = boat.components.container and boat.components.container.boatequipslots
        local boatslots = boat.components.container and boat.components.container.slots
        if boatinv then set_moisture(boatinv) end
        if boatslots then set_moisture(boatslots) end
    end
end

local function check_has_item(inst, item, mult)
    local amount = mult or 1
    if item == nil then return end
    local inv = inst.components.inventory
    local inv_boat = inst.components.sailor and inst.components.sailor:GetBoat() and inst.components.sailor:GetBoat().components.container
    return (inv and inv:Has(item, amount)) or (inv_boat and inv_boat:Has(item, amount))
end

local function consume_item(inst, item, mult)
    local amount = mult or 1
    if item == nil then return end
    local inv = inst.components.inventory
    local inv_boat = inst.components.sailor and inst.components.sailor:GetBoat() and inst.components.sailor:GetBoat().components.container
    if inv and inv:Has(item, amount) then
        inv:ConsumeByName(item, amount)
    elseif inv_boat and inv_boat:Has(item, amount) then
        inv_boat:ConsumeByName(item, amount)
    end
end

local function auto_refuel(inst)
    local is_fx_true = false
    local fueled_table = {
        player = {
            armorskeleton   = { trigger = 1 }, -- 骨甲
            lantern         = { trigger = 1 }, -- 提灯
            lighter         = { trigger = 1 }, -- 薇洛的打火机
            minerhat        = { trigger = 1 }, -- 头灯
            molehat         = { trigger = 2, bonus = 2, cost = 2 }, -- 鼹鼠帽
            nightstick      = { trigger = 1 }, -- 晨星
            thurible        = { trigger = 1 }, -- 香炉
            yellowamulet    = { trigger = 1 }, -- 黄符
            purpleamulet    = { trigger = 1 }, -- 紫符
            blueamulet      = { trigger = 1 }, -- 冰符

            nightpack       = { trigger = 1 }, -- 影背包 in Night Stories
            darkamulet      = { trigger = 1 }, -- 黑暗护符 in Night Stories
            lightamulet     = { trigger = 1 }, -- 光明护符 in Night Stories

            bottlelantern   = { trigger = 1 }, -- 瓶灯 in Island Adventures

        },
        boat = { -- Island Adventures
            boat_lantern    = { trigger = 1 }, -- 船灯
            ironwind        = { trigger = 2, cost = 2 }, -- 螺旋桨
        }
    }
    local finiteuses_table = {
        player = {
            orangestaff     = { trigger = 2, bonus = 2}, -- 橙杖
            orangeamulet    = { trigger = 50, bonus = 50, cost = 1 } -- 橙符
        }
    }

    local player_eslots = inst.components.inventory and inst.components.inventory.equipslots
    local boat = inst.components.sailor and inst.components.sailor:GetBoat() -- Compatible for Island Adventures
    local boatequipslots = boat and boat.components.container and boat.components.container.boatequipslots

    for source, eslots in pairs({player = player_eslots, boat = boatequipslots}) do
        for _, target in pairs(eslots) do
            if fueled_table[source] and fueled_table[source][target.prefab] then
                local data = fueled_table[source][target.prefab]
                local bonus = data.bonus or 1
                local fueled = target.components.fueled
                if fueled and fueled:GetPercent() + TUNING.LARGE_FUEL / fueled.maxfuel * data.trigger * fueled.bonusmult <= 1 and
                    check_has_item(inst, FUELTYPE, data.cost)
                then
                    is_fx_true = true
                    fueled:DoDelta(TUNING.LARGE_FUEL * bonus * fueled.bonusmult)
                    consume_item(inst, FUELTYPE, data.cost)
                    if fueled.ontakefuelfn then fueled.ontakefuelfn(target) end
                end
            elseif finiteuses_table[source] and finiteuses_table[source][target.prefab] then
                local data = finiteuses_table[source][target.prefab]
                local bonus = data.bonus or 1
                local finiteuses = target.components.finiteuses
                if finiteuses and finiteuses:GetUses() + data.trigger <= finiteuses.total and
                    check_has_item(inst, FUELTYPE, data.cost)
                then
                    is_fx_true = true
                    finiteuses:Use(-bonus)
                    consume_item(inst, FUELTYPE, data.cost)
                end
            end
        end
    end

    if is_fx_true then
        SpawnPrefab("pandorachest_reset").entity:SetParent(inst.entity)
    end
end

local function on_boost(inst)
    inst.components.locomotor.runspeed = TUNING.MIOTAN_RUN_SPEED
    inst.components.temperature.mintemp = TUNING.MIOTAN_BOOST_MINTEMP
    if inst.components.eater ~= nil then
        inst.components.eater:SetAbsorptionModifiers(TUNING.MIOTAN_BOOST_ABSORPTION, TUNING.MIOTAN_BOOST_ABSORPTION, TUNING.MIOTAN_BOOST_ABSORPTION)
    end
end

local function end_boost(inst)
    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED
    inst.components.temperature.mintemp = -20
    if inst.components.eater ~= nil then
        inst.components.eater:SetAbsorptionModifiers(1, 1, 1)
    end
end

local function on_update(inst, dt)
    inst.boost_time = inst.boost_time - dt
    if inst.boost_time <= 0 then
        inst.boost_time = 0
        if inst.boosted_task ~= nil then
            inst.boosted_task:Cancel()
            inst.boosted_task = nil
        end
        end_boost(inst)
        if inst._dry_task ~= nil then
            inst._dry_task:Cancel()
            inst._dry_task = nil
        end
        if inst:HasTag("mio_boosted_task") then
            inst:RemoveTag("mio_boosted_task")
        end
    else
        --boosteffect(inst)
        auto_refuel(inst)
        if inst._dry_task == nil then
            inst._dry_task = inst:DoPeriodicTask(0, function(inst)
                dry_equipment(inst)
            end)
        end
        if not inst:HasTag("mio_boosted_task") then
            inst:AddTag("mio_boosted_task")
        end
    end
end

local function on_long_update(inst, dt)
    inst.boost_time = math.max(0, inst.boost_time - dt)
end

local function start_boost(inst, duration)
    inst.boost_time = duration
    if inst.boosted_task == nil then
        inst.boosted_task = inst:DoPeriodicTask(1, on_update, nil, 1)
        inst:DoTaskInTime(0, function(inst) on_update(inst, 0) end) -- Prevent autorefuel function consumes nightmarefuels before actually "eated"
        on_boost(inst)
    end
end

local function on_load(inst, data)
    if data ~= nil and data.boost_time ~= nil then start_boost(inst, data.boost_time) end
end

local function on_save(inst, data)
    data.boost_time = inst.boost_time > 0 and inst.boost_time or nil
end

local function on_becameghost(inst)
    if inst.boosted_task ~= nil then
        -- inst.boosted_task:Cancel()
        -- inst.boosted_task = nil
        inst.boost_time = 0
        on_update(inst, 0)
    end
end

local function on_death(inst)
    if inst.death_task == nil then
        inst.death_task = inst:DoTaskInTime(2, function(inst)
            SpawnPrefab(FUELTYPE).Transform:SetPosition(inst:GetPosition():Get())
            inst.death_task:Cancel()
            inst.death_task = nil
        end)
    end
end

local function on_haunt(inst, doer)
    return not (inst.components.sanity and inst.components.sanity.current == 0)
end

local common_postinit = function(inst)
    inst:AddTag("reader")
    inst:AddTag("nightstorychar")
    inst:AddTag("nightmare_twins")
    -- Minimap icon
    inst.MiniMapEntity:SetIcon("miotan.tex")
end

-- This initializes for the host only
local master_postinit = function(inst)
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default

    inst.talker_path_override = "nightstories/characters/"

    inst.boost_time = 0
    inst.boosted_task = nil

    inst:AddComponent("reader")
    inst.components.reader:SetOnReadFn(on_read_fn)

    inst:AddComponent("hauntable")
    inst.components.hauntable.onhaunt = on_haunt
    inst.components.hauntable.hauntvalue = TUNING.HAUNT_INSTANT_REZ
    inst.components.hauntable.no_wipe_value = true

    inst.components.health:SetMaxHealth(TUNING.MIOTAN_STATUS)
    inst.components.hunger:SetMax(TUNING.MIOTAN_STATUS)
    inst.components.sanity:SetMax(TUNING.MIOTAN_STATUS)

    inst.components.sanity.dapperness = TUNING.MIOTAN_SANITY_DAPPERNESS
    inst.components.sanity.night_drain_mult = TUNING.MIOTAN_SANITY_NIGHT_MULT
    inst.components.sanity.neg_aura_mult = TUNING.MIOTAN_SANITY_MULT

    if inst.components.eater then
        inst.components.eater:SetCanEatNightmareFuel()
        inst.components.eater.stale_hunger = TUNING.MIOTAN_STALE_HUNGER_RATE
        inst.components.eater.stale_health = TUNING.MIOTAN_STALE_HEALTH_RATE
        inst.components.eater.spoiled_hunger = TUNING.MIOTAN_SPOILED_HUNGER_RATE
        inst.components.eater.spoiled_health = TUNING.MIOTAN_SPOILED_HUNGER_RATE
    end

    inst:ListenForEvent("ms_becameghost", on_becameghost)
    inst.OnLongUpdate = on_long_update
    inst.OnSave = on_save
    inst.OnLoad = on_load

    inst.skeleton_prefab = nil
    inst:ListenForEvent("death", on_death)

    inst.StartBoost = start_boost
end

return MakePlayerCharacter("miotan", prefabs, assets, common_postinit, master_postinit)

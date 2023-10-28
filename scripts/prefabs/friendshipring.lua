local assets =
{
    Asset("ANIM", "anim/friendshipring.zip"),
}

local prefabs =
{
    ring =
    {
        "glash_fx",
        "glash_big_fx",
    },
    totem =
    {
        "statue_transition",
        "statue_transition_2",
    },
}
local totem_sounds =
{
    activate = "rifts3/bearger_sack/open_f5_loopstart",
    deactivate = "rifts3/bearger_sack/close",
}

local ACTIVE_SOUNDNAME = "openloop"

----------------------------------------------------------------
------------------------ TOTEM FUNCTION ------------------------
----------------------------------------------------------------


local function StartActiveSound(inst)
    if inst._startsoundtask ~= nil then
        inst._startsoundtask:Cancel()
        inst._startsoundtask = nil
    end

    inst.SoundEmitter:PlaySound(totem_sounds.activate, ACTIVE_SOUNDNAME)
end

local function turn_on(inst)
    if not inst.toggled:value() then
        inst.toggled:set(true)

        if inst._startsoundtask ~= nil then
            inst._startsoundtask:Cancel()
        end

        inst._startsoundtask = inst:DoTaskInTime(5*FRAMES, StartActiveSound)

        if inst.components.fueled then
            inst.components.fueled:StartConsuming()
        end
        if inst.task == nil then
            inst.task = inst:DoPeriodicTask(0.5, inst.totemfn, 0)
        end
    end
end

local function turn_off(inst)
    if inst.toggled:value() then
        inst.toggled:set(false)

        inst.SoundEmitter:KillSound(ACTIVE_SOUNDNAME)

        inst.SoundEmitter:PlaySound(totem_sounds.deactivate)

        if inst.components.fueled then
            inst.components.fueled:StopConsuming()
        end

        if inst.task then
            inst.task:Cancel()
            inst.task = nil
        end
    end
end

local function onupdate(inst)
    if inst.components.fueled and inst.components.fueled:IsEmpty() then
        turn_off(inst)
    else
        turn_on(inst)
    end
end

local totemfn =
{
    dark = function(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        local players = FindPlayersInRange(x, y, z, TUNING.TOTEM_BUFF_RANGE, true)
        for _, player in pairs(players) do
            player:AddDebuff("buff_friendshiptotem_dark", "buff_friendshiptotem_dark")
        end
    end,

    light = function(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        local players = FindPlayersInRange(x, y, z, TUNING.TOTEM_BUFF_RANGE, true)
        for _, player in pairs(players) do
            player:AddDebuff("buff_friendshiptotem_light", "buff_friendshiptotem_light")
        end
    end
}

---------------------------------------------------------------
------------------------ RING FUNCTION ------------------------
---------------------------------------------------------------
local function buff_friends(oneatenfn, food, player, buff_self)
    local buff_entities = {}
    if buff_self then buff_entities[player] = true end
    local leader = player.components.leader
    if leader and leader.numfollowers > 0 then
        for follower in pairs(leader.followers) do
            buff_entities[follower] = true
        end
    end
    for ent in pairs(buff_entities) do
        oneatenfn(food, ent)
        local x, y, z = ent.Transform:GetWorldPosition()
        SpawnPrefab("glash_fx").Transform:SetPosition(x, y, z)
    end
end

local function oneat(inst, owner, data)
    local food = data and data.food
    -- local owner = inst.components.inventoryitem.owner
    if food then
        local oneatenfn = food.components.edible.oneaten
        -- print("oneatenfn", inst, owner, oneatenfn)
        if oneatenfn then
            local x, y, z = owner.Transform:GetWorldPosition()
            local players = FindPlayersInRange(x, y, z, TUNING.TOTEM_BUFF_RANGE, true)
            for _, player in pairs(players) do
                if player.userid ~= owner.userid then
                    buff_friends(oneatenfn, food, player, true)
                else
                    buff_friends(oneatenfn, food, player)
                    SpawnPrefab("glash_big_fx").Transform:SetPosition(x, y, z)
                end
            end
            inst.components.finiteuses:Use(1)
        end
    end
end

local function onequip(inst, owner)

    inst._oneat = function(_owner, _data) oneat(inst, _owner, _data) end
    inst:ListenForEvent("oneat", inst._oneat, owner)

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onunequip(inst, owner)

    inst:RemoveEventCallback("oneat", inst._oneat, owner)

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if inst:GetSkinBuild() ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
end

local function onfinished(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove()
end

local function spawn_fx(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")

    local x, y, z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab("statue_transition_2")
    if fx ~= nil then
        fx.Transform:SetPosition(x, y, z)
        fx.Transform:SetScale(0.4, 1, 0.4)
    end
    fx = SpawnPrefab("statue_transition")
    if fx ~= nil then
        fx.Transform:SetPosition(x, y, z)
        fx.Transform:SetScale(0.4, 0.6, 0.4)
    end
end

local function onfinished_totem(inst)
    spawn_fx(inst)
    inst:Remove()
end

---------------------------------------------------------------
----------------------- COMMON FUNCTION -----------------------
---------------------------------------------------------------

local function common_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("friendshipring")
    inst.AnimState:SetBuild("friendshipring")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")

    inst:AddComponent("inspectable")

    inst:DoTaskInTime(0, function(inst)
        inst.drawnameoverride = rawget(_G, "EncodeStrCode") and EncodeStrCode({content = "NAMES." .. string.upper(inst.prefab)})
    end)

    return inst
end

local function base_fn()
    local inst = common_fn()
    MakeInventoryFloatable(inst, "small", 0.07, {0.7, 0.7, 0.7})

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(onfinished)
    inst.components.finiteuses:SetMaxUses(15)
    inst.components.finiteuses:SetUses(15)

    return inst
end


local function OnLoad(inst, data)
    if data and data.toggled then
        inst:TurnOn()
    end
end

local function OnSave(inst, data)
    data.toggled = inst.toggled:value()
end

local function MakeTotem(color)
    local function totem_fn()
        local inst = common_fn()

        inst.AnimState:PlayAnimation(color .. "_loop", true)

        inst.toggled = net_bool(inst.GUID, "friendshiptotem.toogle", "friendshiptotem.toggledirty")

        if not TheWorld.ismastersim then
            return inst
        end

        inst.components.inventoryitem:SetSinks(true)

        inst:AddComponent("friendshiptotem")

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.MAGIC
        inst.components.fueled:InitializeFuelLevel(480)
        inst.components.fueled:SetDepletedFn(onfinished_totem)
        inst.components.fueled:SetUpdateFn(onupdate)
        inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
        inst.components.fueled.period = FRAMES

        inst.components.inventoryitem:SetOnDroppedFn(turn_on)
        -- inst.components.inventoryitem:SetOnPickupFn(turn_off)
        inst.components.inventoryitem:SetOnPutInInventoryFn(turn_off)
        inst.totemfn = totemfn[color]

        if color == "dark" then
            inst:AddComponent("sanityaura")
            inst.components.sanityaura.aura = - TUNING.SANITYAURA_SMALL
        end

        inst.TurnOn = turn_on
        inst.TurnOff = turn_off
        inst.toggled:set(false)

        inst.OnSave = OnSave
        inst.OnLoad = OnLoad

        return inst
    end

    return Prefab("friendshiptotem_" .. color, totem_fn, assets, prefabs.totem)
end

return Prefab("friendshipring", base_fn, assets.ring),
        MakeTotem("dark"),
        MakeTotem("light")

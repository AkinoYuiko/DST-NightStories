local assets =
{
    Asset("ANIM", "anim/friendshipring.zip"),
}

local prefabs =
{
    "statue_transition",
    "statue_transition_2",
}
----------------------------------------------------------------
------------------------ TOTEM FUNCTION ------------------------
----------------------------------------------------------------
local function turn_on(inst)
    if inst.components.fueled then
        inst.components.fueled:StartConsuming()
    end
    if inst.task == nil then
        inst.task = inst:DoPeriodicTask(1, inst.totemfn, 0)
    end
end

local function turn_off(inst)
    if inst.components.fueled then
        inst.components.fueled:StopConsuming()
    end

    if inst.task then
        inst.task:Cancel()
        inst.task = nil
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
        local players = FindPlayersInRange(x, y, z, 10, true)
        for _, player in pairs(players) do
            player:AddDebuff("buff_friendshiptotem_dark", "buff_friendshiptotem_dark")
        end
    end,
    light = function(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        local players = FindPlayersInRange(x, y, z, 10, true)
        for _, player in pairs(players) do
            player:AddDebuff("buff_friendshiptotem_light", "buff_friendshiptotem_light")
        end
    end
}

---------------------------------------------------------------
------------------------ RING FUNCTION ------------------------
---------------------------------------------------------------
local function oneat(inst, owner, data)
    local food = data and data.food
    -- local owner = inst.components.inventoryitem.owner
    if food then
        local oneatenfn = food.components.edible.oneaten
        -- print("oneatenfn", inst, owner, oneatenfn)
        if oneatenfn then
            local x, y, z = owner.Transform:GetWorldPosition()
            local players = FindPlayersInRange(x, y, z, 10, true)
            for _, player in pairs(players) do
                if player.userid ~= owner.userid then
                    oneatenfn(food, player)
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

    MakeInventoryFloatable(inst)

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

local function MakeTotem(color)
    local function totem_fn()
        local inst = common_fn()

        inst.AnimState:PlayAnimation(color .. "_loop", true)

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.MAGIC
        inst.components.fueled:InitializeFuelLevel(480)
        inst.components.fueled:SetDepletedFn(onfinished_totem)
        inst.components.fueled:SetUpdateFn(onupdate)
        inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
        inst.components.fueled.period = FRAMES

        inst.components.inventoryitem:SetOnDroppedFn(turn_on)
        inst.components.inventoryitem:SetOnPickupFn(turn_off)
        -- inst.components.inventoryitem:SetOnPutInInventoryFn(turn_on)
        inst.totemfn = totemfn[color]

        return inst
    end

    return Prefab("friendshiptotem_" .. color, totem_fn, assets, prefabs)
end

return Prefab("friendshipring", base_fn, assets),
        MakeTotem("dark"),
        MakeTotem("light")

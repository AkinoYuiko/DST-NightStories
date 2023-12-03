local assets = {}

local prefabs = {
    "electrichitsparks",
    "planar_hit_fx",
}

local function setup_fx(target)
    local fx = SpawnPrefab("planar_hit_fx")
    local scale = 0.7
    fx.Transform:SetScale(scale, scale, scale)
    fx.entity:SetParent(target.entity)
end

local function on_attack(inst, attacker, target)
    if target and target:IsValid() then
        setup_fx(target)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    inst:AddTag("ignore_planar_entity")

    inst.persists = false

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.GLASH_BASE_DAMAGE)
    inst.components.weapon:SetRange(TUNING.GESTALTGUARD_ATTACK_RANGE * 10)
    inst.components.weapon:SetOnAttack(on_attack)

    inst:AddComponent("projectile")

    inst:DoTaskInTime(0, inst.Remove)

    return inst
end

------------------------- Glash FX -------------------------

local function play_sound(inst, sound)
    inst.SoundEmitter:PlaySound(sound)
end

local function MakeFx(t)

    local function startfx(proxy, name)

        local inst = CreateEntity(t.name)

        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        inst:AddTag("FX")

        --[[Non-networked entity]]
        inst.entity:SetCanSleep(false)
        inst.persists = false

        inst.Transform:SetFromProxy(proxy.GUID)

        if t.sound then
            inst.entity:AddSoundEmitter()
            inst:DoTaskInTime(t.sounddelay or 0, play_sound, t.sound)
        end

        local anim_state = inst.AnimState
        anim_state:SetBank(t.bank)
        anim_state:SetBuild(t.build)
        anim_state:PlayAnimation(FunctionOrValue(t.anim)) -- THIS IS A CLIENT SIDE FUNCTION
        anim_state:SetMultColour(0.85, 0.85, 0.85, 0.85)
        anim_state:SetBloomEffectHandle("shaders/anim.ksh")
        anim_state:SetSortOrder(3)

        if t.fn then
            t.fn(inst)
        end

        inst:ListenForEvent("animover", inst.Remove)
    end

    local function fx_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddNetwork()

        if not TheNet:IsDedicated() then
            inst:DoTaskInTime(0, startfx, inst)
        end

        inst:AddTag("FX")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst:DoTaskInTime(1, inst.Remove)

        return inst

    end

    return Prefab(t.name, fx_fn)
end

local glash_fx =
{
    name = "glash_fx",
    bank = "glash_fx",
    build = "glash_fx",
    anim = function() return "idle_med_"..math.random(3) end,
    sound = "wanda2/characters/wanda/watch/weapon/nightmare_FX",
    fn = function(inst) inst.AnimState:SetFinalOffset(1) end,
}

local glash_big_fx =
{
    name = "glash_big_fx",
    bank = "glash_fx",
    build = "glash_fx",
    anim = function() return "idle_big_"..math.random(3) end,
    sound = "wanda2/characters/wanda/watch/weapon/shadow_hit_old",
    -- sound = "dontstarve/common/gem_shatter",
    fn = function(inst) inst.AnimState:SetFinalOffset(1) end,
}

return Prefab("glash", fn, assets, prefabs),
    MakeFx(glash_fx),
    MakeFx(glash_big_fx)

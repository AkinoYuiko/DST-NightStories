local MakePlayerCharacter = require("prefabs/player_common")
local DummyBadge = require("widgets/dummybadge")

local assets = {
    Asset( "SCRIPT", "scripts/prefabs/player_common.lua" ),

    Asset( "ANIM", "anim/dummy.zip" ),
    Asset( "ANIM", "anim/ghost_dummy_build.zip" ),
}

local prefabs = {
    "nightmarefuel"
}
local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.DUMMY
end

prefabs = FlattenTree({ prefabs, start_inv }, true)

local function CalcSanityAura(inst, observer)
    if observer.prefab == "dummy" then
        return 0
    elseif observer.prefab ~= "dummy" and observer:HasTag("nightstorychar") then
        return inst.components.sanityaura.aura
    else
        return -inst.components.sanityaura.aura
    end
end

local function GetEquippableDapperness(owner, equippable)
    local dapperness = equippable:GetDapperness(owner, owner.components.sanity.no_moisture_penalty)
    if equippable.inst:HasTag("shadow_item") then
        return 0
    end
    return dapperness
end

local function CheckInsanity(inst)
    local sanity = inst.components.sanity
    if not sanity then return end

    local percent_ignoresinduced = sanity.current / sanity.max
    if sanity.mode == SANITY_MODE_INSANITY then
        if sanity.sane and percent_ignoresinduced <= TUNING.SANITY_BECOME_INSANE_THRESH then --30
            sanity.sane = false
        elseif not sanity.sane and percent_ignoresinduced >= TUNING.SANITY_BECOME_SANE_THRESH then --35
            sanity.sane = true
        end
    else
        if sanity.sane and percent_ignoresinduced >= TUNING.SANITY_BECOME_ENLIGHTENED_THRESH then
            sanity.sane = false
        elseif not sanity.sane and percent_ignoresinduced <= TUNING.SANITY_LOSE_ENLIGHTENMENT_THRESH then
            sanity.sane = true
        end
    end

    if sanity:IsSane() ~= sanity._oldissane then
        sanity._oldissane = sanity:IsSane()
        if sanity._oldissane then
            if sanity.onSane ~= nil then
                sanity.onSane(sanity.inst)
            end
            sanity.inst:PushEvent("gosane")
            ProfileStatsSet("went_sane", true)
        else
            if sanity.mode == SANITY_MODE_INSANITY then
                if sanity.onInsane ~= nil then
                    sanity.onInsane(sanity.inst)
                end
                sanity.inst:PushEvent("goinsane")
                ProfileStatsSet("went_insane", true)
            else --sanity.mode == SANITY_MODE_LUNACY
                if sanity.onEnlightened ~= nil then
                    sanity.onEnlightened(sanity.inst)
                end
                sanity.inst:PushEvent("goenlightened")
                ProfileStatsSet("went_enlightened", true)
            end
        end
    end
end

local function onsanitychange(inst)
    if inst:HasTag("playerghost") or inst.components.health:IsDead() then
        return
    end

    local percent = math.max(0,(inst.components.sanity.current - (inst.components.sanity.max * 0.15)) / (inst.components.sanity.max * 0.85))

    if inst.components.sanity and not inst.components.sanity.inducedinsanity and inst.components.sanity.sane then
        inst.components.hunger:SetRate( (1 + percent) * TUNING.WILSON_HUNGER_RATE)
        inst:AddTag("playermonster")
        inst:AddTag("monster")
        if not inst.components.sanityaura then
            inst:AddComponent("sanityaura")
            inst.components.sanityaura.aurafn = CalcSanityAura
            inst.components.sanityaura.aura = (TUNING.DUMMY_SANITY_AURA * (1 + percent) / 2)
        end
    else
        inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE)
        if inst:HasTag("playermonster") then inst:RemoveTag("playermonster") end
        if inst:HasTag("monster") then inst:RemoveTag("monster") end
        if inst.components.sanityaura then
            inst:RemoveComponent("sanityaura")
        end
    end
end

local function CalcFireDamageUpdate(inst)
    inst._calc_firedamage_task_left = inst._calc_firedamage_task_left - 1
    if inst._calc_firedamage_task_left <= 0 then
        inst._calc_firedamage_task_left = 0
        if inst._calc_firedamage_task ~= nil then
            inst._calc_firedamage_task:Cancel()
            inst._calc_firedamage_task = nil
        end
        inst._ontakenfiredamage_rate:set(0)
    else
        inst._ontakenfiredamage_rate:set(inst._total_firedamage / (GetTime() - inst._firedamage_task_starttime))
    end
end

local function OnCalcFireDamage(inst, amount)
    inst._calc_firedamage_task_left = 31
    if inst._calc_firedamage_task == nil then
        inst._total_firedamage = 0
        inst._firedamage_task_starttime = GetTime()
        inst._calc_firedamage_task = inst:DoPeriodicTask(0, CalcFireDamageUpdate)
    else
        inst._total_firedamage = inst._total_firedamage + amount
    end
end

local function OnHealthSanityChange(inst, data)
    if inst.components.sanity and inst.components.health then
        local sanity = inst.components.sanity
        sanity.current = inst.components.health.currenthealth
        sanity.inst:PushEvent("sanitydelta", { oldpercent = sanity._oldpercent, newpercent = sanity:GetPercent(), overtime = true, sanitymode = sanity.mode})
        sanity._oldpercent = sanity:GetPercent()
    end
    onsanitychange(inst)
    CheckInsanity(inst)

    if data and data.cause == "fire" then
        local amount = data.amount and math.abs(data.amount) or 0
        OnCalcFireDamage(inst, amount)
    end
end

local function redirect_to_health(inst, amount, overtime, ...)
    return inst.components.health ~= nil and inst.components.health:DoDelta(amount, overtime, "lose_sanity", true, nil, true)
end

local function onhaunt(inst, doer)
    return not (inst.components.sanity and inst.components.sanity.current == 0)
end

local function OnRespawnFromGhost(inst, data)
    if data and data.source then
        local target = (data.source.prefab == "reviver" and data.user)
                        or (data.source.prefab == "pocketwatch_revive" and data.source.components.inventoryitem.owner)
                        or data.source
        local reviver_sanity = target.components.sanity
        if reviver_sanity then
            inst.components.health:SetCurrentHealth(reviver_sanity.current)
            OnHealthSanityChange(inst)
            reviver_sanity:DoDelta(-reviver_sanity.current)
        end
    end
end

local function OnDebuffRemoved(inst, name, ...)
    if inst:HasTag("hasbuff_" .. name) then
        inst:RemoveTag("hasbuff_" .. name)
    end
end

local function OnDebuffAdded(inst, name, ...)
    if not inst:HasTag("hasbuff_" .. name) then
        inst:AddTag("hasbuff_" .. name)
    end
end

local common_postinit = function(inst)
    inst.soundsname = "willow"
    inst:AddTag("nightmarebreaker")
    inst:AddTag("insomniac")
    inst:AddTag("reader")
    inst:AddTag("mime")
    inst:AddTag("nightstorychar")
    inst:AddTag("nightmare_twins")
    -- Minimap icon
    inst.MiniMapEntity:SetIcon("dummy.tex")

    if TheNet:GetServerGameMode() == "lavaarena" then
    elseif TheNet:GetServerGameMode() == "quagmire" then
    else
        if not TheNet:IsDedicated() then
            inst.CreateHealthBadge = DummyBadge
        end
    end
end

-- This initializes for the host only
local master_postinit = function(inst)
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default

    inst.customidleanim = "idle_wortox"

    inst._total_firedamage = 0
    inst._ontakenfiredamage_rate = net_byte(inst.GUID, "_ontakenfiredamage_rate", "_ontakenfiredamage_rate")
    -- inst.ontakenfiredamage_rate:set(0)

    inst:AddComponent("reader")

    inst:AddComponent("hauntable")
    inst.components.hauntable.onhaunt = onhaunt
    inst.components.hauntable.hauntvalue = TUNING.HAUNT_INSTANT_REZ
    inst.components.hauntable.no_wipe_value = true

    inst.components.health:SetMaxHealth(TUNING.DUMMY_HEALTH)
    inst.components.hunger:SetMax(TUNING.DUMMY_HUNGER)
    inst.components.sanity:SetMax(TUNING.DUMMY_HEALTH)

    inst.components.sanity.dapperness = TUNING.DAPPERNESS_MED
    inst.components.sanity.night_drain_mult = TUNING.DUMMY_NIGHT_SANITY_MULT
    inst.components.sanity.neg_aura_mult = TUNING.DUMMY_SANITY_MULT
    inst.components.sanity.redirect = redirect_to_health
    inst.components.sanity.get_equippable_dappernessfn = GetEquippableDapperness

    inst.components.health.disable_penalty = true

    inst.components.combat.damagemultiplier = TUNING.DUMMY_DAMAGE_MULT

    inst.spawnlandshadow_fn = function(inst) return "terrorbeak" end

    if inst.components.eater then
        inst.components.eater:SetAbsorptionModifiers(0.5, 1, 0) -- Health, Hunger, Sanity
    end
    inst.components.foodaffinity:AddPrefabAffinity("nightmarepie", TUNING.AFFINITY_15_CALORIES_MED)

    if inst.components.debuffable then
        inst.components.debuffable.ondebuffremoved = OnDebuffRemoved
        inst.components.debuffable.ondebuffadded = OnDebuffAdded
    end

    inst:ListenForEvent("respawnfromghost", OnRespawnFromGhost)
    inst:ListenForEvent("healthdelta", OnHealthSanityChange)

    inst.skeleton_prefab = nil
    inst:ListenForEvent("death", function(inst)
        if inst.death_task == nil then
            inst.death_task = inst:DoTaskInTime(2, function(inst)
                SpawnPrefab("nightmarefuel").Transform:SetPosition(inst:GetPosition():Get())
                inst.death_task:Cancel()
                inst.death_task = nil
            end)
        end
    end)

    -- Hack Builder:RemoveIngredients so Dummy won't do anim when crafting costs Sanity-Health.
    if inst.components.builder then

        local remove_ingredients = inst.components.builder.RemoveIngredients
        inst.components.builder.RemoveIngredients = function(self, ingredients, recname, ...)
            local tab = AllRecipes[recname] and AllRecipes[recname].tab
            if tab.str == "nightmaretab" then
                local push_event = self.inst.PushEvent
                self.inst.PushEvent = function(inst, event, ...)
                    if event ~= "consumehealthcost" then
                        return push_event(inst, event, ...)
                    end
                end
                local ret = remove_ingredients(self, ingredients, recname, ...)
                self.inst.PushEvent = push_event
                return ret
            else
                return remove_ingredients(self, ingredients, recname, ...)
            end
        end
    end
end

return MakePlayerCharacter("dummy", prefabs, assets, common_postinit, master_postinit),
    CreatePrefabSkin("dummy_none", {
        base_prefab = "dummy",
        type = "base",
        assets = assets,
        skins = { normal_skin = "dummy", ghost_skin = "ghost_dummy_build" },
        skin_tags = { "DUMMY", "BASE"},
        bigportrait = { build = "bigportrait/dummy_none.xml", symbol = "dummy_none_oval.tex"},
        build_name_override = "dummy",
        rarity = "Character"
    })

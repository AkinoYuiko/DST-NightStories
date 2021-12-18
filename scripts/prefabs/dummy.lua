local MakePlayerCharacter = require("prefabs/player_common")
local DummyBadge = require "widgets/dummybadge"

local assets = {
    Asset( "SCRIPT", "scripts/prefabs/player_common.lua" ),

	Asset( "ANIM", "anim/dummy.zip" ),
	Asset( "ANIM", "anim/ghost_dummy_build.zip" ),
}

local prefabs = {}
local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
	start_inv[string.lower(k)] = v.DUMMY
end

prefabs = FlattenTree({ prefabs, start_inv }, true)

local function CalcSanityAura(inst, observer)
	if observer.prefab == "dummy" then
		return 0
	elseif observer.prefab ~= "dummy" and observer:HasTag("nightmarer") then
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
			inst.components.sanityaura.aura = (TUNING.SANITY_SMALL * 0.075 * (1 + percent))
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

local function onhealthsanitysync(inst)
	if inst.components.sanity and inst.components.health then
		inst.components.sanity.current = inst.components.health.currenthealth
	end
	onsanitychange(inst)
	CheckInsanity(inst)
end

local function redirect_to_health(inst, amount, overtime, ...)
	return inst.components.health ~= nil and inst.components.health:DoDelta(amount, overtime, "lose_sanity")
end

local function onbecamehuman(inst, data)
	-- inst:ListenForEvent("sanitydelta", onsanitychange)
	inst:ListenForEvent("healthdelta", onhealthsanitysync)
	if inst.HUD then inst.HUD.controls.status:HideDummyBrain() end
end

local function onbecameghost(inst)
	-- inst:RemoveEventCallback("sanitydelta", onsanitychange)
	inst:RemoveEventCallback("healthdelta", onhealthsanitysync)
end

local function onload(inst)
	inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
	inst:ListenForEvent("ms_becameghost", onbecameghost)

	if inst:HasTag("playerghost") then
		onbecameghost(inst)
	else
		onbecamehuman(inst)
	end
end

local common_postinit = function(inst)
	inst.soundsname = "willow"
	inst:AddTag("nm_breaker")
  	inst:AddTag("insomniac")
	inst:AddTag("reader")
  	inst:AddTag("mime")
	inst:AddTag("nightmarer")
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

	inst:AddComponent("reader")

	inst.components.health:SetMaxHealth(TUNING.DUMMY_HEALTH)
	inst.components.hunger:SetMax(TUNING.DUMMY_HUNGER)
	inst.components.sanity:SetMax(TUNING.DUMMY_SANITY)

	inst.components.sanity.dapperness = TUNING.DAPPERNESS_LARGE
	inst.components.sanity.night_drain_mult = 0
	inst.components.sanity.neg_aura_mult = 0.5
	inst.components.sanity.redirect = redirect_to_health
    inst.components.sanity.get_equippable_dappernessfn = GetEquippableDapperness

	inst.components.health.disable_penalty = true

	inst.components.combat.damagemultiplier = 0.75

	-- IA
	inst.spawnlandshadow_fn = function(inst)
		return "terrorbeak"
	end

	if inst.components.eater ~= nil then
		inst.components.eater:SetAbsorptionModifiers(1, 1, 0)
	end
    inst.components.foodaffinity:AddPrefabAffinity("nightmarepie", TUNING.AFFINITY_15_CALORIES_MED)

	inst.OnLoad = onload
	inst.OnNewSpawn = onload

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

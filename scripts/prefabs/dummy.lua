local MakePlayerCharacter = require("prefabs/player_common")

local assets = {
	Asset( "ANIM", "anim/dummy.zip" ),
	Asset( "ANIM", "anim/ghost_dummy_build.zip" ),
}

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

-- local function startlisten(inst)
-- 	inst:ListenForEvent("sanitydelta", onsanitychange)
-- 	onsanitychange(inst)
-- end

local function onbecamehuman(inst, data)
	inst:ListenForEvent("sanitydelta", onsanitychange)
	-- startlisten(inst)
end

local function onbecameghost(inst)
	inst:RemoveEventCallback("sanitydelta", onsanitychange)
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
end

-- This initializes for the host only
local master_postinit = function(inst)

	inst.customidleanim = "idle_wortox"

	inst:AddComponent("reader")

	inst.components.sanity.dapperness = TUNING.DAPPERNESS_LARGE
	inst.components.sanity.night_drain_mult = 0
	inst.components.sanity.neg_aura_mult = 0.5
	inst.components.combat.damagemultiplier = 0.75

	-- inst.dummy_task = nil

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

	-- startlisten(inst)

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

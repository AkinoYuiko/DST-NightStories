local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
	-- Asset( "SCRIPT", "scripts/prefabs/player_common.lua"),
    Asset( "ANIM", "anim/civi.zip" ),
    Asset( "ANIM", "anim/ghost_civi_build.zip" ),
}

local prefabs = {}
local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.CIVI
end
prefabs = FlattenTree({ prefabs, start_inv }, true)

local function updatefood(inst)
    inst.components.foodaffinity:RemovePrefabAffinity("bonesoup")
    inst.components.foodaffinity:RemovePrefabAffinity("meatballs")
    inst.components.foodaffinity:RemovePrefabAffinity("voltgoatjelly")
    if inst.level == 0 then
    	inst.components.foodaffinity:AddPrefabAffinity("bonesoup", 1.1)
    elseif inst.level == 1 then
    	inst.components.foodaffinity:AddPrefabAffinity("meatballs", 1.24)
    elseif inst.level == 2 then
    	inst.components.foodaffinity:AddPrefabAffinity("voltgoatjelly", 1.4)
    end
end

local function applyupgrades(inst)
	inst.level = math.min(2,inst.level)
	inst.level = math.max(0,inst.level)

	updatefood(inst)

	if inst:HasTag("civi_canupgrade") then inst:RemoveTag("civi_canupgrade") end
	if inst:HasTag("civi_candegrade") then inst:RemoveTag("civi_candegrade") end
	if inst.level < 2 then inst:AddTag("civi_canupgrade") end
	if inst.level > 0 then inst:AddTag("civi_candegrade") end

	local hunger_percent = inst.components.hunger:GetPercent()
	local health_percent = inst.components.health:GetPercent()
	local sanity_percent = inst.components.sanity:GetPercent()

	inst.components.hunger.max = ( 175 - inst.level * 50 ) -- max_level = 75
	inst.components.sanity.max = ( 175 - inst.level * 50 ) -- max_level = 75
	inst.components.health.maxhealth = ( 175 - inst.level * 50 ) -- max_level = 75

	inst.components.locomotor.runspeed = ( TUNING.WILSON_RUN_SPEED * ( 1 + 0.25 * inst.level ) ) -- max_level = 9

	inst.components.combat.damagemultiplier = ( 1 + inst.level * 0.25 ) -- max_level = 1.5
	inst.components.sanity.night_drain_mult = ( 0.75 + inst.level * 0.25 )
	inst.components.sanity.neg_aura_mult = ( 0.75 + inst.level * 0.25 )

	if inst.components.eater ~= nil then
		inst.components.eater:SetAbsorptionModifiers(( 1 - 0.25 * inst.level ), ( 1 - 0.25 * inst.level ), ( 1 - 0.25 * inst.level ))
	end
    inst.components.hunger:SetRate(( 1 - inst.level * 0.1 ) * TUNING.WILSON_HUNGER_RATE )
	inst.components.hunger:SetPercent(hunger_percent)
	inst.components.health:SetPercent(health_percent)
	inst.components.sanity:SetPercent(sanity_percent)
end

local function onpreload(inst, data)
	if data then
		if data.level then
			inst.level = data.level
			applyupgrades(inst)
			--re-set these from the save data, because of load-order clipping issues
			if data.health and data.health.health then inst.components.health.currenthealth = data.health.health end
			if data.hunger and data.hunger.hunger then inst.components.hunger.current = data.hunger.hunger end
			if data.sanity and data.sanity.current then inst.components.sanity.current = data.sanity.current end
			inst.components.health:DoDelta(0.01)
			inst.components.hunger:DoDelta(0.01)
			inst.components.sanity:DoDelta(0.01)
		end
	end
end


local function onsave(inst, data)
	data.level = inst.level
end


local function ondeath(inst)
	applyupgrades(inst)
end


local function onbecamehuman(inst)
	applyupgrades(inst)
end
-- This initializes for both clients and the host
local common_postinit = function(inst)
	-- choose which sounds this character will play
    inst.soundsname = "wendy"
	inst:AddTag("nightmarer")
	inst:AddTag("nightmaregem")

	inst.MiniMapEntity:SetIcon( "civi.tex" )
end

-- This initializes for the host only
local master_postinit = function(inst)
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
    
	inst.level = 0

	-- inst.components.eater:SetOnEatFn(oneat)
	inst.components.builder.magic_bonus = 1

	applyupgrades(inst)
	inst.applylevelfn = applyupgrades

	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
	inst:ListenForEvent("death", ondeath)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
end

return MakePlayerCharacter("civi", prefabs, assets, common_postinit, master_postinit), 
CreatePrefabSkin("civi_none", {
    base_prefab = "civi",
    type = "base",
    assets = assets,
    skins = { normal_skin = "civi", ghost_skin = "ghost_civi_build" }, 
    bigportrait = { build = "bigportrait/civi_none.xml", symbol = "civi_none_oval.tex"},
    skin_tags = { "CIVI", "BASE"},
    build_name_override = "civi",
    rarity = "Character",
})
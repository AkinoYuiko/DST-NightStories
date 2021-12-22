local MakePlayerCharacter = require("prefabs/player_common")

local assets = {
    Asset( "SCRIPT", "scripts/prefabs/player_common.lua" ),

    Asset( "ANIM", "anim/miotan.zip" ),
    Asset( "ANIM", "anim/ghost_miotan_build.zip" ),
}
local prefabs = {}
local start_inv = {}

for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.MIOTAN
end
prefabs = FlattenTree({ prefabs, start_inv }, true)

local function set_moisture(table)
	for _, v in pairs(table) do
		if (v.prefab == "nightmarefuel" or
			(v.components.equippable and v.components.equippable:IsEquipped()))
				and v.components.inventoryitem
				and v.components.inventoryitem:IsWet()
				then
			v.components.inventoryitemmoisture:SetMoisture(0)
		end
	end
end

local function find_nightmarefuel(item) return item.prefab == "nightmarefuel" end
local function dryequipment(inst)
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

local function CheckHasItem(inst, item)
	if item == nil then return end
	local inv = inst.components.inventory
	local inv_boat = inst.components.sailor and inst.components.sailor:GetBoat() and inst.components.sailor:GetBoat().components.container
	return (inv and inv:Has(item, 1)) or (inv_boat and inv_boat:Has(item, 1))
end

local function ConsumeItem(inst, item)
	if item == nil then return end
	local inv = inst.components.inventory
	local inv_boat = inst.components.sailor and inst.components.sailor:GetBoat() and inst.components.sailor:GetBoat().components.container
	if inv and inv:Has(item, 1) then
		inv:ConsumeByName(item, 1)
	elseif inv_boat and inv_boat:Has(item, 1) then
		inv_boat:ConsumeByName(item, 1)
	end
end

local function autorefuel(inst)
	local is_fx_true = false
	local fueledtable = {
		player = {
			"armorskeleton", -- 骨甲
			"lantern", -- 提灯
			"lighter", -- 薇洛的打火机
			"minerhat", -- 头灯
			"molehat", -- 鼹鼠帽
			"nightstick", -- 晨星
			"thurible", -- 香炉
			"yellowamulet", -- 黄符
			"purpleamulet", -- 紫符
			"blueamulet", -- 冰符
			"bottlelantern", -- 瓶灯 in Island Adventures
			"nightpack", -- 影背包 in Civi the MOgician of Light and Dark
			"darkamulet", -- 黑暗护符 in Civi
			"lightamulet", -- 光明护符 in Civi

		},
		boat = { -- Island Adventures
			"boat_lantern", -- 船灯
			"ironwind", -- 螺旋桨
		}
	}

	local player_eslots = inst.components.inventory and inst.components.inventory.equipslots
	local boat = inst.components.sailor and inst.components.sailor:GetBoat() -- Compatible for Island Adventures
	local boat_elots = boat and boat.components.container and boat.components.container.boat_elots

	for source, eslots in pairs({player = player_eslots, boat = boat_elots}) do
		for _, target in pairs(eslots) do
			if table.contains(fueledtable[source], target.prefab) then
				local fueled = target.components.fueled
				if fueled and fueled:GetPercent() + TUNING.LARGE_FUEL / fueled.maxfuel * fueled.bonusmult <= 1 and
					CheckHasItem(inst, "nightmarefuel")
				then
					is_fx_true = true
					fueled:DoDelta(TUNING.LARGE_FUEL * fueled.bonusmult)
					ConsumeItem(inst, "nightmarefuel")
					if fueled.ontakefuelfn then fueled.ontakefuelfn(target) end
				end
			end
		end
	end

	if is_fx_true then
		SpawnPrefab("pandorachest_reset").entity:SetParent(inst.entity)
	end
end

local function onboost(inst)
	inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * 1.25
	inst.components.temperature.mintemp = 10
	if inst.components.eater ~= nil then
		inst.components.eater:SetAbsorptionModifiers(0.6, 0.6, 0.6)
	end
end

local function onupdate(inst, dt)
	inst.boost_time = inst.boost_time - dt
	if inst.boost_time <= 0 then
		inst.boost_time = 0
		if inst.boosted_task ~= nil then
			inst.boosted_task:Cancel()
			inst.boosted_task = nil
		end
		inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED
		inst.components.temperature.mintemp = -20
		if inst.components.eater ~= nil then
			inst.components.eater:SetAbsorptionModifiers(1, 1, 1)
		end
		if inst._dry_task ~= nil then
			inst._dry_task:Cancel()
			inst._dry_task = nil
		end
	else
		--boosteffect(inst)
		autorefuel(inst)
		if inst._dry_task == nil then
			inst._dry_task = inst:DoPeriodicTask(0, function(inst)
				dryequipment(inst)
			end)
		end
	end
end

local function onlongupdate(inst, dt)
	inst.boost_time = math.max(0, inst.boost_time - dt)
end

local function startboost(inst, duration)
	inst.boost_time = duration
	if inst.boosted_task == nil then
		inst.boosted_task = inst:DoPeriodicTask(1, onupdate, nil, 1)
		inst:DoTaskInTime(0, function(inst) onupdate(inst, 0) end) -- Prevent autorefuel function consumes nightmarefuels before actually "eated"
		onboost(inst)
	end
end

local function onload(inst, data)
	if data ~= nil and data.boost_time ~= nil then startboost(inst, data.boost_time) end
end

local function onsave(inst, data)
	data.boost_time = inst.boost_time > 0 and inst.boost_time or nil
end

local function oneat(inst, food, eater)
	if food and food.components.edible and food.prefab == "nightmarefuel" then
		-- local player = food.components.inventoryitem and food.components.inventoryitem.owner or nil
		local fx = SpawnPrefab("statue_transition")
		if fx then
			fx.entity:SetParent(inst.entity)
			fx.Transform:SetScale(0.4, 0.4, 0.4)
		end
		inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
		startboost(inst, 180)
	end
end

local function onbecameghost(inst)
	if inst.boosted_task ~= nil then
		inst.boosted_task:Cancel()
		inst.boosted_task = nil
		inst.boost_time = 0
	end
end

local function onhaunt(inst, doer)
	return not (inst.components.sanity and inst.components.sanity.current == 0)
end

local common_postinit = function(inst)
	inst.soundsname = "willow"
	inst:AddTag("reader")
	inst:AddTag("nightstorychar")
	inst:AddTag("nightmare_twins")
	-- Minimap icon
	inst.MiniMapEntity:SetIcon("miotan.tex")
end

-- This initializes for the host only
local master_postinit = function(inst)
	inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default

	inst.boost_time = 0
	inst.boosted_task = nil

	inst:AddComponent("reader")

	inst:AddComponent("hauntable")
	inst.components.hauntable.onhaunt = onhaunt
	inst.components.hauntable.hauntvalue = TUNING.HAUNT_INSTANT_REZ
	inst.components.hauntable.no_wipe_value = true

	inst.components.health:SetMaxHealth(TUNING.MIOTAN_STATUS)
	inst.components.hunger:SetMax(TUNING.MIOTAN_STATUS)
	inst.components.sanity:SetMax(TUNING.MIOTAN_STATUS)

	inst.components.sanity.dapperness = TUNING.MIOTAN_SANITY_DAPPERNESS
	inst.components.sanity.night_drain_mult = TUNING.MIOTAN_SANITY_MULT
	inst.components.sanity.neg_aura_mult = TUNING.MIOTAN_SANITY_MULT

	if inst.components.eater then
		inst.components.eater:SetCanEatNightmareFuel()
		inst.components.eater:SetOnEatFn(oneat)
		inst.components.eater.stale_hunger = -0.5
		inst.components.eater.stale_health = 0
		inst.components.eater.spoiled_hunger = -1
		inst.components.eater.spoiled_health = -0.5
	end

	inst:ListenForEvent("ms_becameghost", onbecameghost)
	inst.OnLongUpdate = onlongupdate
	inst.OnSave = onsave
	inst.OnLoad = onload

	inst.skeleton_prefab = nil
	inst:ListenForEvent("death", function(inst)
		inst:DoTaskInTime(2, function(inst)
			SpawnPrefab("nightmarefuel").Transform:SetPosition(inst:GetPosition():Get())
		end)
	end)

end

return MakePlayerCharacter("miotan", prefabs, assets, common_postinit, master_postinit),
	CreatePrefabSkin("miotan_none", {
		base_prefab = "miotan",
		type = "base",
		assets = assets,
		skins = { normal_skin = "miotan", ghost_skin = "ghost_miotan_build" },
		bigportrait = { build = "bigportrait/miotan_none.xml", symbol = "miotan_none_oval.tex"},
		skin_tags = { "MIOTAN", "BASE"},
		build_name_override = "miotan",
		rarity = "Character",
	}),
	CreatePrefabSkin("miotan_classic", {
		base_prefab = "miotan",
		type = "base",
		assets = {
			Asset( "ANIM", "anim/miotan_classic.zip" ),
			Asset( "ANIM", "anim/ghost_miotan_classic_build.zip" ),
			Asset( "ATLAS", "bigportraits/miotan_classic.xml")
		},
		skins = { normal_skin = "miotan_classic", ghost_skin = "ghost_miotan_classic_build" },
		bigportrait = { build = "bigportrait/miotan_classic.xml", symbol = "miotan_classic_oval.tex"},
		skin_tags = { "MIOTAN", "BASE"},
		build_name_override = "miotan_classic",
		rarity = "Glassic",
	})

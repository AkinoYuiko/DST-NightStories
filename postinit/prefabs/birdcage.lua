local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

-- local GetUpvalue = GlassicAPI.UpvalueUtil.GetUpvalue
-- local SetUpvalue = GlassicAPI.UpvalueUtil.SetUpvalue

-- AddPrefabPostInit("birdcage", function(inst)
--	 if not TheWorld.ismastersim then return end

--	 local digest_food = GetUpvalue(inst.components.trader.onaccept, "DigestFood")
--	 if digest_food then
--		 SetUpvalue(inst.components.trader.onaccept, "DigestFood", function(inst, food)
--			 local stacksize = food and food.components.stackable and food.components.stackable.stacksize or 1
--			 for k = 1, stacksize do
--				 digest_food(inst, food)
--			 end
--		 end)
--	 end
-- end)

local function GetBird(inst)
	return (inst.components.occupiable and inst.components.occupiable:GetOccupant()) or nil
end

local function SpawnLootPrefab(inst, prefab, stacksize)
	if stacksize then
		for k = 1, stacksize do
			inst.components.lootdropper:SpawnLootPrefab(prefab)
		end
	end
end

local function DigestFood(inst, food)
	-- COPIED FROM birdcage.lua --
	local stacksize = food and food.components.stackable and food.components.stackable.stacksize or 1 -- changed part --
	--NOTE (Omar):
	-- Reminder that food is not valid at this point.
	-- So don't call any engine functions or any other functions that check for validity
	local bird = GetBird(inst)

	if bird and bird:HasTag("bird_mutant_rift") then
		if food.components.edible.foodtype == FOODTYPE.LUNAR_SHARDS then
			if food.prefab == "moonglass_charged" then --Can't be a tag check
				if bird.do_drop_brilliance then
					SpawnLootPrefab(inst, "purebrilliance", stacksize) -- changed part --
					bird.do_drop_brilliance = nil
				end
			else
				--inst.components.lootdropper:SpawnLootPrefab("")
			end
		end
	elseif food.components.edible.foodtype == FOODTYPE.MEAT then
		--If the food is meat:
			--Spawn an egg.
		if bird and bird:HasTag("bird_mutant") then
			SpawnLootPrefab(inst, "rottenegg", stacksize) -- changed part --
		else
			SpawnLootPrefab(inst, "bird_egg", stacksize) -- changed part --
		end
	else
		if bird and bird:HasTag("bird_mutant") then
			SpawnLootPrefab(inst, "spoiled_food", stacksize) -- changed part --
		else
			local seed_name = string.lower(food.prefab .. "_seeds")
			if Prefabs[seed_name] ~= nil then
				SpawnLootPrefab(inst, seed_name, stacksize) -- changed part --
			else
				--Otherwise...
					--Spawn a poop 1/3 times.
				if math.random() < 0.33 then
					for k = 1, stacksize do
						local loot = inst.components.lootdropper:SpawnLootPrefab("guano")
						loot.Transform:SetScale(.33, .33, .33)
						loot.components.stackable:SetStackSize(stacksize) -- changed part --
					end
				end
			end
		end
	end

	--Refill bird stomach.
	if bird and bird:IsValid() and bird.components.perishable then
		bird.components.perishable:SetPercent(1)
	end
end

local function OnGetItem(inst, giver, item)
	local bird = GetBird(inst)
	--If you're sleeping, wake up.
	if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
			inst.components.sleeper:WakeUp()
	end

	if item.components.edible ~= nil and
		(   item.components.edible.foodtype == FOODTYPE.MEAT
			or item.components.edible.foodtype == FOODTYPE.LUNAR_SHARDS
			or item.prefab == "seeds"
			or string.match(item.prefab, "_seeds")
			or Prefabs[string.lower(item.prefab .. "_seeds")] ~= nil
		) then
		--If the item is edible...
		--Play some animations (peck, peck, peck, hop, idle)
		inst.AnimState:PlayAnimation("peck")
		inst.AnimState:PushAnimation("peck")
		inst.AnimState:PushAnimation("peck")
		inst.AnimState:PushAnimation("hop")
		-- PushStateAnim(inst, "idle", true)
		inst.AnimState:PushAnimation("idle" .. inst.CAGE_STATE, true) -- changed part

		-- We have to do this logic instantly so the player doesn't feed too many shards before the task in time
		if bird and bird:HasTag("bird_mutant_rift") and item.prefab == "moonglass_charged" then
			bird._infused_eaten = bird._infused_eaten + 1

			if bird._infused_eaten >= TUNING.RIFT_BIRD_EAT_COUNT_FOR_BRILLIANCE then
				bird:PutOnBrillianceCooldown(inst)
				bird.do_drop_brilliance = true
			end
		end
		--Digest Food in 60 frames.
		inst:DoTaskInTime(60 * FRAMES, DigestFood, item)
	end
end

AddPrefabPostInit("birdcage", function(inst)
	if not TheWorld.ismastersim then return end

	inst.components.trader.onaccept = OnGetItem
end)

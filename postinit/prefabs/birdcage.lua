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
	if food.components.edible.foodtype == FOODTYPE.MEAT then
		--If the food is meat:
			--Spawn an egg.
		if inst.components.occupiable and inst.components.occupiable:GetOccupant() and inst.components.occupiable:GetOccupant():HasTag("bird_mutant") then
			SpawnLootPrefab(inst, "rottenegg", stacksize) -- changed part --
		else
			SpawnLootPrefab(inst, "bird_egg", stacksize) -- changed part --
		end
	else
		if inst.components.occupiable and inst.components.occupiable:GetOccupant() and inst.components.occupiable:GetOccupant():HasTag("bird_mutant") then
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
	local bird = GetBird(inst)
	if bird and bird:IsValid() and bird.components.perishable then
		bird.components.perishable:SetPercent(1)
	end
end


local function OnGetItem(inst, giver, item)
	--If you're sleeping, wake up.
	if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
		inst.components.sleeper:WakeUp()
	end

	if item.components.edible ~= nil and
		(   item.components.edible.foodtype == FOODTYPE.MEAT
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
		--Digest Food in 60 frames.
		inst:DoTaskInTime(60 * FRAMES, DigestFood, item)
	end
end

AddPrefabPostInit("birdcage", function(inst)
	if not TheWorld.ismastersim then return end

	inst.components.trader.onaccept = OnGetItem
end)

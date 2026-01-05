local function MakeHat(name)
	local fname = "hat_" .. name
	local symname = name .. "hat"
	local prefabname = symname

	--If you want to use generic_perish to do more, it's still
	--commented in all the relevant places below in this file.
	--[[local function generic_perish(inst)
		inst:Remove()
	end]]

	local swap_data = { bank = symname, anim = "anim" }

	-- do not pass this function to equippable:SetOnEquip as it has different a parameter listing
	local function _onequip(inst, owner, symbol_override)
		local skin_build = inst:GetSkinBuild()
		if skin_build ~= nil then
			owner:PushEvent("equipskinneditem", inst:GetSkinName())
			owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, symbol_override or "swap_hat", inst.GUID, fname)
		else
			owner.AnimState:OverrideSymbol("swap_hat", fname, symbol_override or "swap_hat")
		end
		owner.AnimState:Show("HAT")
		owner.AnimState:Show("HAIR_HAT")
		owner.AnimState:Hide("HAIR_NOHAT")
		owner.AnimState:Hide("HAIR")

		if owner:HasTag("player") then
			owner.AnimState:Hide("HEAD")
			owner.AnimState:Show("HEAD_HAT")
		end

		if inst.components.fueled ~= nil then
			inst.components.fueled:StartConsuming()
		end
	end

	local function _onunequip(inst, owner)
		local skin_build = inst:GetSkinBuild()
		if skin_build ~= nil then
			owner:PushEvent("unequipskinneditem", inst:GetSkinName())
		end

		owner.AnimState:ClearOverrideSymbol("swap_hat")
		owner.AnimState:Hide("HAT")
		owner.AnimState:Hide("HAIR_HAT")
		owner.AnimState:Show("HAIR_NOHAT")
		owner.AnimState:Show("HAIR")

		if owner:HasTag("player") then
			owner.AnimState:Show("HEAD")
			owner.AnimState:Hide("HEAD_HAT")
		end

		if inst.components.fueled ~= nil then
			inst.components.fueled:StopConsuming()
		end
	end

	local function simple_onequip(inst, owner, from_ground)
		_onequip(inst, owner)
	end

	local function simple_onunequip(inst, owner, from_ground)
		_onunequip(inst, owner)
	end
	local function opentop_onequip(inst, owner)
		local skin_build = inst:GetSkinBuild()
		if skin_build ~= nil then
			owner:PushEvent("equipskinneditem", inst:GetSkinName())
			owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, "swap_hat", inst.GUID, fname)
		else
			owner.AnimState:OverrideSymbol("swap_hat", fname, "swap_hat")
		end

		owner.AnimState:Show("HAT")
		owner.AnimState:Hide("HAIR_HAT")
		owner.AnimState:Show("HAIR_NOHAT")
		owner.AnimState:Show("HAIR")

		owner.AnimState:Show("HEAD")
		owner.AnimState:Hide("HEAD_HAT")

		if inst.components.fueled ~= nil then
			inst.components.fueled:StartConsuming()
		end
	end

	local function simple(custom_init)
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank(symname)
		inst.AnimState:SetBuild(fname)
		inst.AnimState:PlayAnimation("anim")

		inst:AddTag("hat")

		if custom_init ~= nil then
			custom_init(inst)
		end

		MakeInventoryFloatable(inst)
		inst.components.floater:SetBankSwapOnFloat(false, nil, swap_data) --Hats default animation is not "idle", so even though we don't swap banks, we need to specify the swap_data for re-skinning to reset properly when floating

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("inventoryitem")

		inst:AddComponent("inspectable")

		inst:AddComponent("tradable")

		inst:AddComponent("equippable")
		inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
		inst.components.equippable:SetOnEquip(simple_onequip)
		inst.components.equippable:SetOnUnequip(simple_onunequip)

		MakeHauntableLaunch(inst)

		return inst
	end

	local function default()
		return simple()
	end

	local function ruinshat_fxanim(inst)
		inst._fx.AnimState:PlayAnimation("hit")
		inst._fx.AnimState:PushAnimation("idle_loop")
	end

	local function ruinshat_oncooldown(inst)
		inst._task = nil
	end

	local function ruinshat_unproc(inst)
		if inst:HasTag("forcefield") then
			inst:RemoveTag("forcefield")
			if inst._fx ~= nil then
				inst._fx:kill_fx()
				inst._fx = nil
			end
			inst:RemoveEventCallback("armordamaged", ruinshat_fxanim)

			inst.components.armor:SetAbsorption(TUNING.ARMOR_RUINSHAT_ABSORPTION)
			inst.components.armor.ontakedamage = nil

			if inst._task ~= nil then
				inst._task:Cancel()
			end
			inst._task = inst:DoTaskInTime(TUNING.ARMOR_RUINSHAT_COOLDOWN, ruinshat_oncooldown)
		end
	end

	local function ruinshat_proc(inst, owner)
		inst:AddTag("forcefield")
		if inst._fx ~= nil then
			inst._fx:kill_fx()
		end
		inst._fx = SpawnPrefab("forcefieldfx")
		inst._fx.entity:SetParent(owner.entity)
		inst._fx.Transform:SetPosition(0, 0.2, 0)
		inst:ListenForEvent("armordamaged", ruinshat_fxanim)

		inst.components.armor:SetAbsorption(TUNING.FULL_ABSORPTION)
		inst.components.armor.ontakedamage = function(inst, damage_amount)
			if owner ~= nil and owner.components.sanity ~= nil then
				owner.components.sanity:DoDelta(-damage_amount * TUNING.ARMOR_RUINSHAT_DMG_AS_SANITY, false)
			end
		end

		if inst._task ~= nil then
			inst._task:Cancel()
		end
		inst._task = inst:DoTaskInTime(TUNING.ARMOR_RUINSHAT_DURATION, ruinshat_unproc)
	end

	local function tryproc(inst, owner, data)
		if inst._task == nil and not data.redirected and math.random() < TUNING.ARMOR_RUINSHAT_PROC_CHANCE then
			ruinshat_proc(inst, owner)
		end
	end

	local function ruins_onunequip(inst, owner)
		_onunequip(inst, owner)
		inst.ondetach()
	end

	local function ruins_onequip(inst, owner)
		_onequip(inst, owner)
		inst.onattach(owner)
	end

	local function ruins_custom_init(inst)
		inst:AddTag("open_top_hat")
		inst:AddTag("metal")
		inst:AddTag("waterproofer")
	end

	local function battleruins_onremove(inst)
		if inst._fx ~= nil then
			inst._fx:kill_fx()
			inst._fx = nil
		end
	end

	local function battleruins()
		local inst = simple(ruins_custom_init)

		inst:AddTag("shadow_item")

		--shadowlevel (from shadowlevel component) added to pristine state for optimization
		inst:AddTag("shadowlevel")

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("armor")
		inst.components.armor:InitCondition(TUNING.ARMOR_RUINSHAT, TUNING.ARMOR_RUINSHAT_ABSORPTION)

		inst:AddComponent("waterproofer")
		inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

		inst.components.equippable:SetOnEquip(ruins_onequip)
		inst.components.equippable:SetOnUnequip(ruins_onunequip)

		inst:AddComponent("shadowlevel")
		inst.components.shadowlevel:SetDefaultLevel(TUNING.NIGHTSWORD_SHADOW_LEVEL)

		MakeHauntableLaunch(inst)

		inst.OnRemoveEntity = battleruins_onremove

		inst._fx = nil
		inst._task = nil
		inst._owner = nil
		inst.procfn = function(owner, data)
			tryproc(inst, owner, data)
		end
		inst.onattach = function(owner)
			if inst._owner ~= nil then
				inst:RemoveEventCallback("attacked", inst.procfn, inst._owner)
				inst:RemoveEventCallback("onremove", inst.ondetach, inst._owner)
			end
			inst:ListenForEvent("attacked", inst.procfn, owner)
			inst:ListenForEvent("onremove", inst.ondetach, owner)
			inst._owner = owner
			inst._fx = nil
		end
		inst.ondetach = function()
			ruinshat_unproc(inst)
			if inst._owner ~= nil then
				inst:RemoveEventCallback("attacked", inst.procfn, inst._owner)
				inst:RemoveEventCallback("onremove", inst.ondetach, inst._owner)
				inst._owner = nil
				inst._fx = nil
			end
		end

		return inst
	end

	local fn = nil
	local assets = { Asset("ANIM", "anim/" .. fname .. ".zip") }
	local prefabs = nil

	if name == "battleruins" then
		fn = battleruins
	end

	return Prefab(prefabname, fn or default, assets, prefabs)
end

return MakeHat("battleruins")

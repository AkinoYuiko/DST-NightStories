
local assets =
{
	-- Asset("ANIM", "anim/ham_bat.zip"),
	-- Asset("ANIM", "anim/swap_ham_bat.zip"),
	Asset("ANIM", "anim/bat_lunarplant.zip"),
	Asset("ANIM", "anim/bat_lunarplant.zip"),
}

local prefabs =
{
	"lunarplanttentacle",
	"hitsparks_fx",
}

local function UpdateDamage(inst)
	if inst.components.perishable and inst.components.weapon then
		local dmg = inst.base_damage * inst.components.perishable:GetPercent()
		dmg = Remap(dmg, 0, inst.base_damage, 0.5 * inst.base_damage, inst.base_damage)
		inst.components.weapon:SetDamage(inst._bonusenabled and dmg * TUNING.WEAPONS_LUNARPLANT_SETBONUS_DAMAGE_MULT or dmg)
	end
end

local function SetBuffEnabled(inst, enabled)
	if enabled then
		if not inst._bonusenabled then
			inst._bonusenabled = true
			UpdateDamage(inst)
			inst.components.planardamage:AddBonus(inst, TUNING.WEAPONS_LUNARPLANT_SETBONUS_PLANAR_DAMAGE, "setbonus")
		end
	elseif inst._bonusenabled then
		inst._bonusenabled = nil
		UpdateDamage(inst)
		inst.components.planardamage:RemoveBonus(inst, "setbonus")
	end
end

local function SetBuffOwner(inst, owner)
	if inst._owner ~= owner then
		if inst._owner ~= nil then
			inst:RemoveEventCallback("equip", inst._onownerequip, inst._owner)
			inst:RemoveEventCallback("unequip", inst._onownerunequip, inst._owner)
			inst._onownerequip = nil
			inst._onownerunequip = nil
			SetBuffEnabled(inst, false)
		end
		inst._owner = owner
		if owner ~= nil then
			inst._onownerequip = function(owner, data)
				if data ~= nil then
					if data.item ~= nil and data.item.prefab == "lunarplanthat" then
						SetBuffEnabled(inst, true)
					elseif data.eslot == EQUIPSLOTS.HEAD then
						SetBuffEnabled(inst, false)
					end
				end
			end
			inst._onownerunequip  = function(owner, data)
				if data ~= nil and data.eslot == EQUIPSLOTS.HEAD then
					SetBuffEnabled(inst, false)
				end
			end
			inst:ListenForEvent("equip", inst._onownerequip, owner)
			inst:ListenForEvent("unequip", inst._onownerunequip, owner)

			local hat = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
			if hat ~= nil and hat.prefab == "lunarplanthat" then
				SetBuffEnabled(inst, true)
			end
		end
	end
end

local function onequip(inst, owner)
	local skin_build = inst:GetSkinBuild()
	if skin_build ~= nil then
		owner:PushEvent("equipskinneditem", inst:GetSkinName())
		owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_bat_lunarplant", inst.GUID, "bat_lunarplant")
	else
		owner.AnimState:OverrideSymbol("swap_object", "bat_lunarplant", "swap_bat_lunarplant")
	end
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
	SetBuffOwner(inst, owner)
end

local function onunequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
	local skin_build = inst:GetSkinBuild()
	if skin_build ~= nil then
		owner:PushEvent("unequipskinneditem", inst:GetSkinName())
	end
	SetBuffOwner(inst, nil)
end

local function OnAttack(inst, attacker, target)
	if target ~= nil and target:IsValid() then
		SpawnPrefab("hitsparks_fx"):Setup(attacker, target)
	end
end

local function SetupComponents(inst)
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)

	inst:AddComponent("weapon")
	inst.components.weapon:SetOnAttack(UpdateDamage)
	inst.components.weapon:SetOnAttack(OnAttack)
	UpdateDamage(inst)
end

local function DisableComponents(inst)
	inst:RemoveComponent("equippable")
	-- inst:RemoveComponent("weapon")
end

local FLOAT_SCALE_BROKEN = { 1, 0.72, 1 }
local FLOAT_SCALE = { 0.75, 0.4, 0.75 }

local function OnIsBrokenDirty(inst)
	if inst.isbroken:value() then
		inst.components.floater:SetSize("small")
		inst.components.floater:SetVerticalOffset(0.1)
		inst.components.floater:SetScale(FLOAT_SCALE_BROKEN)
	else
		inst.components.floater:SetSize("med")
		inst.components.floater:SetVerticalOffset(0.05)
		inst.components.floater:SetScale(FLOAT_SCALE)
	end
end

local SWAP_DATA_BROKEN = { sym_build = "bat_lunarplant", sym_name = "swap_bat_lunarplant_broken_float", bank = "bat_lunarplant", anim = "broken" }
local SWAP_DATA = { sym_build = "bat_lunarplant", sym_name = "swap_bat_lunarplant" }

local function SetIsBroken(inst, isbroken)
	if isbroken then
		inst.components.floater:SetBankSwapOnFloat(true, -8, SWAP_DATA_BROKEN)
	else
		inst.components.floater:SetBankSwapOnFloat(true, -13, SWAP_DATA)
	end
	inst.isbroken:set(isbroken)
	OnIsBrokenDirty(inst)
end

local function OnBroken(inst)
	if inst.components.equippable ~= nil then

		if inst.components.equippable:IsEquipped() then
			local owner = inst.components.inventoryitem.owner
			if owner ~= nil and owner.components.inventory ~= nil then
				local item = owner.components.inventory:Unequip(inst.components.equippable.equipslot)
				if item ~= nil then
					owner.components.inventory:GiveItem(item, nil, owner:GetPosition())
				end
			end
		end

		DisableComponents(inst)
		inst.AnimState:PlayAnimation("broken")
		SetIsBroken(inst, true)
		inst:AddTag("broken")
		inst.components.inspectable.nameoverride = "BROKEN_FORGEDITEM"
	end
end

local function OnRepaired(inst)
	if inst.components.equippable == nil then
		SetupComponents(inst)
		inst.AnimState:PlayAnimation("idle")
		SetIsBroken(inst, false)
		inst:RemoveTag("broken")
		inst.components.inspectable.nameoverride = nil
		UpdateDamage(inst)
	end
end

local function OnLoad(inst, data)
	local percent = inst.components.perishable:GetPercent()
	if percent <= 0 then
		OnBroken(inst)
	end
	UpdateDamage(inst)
	inst.components.forgerepairable:SetRepairable(percent < 1)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("bat_lunarplant")
	inst.AnimState:SetBuild("bat_lunarplant")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("show_broken_ui")
	inst:AddTag("show_spoilage")
	inst:AddTag("icebox_valid")

	--weapon (from weapon component) added to pristine state for optimization
	inst:AddTag("weapon")

	inst:AddComponent("floater")
	inst.isbroken = net_bool(inst.GUID, "bat_lunarplant.isbroken", "isbrokendirty")
	SetIsBroken(inst, false)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst:ListenForEvent("isbrokendirty", OnIsBrokenDirty)

		return inst
	end

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()

	inst.base_damage = TUNING.BAT_LUNARPLANT_DAMAGE

	local planardamage = inst:AddComponent("planardamage")
	planardamage:SetBaseDamage(TUNING.BAT_LUNARPLANT_PLANAR_DAMAGE)

	local damagetypebonus = inst:AddComponent("damagetypebonus")
	damagetypebonus:AddBonus("shadow_aligned", inst, TUNING.WEAPONS_LUNARPLANT_VS_SHADOW_BONUS)

	inst:AddComponent("forcecompostable")
	inst.components.forcecompostable.green = true

	inst.OnLoad = OnLoad

	-------

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")

	SetupComponents(inst)

	inst:AddComponent("lunarplant_tentacle_weapon")

	MakeForgeRepairable(inst, FORGEMATERIALS.LUNARPLANT, nil, OnRepaired)
	-- We handle OnBroken ourselves.
	inst.components.perishable:SetOnPerishFn(OnBroken)
	inst:ListenForEvent("perishchange", function(_inst, data)
		if data and data.percent then
			inst.components.forgerepairable:SetRepairable(data.percent < 1)
		end
	end)

	MakeHauntableLaunch(inst)

	return inst
end

return Prefab("bat_lunarplant", fn, assets, prefabs)

local AddClassPostConstruct = AddClassPostConstruct
local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local CRYSTAL_NAMES = {
	"darkcrystal",
	"lightcrystal",
}
local CRYSTAL_IDS = table.invert(CRYSTAL_NAMES)

local function InitContainer(inst)
	inst:AddTag("crystal_socketed")
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("nightsword")
	inst.components.container.canbeopened = false
end

local function GetImageBG(base_name)
	if not base_name then
		return
	end
	local name = base_name .. "_over.tex"
	return { image = name, atlas = GetInventoryItemAtlas(name) }
end

local function OnCrystalDirty(inst)
	inst.inv_image_bg = GetImageBG(CRYSTAL_NAMES[inst.crystal_id:value()])
	inst:PushEvent("imagechange")
end

local function SetCrystalBG(inst, override)
	inst.crystal_id:set(override or CRYSTAL_IDS[inst.socketed_crystal] or 0)
	OnCrystalDirty(inst)
end

local function on_add_container(inst)
	if not inst:HasTag("_container") then
		inst:AddTag("_container")
	end
	local container = inst.replica.container
	if container then
		if container.classified == nil and inst.container_classified then
			container.classified = inst.container_classified
			inst.container_classified.OnRemoveEntity = nil
			inst.container_classified = nil
			container:AttachClassified(container.classified)
		end
		if container.opener == nil and inst.container_opener then
			container.opener = inst.container_opener
			inst.container_opener.OnRemoveEntity = nil
			inst.container_opener = nil
			container:AttachOpener(container.opener)
		end
	end
end

local function onequipfn(inst, data)
	if inst.components.container then
		inst.components.container:Open(data.owner)
	end
end

local function onunequipfn(inst)
	if inst.components.container then
		inst.components.container:Close()
	end
end

local function onopen(inst)
	inst:SetCrystalBG(0)
end

local function onclose(inst)
	inst:SetCrystalBG()
end

local function onitemget(inst, data)
	if inst.remove_container_task then
		inst.remove_container_task:Cancel()
		inst.remove_container_task = nil
	end
	if data.item.prefab == "darkcrystal" then
		inst.socketed_crystal = "darkcrystal"
		inst.components.weapon:SetDamage(TUNING.NIGHTSWORD_DAMAGE * 1.125)
		inst.components.weapon.attackwearmultipliers:SetModifier("nightcrystal", 1.25)
		inst.components.equippable.dapperness = TUNING.CRAZINESS_MED * 1.25
	elseif data.item.prefab == "lightcrystal" then
		inst.socketed_crystal = "lightcrystal"
		inst.components.weapon:SetDamage(TUNING.NIGHTSWORD_DAMAGE)
		inst.components.weapon.attackwearmultipliers:SetModifier("nightcrystal", 0.8)
		inst.components.equippable.dapperness = 0
	end
	inst:SetCrystalBG(inst.components.container:IsOpen() and 0)
end

local function onitemlose(inst)
	inst.socketed_crystal = nil
	inst.components.weapon:SetDamage(TUNING.NIGHTSWORD_DAMAGE)
	inst.components.weapon.attackwearmultipliers:RemoveModifier("nightcrystal")
	inst.components.equippable.dapperness = TUNING.CRAZINESS_MED
	if inst.remove_container_task then
		inst.remove_container_task:Cancel()
		inst.remove_container_task = nil
	end
	inst.remove_container_task = inst:DoTaskInTime(2, function(inst)
		if inst.components.container and inst.components.container:IsEmpty() then
			inst.components.container:Close()
			inst:RemoveComponent("container")
			inst:RemoveTag("crystal_socketed")
			inst.remove_container_task = nil
		end
	end)
	inst:SetCrystalBG()
end

AddPrefabPostInit("nightsword", function(inst)
	inst.entity:AddSoundEmitter()

	inst.crystal_id = net_tinybyte(inst.GUID, "nightsword.crystal_id", "crystaldirty")
	inst.add_container_event = net_event(inst.GUID, "add_container")
	inst:AddTag("__container")

	if not TheWorld.ismastersim then
		inst:ListenForEvent("crystaldirty", OnCrystalDirty)
		inst:ListenForEvent("add_container", on_add_container)
		return
	end

	inst:RemoveTag("__container")
	inst:PrereplicateComponent("container")
	inst.InitContainer = InitContainer

	inst.SetCrystalBG = SetCrystalBG

	local onfinished = inst.components.finiteuses.onfinished or function() end
	inst.components.finiteuses:SetOnFinished(function(inst, ...)
		local container = inst.components.container
		if container then
			local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
			local inv = owner and owner.components.inventory
			local item = container:RemoveItemBySlot(1)
			if item then
				inst.components.finiteuses:SetPercent(1)
				if inv and (owner.prefab == "civi" or (owner.prefab == "miotan" and owner.boosted_task)) then
					local crystal = inv:FindItem(function(new_item)
						return new_item.prefab == item.prefab
					end)
					if crystal then
						local slot_widget
						local controls = owner.HUD and owner.HUD.controls
						if controls then
							local overflow = inv:GetOverflowContainer()
							slot_widget = controls.inv.inv[inv:GetItemSlot(crystal)] -- check inventory first
								or (inv:GetActiveItem() == crystal and controls.inv.hovertile) -- else, check active item
								or (
									overflow -- else, if backpack, check backpack
									and (
										controls.containers[overflow.inst] -- if backpack is side-display
											and controls.containers[overflow.inst].inv[overflow:GetItemSlot(crystal)]
										or controls.inv.backpackinv[overflow:GetItemSlot(crystal)]
									)
								)
						end
						local single_crystal = inv:RemoveItem(crystal)
						if single_crystal then
							local pos = slot_widget
									and Vector3(TheSim:ProjectScreenPos(slot_widget:GetWorldPosition():Get()))
								or inst:GetPosition()
							container:GiveItem(single_crystal, nil, pos)
						end
					end
				end
				item:Remove()
				return
			end
		end
		return onfinished(inst, ...)
	end)

	inst:ListenForEvent("equipped", onequipfn)
	inst:ListenForEvent("unequipped", onunequipfn)

	inst:ListenForEvent("onopen", onopen)
	inst:ListenForEvent("onclose", onclose)

	inst:ListenForEvent("itemget", onitemget)
	inst:ListenForEvent("itemlose", onitemlose)

	local on_save = inst.OnSave or function() end
	inst.OnSave = function(inst, data, ...)
		data._iscontainer = inst.remove_container_task == nil and inst.components.container and true
		return on_save(inst, data, ...)
	end

	local on_preload = inst.OnPreLoad or function() end
	inst.OnPreLoad = function(inst, data, ...)
		if data and data._iscontainer then
			inst:InitContainer()
		end
		return on_preload(inst, data, ...)
	end
end)

AddClassPostConstruct("widgets/itemtile", function(self)
	if self.item.prefab == "nightsword" and self.imagebg == nil then
		self.imagebg = self:AddChild(Image(nil, nil, "default.tex"))
		self.imagebg:SetClickable(false)
		if GetGameModeProperty("icons_use_cc") then
			self.imagebg:SetEffect("shaders/ui_cc.ksh")
		end
	end
end)

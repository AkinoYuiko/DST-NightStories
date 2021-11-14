local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local NIGHTSWORDMAGATAMA = Action({ mount_valid = true, priority = 2 })

NIGHTSWORDMAGATAMA.id = "NIGHTSWORDMAGATAMA"
NIGHTSWORDMAGATAMA.str = STRINGS.ACTIONS.GIVE.SOCKET
NIGHTSWORDMAGATAMA.fn = function(act)
    local doer = act.doer
    local target = act.target
    if doer.components.inventory then
        local item = doer.components.inventory:RemoveItem(act.invobject)

        target:InitContainer()
		target.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")

        if doer.components.inventory:IsItemEquipped(target) then
            if target.components.container then
                target.components.container:Open(doer)
                target.add_container_event:push()
            end
        end

        target.components.container:GiveItem(item)

        return true
    end
end

ENV.AddAction(NIGHTSWORDMAGATAMA)
ENV.AddComponentAction("USEITEM", "nightmagatama", function(inst, doer, target, actions, right)
    if right and target.prefab == "nightsword" and not target:HasTag("nomagatamasocket") then
        table.insert(actions, ACTIONS.NIGHTSWORDMAGATAMA)
    end
end)

ENV.AddStategraphActionHandler("wilson", ActionHandler(NIGHTSWORDMAGATAMA, "doshortaction"))
ENV.AddStategraphActionHandler("wilson_client", ActionHandler(NIGHTSWORDMAGATAMA, "doshortaction"))

ENV.AddComponentAction("INVENTORY", "nightmagatama", function(inst, doer, actions, right)
    if doer.replica.inventory ~= nil and not doer.replica.inventory:IsHeavyLifting() then
        local sword = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if sword and sword.prefab == "nightsword"
            and sword.replica.container ~= nil and sword.replica.container:IsOpenedBy(doer)
            and sword.replica.container:CanTakeItemInSlot(inst) then

            table.insert(actions, ACTIONS.CHANGE_TACKLE)
        end
    end
end)

local MAGATAMA_NAMES = {
    "darkmagatama",
    "lightmagatama"
}
local MAGATAMA_IDS = table.invert(MAGATAMA_NAMES)

local function InitContainer(inst)
    inst:AddTag("nomagatamasocket")
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("nightsword")
    inst.components.container.canbeopened = false
end

local function GetImageBG(base_name)
    if not base_name then return end
    local name = base_name.."_over.tex"
    return { image = name, atlas = GetInventoryItemAtlas(name) }
end

local function OnMagatamaDirty(inst)
    inst.inv_image_bg = GetImageBG(MAGATAMA_NAMES[inst.magatama_id:value()])
    inst:PushEvent("imagechange")
end

local function SetMagatamaBG(inst, override)
    inst.magatama_id:set(override or MAGATAMA_IDS[inst.socketed_magatama] or 0)
    OnMagatamaDirty(inst)
end

local function on_add_container(inst)
    if not inst:HasTag("_container") then
        inst:AddTag("_container")
    end
    local container = inst.replica.container
    if container ~= nil then
        if container.classified == nil and inst.container_classified ~= nil then
            container.classified = inst.container_classified
            inst.container_classified.OnRemoveEntity = nil
            inst.container_classified = nil
            container:AttachClassified(container.classified)
        end
        if container.opener == nil and inst.container_opener ~= nil then
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
    inst:SetMagatamaBG(0)
end

local function onclose(inst)
    inst:SetMagatamaBG()
end

local function onitemget(inst, data)
    if inst.remove_container_task ~= nil then
        inst.remove_container_task:Cancel()
        inst.remove_container_task = nil
    end
    if data.item.prefab == "darkmagatama" then
        inst.socketed_magatama = "darkmagatama"
        inst.components.weapon:SetDamage(TUNING.NIGHTSWORD_DAMAGE * 1.125)
        inst.components.weapon.attackwearmultipliers:SetModifier("nightmagatama", 1.25)
        inst.components.equippable.dapperness = TUNING.CRAZINESS_MED * 1.5
    elseif data.item.prefab == "lightmagatama" then
        inst.socketed_magatama = "lightmagatama"
        inst.components.weapon:SetDamage(TUNING.NIGHTSWORD_DAMAGE)
        inst.components.weapon.attackwearmultipliers:SetModifier("nightmagatama", 0.8)
        inst.components.equippable.dapperness = 0
    end
    inst:SetMagatamaBG(inst.components.container:IsOpen() and 0)
end

local function onitemlose(inst)
    inst.socketed_magatama = nil
    inst.components.weapon:SetDamage(TUNING.NIGHTSWORD_DAMAGE)
    inst.components.weapon.attackwearmultipliers:RemoveModifier("nightmagatama")
    inst.components.equippable.dapperness = TUNING.CRAZINESS_MED
    if inst.remove_container_task ~= nil then
        inst.remove_container_task:Cancel()
        inst.remove_container_task = nil
    end
    inst.remove_container_task = inst:DoTaskInTime(1, function(inst)
        if inst.components.container and inst.components.container:IsEmpty() then
            inst.components.container:Close()
            inst:RemoveComponent("container")
            inst:RemoveTag("nomagatamasocket")
            inst.remove_container_task = nil
        end
    end)
    inst:SetMagatamaBG()
end

ENV.AddPrefabPostInit("nightsword", function(inst)
	inst.entity:AddSoundEmitter()

    inst.magatama_id = net_tinybyte(inst.GUID, "nightsword.magatama_id", "magatamadirty")
    inst.add_container_event = net_event(inst.GUID, "add_container")
    inst:AddTag("__container")

    if not TheWorld.ismastersim then
        inst:ListenForEvent("magatamadirty", OnMagatamaDirty)
        inst:ListenForEvent("add_container", on_add_container)
        return
    end

    inst:RemoveTag("__container")
    inst:PrereplicateComponent("container")
    inst.InitContainer = InitContainer

    inst.SetMagatamaBG = SetMagatamaBG

    local onfinished = inst.components.finiteuses.onfinished or function() end
    inst.components.finiteuses:SetOnFinished(function(inst, ...)
        local container = inst.components.container
        if container then
            local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
            local inv = owner and owner.components.inventory
            local item = container:RemoveItemBySlot(1)
            if item then
                inst.components.finiteuses:SetPercent(1)
                if inv and ( owner.prefab == "civi" or ( owner.prefab == "miotan" and owner.boosted_task ) ) then
                    local magatama = inv:FindItem(function(new_item) return new_item.prefab == item.prefab end)
                    if magatama then
                        local slot_widget
                        local controls = owner.HUD and owner.HUD.controls
                        if controls then
                            local overflow = inv:GetOverflowContainer()
                            slot_widget = controls.inv.inv[inv:GetItemSlot(magatama)] -- check inventory first
                            or ( inv:GetActiveItem() == magatama and controls.inv.hovertile ) -- else, check active item
                            or ( overflow -- else, if backpack, check backpack
                                and (
                                    controls.containers[overflow.inst] -- if backpack is side-display
                                    and controls.containers[overflow.inst].inv[overflow:GetItemSlot(magatama)]
                                    or controls.inv.backpackinv[overflow:GetItemSlot(magatama)]
                                )
                            )
                        end
                        local single_magatama = inv:RemoveItem(magatama)
                        if single_magatama then
                            local pos = slot_widget
                               and Vector3(TheSim:ProjectScreenPos(slot_widget:GetWorldPosition():Get()))
                               or inst:GetPosition()
                            container:GiveItem(single_magatama, nil, pos)
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

ENV.AddClassPostConstruct("widgets/itemtile", function(self)
    if self.item.prefab == "nightsword" and self.imagebg == nil then
        self.imagebg = self:AddChild(Image(nil, nil, "default.tex"))
        self.imagebg:SetClickable(false)
        if GetGameModeProperty("icons_use_cc") then
            self.imagebg:SetEffect("shaders/ui_cc.ksh")
        end
    end
end)

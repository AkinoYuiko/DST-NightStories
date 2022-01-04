local assets = {
    Asset("ANIM", "anim/blackholestaff.zip"),
}

local prefabs = {

    blackhole = {
        "shadow_puff",
        "reticule",
    },
}

---------- BLACKHOLE STAFF ----------
local function pickup(staff, target, pos)

    local caster = staff.components.inventoryitem.owner
    if caster == nil then return end

    local px = 0
    local py = 0
    local pz = 0
    local prange = 4
    local t_prefab = nil

    if target == nil and pos ~= nil then
        px, py, pz = pos:Get()
    elseif target == nil and pos == nil then
        px, py, pz = caster.Transform:GetWorldPosition()
    elseif target ~= nil and target == caster then
        px, py, pz = target.Transform:GetWorldPosition()
    elseif target ~= nil and target.components.inventoryitem then
        px, py, pz = target.Transform:GetWorldPosition()
        prange = 28
        t_prefab = target.prefab
    else
        return
    end

    local ents = TheSim:FindEntities(px, py, pz, prange,
                    { "_inventoryitem" },
                    { "INLIMBO", "NOCLICK", "catchable", "fire", "minesprung", "mineactive" })
    --for i=1, #ents do
        for i, v in ipairs(ents) do
            if v.components.inventoryitem ~= nil and
                v.components.inventoryitem.canbepickedup and
                v.components.inventoryitem.cangoincontainer and
                not v.components.inventoryitem:IsHeld() and ( t_prefab == nil or ( v.prefab == t_prefab ) ) then
                --local num = v.components.stackable and v.components.stackable.stacksize or 1
                if caster.components.inventory:CanAcceptCount(v, 40) > 0 then

                local fx = SpawnPrefab("shadow_puff")
                if fx then fx.Transform:SetPosition(v.Transform:GetWorldPosition()) fx.Transform:SetScale(0.7, 0.7, 0.7) end
                if v.components.stackable ~= nil then
                    local num = caster.components.inventory:CanAcceptCount(v, 40)
                    v = v.components.stackable:Get(num)
                end
                --end

                if v.components.trap ~= nil and v.components.trap:IsSprung() then
                    v.components.trap:Harvest(caster)
                else
                    caster.components.inventory:GiveItem(v, nil, v:GetPosition())
                end
                --return
            end
        end
    end

    if caster.components.sanity ~= nil then caster.components.sanity:DoDelta(-30) end
    staff.components.finiteuses:Use(1)

end
---------Can Cast Fn---------
-- local function can_cast_fn(doer, target, pos)
--     return target and target.components.inventoryitem or target:HasTag("player")
-- end

---------COMMON FUNCTIONS---------
local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onunequip_skinned(inst, owner)
    if inst:GetSkinBuild() ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end

    onunequip(inst, owner)
end

---------- SPECIFIC FUNC ----------
local function blackhole()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("staffs")
    inst.AnimState:SetBuild("blackholestaff")
    --inst.AnimState:OverrideSymbol("grass", "swap_nightcane", "grass")
    inst.AnimState:PlayAnimation("blackholestaff")
    -- inst.AnimState:SetManualBB(15, -75, 100, 225)

    inst:AddTag("nopunch")
    inst:AddTag("allow_action_on_impassable")

    local swap_data = {sym_build = "blackholestaff", sym_name = "swap_blackholestaff", bank = "staffs", anim = "blackholestaff"}
    MakeInventoryFloatable(inst, "med", 0.1, {0.9, 0.4, 0.9}, true, -13, swap_data)

        -- inst.drawatlasoverride = "images/inventoryimages/blackholestaff.xml"
        -- inst.drawimageoverride = "blackholestaff"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(function(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove() end)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem.imagename = "blackholestaff"
    -- inst.components.inventoryitem.atlasname = resolvefilepath("images/inventoryimages/blackholestaff.xml")


    inst:AddComponent("tradable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(
        function(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "blackholestaff", "swap_blackholestaff")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    end)

    inst.components.equippable:SetOnUnequip(onunequip)


    inst.fxcolour = {1/255, 1/255, 1/255}

    -- inst.spellfn = pickup
    inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canuseonpoint_water = true
    inst.components.spellcaster.canuseontargets = false
    inst.components.spellcaster.canusefrominventory = true
    inst.components.spellcaster:SetSpellFn(pickup)
    -- inst.components.spellcaster:SetCanCastFn(can_cast_fn)


    inst.components.finiteuses:SetMaxUses(TUNING.BLACKHOLESTAFF_USES)
    inst.components.finiteuses:SetUses(TUNING.BLACKHOLESTAFF_USES)

    MakeHauntableLaunch(inst)

    inst:DoTaskInTime(0, function(inst)
        inst.drawnameoverride = rawget(_G, "EncodeStrCode") and EncodeStrCode({content = "NAMES." .. string.upper(inst.prefab)})
    end)

    return inst
end


-- return Prefab("blackholestaff", blackhole, assets, prefabs.blackhole),
--     Prefab("nightmarestaff", nightmare, assets, prefabs.nightmare)
return Prefab("blackholestaff", blackhole, assets, prefabs.blackhole)

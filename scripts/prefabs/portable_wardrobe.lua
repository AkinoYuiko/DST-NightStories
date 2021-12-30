local wrap_assets =
{
    Asset("ANIM", "anim/portable_wardrobe_wrap.zip"),
}

local wrap_prefabs = {}

local wardrobe_assets =
{
    Asset("ANIM", "anim/portable_wardrobe.zip"),
}

local wardrobe_prefabs =
{
    "portable_wardrobe_item",
    "statue_transition",
    "statue_transition_2",
}

local wardrobe_prefabs_item =
{
    "portable_wardrobe",
}

local function SpawnFX(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")

    local x, y, z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab("statue_transition_2")
    if fx ~= nil then
        fx.Transform:SetPosition(x, y, z)
        fx.Transform:SetScale(1, 2, 1)
    end
    fx = SpawnPrefab("statue_transition")
    if fx ~= nil then
        fx.Transform:SetPosition(x, y, z)
        fx.Transform:SetScale(1, 1.5, 1)
    end
end

local function OnAnimOver(inst)
    if inst.AnimState:AnimDone() and inst.AnimState:IsCurrentAnimation("closed") then
        local current_uses = inst.components.finiteuses:GetUses()

        SpawnFX(inst)

        local item = ReplacePrefab(inst, "portable_wardrobe_item")
        item.components.finiteuses:SetUses(current_uses)
        item.AnimState:PlayAnimation("closed", false)
    end
end

local function ChangeToItem(inst)
    inst:RemoveComponent("portablestructure")
    inst:RemoveComponent("workable")

    inst:AddTag("NOCLICK")

    inst.AnimState:PlayAnimation("closed", false)
    inst:ListenForEvent("animover", OnAnimOver)
end

local function OnChangeIn(inst)
    if not inst:HasTag("burnt") then
        inst.components.finiteuses:Use(1)
        inst.AnimState:PlayAnimation("active")
        inst.AnimState:PushAnimation("closed", false)
        inst.SoundEmitter:PlaySound("dontstarve/common/wardrobe_active")
    end
end

local function OnOpen(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("open")
        inst.SoundEmitter:PlaySound("dontstarve/common/wardrobe_open")
    end
end

local function OnClose(inst)
    if not inst:HasTag("burnt") then
        if inst.AnimState:IsCurrentAnimation("open") then
            inst.AnimState:PlayAnimation("cancel")
            inst.SoundEmitter:PlaySound("dontstarve/common/wardrobe_close")
        end
    end
end

local function OnHammered(inst)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    --close it
    if inst:HasTag("burnt") then
        SpawnFX(inst)
        inst:Remove()
    else
        ChangeToItem(inst)
    end
end

local function OnHit(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("closed", false)
        inst.SoundEmitter:PlaySound("dontstarve/common/wardrobe_hit")
    end
    if inst.components.wardrobe ~= nil then
        inst.components.wardrobe:EndAllChanging()
    end
end

local function OnFinished(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("closed", false)
        inst:ListenForEvent("animover", function(inst)
            SpawnFX(inst)
            inst:Remove()
        end)
        -- inst.SoundEmitter:PlaySound("dontstarve/common/wardrobe_close")
        inst.persists = false
    end
end

local function OnSave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function OnDeploy(inst, pt, deployer)
    local wardrobe = SpawnPrefab("portable_wardrobe")
    if wardrobe ~= nil then
        wardrobe.Physics:SetCollides(false)
        wardrobe.Physics:Teleport(pt.x, 0, pt.z)
        wardrobe.Physics:SetCollides(true)

        wardrobe.AnimState:PlayAnimation("place")
        wardrobe.AnimState:PushAnimation("closed", false)

        wardrobe.SoundEmitter:PlaySound("dontstarve/common/wardrobe_craft")

        wardrobe.components.finiteuses:SetUses(inst.components.finiteuses:GetUses())

        inst:Remove()
        PreventCharacterCollisionsWithPlacedObjects(wardrobe)
    end
end

local function Consume(inst)
    if inst.components.stackable:IsStack() then
        inst.components.stackable:Get():Remove()
    else
        inst:Remove()
    end
end

local function common_fn(anim, should_sink)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(anim)
    inst.AnimState:SetBuild(anim)
    inst.AnimState:PlayAnimation("idle")

    if not should_sink then
        MakeInventoryFloatable(inst, "small", 0.25)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    if should_sink then
        inst.components.inventoryitem:SetSinks(true)
    end

    inst:AddComponent("inspectable")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    return inst
end

local function wrap_fn()
    local inst = common_fn("portable_wardrobe_wrap", true)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("wardrobe")
    inst.components.wardrobe:SetCanBeShared(true)
    local ApplySkins = inst.components.wardrobe.ApplySkins
    inst.components.wardrobe.ApplySkins = function(...)
        inst:Consume()
        return ApplySkins(...)
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst.Consume = Consume

    inst:DoTaskInTime(0, function(inst)
        inst.drawnameoverride = rawget(_G, "EncodeStrCode") and EncodeStrCode({content = "NAMES." .. string.upper(inst.prefab)})
    end)

    return inst
end

local function wardrobe_item_fn()
    local inst = common_fn("portable_wardrobe")

    inst.AnimState:PlayAnimation("closed",false)
    inst.AnimState:SetScale(0.4, 0.4, 0.4)

    inst:AddTag("portableitem")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(OnFinished)
    inst.components.finiteuses:SetMaxUses(TUNING.PORTABLE_WARDROBE_USES)
    inst.components.finiteuses:SetUses(TUNING.PORTABLE_WARDROBE_USES)

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.PLACER_DEFAULT)

    inst:DoTaskInTime(0, function(inst)
        inst.drawnameoverride = rawget(_G, "EncodeStrCode") and EncodeStrCode({content = "NAMES." .. string.upper(inst.prefab)})
    end)

    return inst
end

local function OnBurnt(inst)
    DefaultBurntStructureFn(inst)
    RemovePhysicsColliders(inst)

    if inst.components.portablestructure ~= nil then
        inst:RemoveComponent("portablestructure")
    end

end

local function wardrobe_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst:SetPhysicsRadiusOverride(.8)
    MakeObstaclePhysics(inst, inst.physicsradiusoverride)

    inst:AddTag("structure")

    --wardrobe (from wardrobe component) added to pristine state for optimization
    inst:AddTag("wardrobe")

    inst.AnimState:SetBank("portable_wardrobe")
    inst.AnimState:SetBuild("portable_wardrobe")
    inst.AnimState:PlayAnimation("closed")

    inst.MiniMapEntity:SetIcon("portable_wardrobe.png")

    MakeSnowCoveredPristine(inst)
    inst:SetPrefabNameOverride("portable_wardrobe_item")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(OnFinished)
    inst.components.finiteuses:SetMaxUses(TUNING.PORTABLE_TENT_USES)
    inst.components.finiteuses:SetUses(TUNING.PORTABLE_TENT_USES)

    inst:AddComponent("portablestructure")
    inst.components.portablestructure:SetOnDismantleFn(ChangeToItem)

    inst:AddComponent("inspectable")
    inst:AddComponent("wardrobe")
    inst.components.wardrobe:SetChangeInDelay(20 * FRAMES)
    inst.components.wardrobe.onchangeinfn = OnChangeIn
    inst.components.wardrobe.onopenfn = OnOpen
    inst.components.wardrobe.onclosefn = OnClose

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetOnWorkCallback(OnHit)

    MakeLargeBurnable(inst, nil, nil, true)
    inst.components.burnable:SetOnBurntFn(OnBurnt)

    MakeMediumPropagator(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    MakeSnowCovered(inst)
    MakeHauntableWork(inst)

    inst:DoTaskInTime(0, function(inst)
        inst.drawnameoverride = rawget(_G, "EncodeStrCode") and EncodeStrCode({content = "NAMES." .. string.upper(inst.prefab)})
    end)

    return inst
end

return Prefab("portable_wardrobe_wrap", wrap_fn, wrap_assets, wrap_prefabs),
        --
        Prefab("portable_wardrobe", wardrobe_fn, wardrobe_assets, wardrobe_prefabs),
        MakePlacer("portable_wardrobe_item_placer", "portable_wardrobe", "portable_wardrobe", "closed"),
        Prefab("portable_wardrobe_item", wardrobe_item_fn, wardrobe_assets, wardrobe_prefabs_item)

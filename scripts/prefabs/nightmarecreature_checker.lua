local prefabs =
{
    "crawlingnightmare",
    "nightmarebeak"
}

local function get_nearby_dummy(inst)
    if not inst then return end
    for _, v in ipairs(AllPlayers) do
        if inst:GetDistanceSqToInst(v) < 3600 and v.prefab == "dummy" then
            return true
        end
    end
end

local function OnInit(inst)
    SpawnPrefab(get_nearby_dummy(inst) and "nightmarebeak" or "crawlingnightmare").Transform:SetPosition(inst:GetPosition():Get())
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    --[[Non-networked entity]]

    inst:AddTag("CLASSIFIED")

    inst:DoTaskInTime(0, OnInit)

    return inst
end

return Prefab("nightmarecreature_checker", fn, nil, prefabs)

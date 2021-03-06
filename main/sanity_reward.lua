local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local nightmare_prefabs =
{
    "crawlinghorror",
    "terrorbeak",
    "oceanhorror",
    "swimminghorror",   -- IA
}

local function sanity_reward_postinit(inst)
    if not TheWorld.ismastersim then return end

    local on_killed_by_other = inst.components.combat.onkilledbyother
    inst.components.combat.onkilledbyother = function(inst, attacker)
        if attacker and attacker:HasTag("nightmare_twins") and attacker.components.sanity then
            attacker.components.sanity:DoDelta((inst.sanityreward or TUNING.SANITY_SMALL) * 0.5)
        else
            on_killed_by_other(inst, attacker)
        end
    end
end

for _, prefab in ipairs(nightmare_prefabs) do
    AddPrefabPostInit(prefab, sanity_reward_postinit)
end

local function onpickedfn_flower(inst, picker)
    local pos = inst:GetPosition()

    if picker then
        if picker.components.sanity and not picker:HasTag("plantkin") and not picker:HasTag("ns_builder_dummy") then -- changed part from original fn
            picker.components.sanity:DoDelta(TUNING.SANITY_TINY)
        end

        if inst.animname == "rose" and
            picker.components.combat and
            not (picker.components.inventory and picker.components.inventory:EquipHasTag("bramble_resistant")) then
            picker.components.combat:GetAttacked(inst, TUNING.ROSE_DAMAGE)
            picker:PushEvent("thorns")
        end
    end

    if not inst.planted then
        TheWorld:PushEvent("beginregrowth", inst)
    end

    inst:Remove()

    TheWorld:PushEvent("plantkilled", { doer = picker, pos = pos }) --this event is pushed

end

AddPrefabPostInit("flower", function(inst)
    if not TheWorld.ismastersim then return end

    if inst.components.pickable then
        inst.components.pickable.onpickedfn = onpickedfn_flower
    end
end)

local function onpickedfn_evil(inst, picker)
    if picker and picker.components.sanity and not picker:HasTag("ns_builder_dummy") then
        picker.components.sanity:DoDelta(-TUNING.SANITY_TINY)
    end
    inst:Remove()
end

AddPrefabPostInit("flower_evil", function(inst)
    if not TheWorld.ismastersim then return end

    if inst.components.pickable then
        inst.components.pickable.onpickedfn = onpickedfn_evil
    end
end)

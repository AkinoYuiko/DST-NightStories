local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local MUTABLE_TARGETS = {
    goldenaxe       = "moonglassaxe",
    goldenpickaxe   = "moonglasspickaxe",
    hammer          = "moonglasshammer",
    -- goldenmachete   = "moonglassmachete",   -- IA Deluxe Addon
}

local function onmutatefn(inst, target)
    if inst.skinname then
        local target_skins = PREFAB_SKINS[target.prefab]
        if target_skins then
            local skin = target.prefab .. inst.skinname:gsub(inst.prefab, "")
            if table.contains(target_skins, skin) then
                TheSim:ReskinEntity(target.GUID, nil, skin)
            end
        end
    end
end

for base, target in pairs(MUTABLE_TARGETS) do
    AddPrefabPostInit(base, function(inst)
        inst:AddTag("halloweenmoonmutable")
        if not TheWorld.ismastersim then return end
        inst:AddComponent("halloweenmoonmutable")
        inst.components.halloweenmoonmutable:SetPrefabMutated(target)
        inst.components.halloweenmoonmutable:SetOnMutateFn(onmutatefn)
    end)
end

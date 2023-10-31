local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("world", function(inst)
    if inst.ismastersim then
        inst:AddComponent("horrorchainmanager")
    end
end)

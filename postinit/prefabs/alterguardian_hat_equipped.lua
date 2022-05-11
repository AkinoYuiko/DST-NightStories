local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("alterguardian_hat_equipped", function(inst)
    if not TheWorld.ismastersim then return end

    local set_skin = inst.SetSkin
    inst.SetSkin = function(inst, skin_build, ...)
        if GlassicAPI.SkinHandler.IsModSkin(skin_build) then
            inst.AnimState:OverrideSymbol("p4_piece", skin_build, "p4_piece")
        else
            return set_skin(inst, skin_build, ...)
        end
    end
end)

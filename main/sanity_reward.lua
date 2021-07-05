local rewardtable = {
    "miotan",
    "dummy"
}

AddPrefabPostInit("crawlinghorror",function(inst)
	if not GLOBAL.TheWorld.ismastersim then return inst end

	local oldOnKilledByOther = inst.components.combat.onkilledbyother
	inst.components.combat.onkilledbyother = function(inst, attacker)
		if attacker and table.contains(rewardtable, attacker.prefab) and attacker.components.sanity then
        	attacker.components.sanity:DoDelta((inst.sanityreward or TUNING.SANITY_SMALL) * 0.5)
        else
        	oldOnKilledByOther(inst, attacker)
        end
    end
end)

AddPrefabPostInit("terrorbeak",function(inst)
	if not GLOBAL.TheWorld.ismastersim then return inst end

	local oldOnKilledByOther = inst.components.combat.onkilledbyother
	inst.components.combat.onkilledbyother = function(inst, attacker)
		if attacker and table.contains(rewardtable, attacker.prefab) and attacker.components.sanity then
        	attacker.components.sanity:DoDelta((inst.sanityreward or TUNING.SANITY_SMALL) * 0.5)
        else
        	oldOnKilledByOther(inst, attacker)
        end
    end
end)

AddPrefabPostInit("swimminghorror",function(inst)
    if not GLOBAL.TheWorld.ismastersim then return inst end

    local oldOnKilledByOther = inst.components.combat.onkilledbyother
    inst.components.combat.onkilledbyother = function(inst, attacker)
        if attacker and table.contains(rewardtable, attacker.prefab) and attacker.components.sanity then
            attacker.components.sanity:DoDelta((inst.sanityreward or TUNING.SANITY_SMALL) * 0.5)
        else
            oldOnKilledByOther(inst, attacker)
        end
    end
end)
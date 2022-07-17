local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("orangestaff", function(inst)
    if not TheWorld.ismastersim then return end

    local onblink = inst.components.blinkstaff and inst.components.blinkstaff.onblinkfn

    if onblink then
        local FUELTYPE = "nightmarefuel"
        inst.components.blinkstaff.onblinkfn = function(staff, pos, caster)
            if caster and caster.prefab == "miotan" and caster.boosted_task ~= nil then
                local inv = caster.components.inventory
                if inv and inv:Has(FUELTYPE, 1) then
                    inv:ConsumeByName(FUELTYPE,1)
                    return
                end
            end
            onblink(staff, pos, caster)
        end
    end
end)

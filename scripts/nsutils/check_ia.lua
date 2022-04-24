local IA_MODNAMES = {
    "workshop-1467214795",
    "IslandAdventures"
}
local IA_FANCY_NAME = "Island Adventures"

local function IsIA(modname, moddata)
    return table.contains(IA_MODNAMES, modname)
        or moddata.modinfo and moddata.modinfo.name == IA_FANCY_NAME
end

local function HasIA()
    for modname, moddata in pairs(KnownModIndex.savedata.known_mods) do
        if IsIA(modname, moddata) and KnownModIndex:IsModEnabledAny(modname) then
            return true
        end
    end
    return false
end

return HasIA()

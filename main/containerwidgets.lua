GLOBAL.setfenv(1, GLOBAL)
local params = require("containers").params

params.moonlight_shadow = deepcopy(params.slingshot)
params.moonlight_shadow.widget.slotbg = nil
params.moonlight_shadow.excludefromcrafting = false
function params.moonlight_shadow.itemtestfn(container, item, slot)
    return TUNING.MOONLIGHT_SHADOW_BATTERIES[item.prefab]
end

params.nightsword = deepcopy(params.slingshot)
params.nightsword.widget.slotbg = nil
params.nightsword.acceptsstacks = false
function params.nightsword.itemtestfn(container, item, slot)
    return item:HasTag("civicrystal")
end

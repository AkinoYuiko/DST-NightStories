GLOBAL.setfenv(1, GLOBAL)
local params = require("containers").params

params.moonlight_shadow = deepcopy(params.slingshot)
params.moonlight_shadow.widget.slotbg = nil
params.moonlight_shadow.excludefromcrafting = false
function params.moonlight_shadow.itemtestfn(container, item, slot)
    return TUNING.MOONLIGHT_SHADOW.BATTERIES[item.prefab]
end

-- params.moonlight_shadow =
-- {
--     widget =
--     {
--         slotpos = {
--             Vector3(-2, 25, 0),
--         },
--         animbank = "ui_alterguardianhat_1x1",
--         animbuild = "ui_alterguardianhat_1x1",
--         pos = Vector3(0, 20, 0),
--     },
--     usespecificslotsforitems = true,
--     type = "hand_inv",
-- }

params.nightsword = deepcopy(params.slingshot)
params.nightsword.widget.slotbg = nil
params.nightsword.excludefromcrafting = false
params.nightsword.acceptsstacks = false
function params.nightsword.itemtestfn(container, item, slot)
    return item:HasTag("civicrystal")
end

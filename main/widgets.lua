local Vector3 = GLOBAL.Vector3
local containers = require("containers")
local params = containers.params

params.nightsword = 
{
    widget =
    {
        slotpos =
        {
            Vector3(0, 32 + 4, 0),
        },
        animbank = "ui_cookpot_1x2",
        animbuild = "ui_cookpot_1x2",
        pos = Vector3(0, 15, 0),
    },
    usespecificslotsforitems = true,
    acceptsstacks = false,
    type = "hand_inv",
}

function params.nightsword.itemtestfn(container, item, slot)
    return item:HasTag("civigem")
end

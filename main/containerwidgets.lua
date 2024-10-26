GLOBAL.setfenv(1, GLOBAL)

local cooking = require("cooking")
local params = require("containers").params

params.lunarshadow = deepcopy(params.slingshot)
params.lunarshadow.widget.slotbg = nil
params.lunarshadow.excludefromcrafting = false
function params.lunarshadow.itemtestfn(container, item, slot)
	return TUNING.LUNARSHADOW.BATTERIES[item.prefab]
end

params.moonlight_shadow = deepcopy(params.lunarshadow)

params.nightsword = deepcopy(params.slingshot)
params.nightsword.widget.slotbg = nil
params.nightsword.acceptsstacks = false
function params.nightsword.itemtestfn(container, item, slot)
	return item:HasTag("civicrystal")
end

params.cookpackage_container = deepcopy(params.cookpot)
function params.cookpackage_container.itemtestfn(container, item, slot)
	return cooking.IsCookingIngredient(item.prefab)
		or container.finishing_bundling
end
function params.cookpackage_container.widget.buttoninfo.validfn(inst)
	return inst.replica.container and inst.replica.container:IsFull()
end
params.cookpackage_container.widget.buttoninfo.fn = params.bundle_container.widget.buttoninfo.fn
params.cookpackage_container.widget.buttoninfo.text = STRINGS.ACTIONS.COOKPACKAGE
params.cookpackage_container.acceptsstacks = nil

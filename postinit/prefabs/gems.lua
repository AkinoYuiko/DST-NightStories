local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local function add_tag(inst)
	inst:AddTag("nightpackgem")
end

local NIGHTPACK_GEMS = {
	"horrorfuel",
	"nightmarefuel",
	"redgem",
	"bluegem",
	"purplegem",
	"yellowgem",
	"orangegem",
	"greengem",
	"opalpreciousgem",
}
for _, prefab in ipairs(NIGHTPACK_GEMS) do
	AddPrefabPostInit(prefab, add_tag)
end

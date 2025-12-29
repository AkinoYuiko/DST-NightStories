local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local function q1(inst)
	if TheWorld.state.isautumn and TheWorld.state.elapseddaysinseason == 0 then
		inst.components.craftingstation:LearnItem("mossling", "chesspiece_headuck_builder")
	else
		inst.components.craftingstation:ForgetItem("mossling")
	end
end

AddPrefabPostInit("sculptingtable", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	q1(inst)
	inst:WatchWorldState("cycles", q1)
end)

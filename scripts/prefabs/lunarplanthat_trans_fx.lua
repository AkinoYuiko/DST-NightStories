local function lunarplanthat_CreateFxFollowFrame(i)
	local inst = CreateEntity()

	--[[Non-networked entity]]
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddFollower()

	inst:AddTag("FX")

	inst.AnimState:SetBank("lunarplanthat")
	inst.AnimState:SetBuild("lunarplanthat_trans")
	inst.AnimState:PlayAnimation("idle"..tostring(i), true)
	-- inst.AnimState:SetSymbolBloom("glow01")
	inst.AnimState:SetSymbolBloom("float_top")
	-- inst.AnimState:SetSymbolLightOverride("glow01", .5)
	inst.AnimState:SetSymbolLightOverride("float_top", .5)
	inst.AnimState:SetSymbolMultColour("float_top", 1, 1, 1, .6)
	inst.AnimState:SetLightOverride(.1)

	inst:AddComponent("highlightchild")

	inst.persists = false

	return inst
end

--------------------------------------------------------------------------

local function FollowFx_OnRemoveEntity(inst)
	for i, v in ipairs(inst.fx) do
		v:Remove()
	end
end

local function FollowFx_ColourChanged(inst, r, g, b, a)
	for i, v in ipairs(inst.fx) do
		v.AnimState:SetAddColour(r, g, b, a)
	end
end

local function SpawnFollowFxForOwner(inst, owner, createfn, framebegin, frameend, isfullhelm)
	local follow_symbol = isfullhelm and owner:HasTag("player") and owner.AnimState:BuildHasSymbol("headbase_hat") and "headbase_hat" or "swap_hat"
	inst.fx = {}
	local frame
	for i = framebegin, frameend do
		local fx = createfn(i)
		frame = frame or math.random(fx.AnimState:GetCurrentAnimationNumFrames()) - 1
		fx.entity:SetParent(owner.entity)
		fx.Follower:FollowSymbol(owner.GUID, follow_symbol, nil, nil, nil, true, nil, i - 1)
		fx.AnimState:SetFrame(frame)
		fx.components.highlightchild:SetOwner(owner)
		table.insert(inst.fx, fx)
	end
	inst.components.colouraddersync:SetColourChangedFn(FollowFx_ColourChanged)
	inst.OnRemoveEntity = FollowFx_OnRemoveEntity
end

local function MakeFollowFx(name, data)
	local function OnEntityReplicated(inst)
		local owner = inst.entity:GetParent()
		if owner ~= nil then
			SpawnFollowFxForOwner(inst, owner, data.createfn, data.framebegin, data.frameend, data.isfullhelm)
		end
	end

	local function AttachToOwner(inst, owner)
		inst.entity:SetParent(owner.entity)
		if owner.components.colouradder ~= nil then
			owner.components.colouradder:AttachChild(inst)
		end
		--Dedicated server does not need to spawn the local fx
		if not TheNet:IsDedicated() then
			SpawnFollowFxForOwner(inst, owner, data.createfn, data.framebegin, data.frameend, data.isfullhelm)
		end
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddNetwork()

		inst:AddTag("FX")

		inst:AddComponent("colouraddersync")

		if data.common_postinit ~= nil then
			data.common_postinit(inst)
		end

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			inst.OnEntityReplicated = OnEntityReplicated

			return inst
		end

		inst.AttachToOwner = AttachToOwner
		inst.persists = false

		if data.master_postinit ~= nil then
			data.master_postinit(inst)
		end

		return inst
	end

	return Prefab(name, fn, data.assets, data.prefabs)
end

--------------------------------------------------------------------------

return MakeFollowFx("lunarplanthat_trans_fx", {
		createfn = lunarplanthat_CreateFxFollowFrame,
		framebegin = 1,
		frameend = 3,
		isfullhelm = true,
		assets = {},
	})

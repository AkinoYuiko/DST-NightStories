local assets =
{
	Asset("DYNAMIC_ANIM", "anim/dynamic/lantern_mio.zip"),
	Asset("PKGREF", "anim/dynamic/lantern_mio.dyn"),
}

local function KillFX(inst)
	if inst:GetTimeAlive() > 0 then
		inst.killed = true
	else
		inst:Remove()
	end
end

local function IsMovingStep(step)
	return step ~= 0 and step ~= 3
end

local function OnFireflyAnimOver(inst)
	if inst.fireflyemitter:IsValid() then
		if IsMovingStep(inst.step) then
			if inst.fireflyemitter.ismoving then
				inst:Show()
			else
				inst:Hide()
			end
		end
		inst.Transform:SetPosition(inst.fireflyemitter.Transform:GetWorldPosition())
		inst.AnimState:PlayAnimation(inst.anim)
	else
		inst:Remove()
	end
end

local function CreateFirefly(fireflyemitter, variation, step)
	local inst = CreateEntity()

	inst:AddTag("FX")
	--[[Non-networked entity]]
	inst.entity:SetCanSleep(false)
	inst.persists = false

	inst.entity:AddTransform()
	inst.entity:AddAnimState()

	inst.AnimState:SetBank("lantern_mio_fx")
	inst.AnimState:SetBuild("lantern")
	-- inst.AnimState:OverrideItemSkinSymbol("firefly", "lantern_mio", "firefly", 0, "lantern")
	inst.AnimState:OverrideSymbol("firefly", "lantern_mio", "firefly")
	inst.AnimState:SetFinalOffset(1)

	inst.fireflyemitter = fireflyemitter
	inst.anim = "fireflyfall"..tostring(variation)
	inst.step = step
	inst:ListenForEvent("animover", OnFireflyAnimOver)
	OnFireflyAnimOver(inst)

	return inst
end

local function CheckMoving(inst)
	local parent = inst.entity:GetParent()
	if parent ~= nil then
		local newpos = parent:GetPosition()
		inst.ismoving = inst.prevpos ~= nil and inst.prevpos ~= newpos
		inst.prevpos = newpos
	else
		inst.ismoving = false
	end
end

local function heldfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddNetwork()

	inst:AddTag("FX")

	--Dedicated server does not need to spawn the local fx
	if not TheNet:IsDedicated() then
		for i = 0, 5 do
			local delay = i * 86 / 6 * FRAMES
			inst:DoTaskInTime(delay + 1 * FRAMES, CreateFirefly, 1, i)
			inst:DoTaskInTime(delay + 7 * FRAMES, CreateFirefly, 2, i)
			inst:DoTaskInTime(delay + 13 * FRAMES, CreateFirefly, 3, i)
			inst:DoTaskInTime(delay + 30 * FRAMES, CreateFirefly, 4, i)
			inst:DoTaskInTime(delay + 41 * FRAMES, CreateFirefly, 5, i)
			inst:DoTaskInTime(delay + 58 * FRAMES, CreateFirefly, 6, i)
			inst:DoTaskInTime(delay + 67 * FRAMES, CreateFirefly, 7, i)
		end
		inst.ismoving = false
		inst:DoPeriodicTask(0, CheckMoving)
	end

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	return inst
end

local function OnGroundAnimOver(inst)
	if not inst.killed then
		if not inst.AnimState:IsCurrentAnimation("firefly_pre") then
			inst.AnimState:Show("hidepre")
		end
		inst.AnimState:PlayAnimation("firefly_loop")
	elseif inst.AnimState:IsCurrentAnimation("firefly_pst") then
		inst:Remove()
	else
		inst.AnimState:PlayAnimation("firefly_pst")
	end
end

local function groundfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst:AddTag("FX")

	inst.AnimState:SetBank("lantern_mio_fx")
	inst.AnimState:SetBuild("lantern")
	inst.AnimState:Hide("hidepre")
	inst.AnimState:PlayAnimation("firefly_pre")
	inst.AnimState:SetFinalOffset(1)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	if POPULATING then
		inst.AnimState:PlayAnimation("firefly_loop")
		inst.AnimState:SetTime(math.random() * (inst.AnimState:GetCurrentAnimationLength() - FRAMES))
	end

	inst:ListenForEvent("animover", OnGroundAnimOver)
	inst.KillFX = KillFX

	return inst
end

return Prefab("lantern_mio_fx_held", heldfn, assets),
	Prefab("lantern_mio_fx_ground", groundfn, assets)

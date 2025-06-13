local Utils = require "ns_utils"

-------------------------------------------------------------------------
-------------------------- moonlight functions --------------------------
-------------------------------------------------------------------------

local target_testfn = Utils.TargetTestFn
local owner_testfn = Utils.OwnerTestFn
local launching_projectile = Utils.LaunchingProjectile
local do_glash_attack = Utils.DoGlashAttack

local function onattackother(owner, data)
	local target = data and data.target
	local weapon = data and data.weapon
	local projectile = data and data.projectile
	if weapon and weapon.prefab == "glash" then
		return
	elseif projectile and projectile.prefab == "glash" then
		return
	end
	if owner_testfn(owner) and target and target ~= owner and target_testfn(target) then
		-- In combat, this is when we're just launching a projectile, so don't spawn yet
		if launching_projectile(data) then return end
		do_glash_attack(owner, target)
	end
end

local function attack_attach(inst, target)
	if target.components.combat then
		inst:ListenForEvent("onattackother", onattackother, target)
	end
end

local function attack_detach(inst, target)
	inst:RemoveEventCallback("onattackother", onattackother, target)
end

-------------------------------------------------------------------------
----------------------- Prefab building functions -----------------------
-------------------------------------------------------------------------

local function OnTimerDone(inst, data)
	if data.name == "buffover" then
		inst.components.debuff:Stop()
	end
end

local function MakeBuff(name, onattachedfn, onextendedfn, ondetachedfn, duration, priority, prefabs)
	local function OnAttached(inst, target)
		inst.entity:SetParent(target.entity)
		inst.Transform:SetPosition(0, 0, 0) --in case of loading
		inst:ListenForEvent("death", function()
			inst.components.debuff:Stop()
		end, target)

		target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_BUFF_"..string.upper(name), priority = priority })
		if onattachedfn ~= nil then
			onattachedfn(inst, target)
		end
	end

	local function OnExtended(inst, target)
		inst.components.timer:StopTimer("buffover")
		inst.components.timer:StartTimer("buffover", duration)

		target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_BUFF_"..string.upper(name), priority = priority })
		if onextendedfn ~= nil then
			onextendedfn(inst, target)
		end
	end

	local function OnDetached(inst, target)
		if ondetachedfn ~= nil then
			ondetachedfn(inst, target)
		end

		target:PushEvent("foodbuffdetached", { buff = "ANNOUNCE_DETACH_BUFF_"..string.upper(name), priority = priority })
		inst:Remove()
	end

	local function fn()
		local inst = CreateEntity()

		if not TheWorld.ismastersim then
			-- Not meant for client!
			inst:DoTaskInTime(0, inst.Remove)
			return inst
		end

		inst.entity:AddTransform()

		--[[Non-networked entity]]
		--inst.entity:SetCanSleep(false)
		inst.entity:Hide()
		inst.persists = false

		inst:AddTag("CLASSIFIED")

		inst:AddComponent("debuff")
		inst.components.debuff:SetAttachedFn(OnAttached)
		inst.components.debuff:SetDetachedFn(OnDetached)
		inst.components.debuff:SetExtendedFn(OnExtended)
		inst.components.debuff.keepondespawn = true

		inst:AddComponent("timer")
		inst.components.timer:StartTimer("buffover", duration)
		inst:ListenForEvent("timerdone", OnTimerDone)

		return inst
	end

	return Prefab("buff_"..name, fn, nil, prefabs)
end

return MakeBuff("moonglass", attack_attach, nil, attack_detach, TUNING.BUFF_MOONGLASS_DURATION, 1)

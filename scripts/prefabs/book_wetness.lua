local assets = {
	Asset("ANIM", "anim/book_wetness.zip"),
}

local prefabs = {
	"splash_ocean",
	"book_fx",
}

local BOOK_WETNESS_RANGE = 64 * 1.2 -- this is our "outer" sleep radius
local MAX_WETNESS = 100 -- same as MAX_WETNESS in weather.lua :angri: :ducky_smile_dyn:

local book_defs = {
	{
		name = "book_wetness",
		uses = TUNING.BOOK_USES_SMALL,
		read_sanity = -TUNING.SANITY_HUGE,
		peruse_sanity = TUNING.SANITY_LARGE,
		deps = { "fx_book_temperature", "fx_book_temperature_mount", "fx_book_rain", "fx_book_rain_mount" },
		-- fx = "fx_book_rain",
		fn = function(inst, reader)
			local should_dry
			if TheWorld.state.iswet then
				should_dry = true
				TheWorld:PushEvent("ms_deltawetness", -MAX_WETNESS)
			else
				should_dry = false
				TheWorld:PushEvent("ms_deltawetness", MAX_WETNESS)
			end
			local x, _, z = inst.Transform:GetWorldPosition()
			for _, ent in ipairs(TheSim:FindEntities(x, 0, z, BOOK_WETNESS_RANGE)) do
				if ent.components.moisture then
					if should_dry then
						ent.components.moisture:SetPercent(0)
						local fx = SpawnPrefab(ent.components.rider and ent.components.rider:IsRiding() and "fx_book_temperature_mount" or "fx_book_temperature")
						fx.Transform:SetPosition(ent.Transform:GetWorldPosition())
						fx.Transform:SetRotation(ent.Transform:GetRotation())
					else
						ent.components.moisture:SetPercent(1)
						local fx = SpawnPrefab(ent.components.rider and ent.components.rider:IsRiding() and "fx_book_rain_mount" or "fx_book_rain")
						fx.Transform:SetPosition(ent.Transform:GetWorldPosition())
						fx.Transform:SetRotation(ent.Transform:GetRotation())
					end
				elseif ent.components.inventoryitemmoisture then
					if should_dry then
						ent.components.inventoryitemmoisture:SetMoisture(0)
					else
						ent.components.inventoryitemmoisture:SetMoisture(MAX_WETNESS)
					end
				end
			end
			return true
		end,
		perusefn = function(inst, reader)
			if reader.peruse_wetness then
				reader.peruse_wetness(reader)
			end
			reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK", "BOOK_WETNESS"))
			return true
		end,
	},
}

local function MakeBook(def)
	local prefabs
	if def.deps ~= nil then
		prefabs = {}
		for i, v in ipairs(def.deps) do
			table.insert(prefabs, v)
		end
	end
	if def.fx ~= nil then
		prefabs = prefabs or {}
		table.insert(prefabs, def.fx)
	end
	if def.fxmount ~= nil then
		prefabs = prefabs or {}
		table.insert(prefabs, def.fxmount)
	end
	if def.fx_over ~= nil then
		prefabs = prefabs or {}
		local fx_over_prefab = "fx_" .. def.fx_over .. "_over_book"
		table.insert(prefabs, fx_over_prefab)
		table.insert(prefabs, fx_over_prefab .. "_mount")
	end
	if def.fx_under ~= nil then
		prefabs = prefabs or {}
		local fx_under_prefab = "fx_" .. def.fx_under .. "_under_book"
		table.insert(prefabs, fx_under_prefab)
		table.insert(prefabs, fx_under_prefab .. "_mount")
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank("book_wetness")
		inst.AnimState:SetBuild("book_wetness")
		inst.AnimState:PlayAnimation(def.name)

		MakeInventoryFloatable(inst, "med", nil, 0.75)

		inst:AddTag("book")
		inst:AddTag("bookcabinet_item")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		-----------------------------------

		inst.def = def
		inst.swap_build = "book_wetness"
		inst.swap_prefix = def.name

		inst:AddComponent("inspectable")
		inst:AddComponent("book")
		inst.components.book:SetOnRead(def.fn)
		inst.components.book:SetOnPeruse(def.perusefn)
		inst.components.book:SetReadSanity(def.read_sanity)
		inst.components.book:SetPeruseSanity(def.peruse_sanity)
		inst.components.book:SetFx(def.fx, def.fxmount)

		inst:AddComponent("inventoryitem")

		inst:AddComponent("finiteuses")
		inst.components.finiteuses:SetMaxUses(def.uses)
		inst.components.finiteuses:SetUses(def.uses)
		inst.components.finiteuses:SetOnFinished(inst.Remove)

		inst:AddComponent("fuel")
		inst.components.fuel.fuelvalue = TUNING.MED_FUEL

		MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
		MakeSmallPropagator(inst)

		MakeHauntableLaunch(inst)

		-- inst:DoTaskInTime(0, function(inst)
		--	 inst.drawnameoverride = rawget(_G, "EncodeStrCode") and EncodeStrCode({content = "NAMES." .. string.upper(inst.prefab)})
		-- end)
		if rawget(_G, "EncodeDrawNameCode") then
			EncodeDrawNameCode(inst)
		end

		return inst
	end

	return Prefab(def.name, fn, assets, prefabs)
end

local books = {}
for i, v in ipairs(book_defs) do
	table.insert(books, MakeBook(v))
	if v.fx_over ~= nil then
		v.fx_over_prefab = "fx_" .. v.fx_over .. "_over_book"
	end
	if v.fx_under ~= nil then
		v.fx_under_prefab = "fx_" .. v.fx_under .. "_under_book"
	end
end
book_defs = nil

return unpack(books)

GLOBAL.setfenv(1, GLOBAL)
-- Civi
if not rawget(_G, "armorskeleton_clear_fn") then
    armorskeleton_init_fn = function(inst, build)
        
        local function onequipfn(inst, data)
            data.owner.AnimState:ClearOverrideSymbol("swap_body")
        end


        if not TheWorld.ismastersim then return end

        inst.skinname = build
        inst.AnimState:SetBuild(build)
        if inst.components.inventoryitem then 
            inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
        end

        inst:ListenForEvent("equipped", onequipfn)
        inst.OnSkinChange = function(inst) 
            inst:RemoveEventCallback("equipped", onequipfn)
        end
    end
    armorskeleton_clear_fn = function(inst)
        inst.AnimState:SetBuild("armor_skeleton")
        if not TheWorld.ismastersim then return end
    	inst.components.inventoryitem:ChangeImageName()
    end
end

if not rawget(_G, "skeletonhat_clear_fn") then
	skeletonhat_init_fn = function(inst, build)

		local function onequipfn(inst, data)
			data.owner.AnimState:OverrideSymbol("swap_hat", build, "swap_hat")
		--	data.owner.AnimState:ClearOverrideSymbol("swap_body")
		end
		
		if not TheWorld.ismastersim then return end

		inst.skinname = build
		inst.AnimState:SetBuild(build)
		if inst.components.inventoryitem then
			inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
		end

		inst:ListenForEvent("equipped", onequipfn)
		inst.OnSkinChange = function(isnt)
			inst:RemoveEventCallback("equipped", onequipfn)
		end
	end

	skeletonhat_clear_fn = function(inst)
		inst.AnimState:SetBuild("hat_skeleton")
		if not TheWorld.ismastersim then return end
		inst.components.inventoryitem:ChangeImageName()
	end
end

-- Mio
-- fix lantern reskin in inventory
local old_lantern_clear_fn = lantern_clear_fn
lantern_clear_fn = function(inst, ...)
    local rt_lantern_clear = {old_lantern_clear_fn(inst, ...)}
    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName()
    end
    return unpack(rt_lantern_clear)
end

local old_lantern_init_fn = lantern_init_fn
lantern_init_fn = function(inst, ...)
    local rt_lantern_init = {old_lantern_init_fn(inst, ...)}
    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
    end
    return unpack(rt_lantern_init)
end

-- nightstick 
if not rawget(_G, "nightstick_clear_fn") then
    nightstick_init_fn = function(inst, skinname, override_build)
		GlassicAPI.SetFloatData(inst, { sym_build = override_build or skinname, sym_name = "swap_nightstick" })
        GlassicAPI.BasicInitFn(inst, skinname, override_build or skinname, override_build or skinname)
        GlassicAPI.BasicOnequipFn(inst, "hand", override_build or skinname, "swap_nightstick")
    end
    nightstick_clear_fn = function(inst)
		GlassicAPI.SetFloatData(inst, { sym_build = "swap_nightstick"})
		basic_clear_fn(inst, "nightstick")
	end
end

-- yellowamulet 
if not rawget(_G, "yellowamulet_clear_fn") then
    yellowamulet_init_fn = function(inst, skinname, override_build)
        GlassicAPI.BasicInitFn(inst, skinname, override_build or skinname, override_build or skinname)
        GlassicAPI.BasicOnequipFn(inst, "body", override_build or skinname)
    end
    yellowamulet_clear_fn = function(inst) basic_clear_fn(inst, "amulets") end
end

-- lantern_mio
lantern_mio_init_fn = function(inst, build)
    local function onequipfn(inst, data)
        local owner = data.owner
        owner.AnimState:OverrideSymbol("swap_object", "swap_"..build, "swap_lantern")
        owner.AnimState:OverrideSymbol("lantern_overlay", "swap_"..build, "lantern_overlay")
    end
    
    local function lantern_on(inst)
        if inst._light then
            inst._light.Light:SetColour(195 / 255, 190 / 255, 120 / 255)
        end
    end
    
    if not TheWorld.ismastersim then return end

    inst.skinname = build
    inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
    -- inst.components.inventoryitem.atlasname = GetInventoryItemAtlas(inst:GetSkinName())
    inst.AnimState:SetBank(build)
    inst.AnimState:SetBuild(build)

    inst:ListenForEvent("equipped", onequipfn)
    inst:ListenForEvent("stoprowing",onequipfn) -- IA compatible after stopping rowing.
    inst:ListenForEvent("lantern_on", lantern_on)

    inst.OnSkinChange = function(inst)
        inst:RemoveEventCallback("equipped", onequipfn)
        inst:RemoveEventCallback("stoprowing", onequipfn) -- IA compatible after stopping rowing.
        inst:RemoveEventCallback("lantern_on", lantern_on)
    end
end

-- Dummy

-- Green Amulet
if not rawget(_G, "greenamulet_clear_fn") then
    greenamulet_init_fn = function(inst, skinname, override_build)
        GlassicAPI.BasicInitFn(inst, skinname, override_build or skinname, override_build or skinname)
        GlassicAPI.BasicOnequipFn(inst, "body", override_build or skinname)
    end
    greenamulet_clear_fn = function(inst) basic_clear_fn(inst, "amulets") end
end

-- Raincoat
if not rawget(_G, "raincoat_clear_fn") then
    raincoat_init_fn = function(inst, skinname, override_build)
        GlassicAPI.BasicInitFn(inst, skinname, override_build or skinname, override_build or skinname)
        GlassicAPI.BasicOnequipFn(inst, "body", override_build or skinname)
    end
    raincoat_clear_fn = function(inst)
        inst.AnimState:SetBuild("torso_rain")
        if not TheWorld.ismastersim then return end
        inst.components.inventoryitem:ChangeImageName()
    end
end

-- Meat Rack --
local _meatrack_clear_fn = meatrack_clear_fn
meatrack_clear_fn = function(inst)
    inst.AnimState:SetBank("meat_rack")
    return _meatrack_clear_fn(inst)
end

GlassicAPI.SkinHandler.AddModSkins({
    -- Civi
    civi = { 
        is_char = true,
        "civi_none"
    },
    armorskeleton = {
        { name = "armorskeleton_none", test_fn = GlassicAPI.SetExclusiveToPlayer("civi") },
    },
	skeletonhat = {
		{ name = "skeletonhat_glass", test_fn = GlassicAPI.SetExclusiveToPlayer("civi") },
	},
    -- Mio
    miotan = {
        is_char = true,
        "miotan_none",
        "miotan_classic"
    },
    nightstick = {
        { name = "nightstick_crystal", test_fn = GlassicAPI.SetExclusiveToPlayer("miotan") }
    },
    yellowamulet = {
        { name = "yellowamulet_heart", test_fn = GlassicAPI.SetExclusiveToPlayer("miotan") }
    },
    -- Dummy
    dummy = {
        is_char = true,
        "dummy_none"
    },
    greenamulet = {
        { name = "greenamulet_heart", test_fn = GlassicAPI.SetExclusiveToPlayer("dummy") }
    },
    raincoat = { 
        {name = "raincoat_peggy", test_fn = GlassicAPI.SetExclusiveToPlayer("dummy") }
    },
    dragonflychest = { "dragonflychest_gingerbread" },
    meatrack = { "meatrack_rice" },
})

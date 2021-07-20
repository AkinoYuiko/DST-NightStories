local assets =
{
    Asset("ANIM", "anim/dummy_books.zip"),
    Asset("ANIM", "anim/swap_book_harvest.zip"),
    Asset("ANIM", "anim/swap_book_toggledownfall.zip"),
    
}

local prefabs =
{
    "splash_ocean",
    "book_fx",
}

local UpvalueHacker = require("upvaluehacker")

local book_defs =
{
    {
        name = "book_toggledownfall",
        uses = 3,
        fn = function(inst, reader)
            reader.components.sanity:DoDelta(-50)
            local weather_cmp = TheWorld:HasTag("cave") and TheWorld.net.components.caveweather or TheWorld.net.components.weather
            if TheWorld.state.islandisraining or TheWorld.state.israining or TheWorld.state.issnowing then
                TheWorld:PushEvent("ms_forceprecipitation_island", false)
                TheWorld:PushEvent("ms_forceprecipitation", false)
                local _moistureceil = UpvalueHacker.GetUpvalue(weather_cmp.OnUpdate, "_moistureceil") or UpvalueHacker.GetUpvalue(weather_cmp.OnUpdate, "_moistureceil_island")
                local old_val = _moistureceil:value()
                weather_cmp:OnUpdate(0)
                _moistureceil:set(old_val)
            else
                TheWorld:PushEvent("ms_forceprecipitation_island", true)
                TheWorld:PushEvent("ms_forceprecipitation", true)
                weather_cmp:OnUpdate(0)
                local _moisture = UpvalueHacker.GetUpvalue(weather_cmp.OnUpdate, "_moisture") or UpvalueHacker.GetUpvalue(weather_cmp.OnUpdate, "_moisture_island")
                local _moisturefloormultiplier = UpvalueHacker.GetUpvalue(weather_cmp.OnSave, "_moisturefloormultiplier")
                local _moisturefloor = UpvalueHacker.GetUpvalue(weather_cmp.OnUpdate, "_moisturefloor") or UpvalueHacker.GetUpvalue(weather_cmp.OnUpdate, "_moisturefloor_island")
                _moisturefloor:set(0.25 * _moisture:value() * _moisturefloormultiplier)
            end
            return true
        end
    },

    {
        name = "book_harvest",
        uses = 5,
        fn = function(inst, reader)
            reader.components.sanity:DoDelta(-40)
            local pos = Vector3(inst.Transform:GetWorldPosition())
            local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 30)
            for k,v in pairs(ents) do
                if v.components.pickable and not
                (v.prefab == "flower" or
                 v.prefab == "flower_evil" or
                 v.prefab == "gemsocket" or
                 v.prefab == "nightmare_gemlight") then
                    v.components.pickable:Pick(reader)
                end
                if v.components.crop then v.components.crop:Harvest(reader) end
                -- 针对蜂箱、藤壶和肉架 --
                if v.prefab == "beebox"
                  or v.prefab == "waterplant_baby"
                  or v.prefab == "waterplant"
                  then
                    if v.components.harvestable then v.components.harvestable:Harvest(reader) end
                end
                if v.prefab == "meatrack" then
                    if v.components.dryer then v.components.dryer:Harvest(reader) end
                end
            end
            return true
        end
    },
}

local function MakeBook(def)

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("dummy_books")
        inst.AnimState:SetBuild("dummy_books")
        inst.AnimState:PlayAnimation(def.name)

        MakeInventoryFloatable(inst, "med", nil, 0.75)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        -----------------------------------
        inst.skinname = def.name -- reading-book animation

        inst:AddComponent("inspectable")
        inst:AddComponent("book")
        inst.components.book.onread = def.fn

        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem.imagename = def.name
        -- inst.components.inventoryitem.atlasname = resolvefilepath("images/inventoryimages/"..def.name..".xml")

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(def.uses)
        inst.components.finiteuses:SetUses(def.uses)
        inst.components.finiteuses:SetOnFinished(inst.Remove)

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.MED_FUEL

        MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
        MakeSmallPropagator(inst)

        --MakeHauntableLaunchOrChangePrefab(inst, TUNING.HAUNT_CHANCE_OFTEN, TUNING.HAUNT_CHANCE_OCCASIONAL, nil, nil, morphlist)
        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(def.name, fn, assets, prefabs)
end

local books = {}
for i, v in ipairs(book_defs) do
    table.insert(books, MakeBook(v))
end
book_defs = nil

return unpack(books)

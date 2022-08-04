local assets =
{
    Asset("ANIM", "anim/dummy_books.zip"),
    Asset("ANIM", "anim/swap_book_harvest.zip"),
    Asset("ANIM", "anim/swap_book_toggledownfall.zip"),
    Asset("ANIM", "anim/swap_dummy_books.zip"),

}

local prefabs =
{
    "splash_ocean",
    "book_fx",
}

local UpvalueUtil = GlassicAPI.UpvalueUtil

local book_defs =
{
    {
        name = "book_toggledownfall",
        uses = TUNING.BOOK_USES_SMALL,
        read_sanity = -TUNING.SANITY_HUGE,
        peruse_sanity = -TUNING.SANITY_HUGE,
        fx = "fx_book_rain",
        layer = "",
        fn = function(inst, reader)
            local weather_cmp = TheWorld:HasTag("cave") and TheWorld.net.components.caveweather or TheWorld.net.components.weather
            if TheWorld.state.precipitation ~= "none" then
                TheWorld:PushEvent("ms_forceprecipitation_island", false)
                TheWorld:PushEvent("ms_forceprecipitation", false)
                local _moistureceil = UpvalueUtil.GetUpvalue(weather_cmp.OnUpdate, "_moistureceil") or UpvalueUtil.GetUpvalue(weather_cmp.OnUpdate, "_moistureceil_island")
                local old_val = _moistureceil:value()
                weather_cmp:OnUpdate(0)
                _moistureceil:set(old_val)
            else
                TheWorld:PushEvent("ms_forceprecipitation_island", true)
                TheWorld:PushEvent("ms_forceprecipitation", true)
                weather_cmp:OnUpdate(0)
                local _moisture = UpvalueUtil.GetUpvalue(weather_cmp.OnUpdate, "_moisture") or UpvalueUtil.GetUpvalue(weather_cmp.OnUpdate, "_moisture_island")
                local _moisturefloormultiplier = UpvalueUtil.GetUpvalue(weather_cmp.OnSave, "_moisturefloormultiplier")
                local _moisturefloor = UpvalueUtil.GetUpvalue(weather_cmp.OnUpdate, "_moisturefloor") or UpvalueUtil.GetUpvalue(weather_cmp.OnUpdate, "_moisturefloor_island")
                _moisturefloor:set(0.25 * _moisture:value() * _moisturefloormultiplier)
            end
            return true
        end,
        perusefn = function(inst,reader)
            if reader.peruse_toggledownfall then
                reader.peruse_toggledownfall(reader)
            end
            reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK","BOOK_TOGGLEDOWNFALL"))
            return true
        end,
    },

    {
        name = "book_harvest",
        uses = TUNING.BOOK_USES_LARGE,
        read_sanity = -TUNING.SANITY_LARGER,
        peruse_sanity = -TUNING.SANITY_HUGE,
        layer = "",
        layer_sound = { frame = 30, sound = "wickerbottom_rework/book_spells/upgraded_horticulture" },
        fn = function(inst, reader)
            local success
            local pos = Vector3(inst.Transform:GetWorldPosition())
            local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 30)
            local NO_PICK_DEFS = {
                "flower",
                "flower_evil",
                "gemsocket",
            }
            local HARVESTABLE_DEFS = {
                "beebox",
                "waterplant_baby",
                "waterplant",
            }
            for k,v in pairs(ents) do

                if v.components.pickable and not table.contains(NO_PICK_DEFS, v.prefab) then
                    if v.components.pickable:Pick(reader) then
                        success = true
                    end
                end

                if v.components.crop then
                    if v.components.crop:Harvest(reader) then
                        success = true
                    end
                end

                if v.components.harvestable and table.contains(HARVESTABLE_DEFS, v.prefab) then
                    if v.components.harvestable:Harvest(reader) then
                        success = true
                    end
                end

                if v.components.dryer and v.prefab == "meatrack" then
                    if v.components.dryer:Harvest(reader) then
                        success = true
                    end
                end
            end
            return success, "NOHARVESTABLE"
        end,
        perusefn = function(inst,reader)
            if reader.peruse_harvest then
                reader.peruse_harvest(reader)
            end
            reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK","BOOK_HARVEST"))
            return true
        end,
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

        inst:AddTag("book")
        inst:AddTag("bookcabinet_item")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        -----------------------------------

        inst:AddComponent("inspectable")
        inst:AddComponent("book")
        if inst.components.book.SetOnRead ~= nil then
            inst.components.book:SetOnRead(def.fn)
            inst.components.book:SetReadSanity(def.read_sanity)
            inst.components.book:SetOnPeruse(def.perusefn)
            inst.components.book:SetPeruseSanity(def.peruse_sanity)
            inst.components.book:SetFx(def.fx)

            inst.def = def
            inst.swap_build = "swap_dummy_books"
            inst.swap_prefix = def.name
        else
            inst.skinname = def.name -- reading-book animation
            inst.components.book.onread = def.fn
        end

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

        inst:DoTaskInTime(0, function(inst)
            inst.drawnameoverride = rawget(_G, "EncodeStrCode") and EncodeStrCode({content = "NAMES." .. string.upper(inst.prefab)})
        end)

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

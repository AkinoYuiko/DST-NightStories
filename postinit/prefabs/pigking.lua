local AddPrefabPostInit = AddPrefabPostInit
local UpvalueUtil = GlassicAPI.UpvalueUtil
GLOBAL.setfenv(1, GLOBAL)

local function get_reward(giver)
    if giver.prefab == "miotan" then
        return "nightmarefuel", 2
    elseif TheWorld.components.riftspawner:IsLunarPortalActive() then
        local rifts = TheWorld.components.riftspawner:GetRiftsOfPrefab("lunarrift_portal")
        for _, rift in ipairs(rifts) do
            if rift._stage == TUNING.RIFT_LUNAR1_MAXSTAGE then
                return "moonglass_charged", 1
            end
        end
        return "moonglass", 1
    elseif TheWorld.state.isalterawake then
        return "moonglass", 1
    end
    return "goldnugget"
end

local function launchitem(item, angle)
    -- copied from pigking.lua --
    local speed = math.random() * 4 + 2
    angle = (angle + math.random() * 60 - 30) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end

local function ontradeforitem(inst, item, giver, ...)
    -- copied from pigking.lua --
    AwardPlayerAchievement("pigking_trader", giver)

    local x, y, z = inst.Transform:GetWorldPosition()
    y = 4.5

    local angle
    if giver ~= nil and giver:IsValid() then
        angle = 180 - giver:GetAngleToPoint(x, 0, z)
    else
        local down = TheCamera:GetDownVec()
        angle = math.atan2(down.z, down.x) / DEGREES
        giver = nil
    end

    -- CHANGED PART --
    local reward, max_amount = get_reward(giver)
    local amount = math.min(max_amount or 9999, item.components.tradable.goldvalue) * (item.components.stackable and item.components.stackable.stacksize or 1)
    for k = 1, amount do
        local nug = SpawnPrefab(reward)
        nug.Transform:SetPosition(x, y, z)
        launchitem(nug, angle)
    end
    -- end --

    if item.components.tradable.tradefor ~= nil then
        for _, v in pairs(item.components.tradable.tradefor) do
            local item = SpawnPrefab(v)
            if item ~= nil then
                item.Transform:SetPosition(x, y, z)
                launchitem(item, angle)
            end
        end
    end

    if IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) then
        -- pick out up to 3 types of candies to throw out
        local candytypes = { math.random(NUM_HALLOWEENCANDY), math.random(NUM_HALLOWEENCANDY), math.random(NUM_HALLOWEENCANDY) }
        local numcandies = (item.components.tradable.halloweencandyvalue or 1) + math.random(2) + 2

        -- only people in costumes get a good amount of candy!
        if giver ~= nil and giver.components.skinner ~= nil then
            for _, item in pairs(giver.components.skinner:GetClothing()) do
                if DoesItemHaveTag(item, "COSTUME") or DoesItemHaveTag(item, "HALLOWED") then
                    numcandies = numcandies + math.random(4) + 2
                    break
                end
            end
        end

        for k = 1, numcandies do
            local candy = SpawnPrefab("halloweencandy_"..GetRandomItem(candytypes))
            candy.Transform:SetPosition(x, y, z)
            launchitem(candy, angle)
        end
    end
end

AddPrefabPostInit("pigking", function(inst)
    if not TheWorld.ismastersim then return end
    UpvalueUtil.SetUpvalue(inst.components.trader.onaccept, "ontradeforgold", ontradeforitem)
end)

local function get_rate_from_table(t)
    local rate = 0
    local time = GetTime() - 1

    local j = 1
    for i = 1, #t do
        local val = t[i]
        if val.time < time then
            t[i] = nil
        else
            rate = rate + val.amount
            if i ~= j then
                t[j] = val
                t[i] = nil
            end
            j = j + 1
        end
    end

    return rate
end

local function table_insert_rate(t, amount)
    t[#t + 1] = {amount = amount, time = GetTime()}
end

return {
    GetRateFromTable = get_rate_from_table,
    TableInsertRate = table_insert_rate
}

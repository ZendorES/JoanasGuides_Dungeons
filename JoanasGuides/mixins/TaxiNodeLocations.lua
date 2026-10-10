--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local columns = {
    y = 1,
    x = 2,
    continentID = 3,
    flags = 4
}

TaxiNodeLocationsMetatable = {
    __index = function(t, k)
        if (type(k) == "number") then
            return rawget(t, k)
        end
        return rawget(t, columns[k] or 0)
    end
}

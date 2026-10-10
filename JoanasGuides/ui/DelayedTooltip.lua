--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("DelayedTooltip")

DelayedTooltip = { }

local lastID = 0
local tooltips = { }

function component.Init()
    tooltips[GuideTooltip] = true
end

function DelayedTooltip.Cancel(tooltipID)
    if (lastID == tooltipID) then
        lastID = lastID + 1
    end
end

function DelayedTooltip.Show(delay, callback, ...)
    local newID = lastID + 1
    lastID = newID
    local args = { ... }
    C_Timer.NewTimer(delay, function()
        if (lastID == newID) then
            for tooltip in pairs(tooltips) do
                tooltip:Hide()
            end
            callback(unpack(args))
        end
    end)
    return lastID
end

function DelayedTooltip.AddTooltip(tooltip)
    tooltips[tooltip] = true
end

UI.Add(component)
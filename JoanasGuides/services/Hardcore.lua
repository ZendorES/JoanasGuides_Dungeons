--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local isHardcoreServer = C_Seasons and (C_Seasons.GetActiveSeason() == Enum.SeasonID.Hardcore or C_Seasons.GetActiveSeason() == Enum.SeasonID.FreshHardcore)

HardcoreService = { }

function HardcoreService.IsHardcoreServer()
    return isHardcoreServer
end

function HardcoreService.IsHardcoreEnabled()
    if (isHardcoreServer) then
        return true
    end
    return State.IsHardcoreEnabled()
end

function HardcoreService.SetHardcoreEnabled(enabled)
    if (isHardcoreServer) then return end
    State.SetHardcoreEnabled(enabled)
    MarkAllDirty()
    if (enabled) then
        local willPlay, soundHandle = PlaySound(11773)
        if (not willPlay) then
            willPlay, soundHandle = PlaySound(7294)
            if (soundHandle) then
                C_Timer.After(4, function()
                    StopSound(soundHandle)
                end)
            end
        end
    end
end

--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local overlayTable

GameObjectModelsMetatable = {
    __index = function(_, k)
        return overlayTable[k]
    end
}

local lastGameversion

function GameObjectModelsMetatable.Refresh()
    local gameversion = GetCondition("GAMEVERSION")
    if (gameversion == lastGameversion) then  return end
    lastGameversion = gameversion
    if (gameversion >= 10000 and gameversion < 20000) then
        overlayTable = GameObjectModels_Era
    elseif (gameversion >= 20000 and gameversion < 30000) then
        overlayTable = GameObjectModels_TBC
    else
        overlayTable = GameObjectModels_WOTLK
    end
end

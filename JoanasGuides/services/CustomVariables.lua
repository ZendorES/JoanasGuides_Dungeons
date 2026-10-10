--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local SessionScope = { }
local CharacterScope = { }

setmetatable(CharacterScope, {
    __index = function(t, k)
        return State.GetCustomVariables()[k]
    end,
    __newindex = function(t, k, v)
        State.SetCustomVariable(k, v)
        MarkAllDirty()
    end
})

CustomVariablesService = { }

function CustomVariablesService.GetGuideScope()
    local currentGuide = GuideNavigationService.GetGuide()
    if (currentGuide) then
        return State.GetGuideVariables(currentGuide.id)
    end
    return { }
end

function CustomVariablesService.GetSessionScope()
    return SessionScope
end

function CustomVariablesService.GetCharacterScope()
    return CharacterScope
end

function CustomVariablesService.SetCharacterVariable(key, value)
    CharacterScope[key] = value
end

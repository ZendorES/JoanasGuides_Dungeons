--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local warnings

CompatibilityWarnings = { }

function CompatibilityWarnings.GetWarnings()
    return warnings
end

function CompatibilityWarnings.SetWarnings(warnings_)
    warnings = warnings_
    UI.MarkDirty()
end

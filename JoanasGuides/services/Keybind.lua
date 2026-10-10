--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local hasBindings = false

local function UpdateBindings()
    for i = 1, 6 do
        local keybind1, keybind2 = GetBindingKey("CLICK JoanasGuides_ActionButton" .. i .. ":LeftButton")
        if (keybind1 or keybind2) then
            hasBindings = true
            return
        end
    end
    hasBindings = false
end

KeybindService = { }

function KeybindService.HasBindings()
    return hasBindings
end

function KeybindService.Init()
    for i = 1, 6 do
        _G["BINDING_NAME_CLICK JoanasGuides_ActionButton" .. i .. ":LeftButton"] = "Action Button " .. i
    end
    UpdateBindings()
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("UPDATE_BINDINGS")
eventFrame:SetScript("OnEvent", UpdateBindings)

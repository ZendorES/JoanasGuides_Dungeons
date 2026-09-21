--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("HeaderStep")
local parent, invertedMode

function component.Init(components)
	parent = components.Header.frame
	local text = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	invertedMode = State.IsInvertedModeEnabled()
	if (invertedMode) then
		text:SetPoint("TOP", parent, "BOTTOM", -8, 6)
	else
		text:SetPoint("BOTTOM", parent, "TOP", -8, 0)
	end
	text:SetTextScale(0.95)
	text:Hide()
	component.text = text
end

function component.Update()
	if (component:IsDirty()) then
		local invertedMode_ = State.IsInvertedModeEnabled()
		if (invertedMode_ ~= invertedMode) then
			component.text:ClearAllPoints()
			if (invertedMode_) then
				component.text:SetPoint("TOP", parent, "BOTTOM", -8, 6)
			else
				component.text:SetPoint("BOTTOM", parent, "TOP", -8, 0)
			end
			invertedMode = invertedMode_
		end
		local stepText = State.IsStepIDEnabled() and HeaderService.GetStepText()
		if (stepText) then
			component.text:SetText(("Step: %s"):format(stepText))
			component.text:SetShown(true)
		else
			component.text:SetShown(false)
		end
		component:MarkClean()
	end
end

UI.Add(component)

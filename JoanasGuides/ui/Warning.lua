--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("Warning")

function component.Init(components)
	local parent = components.Header.frame
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(18, 18)
	frame:SetPoint("BOTTOM", parent.Icon, "RIGHT", 1, 0)
	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetTexture("Interface/AddOns/JoanasGuides/images/Warning.blp")
	frame.Icon:SetAllPoints()
	frame:EnableMouse()
	frame:SetScript("OnEnter", function(self)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		for _, text in ipairs(CompatibilityWarnings.GetWarnings()) do
			GameTooltip:AddLine(text, nil, nil, nil, true)
		end
		GameTooltip:Show()
	end)
	frame:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	frame:Hide()
	component.frame = frame
end

function component.Update()
	if (component:IsDirty()) then
		local warnings = CompatibilityWarnings.GetWarnings()
		if (warnings) then
			component.frame:Show()
		else
			component.frame:Hide()
		end
		component:MarkClean()
	end
end

UI.Add(component)

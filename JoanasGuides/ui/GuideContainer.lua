--[[ Copyright (C) 2018-2026 TomCat's Gaming, LLC. All Rights Reserved.
     Unauthorized use, reproduction, or distribution is prohibited.
     See license.txt included with this distribution for full terms. ]]
select(2, ...).SetupGlobalFacade()

local isMoving

local component = UI.CreateComponent("GuideContainer")

function component.Init()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()
	frame:SetSize(242, 40)
	local windowLocation = State.GetWindowLocation()
	if (windowLocation) then
		frame:ClearAllPoints();
		frame:SetPoint(unpack(windowLocation));
		ValidateFramePosition(frame);
	else
		frame:SetPoint("TOPRIGHT", -15, -330)
	end
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)

	local dragBar = CreateFrame("Frame", nil, frame, "PanelDragBarTemplate")
	dragBar:SetAllPoints()
	dragBar:SetScript("OnEnter", nil)
	dragBar:SetScript("OnLeave", nil)
	if (dragBar.SetPassThroughButtons) then
		dragBar:SetPassThroughButtons("RightButton")
	end
	dragBar:HookScript("OnDragStart", function()
		ResetCursor()
		isMoving = true
		UI.CloseGuideMenu()
	end)
	dragBar:HookScript("OnDragStop", function()
		isMoving = nil
		SavedVariables.WindowLocation = { frame:GetPoint() }
	end)
	component.dragBar = dragBar
	component.frame = frame
end

function component.Update()
	local inInstance = IsInInstance()
	local shown
	if (inInstance and State.IsHiddenInInstances() and not GuideNavigationService.IsInstanceStep()) then
		shown = false
	else
		shown = State.IsGuideShown()
	end
	if (component.frame:IsShown() ~= shown) then
		component.frame:SetShown(shown)
	end
	if (component:IsDirty() and not InCombatLockdown()) then
		component.frame:SetScale(State.GetGuideScale())
		component:MarkClean()
	end
end

function UI.IsGuideContainerLocked()
	return State.IsWindowLocked()
end

function UI.IsGuideContainerMoving()
	return isMoving
end

function UI.SetGuideContainerLocked(lockedFlag)
	State.SetWindowLocked(lockedFlag)
	component.dragBar:EnableMouse(not lockedFlag)
end

UI.Add(component)

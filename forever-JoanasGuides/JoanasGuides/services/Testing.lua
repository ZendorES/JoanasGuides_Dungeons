select(2, ...).SetupGlobalFacade()

local connected = false

function _G.JoanasGuides_EnableTestMode()
	if (C_AddOns.IsAddOnLoaded("JoanasTestingTool")) then
		local overrides = JoanasTestingTool_Connect(__G)
		QuestStatusOverride = overrides.QuestStatusOverride
		PlayerPositionOverride = overrides.PlayerPositionOverride
		PlayerOnTaxiOverride = overrides.PlayerOnTaxiOverride
		connected = true
	end
end

TestingService = { }

function TestingService.Reload()
	GuideService.Init()
	if (GuideNavigationService.IsGuideSet()) then
		local guideID = GuideNavigationService.GetGuide().id
		local stepID = GuideNavigationService.GetStep().id
		State.SetGuide()
		GuideNavigationService.SetGuide(guideID)
		GuideNavigationService.SetAutoAdvanceEnabled(false)
		GuideNavigationService.SetStep(stepID)
	end
end

function TestingService.IsConnected()
	return connected
end
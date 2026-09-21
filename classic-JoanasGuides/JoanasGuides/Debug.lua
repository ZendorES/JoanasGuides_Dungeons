--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

Debug = { }

local DEBUG_MSG = "WoW Build: %s %s\n"..
		"Addon Version: %s\n"..
		"Guide ID: %s\n"..
		"Guide Version: %s\n"..
		"Step: %s"

function Debug.AnnounceStep()
	if (State.IsDebugEnabled()) then
		DEFAULT_CHAT_FRAME:AddMessage("Current Step: " .. GuideNavigationService.GetStep().id)
	end
end

function Debug.GetDebugInfo()
	local wowVersion, wowBuild = GetBuildInfo()
	local guideID = "None"
	local guideVersion = "None"
	if (GuideNavigationService.IsGuideSet()) then
		local currentGuide = GuideNavigationService.GetGuide()
		guideID = currentGuide.id
		guideVersion = currentGuide.moduleInfo.version
	end
	local stepID = GuideNavigationService.GetStep() and GuideNavigationService.GetStep().id or "None"
	return DEBUG_MSG:format(wowVersion, wowBuild, GuideModules.GetAddonVersion(), guideID, guideVersion, stepID)
end

local mapPinDebugging = {
	HIDDEN = false,
	NONPASSING = false
}

function Debug.EnableMapPinDebugging(enable, type)
	mapPinDebugging[type] = enable
	MarkAllDirty()
end

function Debug.IsMapPinDebuggingEnabled(type)
	return mapPinDebugging[type]
end

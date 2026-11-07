--[[ Copyright (C) 2018-2026 TomCat's Gaming, LLC. All Rights Reserved.
     Unauthorized use, reproduction, or distribution is prohibited.
     See license.txt included with this distribution for full terms. ]]
select(2, ...).SetupGlobalFacade()

Brand.headerLogo = "JoanasGuidesPortrait"
Brand.minimapIcon = "JoanasGuidesPortrait"
Brand.headerLogoHC = "JoanasGuidesHardcorePortrait"
Brand.slashCommand = "joana"
Brand.hasWebGuides = true
Brand.installerName = "Joana's Guides Manager"

-- Deprecated: Remove this once Era guides are fully migrated to Forever context including guide ID conditions and
-- goto buttons have been resolved
function Brand.registerGuideAlias(guideID, context)
	local baseID = guideID:match("^(.+)_FVR$")
	if (baseID) then
		context[baseID] = true
	end
end

-- Deprecated: Remove this once Era guides are fully migrated to Forever context including guide ID conditions and
-- goto buttons have been resolved
function Brand.resolveGuideAlias(guideID)
	if (not CatalogService.IsInstalled(guideID)) then
		local fvrID = guideID .. "_FVR"
		if (CatalogService.IsInstalled(fvrID)) then
			return fvrID
		end
	end
	return guideID
end

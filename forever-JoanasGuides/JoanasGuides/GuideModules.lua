select(2, ...).SetupGlobalFacade()

local AddonVersion = "3.02.63"
local isBeta = true
local GuideVersion = "3.02.59"
local GuideVersionMinimum = "3.02.59"

GuideModules = { }

local modules

local GuideModulesBase = {
	Starter = {
		name = "Starter",
	},
	SoD = {
		name = "Season of Discovery",
	},
	Era = {
		name = "Classic Era",
	},
	TBC = {
		name = "The Burning Crusade",
	},
	Wrath = {
		name = "Wrath of the Lich King",
	},
	--Cata = {
	--	name = "Cataclysm",
	--},
	--MoP = {
	--	name = "Mists of Pandaria",
	--}
}

local major, minor, _ = GuideVersion:match("(%d+)%.(%d+)%.(%d+)")

for _, v in pairs(GuideModulesBase) do
	v.latest = v.latest or GuideVersion
	v.minimum = v.minimum or GuideVersionMinimum or ("%s.%s.%s"):format(major, minor, "01")
end
-- Module properties
-- version: the version of the guide module
-- latest: latest known version of the guide module as of this addon's release
-- minimum: minimum version of the guide module that is compatible with this version of the addon
-- maximum: maximum version of the guide module that is compatible with this version of the addon
-- requires: minimum version of the addon that the guide module requires in order to function
-- preferred: latest known version of the addon available at the time of the guide module's release
-- installed: (boolean or nil) determines that the guide was able to be loaded, but not necessarily that it is compatible
-- compatible: (boolean or nil) determines that the guide is compatible with the addon

local LatestAddonVersion = AddonVersion

function GuideModules.GetAddonVersion()
	if (GuideModules.IsBeta()) then
		return AddonVersion .. "-beta"
	end
	return AddonVersion
end

function GuideModules.GetModule(moduleID)
	return modules[moduleID]
end

function GuideModules.IsBeta()
	return isBeta
end

function GuideModules.Reload()
	modules = { }
	local warnings = { }
	local incompatible
	-- October 15 2026 12:00 AM EDT
	local expiration = 1792036800
	local expired = time() > expiration
	local expiringSoon = time() > expiration - (60 * 60 * 24 * 7)

	for moduleName, moduleInfoBase in pairs(GuideModulesBase) do
		modules[moduleName] = {
			latest = moduleInfoBase.latest,
			minimum = moduleInfoBase.minimum,
			name = moduleInfoBase.name,
		}
		local moduleInfo = modules[moduleName]
		local metadataHTML = CreateFrame("SimpleHTML", nil, nil, ("JoanasGuides-%s-metadata"):format(moduleName))
		local regions = { metadataHTML:GetRegions() }
		if (#regions > 0) then
			local dataParts = { }
			for _, region in ipairs(regions) do
				table.insert(dataParts, RemoveSpaces(region:GetText()))
			end
			local metadata = loadstring(Base64.decode(table.concat(dataParts)))()
			moduleInfo.version = metadata.version
			moduleInfo.requires = metadata.requires
			moduleInfo.installed = true
			moduleInfo.preferred = metadata.preferred
		end
		if (expired) then
			moduleInfo.compatible = false
		elseif (moduleInfo.installed) then
			moduleInfo.compatible = (AddonVersion >= moduleInfo.requires and moduleInfo.version >= moduleInfo.minimum)
			moduleInfo.current = (moduleInfo.version >= moduleInfo.minimum)
			LatestAddonVersion = (moduleInfo.preferred > LatestAddonVersion) and moduleInfo.preferred or LatestAddonVersion
			if (not moduleInfo.current) then
				table.insert(warnings, ("%s"):format(moduleInfo.name))
			end
			if (AddonVersion < moduleInfo.requires) then
				incompatible = true
			end
		end
	end
	if (expired) then
		warnings = { }
		table.insert(warnings, 1, "Time to update, adventurer!\n\nYour Joana's Guides addon and guide content are outdated. Get back into action by grabbing the latest updates from our website. Install them, then type /reload to keep enjoying Joana's Guides!")
		CompatibilityWarnings.SetWarnings(warnings)
	elseif (expiringSoon) then
		warnings = { }
		table.insert(warnings, 1, "Attention, fellow explorer!\n\nJust a heads-up: Your Joana's Guides addon and guide content are set to become outdated soon. Fear not, an update is ready! Visit our website, grab the latest addon and guide content, and keep your adventure alive. Don't let the expiration date catch you off guard.")
		CompatibilityWarnings.SetWarnings(warnings)
	elseif (#warnings > 0) then
		if (incompatible) then
			warnings = { }
			table.insert(warnings, 1, "Oops! It looks like the addon and guide content aren't quite in sync. To get things back on track, just update the addon and guide content to the latest versions. Afterward, a quick /reload will do the trick!");
		else
			table.insert(warnings, 1, " ")
			table.insert(warnings, 1, "Outdated guides:")
			table.insert(warnings, 1, " ")
			table.insert(warnings, 1, "Oops! It looks like you've updated the addon but haven't updated some of your guides content yet. Get back into action by grabbing the latest updates from our website. Install them, then type /reload to keep enjoying Joana's Guides!")
		end
		CompatibilityWarnings.SetWarnings(warnings)
	elseif (GuideModules.IsBeta()) then
		-- remove after Forever Beta ends
		warnings = { }
		table.insert(warnings, 1, "Note: As of Sep. 20 2026 due to a game client issue, your guide progress might not reliably save. To find your place after logging back in, hold shift while clicking the guide step left or right arrow to quickly skip over completed steps to find where you left off or if you remember the step ID, you can use /joana goto ##-## ")
		table.insert(warnings, 1, " ")
		table.insert(warnings, 1, "Joana's Guides for WoW Forever is currently in beta. Please report bugs via the support form at joanasworld.com.")
		CompatibilityWarnings.SetWarnings(warnings)
	else
		CompatibilityWarnings.SetWarnings(nil)
	end
	UI.MarkDirty()
	Condition_ResetGuides()
end

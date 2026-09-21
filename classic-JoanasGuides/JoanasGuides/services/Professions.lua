--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local wowversion = select(7,GetBuildInfo())
if (not wowversion) then wowversion = select(4, GetBuildInfo()) end

local eventFrame = CreateFrame("Frame")
local skillNameLUT
local skillPoints = { }
local RefreshSkillPoints

ProfessionService = { }

ProfessionService.Tiers = {
	NONE = 0,
	APPRENTICE = 1,
	JOURNEYMAN = 2,
	EXPERT = 3,
	ARTISAN = 4,
	MASTER = 5,
	GRANDMASTER = 6
}

ProfessionService.PlayerProfessions = { }

function ProfessionService.GetPoints(profKey)
	if (skillNameLUT) then
		local skillName = skillNameLUT[profKey]
		if (skillName) then
			return skillPoints[skillName] or 0
		end
	end
	return 0
end

function RefreshSkillPoints()
	if (wowversion < 100000) then
		local numSkills = GetNumSkillLines();
		skillPoints = { }
		for i = 1, numSkills do
			local skillName, _, _, skillRank = GetSkillLineInfo(i);
			skillPoints[skillName] = skillRank
		end
	end
end

local function OnEvent()
	if (not skillNameLUT) then
		skillNameLUT = { }
		if (wowversion < 100000) then
			for profKey, tiers in pairs(Professions) do
				local name = GetSpellInfo(tiers[1])
				if (name) then
					skillNameLUT[name] = profKey
					skillNameLUT[profKey] = name
				end
			end
		end
	end
	for profKey, tiers in pairs(Professions) do
		ProfessionService.PlayerProfessions[profKey] = 0
		for i = #tiers, 1, -1 do
			if (IsPlayerSpell(tiers[i])) then
				ProfessionService.PlayerProfessions[profKey] = i
				break;
			end
		end
	end
	RefreshSkillPoints()
	MarkAllDirty()
end

eventFrame:SetScript("OnEvent", OnEvent)
eventFrame:RegisterEvent("SPELLS_CHANGED")
eventFrame:RegisterEvent("SKILL_LINES_CHANGED")
eventFrame:RegisterEvent("CHARACTER_POINTS_CHANGED")

--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "level",
	dimmable = true,
	--todo: Choose an icon for level tasks
	incompleteIcon = IconService.GetIconInfo("vignettekill")
}, TaskTypeMixin)

function TaskType:IsCompletedFunc(task)
	if (task.xp) then
		return (UnitLevel("player") >= task.level + 1)
				or (UnitLevel("player") >= task.level and UnitXP("player") >= task.xp)
	else
		return UnitLevel("player") >= task.level
	end
end

function TaskType:RenderFunc(task, container)
	container.text:SetShown(true)
	if (task.xp) then
		if (UnitLevel("player") >= task.level) then
			local currentXP = task.completedPassed and task.xp or UnitXP("player")
			container.text:SetText(L["Grind XP to: |C%s%s /|r |C%s%s|r"]:format(
					Color.XPCURRENT, CommaFormat(currentXP), Color.XP, CommaFormat(task.xp)))
			if (not task.completedPassed) then
				UI.SetXPGoal(task.xp)
			end
		else
			container.text:SetText(L["Reach level |C%s%d|r and |C%s%s|r XP before continuing"]:format(
					Color.LEVEL, task.level, Color.XP, CommaFormat(task.xp)))
		end
	else
		container.text:SetText(L["Reach level |C%s%d|r before continuing"]:format(Color.LEVEL, task.level))
	end
end

RegisterTaskType(TaskType)

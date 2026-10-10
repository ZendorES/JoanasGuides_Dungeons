--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "startwork",
	taskPrefix = L["Start: |C%s%s|r"],
	taskColor = Color.QUEST_STARTWORK,
	incompleteIcon = IconService.GetIconInfo("slay")
}, DoQuestMixin)

function TaskType:IsOptional(task)
	return task.optional ~= false
end

RegisterTaskType(TaskType)

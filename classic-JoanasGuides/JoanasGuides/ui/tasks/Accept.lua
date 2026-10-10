--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "accept",
	dimmable = true,
	compactable = true,
	incompleteIcon = IconService.GetIconInfo("questnormal")
}, TaskTypeMixin)

function TaskType:IsCompletedFunc(task)
	return QuestStatus.GetQuestStatus(task.accept) >= QuestStatus.status.ACCEPTED
end

function TaskType:RenderFunc(task, container)
	local link = Hyperlinks.GetQuestHyperlink(task, "accept")
	container.text:SetShown(true)
	container.text:SetText(L["Accept: |C%s%s|r"]:format(Color.QUEST_ACCEPT, link))
end

RegisterTaskType(TaskType)

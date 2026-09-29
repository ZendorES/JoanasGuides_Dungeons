--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "acceptone",
	dimmable = true,
	compactable = true,
	incompleteIcon = IconService.GetIconInfo("questnormal")
}, TaskTypeMixin)

function TaskType:IsCompletedFunc(task)
	local completed = false
	for _, questID in ipairs(task.acceptone) do
		completed = completed or QuestStatus.GetQuestStatus(questID) >= QuestStatus.status.ACCEPTED
	end
	return completed
end

function TaskType:RenderFunc(task, container)
	local link = Hyperlinks.GetQuestHyperlink({ accept = task.acceptone[1] }, "accept")
	container.text:SetShown(true)
	container.text:SetText(L["Accept: |C%s%s|r"]:format(Color.QUEST_ACCEPT, link))
end

RegisterTaskType(TaskType)

--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "turnin",
	dimmable = true,
	compactable = true,
	incompleteIcon = IconService.GetIconInfo("questturnin")
}, TaskTypeMixin)

function TaskType:IsCompletedFunc(task)
	return QuestStatus.GetQuestStatus(task.turnin) >= QuestStatus.status.TURNEDIN
end

function TaskType:RenderFunc(task, container)
	local link = Hyperlinks.GetQuestHyperlink(task, "turnin")
	local questID = task[self.type]
	task.warn = nil
	local objectives = C_QuestLog.GetQuestObjectives(questID)
	local questStatus = QuestStatus.GetQuestStatus(questID)
	local hasObjectives = objectives and #objectives > 0
	if ((questStatus == 0 or (questStatus < 2 and hasObjectives)) and not TurninOnlyQuests[questID]) then
		if (questStatus == 0) then
			task.warn = string.format("|c%sYou don't have this quest|r", Color.RED_TEXT)
		else
			task.warn = string.format("|c%sQuest is not ready to be turned in|r", Color.RED_TEXT)
		end
		for _, taskGroup in ipairs(task.root) do
			for _, task_ in ipairs(taskGroup) do
				if (questID == task_.accept) then
					task.warn = nil
					break
				end
			end
			if (not task.warn) then break end
		end
	end
	local color
	if (task.warn) then
		color = Color.RED_TEXT
		task.iconOverride = IconService.GetIconInfo("services-icon-warning")
	else
		color = Color.QUEST_TURNIN
		task.iconOverride = nil
	end
	container.text:SetShown(true)
	container.text:SetText(L["Turn in: |C%s%s|r"]:format(color, link))
end

RegisterTaskType(TaskType)

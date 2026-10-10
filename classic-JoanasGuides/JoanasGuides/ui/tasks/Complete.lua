--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "complete",
	taskPrefix = L["Do: |C%s%s|r"],
	taskColor = Color.QUEST_DO,
	incompleteIcon = IconService.GetIconInfo("worldquest-icon-pvp-ffa")
}, DoQuestMixin)

RegisterTaskType(TaskType)

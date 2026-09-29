--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "sethearthstone",
	dimmable = true,
	incompleteIcon = IconService.GetIconInfo("poi-town")
}, TaskTypeMixin)

function TaskType:IsCompletedFunc(task)
	return GetBindLocation() == C_Map.GetAreaInfo(task.sethearthstone)
end

function TaskType:RenderFunc(task, container)
	local areaName = Names.GetName(C_Map.GetAreaInfo, task.sethearthstone)
	local npcName
	if (task.fromnpc) then
		npcName = Hyperlinks.GetNPCHyperlink(task)
	end
	container.text:SetShown(true)
	if (npcName) then
		container.text:SetText(L["Habla con %s y haz |C%s%s|r sea tu nuevo hogar."]:format(npcName, Color.INN, areaName))
	else
		container.text:SetText(L["Haz que |C%s%s|r sea tu nuevo hogar."]:format(Color.INN, areaName))
	end
end

RegisterTaskType(TaskType)

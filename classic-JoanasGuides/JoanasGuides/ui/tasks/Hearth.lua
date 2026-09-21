--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "hearth",
	disableCompleteIcon = true,
}, TaskTypeMixin)

function TaskType:RenderFunc(task, container)
	local name = Hyperlinks.GetAreaHyperlink({ area = task.hearth} )
	container.text:SetShown(true)
	container.text:SetText(L["Hearth (if you can) to |C%s%s|r."]:format(Color.AREA, name))
end

RegisterTaskType(TaskType)

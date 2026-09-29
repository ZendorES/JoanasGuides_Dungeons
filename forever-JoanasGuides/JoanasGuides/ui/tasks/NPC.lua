--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "npc",
}, TaskTypeMixin)

function TaskType:RenderFunc(task, container)
	local link = Hyperlinks.GetNPCHyperlink(task)
	container.text:SetShown(true)
	local hint = ""
	if (task.hint and type(task.hint) == "string") then
		hint = " (" .. task.hint .. ")"
	end
	if (task.click) then
		container.text:SetText(L["Click en %s%s."]:format(link, hint))
	else
		container.text:SetText(L["Habla con %s%s."]:format(link, hint))
	end
end

RegisterTaskType(TaskType)

--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "learntaxi",
	dimmable = true,
	incompleteIcon = IconService.GetIconInfo("flightmaster")
}, TaskTypeMixin)

function TaskType:IsCompletedFunc(task)
	return TaxiService.HasTaxi(task.learntaxi)
end

function TaskType:RenderFunc(task, container)
	local name
	if (task.fromnpc) then
		name = Hyperlinks.GetNPCHyperlink(task)
	end
	local fpname = Names.GetName(TaxiService.GetTaxiName, task.learntaxi)
	container.text:SetShown(true)
	if (task.fromnpc) then
		container.text:SetText(L["Habla con %s y consigue la ruta de vuelo de |C%s%s|r."]:format(name, Color.TAXI, fpname))
	else
		container.text:SetText(L["Coge la ruta de vuelo de |C%s%s|r."]:format(Color.TAXI, fpname))
	end
end

RegisterTaskType(TaskType)

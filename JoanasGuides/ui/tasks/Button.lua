--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "button"
}, TaskTypeMixin)

function TaskType:IsCompletedFunc(task)
	return task.optional or false
end

function TaskType:RenderFunc(task, container)
	container.button:SetShown(true)
	container.button:SetText(task.button)
	if (task.color) then
		container:SetButtonColor("FF" .. task.color)
	elseif (ConditionContext["HC"]) then
		if (task.highlight and CheckCondition(task, task.highlight)) then
			container:SetButtonColor(Color.MODE_HIGHLIGHT_HC)
		else
			container:SetButtonColor(nil)
		end
	else
		if (task.highlight and CheckCondition(task, task.highlight)) then
			container:SetButtonColor(Color.MODE_HIGHLIGHT)
		else
			container:SetButtonColor(Color.MODE_NORMAL)
		end
	end
	container.button:SetScript("OnClick", function()
		if (task.setvar) then
			if (task.scope == "GUIDE") then
				CustomVariablesService.GetGuideScope()[task.setvar] = task.value
			else
				CustomVariablesService.SetCharacterVariable(task.setvar, task.value)
			end
			MarkAllDirty()
		end
		if (task.guide or task.goto) then
			GuideNavigationService.SetManualOverrideEnabled(false)
			GuideNavigationService.Goto(task.guide, task.goto)
		end
	end)
end

RegisterTaskType(TaskType)

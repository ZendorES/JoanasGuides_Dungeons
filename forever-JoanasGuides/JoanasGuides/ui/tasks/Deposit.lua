--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "deposit",
	taskLabel = L["Depostita en el banco:"],
	incompleteIcon = IconService.GetIconInfo("vignetteloot"),
}, BankTaskMixin)

function TaskType:IsObjectiveComplete(itemObjective)
	local totalInBags = GetItemCount(itemObjective.item, false)
	local totalInBank = GetItemCount(itemObjective.item, true) - totalInBags
	local totalToMove = totalInBags
	if (itemObjective.bags and totalInBags > itemObjective.bags) then
		totalToMove = totalInBags - itemObjective.bags
	elseif (itemObjective.bank) then
		totalToMove = math.min(itemObjective.bank - totalInBank, totalInBags)
	end
	return totalToMove <= 0
end

RegisterTaskType(TaskType)

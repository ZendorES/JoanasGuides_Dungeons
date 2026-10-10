--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "withdraw",
	taskLabel = L["Withdraw from the bank:"],
	incompleteIcon = IconService.GetIconInfo("vignettelootelite"),
}, BankTaskMixin)

function TaskType:IsObjectiveComplete(itemObjective)
	local totalInBags = GetItemCount(itemObjective.item, false)
	local totalInBank = GetItemCount(itemObjective.item, true) - totalInBags
	local totalToMove = totalInBank
	if (itemObjective.bank and totalInBank > itemObjective.bank) then
		totalToMove = totalInBank - itemObjective.bank
	elseif (itemObjective.bags) then
		totalToMove = math.min(itemObjective.bags - totalInBags, totalInBank)
	end
	return totalToMove <= 0
end

RegisterTaskType(TaskType)

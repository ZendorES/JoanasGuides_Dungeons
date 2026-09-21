--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local eventFrame = CreateFrame("Frame")

local questItemsInQuestLogLookup = { }

local function OnEvent()
	local questIndex = 1
	questItemsInQuestLogLookup = { }
	while(true) do
		local questLogTitleText = GetQuestLogTitle(questIndex)
		-- function may not be available in some versions of Classic WoW
		if (questLogTitleText == nil or GetQuestLogSpecialItemInfo == nil) then break end
		local itemLink = GetQuestLogSpecialItemInfo(questIndex);
		if (itemLink) then
			local itemId = GetItemInfoInstant(itemLink)
			if (itemId) then
				questItemsInQuestLogLookup[itemId] = questIndex
			end
		end
		questIndex = questIndex + 1
	end
end

eventFrame:SetScript("OnEvent", OnEvent)
eventFrame:RegisterEvent("QUEST_LOG_UPDATE")

function GetQuestLogIndexForItem(itemId)
	return questItemsInQuestLogLookup[itemId]
end

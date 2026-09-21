--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local canUseQuestLinks = GameTooltip.SetPassThroughButtons and true or false

Compatibility = { }

function Compatibility.CanUseQuestLinks()
	return canUseQuestLinks
end

GetGossipAvailableQuests = GetGossipAvailableQuests or function()
	local availableQuests = C_GossipInfo.GetAvailableQuests()
	local questInfos = { }
	for k, v in ipairs(availableQuests) do
		table.insert(questInfos, v.title)
		table.insert(questInfos, v.questLevel)
		table.insert(questInfos, v.isTrivial)
		table.insert(questInfos, v.frequency)
		table.insert(questInfos, v.repeatable)
		table.insert(questInfos, v.isLegendary)
		table.insert(questInfos, v.isIgnored)
	end
	return unpack(questInfos)
end
GetGossipActiveQuests = GetGossipActiveQuests or function()
	local activeQuests = C_GossipInfo.GetActiveQuests()
	local questInfos = { }
	for k, v in ipairs(activeQuests) do
		table.insert(questInfos, v.title)
		table.insert(questInfos, v.questLevel)
		table.insert(questInfos, v.isTrivial)
		table.insert(questInfos, v.isComplete)
		table.insert(questInfos, v.isLegendary)
		table.insert(questInfos, v.isIgnored)
	end
	return unpack(questInfos)
end
SelectGossipAvailableQuest = SelectGossipAvailableQuest or function(idx)
	local availableQuests = C_GossipInfo.GetAvailableQuests()
	C_GossipInfo.SelectAvailableQuest(availableQuests[idx].questID)
end
SelectGossipActiveQuest = SelectGossipActiveQuest or function(idx)
	local activeQuests = C_GossipInfo.GetActiveQuests()
	C_GossipInfo.SelectActiveQuest(activeQuests[idx].questID)
end
GetContainerNumSlots = GetContainerNumSlots or C_Container.GetContainerNumSlots
GetContainerItemLink = GetContainerItemLink or C_Container.GetContainerItemLink
GetContainerItemCooldown = GetContainerItemCooldown or C_Container.GetContainerItemCooldown
PickupContainerItem = PickupContainerItem or C_Container.PickupContainerItem
GetQuestLogTitle = GetQuestLogTitle or function(questIdx)
	local questInfo = C_QuestLog.GetInfo(questIdx)
	if (questInfo) then
		local isComplete = C_QuestLog.IsComplete(questInfo.questID)
		return questInfo.title, nil, nil, nil, nil, isComplete, nil, questInfo.questID, questInfo.startEvent
	end
end

NUM_BANKBAGSLOTS = NUM_BANKBAGSLOTS or 7

UnitBuff = UnitBuff or function(unit, idx)
	local result = C_UnitAuras.GetBuffDataByIndex(unit, idx)
	if (result) then
		return result.name, _, _, _, _, _, _, _, _, result.spellId
	end
end

UnitDebuff = UnitDebuff or function(unit, idx)
	local result = C_UnitAuras.GetDebuffDataByIndex(unit, idx)
	if (result) then
		return result.name, _, _, _, _, _, _, _, _, result.spellId
	end
end

GetSpellInfo = GetSpellInfo or function(id)
	local spellInfo = C_Spell.GetSpellInfo(id)
	if (spellInfo) then
		return spellInfo.name, _, spellInfo.iconID
	end
end

local wowversion = select(7,GetBuildInfo())
if (not wowversion) then wowversion = select(4, GetBuildInfo()) end

function GetWowVersion()
	return wowversion
end

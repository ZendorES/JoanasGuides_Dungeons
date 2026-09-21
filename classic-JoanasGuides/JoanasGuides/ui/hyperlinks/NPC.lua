--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local function TooltipShow(_, npcRef)
    GuideTooltip:SetSideAnchor()
    GuideTooltip:SetNPC(npcRef.npc or npcRef.fromnpc)
    GuideTooltip:Show()
end

local function OnClick(frame, npcRef)
    TogglePopup(Hyperlinks.GetExternalSiteURL("npc", npcRef.npc or npcRef.fromnpc), L["CTRL-C"], nil, frame)
end

function Hyperlinks.GetNPCHyperlink(npcRef, useTitle)
    local npcID = npcRef.npc or npcRef.fromnpc
    local npcName = Names.GetName(GetCreatureName, npcID)
    local label
    if (npcRef.label) then
        label = npcRef.label
    elseif (useTitle) then
        local npcInfo = GetCreatureInfo(npcID)
        label = npcInfo and npcInfo.title or "..."
    else
        label = npcName
    end
    return string.format("|c%s|Hnpc:%s:%s|h%s|h|r",
            NPCColor[GetNPCReaction(npcID)] or Color.NPC, npcID, Hyperlinks.CreateReference(npcRef), label)
end

Hyperlinks.RegisterHyperlinkType("npc", OnClick, Hyperlinks.OnEnterTooltipFunc, Hyperlinks.OnLeaveTooltipFunc, TooltipShow)

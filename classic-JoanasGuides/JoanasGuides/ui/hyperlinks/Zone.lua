--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local function TooltipShow(frame, zoneRef)
    GuideTooltip:SetOwner(frame, "ANCHOR_CURSOR")
    GuideTooltip:AddLine(GetMapName(zoneRef.zone))
    GuideTooltip:Show()
end

function Hyperlinks.GetZoneHyperlink(zoneRef)
    if (zoneRef.label) then
        return string.format("|Hzone:%s:%s|h%s|h", zoneRef.zone, Hyperlinks.CreateReference(zoneRef), zoneRef.label)
    else
        return Names.GetName(GetMapName, zoneRef.zone)
    end
end

Hyperlinks.RegisterHyperlinkType("zone", nil, Hyperlinks.OnEnterTooltipFunc, Hyperlinks.OnLeaveTooltipFunc, TooltipShow)

--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local function OnEvent()
    if (AutoQuestsService.OnGossipShow()) then return end
    if (TaxiService.OnGossipShow()) then return end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("GOSSIP_SHOW")
eventFrame:SetScript("OnEvent", OnEvent)

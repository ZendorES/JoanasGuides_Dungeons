--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("Header")
local hc

local function RefreshIcon()
	if (hc) then
		component.frame.Icon:SetTexture(I["JoanasGuidesHardcorePortrait"])
	else
		component.frame.Icon:SetTexture(I["JoanasGuidesPortrait"])
	end
end

function component.Init(components)
	hc = HardcoreService.IsHardcoreEnabled()
	local guideContainer = components.GuideContainer.frame
	local frame = CreateFrame("Frame", nil, guideContainer, "BackdropTemplate")
	component.frame = frame
	frame:SetSize(220, 44)
	frame:SetPoint("TOPLEFT", 22, 0)
	frame.backdropInfo = BACKDROP_GLUE_TOOLTIP_16_16
	frame.backdropColor = GLUE_BACKDROP_COLOR
	frame.backdropColorAlpha = 1.0
	frame.backdropBorderColor = CreateColor(0.78, 0.73, 0.56)
	frame:OnBackdropLoaded()
	frame.IconBorder = frame:CreateTexture(nil, "OVERLAY")
	frame.IconBorder:SetAtlas("auctionhouse-itemicon-border-artifact")
	frame.IconBorder:SetSize(56, 56)
	frame.IconBorder:SetPoint("LEFT", -32, 3)
	frame.Icon = frame:CreateTexture(nil, "ARTWORK")
	RefreshIcon()
	frame.Icon:SetSize(36, 36)
	frame.Icon:SetPoint("CENTER", frame.IconBorder)
end

function component.Update()
	if (component:IsDirty()) then
		local newHC = HardcoreService.IsHardcoreEnabled()
		if (newHC ~= hc) then
			hc = newHC
			RefreshIcon()
		end
		component:MarkClean()
	end
end

UI.Add(component)

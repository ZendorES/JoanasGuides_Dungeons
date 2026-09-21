--[[
Popup.lua
Copyright (C) 2018-2023 TomCat's Tours
All rights reserved.

Non-exclusive license to this library has been provided to Joana for use within the JoanasGuides testing tool

For more information, contact via email at tomcat@tomcatstours.com
(or visit https://www.tomcatstours.com)
]]
select(2, ...).SetupGlobalFacade()
local popupFrame, OnMouseDown

local BACKDROP_GLUE_TOOLTIP_16_16 = {
    bgFile = "Interface\\Glues\\Common\\Glue-Tooltip-Background",
    edgeFile = "Interface\\Glues\\Common\\Glue-Tooltip-Border",
    tile = true,
    tileEdge = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 10, right = 5, top = 4, bottom = 9 },
};

local GLUE_BACKDROP_COLOR = CreateColor(0.09, 0.09, 0.09);

local GLUE_BACKDROP_BORDER_COLOR = CreateColor(0.8, 0.8, 0.8);

local function Init()
    popupFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    PopupFrame = popupFrame
    popupFrame:SetSize(400, 116)
    popupFrame.backdropInfo = BACKDROP_GLUE_TOOLTIP_16_16
    popupFrame.backdropColor = GLUE_BACKDROP_COLOR
    popupFrame.backdropBorderColor = GLUE_BACKDROP_BORDER_COLOR
    popupFrame:SetPoint("CENTER")
    popupFrame:SetFrameStrata("TOOLTIP")
    popupFrame.info = popupFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    popupFrame.info:SetPoint("CENTER")
    popupFrame.editBox = CreateFrame("EditBox", nil, popupFrame, "InputBoxTemplate")
    popupFrame.editBox:SetSize(280, 32)
    popupFrame.editBox:SetPoint("TOP", 2.5, -16)
    popupFrame.editBox:SetScript("OnChar", function(self)
        self:SetText(self.text)
        self:HighlightText()
    end)
    popupFrame.editBox:SetScript("OnMouseUp", function(self)
        self:HighlightText()
    end)
    popupFrame.editBox:SetScript("OnEscapePressed", function()
        popupFrame:Hide()
    end)
    popupFrame.button = CreateFrame("Button", nil, popupFrame, "UIPanelButtonTemplate")
    popupFrame.button:SetSize(96, 22)
    popupFrame.button:SetPoint("BOTTOM", 0, 16)
    popupFrame.button:SetText(CLOSE)
    popupFrame.button:SetScript("OnClick", function()
        popupFrame:Hide()
    end)
    popupFrame:OnBackdropLoaded()
    popupFrame:Hide()
    popupFrame:RegisterEvent("GLOBAL_MOUSE_DOWN")
    popupFrame:SetScript("OnEvent", OnMouseDown)
end

function OnMouseDown(self)
    if (self:IsShown() and not self:IsMouseOver()) then
        if (self.target) then
            if (self.bounds) then
                local regionWidth, regionHeight = self.target:GetSize()
                if (self.target:IsMouseOver(
                        self.bounds[2],
                        regionHeight + self.bounds[2] - self.bounds[4],
                        self.bounds[1],
                        - (regionWidth - self.bounds[3] - self.bounds[1])
                )) then
                    return
                end
            else
                if (self.target:IsMouseOver()) then
                    return
                end
            end
        end
        HidePopup()
    end
end

function TogglePopup(text, caption, point, target, bounds)
    Init = Init() or nop
    if (text == popupFrame.editBox.text and popupFrame:IsShown()) then
        HidePopup()
        return
    end
    popupFrame.editBox.text = text
    popupFrame.editBox:SetText(text)
    popupFrame.info:SetText(caption)
    popupFrame:ClearAllPoints()
    if (point) then
        popupFrame:SetPoint(unpack(point))
    else
        popupFrame:SetPoint("CENTER")
    end
    popupFrame.editBox:HighlightText()
    popupFrame.target = target
    popupFrame.bounds = bounds
    popupFrame:Show()
end

function HidePopup()
    Init = Init() or nop
    popupFrame.editBox.text = nil
    popupFrame:Hide()
end

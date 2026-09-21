--[[
GlobalFacade.lua
Copyright (C) 2018-2023 TomCat's Tours
All rights reserved.

For more information, contact via email at tomcat@tomcatstours.com
(or visit https://www.tomcatstours.com)
]]
local globalFacade = { }
globalFacade.addonName, globalFacade.addon = ...

local directReferences = {
	ColorMixin = ColorMixin,
	ItemLocationMixin = ItemLocationMixin,
	ItemTransmogInfoMixin = ItemTransmogInfoMixin,
	PlayerLocationMixin = PlayerLocationMixin,
	ReportInfoMixin = ReportInfoMixin,
	TransmogLocationMixin = TransmogLocationMixin,
	TransmogPendingInfoMixin = TransmogPendingInfoMixin,
	Vector2DMixin = Vector2DMixin,
	Vector3DMixin = Vector3DMixin,
}

local function applyDirectReferences(scope)
	for k, v in pairs(directReferences) do
		scope[k]= v
	end
end

applyDirectReferences(globalFacade)

local function CreateFrameProxy(...)
	return CreateFrame(...)
end

globalFacade._G = _G
globalFacade.__G = globalFacade
globalFacade.SavedVariablesName = ("%s_Account"):format(globalFacade.addonName)
globalFacade.SavedVariablesPerCharacterName = ("%s_Character"):format(globalFacade.addonName)
globalFacade.CreateFrame = CreateFrameProxy

function globalFacade.getGlobalValue(key)
	return _G[key]
end

function globalFacade.setGlobalValue(key, value)
	_G[key] = value
end

setmetatable(globalFacade, {
	__index = function(self, key)
		local value = rawget(self,key)
		if (not value) then
			return _G[key]
		end
		return value
	end,
	__newindex = function(self, key, value)
		rawset(self, key, value)
	end
})

function globalFacade.addon.SetupGlobalFacade()
	setfenv(2, globalFacade)
end

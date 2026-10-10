--[[
Language.lua
Copyright (C) 2018-2023 TomCat's Tours
All rights reserved.

For more information, contact via email at tomcat@tomcatstours.com
(or visit https://www.tomcatstours.com)
]]
select(2, ...).SetupGlobalFacade()

L = { }

setmetatable(L, {
	__index = function(self, key)
		local value = rawget(self, key)
		if (value) then return value end
		return key
	end
})

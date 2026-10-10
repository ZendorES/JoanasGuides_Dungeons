--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

Flags = { }

function Flags.HasFlag(obj, flag)
	if (obj.flags == nil) then
		return false
	end
	return string.find(obj.flags, flag) and true or false
end

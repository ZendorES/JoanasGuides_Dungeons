--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "gameobject",
}, TaskTypeMixin)

function TaskType:RenderFunc(task, container)
	local name = Hyperlinks.GetGameObjectHyperlink(task)
	container.text:SetShown(true)
	container.text:SetText(L["Click on |c%s%s|r."]:format(Color.GAME_OBJECT, name))
end

RegisterTaskType(TaskType)

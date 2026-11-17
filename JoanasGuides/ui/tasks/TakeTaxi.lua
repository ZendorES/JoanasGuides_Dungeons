--[[ Copyright (C) 2018-2026 TomCat's Gaming, LLC. All Rights Reserved.
     Unauthorized use, reproduction, or distribution is prohibited.
     See license.txt included with this distribution for full terms. ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
    type = "taketaxi",
    dimmable = true,
    incompleteIcon = IconService.GetIconInfo("flightmaster")
}, TaskTypeMixin)

function TaskType:IsCompletedFunc(task)
    if (ConditionContext["SEEKING"]) then return true end
    return TaxiService.IsTaxiTaken(task.root)
end

function TaskType:RenderFunc(task, container)
    local name = Names.GetName(TaxiService.GetTaxiName, task.taketaxi)
    container.text:SetShown(true)
    if (task.fromnpc) then
        container.text:SetText(L["Desde el %s, coge el vuelo a |C%s%s|r"]:format(Hyperlinks.GetNPCHyperlink(task, true), Color.TAXI, name))
    else
        container.text:SetText(L["Coge el vuelo a |C%s%s|r"]:format(Color.TAXI, name))
    end
end

RegisterTaskType(TaskType)

--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "merchant",
	dimmable = true,
	incompleteIcon = IconService.GetIconInfo("flightmaster")
}, TaskTypeMixin)

local defaultText = {
	[MERCHANT_TYPE.STABLEIN] = "Stable your main pet",
	[MERCHANT_TYPE.STABLEOUT] = "Get your main pet out of the stable",
	[MERCHANT_TYPE.REPAIRS] = "Get Repaired/Resupplied",
	[MERCHANT_TYPE.SUPPLIES] = "Get Resupplied",
	[MERCHANT_TYPE.TALENTS] = "Get new Spells/Abilities",
	[MERCHANT_TYPE.WEAPONSKILLS] = "Learn new Weapon Possibilities",
	[MERCHANT_TYPE.TRADESKILLS] = "Get new Tradeskills",
}

local iconOverrides = {
	[MERCHANT_TYPE.STABLEIN] = IconService.GetIconInfo("wildbattlepet"),
	[MERCHANT_TYPE.STABLEOUT] = IconService.GetIconInfo("wildbattlepet"),
	[MERCHANT_TYPE.REPAIRS] = IconService.GetIconInfo("repair"),
	[MERCHANT_TYPE.SUPPLIES] = IconService.GetIconInfo("banker"),
	[MERCHANT_TYPE.TALENTS] = IconService.GetIconInfo("class"),
	[MERCHANT_TYPE.WEAPONSKILLS] = IconService.GetIconInfo("vignetteeventelite"),
	[MERCHANT_TYPE.TRADESKILLS] = IconService.GetIconInfo("class"),
}

local checkFunctions = {
	[MERCHANT_TYPE.STABLEIN] = MerchantService.IsPetStableVisited,
	[MERCHANT_TYPE.STABLEOUT] = MerchantService.IsPetStableVisited,
	[MERCHANT_TYPE.REPAIRS] = MerchantService.IsRepairMerchantVisited,
	[MERCHANT_TYPE.SUPPLIES] = MerchantService.IsSupplyMerchantVisited,
	[MERCHANT_TYPE.TALENTS] = MerchantService.IsTalentTrainerVisited,
	[MERCHANT_TYPE.WEAPONSKILLS] = MerchantService.IsTalentTrainerVisited,
	[MERCHANT_TYPE.TRADESKILLS] = MerchantService.IsTradeskillTrainerVisited,
}

function TaskType:IsCompletedFunc(task)
	return checkFunctions[task.merchant](task.root)
end

function TaskType:RenderFunc(task, container)
	container.text:SetShown(true)
	task.iconOverride = iconOverrides[task.merchant]
	container.text:SetText(defaultText[task.merchant])
end

RegisterTaskType(TaskType)

--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

PetSpellsService = { }

function PetSpellsService.HasPetSpell(spellID)
	for i = 1, NUM_PET_ACTION_SLOTS do
		local _, _, _, _, _, _, spellID_ = GetPetActionInfo(i)
		if spellID == spellID_ then
			return true
		end
	end
	return false
end

--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

--[[
	Reaction values:
	1 = unknown
	2 = hostile
	3 = friendly
	4 = neutral
]]

function GetNPCReaction(npcID)
    local npcInfo = NPCs[npcID]
    local react = 1
    if (npcInfo) then
        react = PLAYER_FACTION == "ALLIANCE" and npcInfo.reactA or npcInfo.reactH
    end
    return react
end

NPCRaces = {
    [1] = "Humano",
    [2] = "Orco",
    [3] = "Enano",
    [4] = "Elfo de la Noche",
    [5] = "No-Muerto",
    [6] = "Tauren",
    [7] = "Gnomo",
    [8] = "Troll",
    [9] = "Goblin",
    [10] = "Elfo de Sangre",
    [11] = "Draenei",
    [12] = "Fel Orc",
    [13] = "Naga",
    [14] = "Broken Draenei",
    [15] = "Skeleton",
    [16] = "Vrykul",
    [17] = "Tuskarr",
    [18] = "Forest Troll",
    [19] = "Taunka",
    [20] = "Northrend Skeleton",
    [21] = "Ice Troll",
    [22] = "Worgen",
    [23] = "Gilnean",
    [24] = "Pandaren",
    [25] = "Alliance Pandaren",
    [26] = "Horde Pandaren",
    [27] = "Nightborne",
    [28] = "Highmountain Tauren",
    [29] = "Void Elf",
    [30] = "Lightforged Draenei",
    [31] = "Zandalari Troll",
    [32] = "Kul'Tiran",
    [33] = "Thin Human",
    [34] = "Dark Iron Dwarf",
    [35] = "Vulpera",
    [36] = "Mag'har Orc",
    [37] = "Mechagnome"
}

NPCGenders = {
    [0] = "hombre",
    [1] = "mujer"
}

NPCTypes = {
    [0] = "Humanoide",
    [1] = "No-Muerto",
    [2] = "Elemental",
    [3] = "Bestia",
    [4] = "Dragonante",
    [5] = "Gigante",
    [6] = "Demonio",
    [7] = "Mecánico",
    [8] = "Critter",
}

NPCClassifications = {
    [1] = ELITE, -- Elite
    [2] = ITEM_QUALITY3_DESC, -- Rare,
    [3] = BOSS, -- Boss
    [4] = ITEM_QUALITY3_DESC .. " " .. ELITE, -- Rare Elite
}
--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

CHECKMARK = "|A:Capacitance-General-WorkOrderCheckmark:16:16|a "
FLIGHTMASTER = "|A:FlightMaster:16:16|a "
INNKEEPER = "|A:poi-town:16:16|a "
QUESTTURNIN = "|A:QuestTurnin:16:16|a "
QUESTNORMAL = "|A:QuestNormal:16:16|a "
VENDORGOSSIP = "|TInterface/GossipFrame/VendorGossipIcon:16:16|t "

DIM = 0.5

ALIGNMENT_RIGHT = 1
ALIGNMENT_LEFT = 2

ICONSIZE = 14

MULTITEXT_IGNORED_KEYS = {
	condition = true,
	completed = true,
	root = true,
	parent = true,
	color = true,
	icon = true,
}

LOCATION_DEFAULT_RADIUS = 0

SCREEN_RIGHT, SCREEN_LEFT = 1, 2

GUIDE_TYPE = {
	NONE = 0,
	LEVELING = 1,
	RUNE = 2
}
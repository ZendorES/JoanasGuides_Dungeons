--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("Waypoints")

local arrow = addon.CreateArrow(0, 1, 0)
local currentWaypoint, currentLocation, tooltipLabel, tooltipAltLabel, pingSetting

arrow.tooltip = {
	Show = function(this)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(this, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPRIGHT", this, "BOTTOMRIGHT", 0, 0)
		GameTooltip:SetText(tooltipLabel, 1, 1, 1)
		GameTooltip:Show()
	end,
	Hide = function()
		GameTooltip:Hide()
	end
}

function component.RemoveCurrentLocation()
	currentLocation = nil
end

function component.Update()
	if (component:IsDirty()) then
		local activeLocation = LocationsService.GetActiveLocation()
		if (GhostService.IsSpiritRessing() and UnitIsDeadOrGhost("player")) then
			if (UnitIsGhost("player")) then
				local location = State.GetLastSpiritHealerLocation()
				if (location) then
					local _, mapPosition = C_Map.GetMapPosFromWorldPos(location.continentID, location, location.mapID)
					activeLocation = {
						x = mapPosition.x * 100,
						y = mapPosition.y * 100,
						map = location.mapID,
						GetTooltipLabel = function()
							return "Spirit Healer"
						end
					}
				end
			end
		end
		local changed = false
		if (State.IsMapPingAnimationEnabled() ~= pingSetting) then
			changed = true
			pingSetting = State.IsMapPingAnimationEnabled()
		end
		if (currentLocation ~= activeLocation) then
			currentLocation = activeLocation
			changed = true
		end
		if (currentLocation) then
			local newLabel = currentLocation:GetTooltipLabel()
			if (tooltipLabel ~= newLabel) then
				changed = true
			end
		end
		if (changed) then
			if (currentLocation) then
				arrow:SetTarget(currentLocation.x / 100, currentLocation.y / 100, currentLocation.map, not State.IsMapPingAnimationEnabled())
				tooltipLabel = currentLocation:GetTooltipLabel()
				tooltipAltLabel = currentLocation:GetTooltipLabel(true)
			else
				arrow:ClearTarget()
				tooltipLabel = nil
				tooltipAltLabel = nil
			end
			if (TomTom) then
				if (currentWaypoint) then
					TomTom:RemoveWaypoint(currentWaypoint)
					currentWaypoint = nil
				end
				if (currentLocation) then
					local arrivaldistance = 1
					if (currentLocation.radius ~= 0) then
						arrivaldistance = currentLocation.radius
					end
					currentWaypoint = TomTom:AddWaypoint(currentLocation.map, currentLocation.x / 100, currentLocation.y / 100, {
						title = tooltipAltLabel,
						persistent = false,
						minimap = false,
						world = false,
						cleardistance = 0,
						arrivaldistance = arrivaldistance,
					})
				end
			end
		end
		component:MarkClean()
	end
end

UI.Add(component)

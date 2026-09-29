--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local continentIDCache = { }

LocationsInitService = { }

local function createTaskLocationCondition(task, taskGroup, objectiveIdx)
    local condition
    if (objectiveIdx) then
        condition = {
            "(ROOT_COMPLETED or not OBJECTIVE[",
            task.complete,
            "][",
            objectiveIdx,
            "])"
        }
    else
        condition = {
            "TGLOCATION_ENABLED[",
            taskGroup.idx,
            "]"
        }
    end
    if (taskGroup.condition) then
        table.insert(condition, " and (")
        table.insert(condition, taskGroup.condition)
        table.insert(condition, ")")
    end
    if (task.condition) then
        table.insert(condition, " and (")
        table.insert(condition, task.condition)
        table.insert(condition, ")")
    end
    return condition
end

local MoPMapAliases = {
    [1454] = 85, -- Orgrimmar
    [1419] = 17, -- Blasted Lands
    [1945] = 1467, -- Outland
    [1944] = 100, -- Hellfire Peninsula
    [1946] = 102, -- Zangarmarsh
    [1948] = 104, -- Shadowmoon Valley
    [1949] = 105, -- Blade's Edge
    [1951] = 107, -- Nagrand
    [1952] = 108, -- Terrokar Forest
    [1953] = 109, -- Netherstorm
    [1955] = 111, -- Shattrath City
}

local function remap(map)
    if (GetWowVersion() < 50000) then return map end
    return MoPMapAliases[map] or map
end

function LocationsInitService.InitGuide(guide)
    for _, step in ipairs(guide) do
        step.locations = step.locations or { }
        for taskGroupIdx, taskGroup in ipairs(step) do
            taskGroup.idx = taskGroupIdx
            for _, task in ipairs(taskGroup) do
                if ((task.npc or task.fromnpc) and task.location) then
                    table.insert(step.locations,{
                        task.location,
                        npc = task.npc or task.fromnpc,
                        condition = table.concat(createTaskLocationCondition(task, taskGroup)),
                    })
                elseif (task.gameobject and task.location) then
                    table.insert(step.locations,{
                        task.location,
                        gameobject = task.gameobject,
                        condition = table.concat(createTaskLocationCondition(task, taskGroup)),
                    })
                elseif (task.complete) then
                    local questInfo = guide.quests[task.complete]
                    if (questInfo) then
                        local objectives = CreateObjectivesList(task, questInfo)
                        for _, objectiveIdx in ipairs(objectives) do
                            local objective = questInfo.objectives[objectiveIdx]
                            if (objective.around or objective.at or objective.location) then
                                local location = {
                                    objective.around or objective.at or objective.location,
                                    label = objective.label,
                                    area = objective.area,
                                    gameobject = objective.gameobject,
                                    condition = table.concat(createTaskLocationCondition(task, taskGroup, objectiveIdx))
                                }
                                if (not (objective.label or objective.area)) then
                                    if (objective.around) then
                                        location.label = "Around the area"
                                    elseif (objective.at) then
                                        if (objective.clicknpc and type(objective.clicknpc) ~= "table") then
                                            location.npc = objective.clicknpc
                                        elseif (objective.kill and type(objective.kill) ~= "table") then
                                            location.npc = objective.kill
                                        elseif (objective.clickgameobject and type(objective.clickgameobject) ~= "table") then
                                            location.gameobject = objective.clickgameobject
                                        elseif (objective.speakto) then
                                            location.npc = objective.speakto
                                        end
                                    end
                                end
                                table.insert(step.locations, location)
                            elseif (objective.goto) then
                                table.insert(step.locations, {
                                    objective.goto,
                                    label = objective.label,
                                    area = objective.area,
                                    zone = objective.zone,
                                    gameobject = objective.gameobject,
                                    condition = table.concat(createTaskLocationCondition(task, taskGroup, objectiveIdx)),
                                })
                            end
                        end
                    end
                end
            end
        end
        local newLocations = { }
        for idx, location in ipairs(step.locations) do
            if (type(location) == "string" or type(location[1]) == "string") then
                local condition
                local locationAsTable
                if (type(location) == "table") then
                    condition = location.condition
                    locationAsTable = location
                    location = location[1]
                end
                local flags, map, x, y, radius = strsplit("|", location)
                map = remap(tonumber(map))
                x = tonumber(x)
                y = tonumber(y)
                local newLocation = Mixin({
                    flags = flags,
                    originalFlags = flags,
                    map = map,
                    x = 0,
                    y = 0,
                    worldX = 0,
                    worldY = 0,
                    within = false,
                    radius = radius ~= nil and tonumber(radius) or LOCATION_DEFAULT_RADIUS,
                    condition = condition,
                    label = locationAsTable and locationAsTable.label,
                    area = locationAsTable and locationAsTable.area,
                    wmoarea = locationAsTable and locationAsTable.wmoarea,
                    npc = locationAsTable and locationAsTable.npc,
                    quest = locationAsTable and locationAsTable.quest,
                    item = locationAsTable and locationAsTable.item,
                    zone = locationAsTable and locationAsTable.zone,
                    gameobject = locationAsTable and locationAsTable.gameobject,
                    conditionPassed = false,
                    onactivate = locationAsTable.onactivate,
                    onenter = locationAsTable.onenter,
                    onleave = locationAsTable.onleave,
                    root = step,
                    idx = idx
                }, LocationMixin)
                if (Flags.HasFlag(newLocation, "W")) then
                    newLocation.worldX = x
                    newLocation.worldY = y
                    continentIDCache[map] = continentIDCache[map]
                            or C_Map.GetWorldPosFromMapPos(map, { x = 0.5, y = 0.5 })
                    newLocation.continentID = continentIDCache[map]
                    local _, mapPosition = C_Map.GetMapPosFromWorldPos(continentIDCache[map], { x = x, y = y }, map)
                    newLocation.x = mapPosition.x * 100
                    newLocation.y = mapPosition.y * 100
                else
                    newLocation.x = x
                    newLocation.y = y
                    local continentID, worldCoordinate = C_Map.GetWorldPosFromMapPos(map,
                            { x = newLocation.x / 100, y = newLocation.y / 100 })
                    newLocation.continentID = continentID
                    newLocation.worldX = worldCoordinate and worldCoordinate.x or 0
                    newLocation.worldY = worldCoordinate and worldCoordinate.y or 0
                end
                table.insert(newLocations, newLocation)
            else
                table.insert(newLocations,location)
            end
        end
        step.locations = newLocations
    end
end

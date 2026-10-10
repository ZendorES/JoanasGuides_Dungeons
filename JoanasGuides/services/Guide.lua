--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local guideCache
local guideInfoLookup
local SetupHierarchicalReferences

function SetupHierarchicalReferences(node, root, parent)
    root = root or node
    parent = parent or root
    if (type(node) == "table") then
        if (node ~= root) then
            node.root = root
        end
        if (node ~= parent) then
            node.parent = parent
        end
        for _, child in ipairs(node) do
            if (child ~= root and child ~= parent) then
                SetupHierarchicalReferences(child, root, node)
            end
        end
    end
end

GuideService = { }

function GuideService.Init()
    guideCache = { }
end

function GuideService.GetGuide(guideID)
    local guide = guideCache[guideID]
    if (not guide) then
        GuideModules.Reload()
        if (not guideInfoLookup) then
            guideInfoLookup = { }
            for _, guideInfo in ipairs(GuideInfos) do
                guideInfoLookup[guideInfo.guideID] = guideInfo
            end
        end
        local guideInfo = guideInfoLookup[guideID]
        if (not guideInfo) then
            guideID = "B" .. string.sub(guideID,2)
            guideInfo = guideInfoLookup[guideID]
            if (not guideInfo) then
                return
            end
        end
        local guideTemplate = ("%s-%s"):format(addonName, guideID)
        local guideHTML = CreateFrame("SimpleHTML", nil, nil, guideTemplate)
        local regions = { guideHTML:GetRegions() }
        if (not (regions and #regions > 0)) then return end
        local dataParts = { }
        for _, region in ipairs(regions) do
            table.insert(dataParts, RemoveSpaces(region:GetText()))
        end
        local f = loadstring(Base64.decode(table.concat(dataParts)))
        setfenv(f, MERCHANT_TYPE)
        guide = f()
        assert(guide, ("Error extracting guide data: %s"):format(guideID))
        guide.info = guideInfo
        assert(guide.info, ("GuideInfo is not present: %s"):format(guideID))
        guide.id = guideID
        guide.quests = guide.quests or { }
        for _, step in ipairs(guide) do
            if (step.quests) then
                for questID, questInfo in pairs(step.quests) do
                    guide.quests[questID] = questInfo
                    step.quests = nil
                end
            end
            for _, taskGroup in ipairs(step) do
                for taskIdx, task in ipairs(taskGroup) do
                    if (task.seq) then
                        if (type(task.seq) == "number") then
                            local newSeq = { }
                            for seqNum = 1, task.seq do
                                newSeq[seqNum] = seqNum
                            end
                            task.seq = newSeq
                        end
                        for seqIdx = #task.seq, 1, -1 do
                            local objectiveIdx = task.seq[seqIdx]
                            local newTask = {
                                complete = task.complete,
                                objective = objectiveIdx
                            }
                            local condition = { }
                            if (task.condition) then
                                table.insert(condition, "(")
                                table.insert(condition, task.condition)
                                table.insert(condition, ") and ")
                            end
                            if (seqIdx == 1) then
                                table.insert(condition, "(")
                                table.insert(condition, "not OBJECTIVE[")
                                table.insert(condition, task.complete)
                                table.insert(condition, "][")
                                table.insert(condition, task.seq[seqIdx])
                                table.insert(condition, "] or QUEST[")
                                table.insert(condition, task.complete)
                                table.insert(condition, "] >= COMPLETED)")
                                newTask.condition = table.concat(condition)
                                taskGroup[taskIdx] = newTask
                                task = newTask
                            else
                                table.insert(condition, "(")
                                for seqIdxB = 1, seqIdx - 1 do
                                    table.insert(condition, "OBJECTIVE[")
                                    table.insert(condition, task.complete)
                                    table.insert(condition, "][")
                                    table.insert(condition, task.seq[seqIdxB])
                                    table.insert(condition, "] and ")
                                end
                                table.insert(condition, "not OBJECTIVE[")
                                table.insert(condition, task.complete)
                                table.insert(condition, "][")
                                table.insert(condition, task.seq[seqIdx])
                                table.insert(condition, "])")
                                newTask.condition = table.concat(condition)
                                table.insert(taskGroup, taskIdx + 1, newTask)
                            end
                        end
                    end
                end
            end
        end
        LocationsInitService.InitGuide(guide)
        ButtonGenerationService.GenerateButtons(guide)
        guide.stepLUT = { }
        for stepIdx, step in ipairs(guide) do
            step.idx = stepIdx
            guide.stepLUT[step.id] = step
            for taskGroupIdx, taskGroup in ipairs(step) do
                taskGroup.idx = taskGroupIdx
                local lastInsert = nil
                for taskIdx, task in ipairs(taskGroup) do
                    if (type(task) == "string") then
                        task = {
                            text = task
                        }
                        taskGroup[taskIdx] = task
                    else
                        if (not lastInsert or taskGroup[taskIdx-1] ~= lastInsert) then
                            lastInsert = QuestTextService.TryCreateTextTask(task,guide,step.id)
                            if (lastInsert) then
                                table.insert(taskGroup, taskIdx, lastInsert)
                                task = lastInsert
                            end
                        end
                    end
                    local multitext = true
                    for key in pairs(task) do
                        if (not (MULTITEXT_IGNORED_KEYS[key] or type(key) == "number")) then
                            multitext = nil
                        end
                    end
                    if (multitext) then
                        task.text = "multitext"
                    end
                    task.taskType = GetTaskType(task)
                    if (task.hintbutton) then
                        if (task.condition) then
                            task.condition = string.format("(%s) and HINTLEVEL <= %s", task.condition, task.hintbutton)
                        else
                            task.condition = string.format("HINTLEVEL <= %s", task.hintbutton)
                        end
                    end
                end
                if (taskGroup.buttons) then
                    for _, buttonRef in ipairs(taskGroup.buttons) do
                        buttonRef.parent = taskGroup
                        buttonRef.root = step
                    end
                end
            end
            SetupHierarchicalReferences(step)
            for _, taskGroup in ipairs(step) do
                for _, task in ipairs(taskGroup) do
                    task.taskType:Setup(task)
                end
            end
        end
        guideCache[guideID] = guide
        local moduleInfo = GuideModules.GetModule(guide.info.moduleID)
        if (moduleInfo and moduleInfo.installed and moduleInfo.compatible) then
            guide.moduleInfo = moduleInfo
            if (State.IsDebugEnabled()) then
                ValidateGuide()
            end
        else
            guide = nil
        end
    end
    if (guide) then
        if (Flags.HasFlag(guide.info, "B")) then
            guide.bookmark = State.GetBookmark(guideID)
        else
            guide.bookmark = { }
        end
    end
    return guide
end

function GuideService.GetGuideType(guideID)
    return ((not guideID) and GUIDE_TYPE.NONE)
            or (RunesService.IsRuneGuide(guideID) and GUIDE_TYPE.RUNE)
            or GUIDE_TYPE.LEVELING
end

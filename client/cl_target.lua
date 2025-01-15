if not Config.Target then return end

local craftingPointsZones = {}
local craftingTablesZones = {}


local function checkIfPlayerCanUseTable(targetType, targetData)
    local extendedCraftingData = nil
    if targetType == 'table' then
        extendedCraftingData = Config.CraftingTables[targetData.tableType]
    elseif targetType == 'point' then
        extendedCraftingData = Config.CraftingPoints[targetData.id]
    else
        lib.print.error('Invalid craftingType:', targetType)
        return false
    end

    if extendedCraftingData.restricCrafting['onlyOwner'] and targetType == 'table' then
        if targetData.owner ~= it.getCitizenId() then
            ShowNotification(nil, _U('NOTIFICATION__NOT__OWNER'), 'error')
            return false
        end
    end

    if extendedCraftingData.restricCrafting['jobs'] and next(extendedCraftingData.restricCrafting['jobs']) then
        local playerJob = it.getPlayerJob()

        if not playerJob then
            lib.print.error('[checkIfPlayerCanUseTable | ERROR] - Unable to get player job')
            return false
        end

        local allowedJobs = extendedCraftingData.restricCrafting['jobs']
        if not allowedJobs[playerJob.name] then
            ShowNotification(nil, _U('NOTIFICATION__NOT__ALLOWED'), 'error')
            return false
        end

        -- check if allowedJobs[playerJob.name] is boolean or table
        if type(allowedJobs[playerJob.name]) == 'table' then
            -- Check if table contains the job grade ['police'] = {1, 2, 3, 4, 5}
            if not lib.table.contains(allowedJobs[playerJob.name], playerJob.grade_level) then
                ShowNotification(nil, _U('NOTIFICATION__NOT__ALLOWED'), 'error')
                return false
            end
        end
    end
    return true
end


local function createPointBoxTarget(targetType, targetData)
    local options = {}
    if it.target == 'ox_target' then
        if targetType == 'table' then
            options = {
                {
                    label = _U('TARGET__TABLE__LABEL'),
                    name = 'it-crafting-use-table',
                    icon = 'fas fa-eye',
                    onSelect = function(data)
                        lib.callback("it-crafting:server:getDataById", false, function(tableData)
                            if not tableData then
                                lib.print.error('[it-crafting] Unable to get table data by network id')
                            else
                                if Config.Debug then
                                    lib.print.info('[createProccessingTargets] Current table data: ', tableData)
                                end

                                if not checkIfPlayerCanUseTable('table', tableData) then return end

                                TriggerEvent('it-crafting:client:showRecipesMenu', 'table', {tableId = tableData.id})
                            end
                        end, 'table', targetData.id)
                    end,
                    distance = 1.5
                },
                {
                    label = _U('TARGET__TABLE__REMOVE'),
                    name = 'it-crafting-remove-table',
                    icon = 'fas fa-trash',
                    onSelect = function(data)
                        lib.callback("it-crafting:server:removeTable", false, targetData.id)
                    end,
                    distance = 1.5
                }
            }
        elseif targetType == 'point' then
            options = {
                {
                    label = _U('TARGET__TABLE__LABEL'),
                    name = 'it-crafting-use-point',
                    icon = 'fas fa-eye',
                    onSelect = function(data)
                        lib.callback("it-crafting:server:getDataById", false, function(pointData)
                            if not pointData then
                                lib.print.error('[it-crafting] Unable to get table data by network id')
                            else
                                if Config.Debug then
                                    lib.print.info('[createProccessingTargets] Current point data: ', pointData)
                                end
                                
                                if not checkIfPlayerCanUseTable('point', pointData) then return end

                                TriggerEvent('it-crafting:client:showRecipesMenu', 'point', {tableId = pointData.id})
                            end
                        end, 'point', targetData.id)
                    end,
                    distance = 1.5
                }
            }
        end

        local boxZone = exports.ox_target:addBoxZone({
            coords = targetData.coords,
            size = targetData.size,
            rotation = targetData.rotation,
            debug = Config.DebugPoly,
            drawSprite = true,
            options = options,
            distance = 1.5,
        })

        return boxZone
    elseif it.target == 'qb-target' then
        if type == 'table' then
            options = {
                {
                    label = _U('TARGET__TABLE__LABEL'),
                    icon = 'fas fa-eye',
                    action = function(entity)
                        lib.callback("it-crafting:server:getDataById", false, function(tableData)
                            if not tableData then
                                lib.print.error('[it-crafting] Unable to get table data by network id')
                            else
                                if Config.Debug then
                                    lib.print.info('[createProccessingTargets] Current table data: ', tableData)
                                end

                                if not checkIfPlayerCanUseTable('table', tableData) then return end

                                TriggerEvent('it-crafting:client:showRecipesMenu', 'table', {tableId = tableData.id})
                            end
                        end, 'table', targetData.id)
                    end
                },
                {
                    label = _U('TARGET__TABLE__REMOVE'),
                    name = 'it-crafting-remove-table',
                    icon = 'fas fa-trash',
                    action = function(entity)
                        lib.callback("it-crafting:server:removeTable", false, targetData.id)
                    end
                }
            }
        elseif type == 'point' then
            options = {
                {
                    label = _U('TARGET__TABLE__LABEL'),
                    icon = 'fas fa-eye',
                    action = function(entity)
                        lib.callback("it-crafting:server:getDataById", false, function(pointData)
                            if not pointData then
                                lib.print.error('[it-crafting] Unable to get table data by network id')
                            else
                                if Config.Debug then
                                    lib.print.info('[createProccessingTargets] Current point data: ', pointData)
                                end
                                
                                if not checkIfPlayerCanUseTable('point', pointData) then return end

                                TriggerEvent('it-crafting:client:showRecipesMenu', 'point', {tableId = pointData.id})
                            end
                        end, 'point', targetData.id)
                    end
                }
            }
        end

        exports['qb-target']:AddBoxZone(targetData.id, targetData.coords, targetData.size.x, targetData.size.y, {
            name = targetData.id,
            heading = targetData.rotation,
            debugPoly = Config.DebugPoly,
            maxZ = targetData.size.z,
            {
                options = options,
            },
            distance = 1.5
        })
        return targetData.id
    else
        lib.print.error('Invalid target:', it.target)
    end
end

local function createCraftingPointZones()
    for pointId, pointData in pairs(Config.CraftingPoints) do
        local boxZoneData = {
            coords = vector3(pointData.coords.x, pointData.coords.y, pointData.coords.z),
            size = pointData.zone,
            rotation = pointData.coords.w,
            id = pointId
        }

        local boxZone = createPointBoxTarget('point', boxZoneData)
        craftingPointsZones[pointId] = boxZone
    end
end

RegisterNetEvent('it-crafting:client:addTableZone', function(tableType, tableId)
    local tableData = lib.callback.await('it-crafting:server:getDataById', false, 'table', tableId)

    if not tableData then return end

    if not craftingPointsZones[tableData.id] then
        local extendedTableData = Config.CraftingTables[tableType]
        local pointData = {
            coords = tableData.coords,
            size = extendedTableData.zone,
            rotation = tableData.rotation,
            id = tableData.id
        }
        local boxZone = createPointBoxTarget('table', pointData)
        if it.target == 'ox_target' then
            if craftingTablesZones[tableData.id] then exports.ox_target:removeZone(craftingTablesZones[tableData.id]) end
            craftingTablesZones[tableData.id] = boxZone
        elseif it.target == 'qb-target' then
            if craftingTablesZones[tableData.id] then exports['qb-target']:RemoveZone(tableData.id) end
            craftingTablesZones[tableData.id] = boxZone
        end
        if craftingTablesZones[tableData.id] then exports.ox_target:removeZone(craftingTablesZones[tableData.id]) end
        craftingTablesZones[tableData.id] = boxZone
    end
end)

RegisterNetEvent('it-crafting:client:removeTableZone', function(tableId)

    if it.target == 'ox_target' then
        if craftingTablesZones[tableId] then
            exports.ox_target:removeZone(craftingTablesZones[tableId])
            craftingTablesZones[tableId] = nil
        end
    elseif it.target == 'qb-target' then
        if craftingTablesZones[tableId] then
            exports['qb-target']:RemoveZone(tableId)
            craftingTablesZones[tableId] = nil
        end
    end
end)

CreateThread(function()
    while not it.getTargetName() do
        Wait(100)
    end

    createCraftingPointZones()

    local tables = lib.callback.await('it-crafting:server:getTables')
    for _, tableData in pairs(tables) do

        if not craftingTablesZones[tableData.id] then
            local extendedTableData = Config.CraftingTables[tableData.tableType]
            local pointData = {
                coords = tableData.coords,
                size = extendedTableData.zone,
                rotation = tableData.rotation,
                id = tableData.id
            }
            local boxZone = createPointBoxTarget('table', pointData)

            if it.target == 'ox_target' then
                if craftingTablesZones[tableData.id] then exports.ox_target:removeZone(craftingTablesZones[tableData.id]) end
                craftingTablesZones[tableData.id] = boxZone
            elseif it.target == 'qb-target' then
                if craftingTablesZones[tableData.id] then exports['qb-target']:RemoveZone(tableData.id) end
                craftingTablesZones[tableData.id] = boxZone
            end
        end
    end
end)



-- Remove all Targets
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    if it.getTargetName() == 'qb-target' then
        for _, zoneId in pairs(craftingPointsZones) do
            exports['qb-target']:RemoveZone(zoneId)
        end

        for _, zoneId in pairs(craftingTablesZones) do
            exports['qb-target']:RemoveZone(zoneId)
        end
    elseif it.getTargetName() == 'ox_target' then

        for _, zoneId in pairs(craftingPointsZones) do
            exports.ox_target:removeZone(zoneId)

        end

        for _, zoneId in pairs(craftingTablesZones) do
            exports.ox_target:removeZone(zoneId)
        end
    end
end)
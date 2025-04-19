function CheckIfPlayerCanUseTable(targetType, targetData)
    local extendedCraftingData = nil
    if targetType == 'table' then
        extendedCraftingData = Config.CraftingTables[targetData.tableType]
    elseif targetType == 'point' then
        extendedCraftingData = Config.CraftingPoints[targetData.id]
    else
        lib.print.error('Invalid craftingType:', targetType)
        return false
    end

    if extendedCraftingData.restricCrafting['onlyOwnerCraft'] and targetType == 'table' then
        if targetData.owner ~= exports.it_bridge:GetCitizenId() then
            ShowNotification(nil, _U('NOTIFICATION__NOT__ALLOWED'), 'error')
            return false
        end
    end

    if extendedCraftingData.restricCrafting['jobs'] and next(extendedCraftingData.restricCrafting['jobs']) then
        local playerJob = exports.it_bridge:GetPlayerJob()

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

    if extendedCraftingData.restricCrafting['onlyOnePlayer'] then
        local inUse = lib.callback.await('it-crafting:callback:inUse', false, targetType, targetData.id)
        if inUse then
            ShowNotification(nil, _U('NOTIFICATION__TABLE__INUSE'), 'error')
            return false
        end
    end
    return true
end

if not exports.it_bridge:GetServerInteraction() then return end

local craftingPointsZones = {}
local craftingTablesZones = {}

local function createPointBoxTarget(targetType, targetData)
    local options = {}
    if targetType == 'table' then
        options = {
            {
                label = _U('TARGET__TABLE__LABEL'):format(targetData.label),
                name = 'it-crafting-use-table',
                icon = 'fas fa-eye',
                onSelect = function(_)
                    lib.callback("it-crafting:callback:getDataById", false, function(tableData)
                        if not tableData then
                            lib.print.error('[it-crafting] Unable to get table data by network id')
                        else
                            if Config.Debug then
                                lib.print.info('[createProccessingTargets] Current table data: ', tableData)
                            end

                            if not CheckIfPlayerCanUseTable('table', tableData) then return end
                            lib.print.info('can use table')
                            if not lib.callback.await('it-crafting:callback:updateUse', false, 'table', tableData.id, true) then return end
                            if Config.UseNewUI ~= nil and Config.UseNewUI then
                                lib.print.info('Using new UI')
                                TriggerEvent('it-crafting:client:showCraftingUI', 'table', {tableId = tableData.id})
                            else
                                lib.print.info('Using old UI')
                                TriggerEvent('it-crafting:client:showRecipesMenu', 'table', {tableId = tableData.id})
                            end
                        end
                    end, 'table', targetData.id)
                end,
                distance = targetData.interactDistance
            },
            {
                label = _U('TARGET__TABLE__REMOVE'),
                name = 'it-crafting-remove-table',
                icon = 'fas fa-trash',
                onSelect = function(_)
                    lib.callback("it-crafting:callback:getDataById", false, function(tableData)
                        if not tableData then
                            lib.print.error('[it-crafting] Unable to get table data by network id')
                        else
                            local extendedCraftingData = nil
                            extendedCraftingData = Config.CraftingTables[tableData.tableType]
                            if extendedCraftingData.restricCrafting['onlyOwnerRemove'] then
                                if tableData.owner ~= exports.it_bridge:GetCitizenId() then
                                    ShowNotification(nil, _U('NOTIFICATION__NOT__ALLOWED'), 'error')
                                    return
                                end
                            end
                            TriggerEvent('it-crafting:client:removeTable', {tableId = targetData.id})
                        end
                    end, 'table', targetData.id)
                end,
                distance = targetData.interactDistance
            }
        }
    elseif targetType == 'point' then
        options = {
            {
                label = _U('TARGET__TABLE__LABEL'):format(targetData.label),
                name = 'it-crafting-use-point',
                icon = 'fas fa-eye',
                onSelect = function(_)
                    lib.callback("it-crafting:callback:getDataById", false, function(pointData)
                        if not pointData then
                            lib.print.error('[it-crafting] Unable to get table data by network id')
                        else
                            if Config.Debug then
                                lib.print.info('[createProccessingTargets] Current point data: ', pointData)
                            end
                            
                            if not CheckIfPlayerCanUseTable('point', pointData) then return end
                            if not lib.callback.await('it-crafting:callback:updateUse', false, 'point', pointData.id, true) then return end

                            if Config.UseNewUI then
                                TriggerEvent('it-crafting:client:showCraftingUI', 'point', {tableId = pointData.id})
                            else
                                TriggerEvent('it-crafting:client:showRecipesMenu', 'point', {tableId = pointData.id})
                            end
                        end
                    end, 'point', targetData.id)
                end,
                distance = targetData.interactDistance
            }
        }
    end

    local boxZone = exports.it_bridge:CreateBoxZone({
        coords = vector3(targetData.coords.x, targetData.coords.y, targetData.coords.z + (targetData.size.z / 2)),
        size = targetData.size,
        rotation = (targetData.rotation + targetData.zoneRotation),
        debug = Config.DebugPoly,
        drawSprite = targetData.drawSprite,
        distance = targetData.interactDistance,
        maxZ = targetData.coords.z + (targetData.size.z / 2),
        minZ = targetData.coords.z,
    }, options)

    return boxZone
end

local function createCraftingPointZones()
    for pointId, pointData in pairs(Config.CraftingPoints) do

        local boxZoneData = {}
        if pointData.model then
            RequestModel(pointData.model)
            while not HasModelLoaded(pointData.model) do
                Wait(100)
            end

            local min, max = GetModelDimensions(pointData.model)
            -- Calculate prop dimensions
            local size = vector3(max.x - min.x, max.y - min.y, max.z - min.z)


            boxZoneData = {
                label = pointData.label,
                id = pointId,
                coords = vector3(pointData.coords.x, pointData.coords.y, pointData.coords.z),
                rotation = pointData.coords.w,
                size = size,
                zoneRotation = pointData.target.rotation or 0,
                drawSprite = pointData.target.drawSprite or false,
                interactDistance = pointData.target.interactDistance or 1.5,
            }
        else
            boxZoneData = {
                label = pointData.label,
                id = pointId,
                coords = vector3(pointData.coords.x, pointData.coords.y, pointData.coords.z),
                rotation = pointData.coords.w,
                size = pointData.target.size or vector3(1.0, 1.0, 1.0),
                zoneRotation = pointData.target.rotation or 0,
                drawSprite = pointData.target.drawSprite or false,
                interactDistance = pointData.target.interactDistance or 1.5,
            }
        end

        local boxZone = createPointBoxTarget('point', boxZoneData)
        craftingPointsZones[pointId] = boxZone
    end
end

RegisterNetEvent('it-crafting:client:addTableZone', function(tableType, tableId)
    local tableData = lib.callback.await('it-crafting:callback:getDataById', false, 'table', tableId)

    if not tableData then return end

    if not craftingPointsZones[tableData.id] then
        local extendedTableData = Config.CraftingTables[tableType]

        RequestModel(extendedTableData.model)
        while not HasModelLoaded(extendedTableData.model) do
            Wait(100)
        end

        local min, max = GetModelDimensions(extendedTableData.model)
        -- Calculate prop dimensions
        local size = vector3(max.x - min.x, max.y - min.y, max.z - min.z)

        local pointData = {
            label = extendedTableData.label,
            id =  tableData.id,
            coords = tableData.coords,
            rotation = tableData.rotation,
            size = size, --extendedTableData.target.size or vector3(1.0, 1.0, 1.0),
            zoneRotation = extendedTableData.target.rotation or 0,
            drawSprite = extendedTableData.target.drawSprite or false,
            interactDistance = extendedTableData.target.interactDistance or 1.5,
        }
        local boxZone = createPointBoxTarget('table', pointData)
        
        if craftingTablesZones[tableData.id] then exports.ox_target:removeZone(craftingTablesZones[tableData.id]) end
        craftingTablesZones[tableData.id] = boxZone
        
    end
end)

RegisterNetEvent('it-crafting:client:removeTableZone', function(tableId)
    if craftingTablesZones[tableId] then
        exports.it_bridge:RemoveBoxZone(craftingTablesZones[tableId])
        craftingTablesZones[tableId] = nil
    end
end)

CreateThread(function()
    createCraftingPointZones()

    local tables = lib.callback.await('it-crafting:callback:getTables')
    for _, tableData in pairs(tables) do

        if not craftingTablesZones[tableData.id] then
            local extendedTableData = Config.CraftingTables[tableData.tableType]

            RequestModel(extendedTableData.model)
            while not HasModelLoaded(extendedTableData.model) do
                Wait(100)
            end

            local min, max = GetModelDimensions(extendedTableData.model)
            -- Calculate prop dimensions
            local size = vector3(max.x - min.x, max.y - min.y, max.z - min.z)

            local pointData = {
                label = extendedTableData.label,
                id =  tableData.id,
                coords = tableData.coords,
                rotation = tableData.rotation,
                size = size, --extendedTableData.target.size or vector3(1.0, 1.0, 1.0),
                zoneRotation = extendedTableData.target.rotation or 0,
                drawSprite = extendedTableData.target.drawSprite or false,
                interactDistance = extendedTableData.target.interactDistance or 1.5,
            }

            local boxZone = createPointBoxTarget('table', pointData)
            if craftingTablesZones[tableData.id] then exports.it_bridge:RemoveBoxZone(craftingTablesZones[tableData.id]) end
            craftingTablesZones[tableData.id] = boxZone
        end
    end
end)

-- Remove all Targets
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for _, zoneId in pairs(craftingPointsZones) do
        exports.it_bridge:RemoveBoxZone(zoneId)

    end

    for _, zoneId in pairs(craftingTablesZones) do
        exports.it_bridge:RemoveBoxZone(zoneId)
    end
end)
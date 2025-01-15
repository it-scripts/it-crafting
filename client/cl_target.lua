if not Config.Target then return end

local craftingPointsZones = {}
local craftingTablesZones = {}


local function createPointBoxTarget(targetType, targetData)
    local options = {}
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
                            TriggerEvent('it-crafting:client:showRecipesMenu', 'table', {tableId = tableData.id})
                        end
                    end, 'table', targetData.id)
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
                    lib.callback("it-crafting:server:getDataById", false, function(tableData)
                        if not tableData then
                            lib.print.error('[it-crafting] Unable to get table data by network id')
                        else
                            if Config.Debug then
                                lib.print.info('[createProccessingTargets] Current point data: ', tableData)
                            end
                            lib.print.info('Showing recipes menu')
                            TriggerEvent('it-crafting:client:showRecipesMenu', 'point', {tableId = tableData.id})
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
        debug = Config.TargetDebug,
        drawSprite = true,
        options = options,
        distance = 1.5,
    })

    return boxZone
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
        if craftingTablesZones[tableData.id] then exports.ox_target:removeZone(craftingTablesZones[tableData.id]) end
        craftingTablesZones[tableData.id] = boxZone
    end
end)

RegisterNetEvent('it-crafting:client:removeTableZone', function(tableId)
    if craftingTablesZones[tableId] then
        exports.ox_target:removeZone(craftingTablesZones[tableId])
        craftingTablesZones[tableId] = nil
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
            if craftingTablesZones[tableData.id] then exports.ox_target:removeZone(craftingTablesZones[tableData.id]) end
            craftingTablesZones[tableData.id] = boxZone
        end
    end
end)



-- Remove all Targets
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    if it.getTargetName() == 'qb-target' then
        for _, v in pairs(Config.PlantTypes) do
            for _, plant in pairs(v) do
                exports['qb-target']:RemoveTargetModel(plant[1])
            end
        end
        for k, v in pairs(Config.ProcessingTables) do
            if v.model ~= nil then
                exports['qb-target']:RemoveTargetModel(v.model)
            end
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
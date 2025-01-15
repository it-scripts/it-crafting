local zoneBlips = {}
local carftingPointBlips = {}
local tableBlips = {}

local function calculateCenterPoint(coords)
    -- Initialize variables
    local avgX = 0
    local avgY = 0
    local numCoords = #coords

    -- Iterate through coordinates and accumulate sums
    for i = 1, numCoords do
        avgX = avgX + coords[i].x
        avgY = avgY + coords[i].y
    end

    -- Calculate averages
    avgX = avgX / numCoords
    avgY = avgY / numCoords

    -- Create and return center point vector2
    return vector2(avgX, avgY)
end

local function AddTableBlip(blipData)
    if blipData.display then
        local blip = AddBlipForCoord(blipData.coords.x, blipData.coords.y, blipData.coords.z)
        SetBlipSprite(blip, blipData.sprite)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, blipData.displayColor)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(blipData.displayText)
        EndTextCommandSetBlipName(blip)
        tableBlips[blipData.id] = blip
    end
end

CreateThread(function()

    for _, v in pairs(Config.Zones) do
        if v.blip.display then
            local center = calculateCenterPoint(v.points)

            local blip = AddBlipForCoord(center.x, center.y, 200)
            SetBlipSprite(blip, v.blip.sprite)
            SetBlipDisplay(blip, 2)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, v.blip.displayColor)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blip.displayText)
            EndTextCommandSetBlipName(blip)
            table.insert(zoneBlips, blip)
        end
    end

    for _, pointData in pairs(Config.CraftingPoints) do
        if pointData.blip.display then
            local blip = AddBlipForCoord(pointData.coords.x, pointData.coords.y, pointData.coords.z)
            SetBlipSprite(blip, pointData.blip.sprite)
            SetBlipDisplay(blip, 2)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, pointData.blip.displayColor)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(pointData.blip.displayText)
            EndTextCommandSetBlipName(blip)
            table.insert(carftingPointBlips, blip)
        end
    end


    local tables = lib.callback.await('it-crafting:server:getTables', false)
    for _, tableData in pairs(tables) do
        local extendedTableData = Config.CraftingTables[tableData.tableType]
        local blipData = {
            coords = tableData.coords,
            sprite = extendedTableData.blip.sprite,
            display = extendedTableData.blip.display,
            displayColor = extendedTableData.blip.displayColor,
            displayText = extendedTableData.blip.displayText,
            id = tableData.id
        }
        AddTableBlip(blipData)
    end
end)


RegisterNetEvent('it-crafting:client:addTableBlip', function(tableType, tableId)
    local tableData = lib.callback.await('it-crafting:server:getDataById', false, 'table', tableId)
    if not tableData then
        if Config.Debug then lib.print.error('[it-crafting:client:addTableBlip] - Table data not found') end
        return
    end

    local extendedTableData = Config.CraftingTables[tableType]
    local blipData = {
        coords = tableData.coords,
        sprite = extendedTableData.blip.sprite,
        display = extendedTableData.blip.display,
        displayColor = extendedTableData.blip.displayColor,
        displayText = extendedTableData.blip.displayText,
        id = tableData.id
    }
    AddTableBlip(blipData)
end)

RegisterNetEvent('it-crafting:client:removeTableBlip', function(tableId)
    if tableBlips[tableId] then
        RemoveBlip(tableBlips[tableId])
        tableBlips[tableId] = nil
    end
end)


-- Remove Blips on Resource Stop
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, v in pairs(zoneBlips) do
            RemoveBlip(v)
        end
        for _, v in pairs(carftingPointBlips) do
            RemoveBlip(v)
        end

        for _, v in pairs(tableBlips) do
            RemoveBlip(v)
        end
    end
end)
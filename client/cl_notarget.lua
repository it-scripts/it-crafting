local craftingPoints = {}
local craftingTables = {}
local restLoop = false

local function getClosestCraftingTable(coords)

    local closestTable = nil
    local closestDistance = 20

    for k, v in pairs(craftingTables) do
        local distance = #(coords - v.coords)
        if distance < closestDistance then
            closestDistance = distance
            closestTable = v
        end
    end

    return closestTable, closestDistance
end

local function getClosetsCraftingPoint(coords)
    local closestPoint = nil
    local closestDistance = 20

    for k, v in pairs(craftingPoints) do
        local distance = #(coords - v.coords)
        if distance < closestDistance then
            closestDistance = distance
            closestPoint = v
        end
    end

    return closestPoint, closestDistance
end

RegisterNetEvent('it-crafting:client:syncRestLoop', function(status)
    restLoop = status
end)

RegisterNetEvent('it-crafting:client:syncTables', function(tableList)
    if Config.Debug then lib.print.info('Syncing tables', tableList) end
    craftingTables = tableList
end)

if Config.Target then return end
CreateThread(function()

    craftingPoints = lib.callback.await('it-crafting:server:getPoints', false)
    craftingTables = lib.callback.await('it-crafting:server:getTables', false)

    while true do
        if not restLoop then

            local coords = GetEntityCoords(PlayerPedId())
        
            local closestTable, tableDistance = getClosestCraftingTable(coords)
            local closestPoint, pointDistance = getClosetsCraftingPoint(coords)


            if tableDistance < pointDistance then
                if closestTable and tableDistance <= 2.0 then
                    it.DrawText3D(closestTable.coords.x, closestTable.coords.y, closestTable.coords.z + 0.5, 'Press ~g~E~w~ to interact with table')
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent('it-crafting:client:showRecipesMenu', 'table', {tableId = closestTable.id})
                    end
                end
            else
                if closestPoint and pointDistance <= 2.0 then
                    it.DrawText3D(closestPoint.coords.x, closestPoint.coords.y, closestPoint.coords.z + 0.5, 'Press ~g~E~w~ to interact with point')
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent('it-crafting:client:showRecipesMenu', 'point', {tableId = closestPoint.id})
                    end
                end
            end
        end
        Wait(0)
    end
end)

CreateThread(function()
    while true do
        Wait(10000)  -- Wait 10 Seconds for refresh Press E and refresh info
        local newTables = lib.callback.await('it-crafting:server:getTables', false)
        if newTables then
            craftingTables = newTables
        end
    end
end)

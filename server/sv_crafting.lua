--- Method to setup all the weedplants, fetched from the database
--- @return boolean: true if setup was successful, false if not
local setupTables = function()
    local result = MySQL.query.await('SELECT * FROM it_crafting_tables')

    if not result then return false end
    
    if Config.Debug then lib.print.info('[setupTables] - Found', #result, 'tables in the database') end

    for i = 1, #result do
        local v = result[i]

        if not Config.CraftingTables[v.type] then
            MySQL.query('DELETE FROM it_crafting_tables WHERE id = :id', {
                ['id'] = v.id
            }, function()
                lib.print.info('[setupTables] - Table with ID:', v.id, 'has a invalid type, deleting it from the database') 
            end)
        elseif not v.owner then
            MySQL.query('DELETE FROM it_crafting_tables WHERE id = :id', {
                ['id'] = v.id
            }, function()
                lib.print.info('[setupTables] - Table with ID:', v.id, 'has no owner, deleting it from the database')
            end)
        else
            local coords = json.decode(v.coords)
            local currentTable = CraftingTable:new(v.id, {
                entity = nil,
                coords = vector3(coords.x, coords.y, coords.z),
                rotation = v.rotation + .0,
                owner = v.owner,
                tableType = v.type
            })


            local recipes = Config.CraftingTables[v.type].recipes
            for _, recipeId in pairs(recipes) do
                if currentTable:getRecipeData(recipeId) then
                    if Config.Debug then lib.print.info('[setupTables] - Table with ID:', v.id, 'already has recipe with ID:', recipeId) end
                else
                    if not Config.Recipes[recipeId] then
                        if Config.Debug then lib.print.error('[setupTables] - Recipe with ID:', recipeId, 'not found') end
                    else
                        local recipe = Recipe:new(recipeId, Config.Recipes[recipeId])
                        currentTable:addRecipe(recipeId, recipe)
                    end
                end
            end

            currentTable:spawn()
        end
    end
    TriggerClientEvent('it-crafting:client:syncTables', -1, CraftingTables)
    return true
end

--- Method to setup all the weedplants, fetched from the database
--- @return nil
local setupPoints = function()
    local craftingPoints = Config.CraftingPoints

    if not next(craftingPoints) then return nil end

    for pointId, tableData in pairs(craftingPoints) do
        local coords = vector3(tableData.coords.x, tableData.coords.y, tableData.coords.z)
        local rotation = tableData.coords.w

        local currentPoint = CraftingPoint:new(pointId, {
            entity = nil,
            coords = coords,
            rotation = rotation,
            craftingType = tableData.pointId
        })

        local recipes = tableData.recipes
        for _, recipeId in pairs(recipes) do
            if currentPoint:getRecipeData(recipeId) then
                if Config.Debug then lib.print.info('[setupPoints] - Point with ID:', pointId, 'already has recipe with ID:', recipeId) end
            else
                if not Config.Recipes[recipeId] then
                    if Config.Debug then lib.print.error('[setupTables] - Recipe with ID:', recipeId, 'not found') end
                else
                    local recipe = Recipe:new(recipeId, Config.Recipes[recipeId])
                    currentPoint:addRecipe(recipeId, recipe)
                end
            end
        end

        currentPoint:spawn()
    end
    return true
end

--- Thread to check if the entities are still valid
local function updateThread()
    for _, craftingTable in pairs(CraftingTables) do
        if craftingTable.entity then
            -- Check if entity is still valid
            if not DoesEntityExist(craftingTable.entity) then
                if Config.Debug then lib.print.warn('[updateThread] - Table with ID:', craftingTable.id, 'entity does not exist. Try to respawn') end
                craftingTable:destroyProp()
                craftingTable:spawn()
            end
        end
    end

    for _, craftingPoint in pairs(CraftingPoints) do
        if craftingPoint.entity then
            -- Check if entity is still valid
            if not DoesEntityExist(craftingPoint.entity) then
                if Config.Debug then lib.print.warn('[updateThread] - Point with ID:', craftingPoint.id, 'entity does not exist. Try to respawn') end
                craftingPoint:destroyProp()
                craftingPoint:spawn()
            end
        end
    end

    SetTimeout(1000 * 60, updateThread)
end

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    while not DatabaseSetuped do
        Wait(100)
    end
    if Config.Debug then lib.print.info('Setting up Processing Tables') end
    while not setupTables() do
        Wait(100)
    end

    local setupPoints = setupPoints()
    if setupPoints == nil then
        if Config.Debug then lib.print.warn('No Crafting Points found in the config') end
    elseif not setupPoints then
        if Config.Debug then lib.print.error('Error while setting up Crafting Points') end
    end

    updateThread()
end)


AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    
    for _, craftinTable in pairs(CraftingTables) do
        craftinTable:delete()
    end

    for _, craftingPoint in pairs(CraftingPoints) do
        craftingPoint:delete()
    end
end)

RegisterNetEvent('it-crafting:server:createNewTable', function(coords, type, rotation, metadata)
    local src = source
    local player = exports.it_bridge:GetPlayer(src)

    if not player then if Config.Debug then lib.print.error("No Player") end return end
    if #(GetEntityCoords(GetPlayerPed(src)) - coords) > Config.rayCastingDistance + 10 then return end
    
    if exports.it_bridge:RemoveItem(src, type, 1, metadata) then

        local id = exports.it_bridge:GenerateCustomID(8)
        while CraftingTables[id] do
            id = exports.it_bridge:GenerateCustomID(8)
        end

        local currentDimension = GetEntityRoutingBucket(GetPlayerPed(src))
        
        MySQL.insert('INSERT INTO `it_crafting_tables` (id, coords, type, rotation, dimension, owner) VALUES (:id, :coords, :type, :rotation, :dimension, :owner)', {
            ['id'] = id,
            ['coords'] = json.encode(coords),
            ['type'] = type,
            ['rotation'] = rotation,
            ['dimension'] = currentDimension,
            ['owner'] = exports.it_bridge:GetCitizenId(src),
        }, function()
            local currentTable = CraftingTable:new(id, {
                entity = nil,
                coords = coords,
                dimension = currentDimension,
                rotation = rotation,
                owner = exports.it_bridge:GetCitizenId(src),
                tableType = type
            })

            local recipes = Config.CraftingTables[type].recipes
            for _, recipeId in pairs(recipes) do
                if currentTable:getRecipeData(recipeId) then
                    if Config.Debug then lib.print.info('[setupTables] - Table with ID:', v.id, 'already has recipe with ID:', recipeId) end
                else
                    if not Config.Recipes[recipeId] then
                        if Config.Debug then lib.print.error('[setupTables] - Recipe with ID:', recipeId, 'not found') end
                    else
                        local recipe = Recipe:new(recipeId, Config.Recipes[recipeId])
                        currentTable:addRecipe(recipeId, recipe)
                    end
                end
            end

            currentTable:spawn()
            TriggerClientEvent('it-crafting:client:syncTables', -1, CraftingTables)
            local tableData = currentTable:getData()
            SendToWebhook(src, 'table', 'place', tableData)
        end)
    else
        if Config.Debug then lib.print.error("Can not remove item") end
    end
end)

RegisterNetEvent('it-crafting:server:removeTable', function(args)

    if not CraftingTables[args.tableId] then return end

    local craftingTable = CraftingTables[args.tableId]

    if not args.extra then
        if #(GetEntityCoords(GetPlayerPed(source)) - craftingTable.coords) > 10 then return end
        exports.it_bridge:GiveItem(source, craftingTable.tableType, 1)
    end

    MySQL.query('DELETE from it_crafting_tables WHERE id = :id', {
        ['id'] = args.tableId
    })

    local tableData = craftingTable:getData()
    SendToWebhook(source, 'table', 'remove', tableData)

    craftingTable:delete()
    TriggerClientEvent('it-crafting:client:syncTables', -1, CraftingTables)
end)


-- This event is currently not used, but it is here for future use
RegisterNetEvent('it-crafting:server:syncparticlefx', function(status, tableId, netId, particlefx)
    TriggerClientEvent('it-crafting:client:syncparticlefx',-1, status, tableId, netId, particlefx)
end)

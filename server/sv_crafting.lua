lib.callback.register('it-crafting:server:getRecipes', function(source, type, id)
    if Config.Debug then lib.print.info('[getRecipes] - Try to get Recipes from Table with ID:', id) end
    if type == 'table' then
        if not CraftingTables[id] then
            if Config.Debug then lib.print.error('[getRecipes | Debug] - Table with ID:', id, 'not found') end
            return nil
        end
        if Config.Debug then lib.print.info('[getRecipes | Debug] - Recipes from Table with ID:', id, 'found') end
        return CraftingTables[id]:getRecipes()
    elseif type == 'point' then
        if not CraftingPoints[id] then
            if Config.Debug then lib.print.error('[getRecipes | Debug] - Point with ID:', id, 'not found') end
            return nil
        end
        if Config.Debug then lib.print.info('[getRecipes | Debug] - Point from Table with ID:', id, 'found') end
        return CraftingPoints[id]:getRecipes()
    end
    if Config.Debug then lib.print.error('[getRecipes | Debug] - type', type, 'is invalid!') end
    return nil
end)

lib.callback.register('it-crafting:server:getRecipeById', function(source, type, craftId, recipeId)

    if Config.Debug then lib.print.info('[getRecipeById] - Try to get Recipe with ID:', recipeId, 'from Table with ID:', tableId) end
    local currentTable = nil
    if type == 'table' then
        currentTable = CraftingTables
    elseif type == 'point' then
        currentTable = CraftingPoints
    else
        if Config.Debug then lib.print.error('[getRecipeById] - type', type, 'is invalid!') end
        return nil
    end

    if not currentTable[craftId] then
        if Config.Debug then lib.print.error('[getRecipeById] - Table with ID:', craftId, 'not found') end
        return nil
    end

    local currentPoint = currentTable[craftId]

    local recipe = currentPoint:getRecipeData(recipeId)

    if not recipe then
        if Config.Debug then lib.print.error('[getRecipeById] - Recipe with ID:', recipeId, 'not found') end
        return nil
    end

    if Config.Debug then lib.print.info('[getRecipeById] - Recipe with ID:', recipeId, 'from CraftID:', craftId, 'found') end
    return recipe
end)

lib.callback.register('it-crafting:server:getDataById', function(source, type, id)
    
    if Config.Debug then lib.print.info('[getDataById | Debug] - Try to get Table with ID:', id) end

    if type == 'table' then
        if not CraftingTables[id] then
            if Config.Debug then lib.print.error('[getDataById | Debug] - Table with ID:', id, 'not found') end
            return nil
        end
        if Config.Debug then lib.print.info('[getDataById | Debug] - Table with ID:', id, 'found') end
        return CraftingTables[id]:getData()
    elseif type == 'point' then
        if not CraftingPoints[id] then
            if Config.Debug then lib.print.error('[getDataById | Debug] - Point with ID:', id, 'not found') end
            return nil
        end
        if Config.Debug then lib.print.info('[getDataById | Debug] - Point with ID:', id, 'found') end
        return CraftingPoints[id]:getData()
    end

    if Config.Debug then lib.print.error('[getDataById | Debug] - type', type, 'is invalid!') end
    return nil
end)

lib.callback.register('it-crafting:server:getTableByNetId', function(source, netId)
        
    if Config.Debug then lib.print.info('[getTableByNetId] - Try to get Table with NetID:', netId) end

    for _, processingTable in pairs(CraftingTables) do
        if processingTable.netId == netId then
            if Config.Debug then lib.print.info('[getTableByNetId] - Table with NetID:', netId, 'found') end
            return processingTable:getData()
        end
    end

    if Config.Debug then lib.print.error('[getTableByNetId] - Table with NetID:', netId, 'not found') end
    return nil
end)

lib.callback.register('it-crafting:server:getTableByOwner', function(source)

    if Config.Debug then lib.print.info('[getTableByOwner] - Try to get Table with Owner:', source) end

    local src = source
    local citId = it.getCitizenId(src)

    local temp = {}

    for k, v in pairs(CraftingTables) do
        if v.owner == citId then
            temp[k] = v:getData()
        end
    end

    if #temp == 0 then
        if Config.Debug then lib.print.error('[getTableByOwner] - Table with Owner:', source, 'not found') end
        return nil
    end

    if Config.Debug then lib.print.info('[getTableByOwner] - Table with Owner:', source, 'found') end
    return temp
end)

lib.callback.register('it-crafting:server:inUse', function(source, type, id)
    if Config.Debug then lib.print.info('[inUse] - Try to get Table with ID:', id) end

    if type == 'table' then
        if not CraftingTables[id] then
            if Config.Debug then lib.print.error('[inUse | Debug] - Table with ID:', id, 'not found') end
            return nil
        end
        if Config.Debug then lib.print.info('[inUse | Debug] - Table with ID:', id, 'found') end
        return CraftingTables[id].inUse
    elseif type == 'point' then
        if not CraftingPoints[id] then
            if Config.Debug then lib.print.error('[inUse | Debug] - Point with ID:', id, 'not found') end
            return nil
        end
        if Config.Debug then lib.print.info('[inUse | Debug] - Point with ID:', id, 'found') end
        return CraftingPoints[id].inUse
    end

    if Config.Debug then lib.print.error('[inUse | Debug] - type', type, 'is invalid!') end
    return nil
end)

lib.callback.register('it-crafting:server:updateUse', function(source, type, id, inUse)
    if Config.Debug then lib.print.info('[updateUse] - Try to get Table with ID:', id) end

    if type == 'table' then
        if not CraftingTables[id] then
            if Config.Debug then lib.print.error('[updateUse | Debug] - Table with ID:', id, 'not found') end
            return nil
        end
        if Config.Debug then lib.print.info('[updateUse | Debug] - Table with ID:', id, 'found') end
        CraftingTables[id]:useTable(inUse)
        return true
    elseif type == 'point' then
        if not CraftingPoints[id] then
            if Config.Debug then lib.print.error('[updateUse | Debug] - Point with ID:', id, 'not found') end
            return nil
        end
        if Config.Debug then lib.print.info('[updateUse | Debug] - Point with ID:', id, 'found') end
        CraftingPoints[id]:useTable(inUse)
        return true
    end

    if Config.Debug then lib.print.error('[updateUse | Debug] - type', type, 'is invalid!') end
    return false
end)

lib.callback.register('it-crafting:server:getTables', function(source)
    local temp = {}

    for k, v in pairs(CraftingTables) do
        temp[k] = v:getData()
    end

    return temp
end)

lib.callback.register('it-crafting:server:getPoints', function(source)
    local temp = {}

    for k, v in pairs(CraftingPoints) do
        temp[k] = v:getData()
    end

    return temp
end)

--- Method to setup all the weedplants, fetched from the database
--- @return nil
local setupTables = function()
    local result = MySQL.query.await('SELECT * FROM it_crafting_tables')

    if not result then return false end
    
    if Config.Debug then lib.print.info('[setupTables] - Found', #result, 'tables in the database') end

    for i = 1, #result do
        local v = result[i]

        if not Config.CraftingTables[v.type] then
            MySQL.query('DELETE FROM drug_processing WHERE id = :id', {
                ['id'] = v.id
            }, function()
                lib.print.info('[setupTables] - Table with ID:', v.id, 'has a invalid type, deleting it from the database') 
            end)
        elseif not v.owner then
            MySQL.query('DELETE FROM drug_processing WHERE id = :id', {
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
            for recipeId, recipeData in pairs(recipes) do
                if currentTable:getRecipeData(recipeId) then
                    if Config.Debug then lib.print.info('[setupTables] - Table with ID:', v.id, 'already has recipe with ID:', recipeId) end
                else
                    local recipe = Recipe:new(recipeId, recipeData)
                    currentTable:addRecipe(recipeId, recipe)
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
        for recipeId, recipeData in pairs(recipes) do
            if currentPoint:getRecipeData(recipeId) then
                if Config.Debug then lib.print.info('[setupPoints] - Point with ID:', pointId, 'already has recipe with ID:', recipeId) end
            else
                local recipe = Recipe:new(recipeId, recipeData)
                currentPoint:addRecipe(recipeId, recipe)
            end
        end

        currentPoint:spawn()
    end
    return true
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

--- Thread to check if the entities are still valid
function updateThread()
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

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    
    for _, craftinTable in pairs(CraftingTables) do
        craftinTable:delete()
    end

    for _, craftingPoint in pairs(CraftingPoints) do
        craftingPoint:delete()
    end
end)

RegisterNetEvent('it-crafting:server:craftItem', function(type, data)

    local currentTable = {}
    if type == 'table' then
        currentTable = CraftingTables
    elseif type == 'point' then
        currentTable = CraftingPoints
    else
        lib.print.error('[Crafting] - Invalid type:', type)
        return
    end

    if not currentTable[data.tableId] then return end
    local craftingAction = currentTable[data.tableId]
    local recipe = craftingAction:getRecipeData(data.recipeId)
    if #(GetEntityCoords(GetPlayerPed(source)) - craftingAction.coords) > 10 then return end

    local player = it.getPlayer(source)
    --local tableInfos = Config.ProcessingTables[processingTables[entity].type]

    if not player then return end
    local givenItems = {}

    local failChance = math.random(1, 100)
    if failChance <= recipe.failChance then
        ShowNotification(source, _U('NOTIFICATION__PROCESS__FAIL'), 'error')
        for k,v in pairs(recipe.ingrediants) do
            it.removeItem(source, k, v.amount)
        end
        return
    end

    for k, v in pairs(recipe.ingrediants) do
        if v.remove then
            if not it.removeItem(source, k, v.amount) then
                ShowNotification(source, _U('NOTIFICATION__MISSING__INGIDIANT'), 'error')
                if #givenItems > 0 then
                    for _, x in pairs(givenItems) do
                        it.giveItem(source, x.name, x.amount)
                    end
                end
                return
            else
                table.insert(givenItems, {name = k, amount = v.amount})
            end
        end
    end
    SendToWebhook(source, 'table', 'process', craftingAction:getData())
    
    for k, v in pairs(recipe.outputs) do
        it.giveItem(source, k, v)
    end
end)


RegisterNetEvent('it-crafting:server:removeTable', function(args)

    if not CraftingTables[args.tableId] then return end

    local craftingTable = CraftingTables[args.tableId]

    if not args.extra then
        if #(GetEntityCoords(GetPlayerPed(source)) - craftingTable.coords) > 10 then return end
        it.giveItem(source, craftingTable.tableType, 1)
    end

    MySQL.query('DELETE from it_crafting_tables WHERE id = :id', {
        ['id'] = args.tableId
    })

    local tableData = craftingTable:getData()
    SendToWebhook(source, 'table', 'remove', tableData)

    craftingTable:delete()
    TriggerClientEvent('it-crafting:client:syncTables', -1, CraftingTables)
end)

RegisterNetEvent('it-crafting:server:createNewTable', function(coords, type, rotation, metadata)
    local src = source
    local player = it.getPlayer(src)

    if not player then if Config.Debug then lib.print.error("No Player") end return end
    if #(GetEntityCoords(GetPlayerPed(src)) - coords) > Config.rayCastingDistance + 10 then return end
    local itemRemoved = false
    if it.inventory == 'ox' then
        itemRemoved = true
    else
        itemRemoved = it.removeItem(src, type, 1, metadata)
    end
    if itemRemoved then

        local id = it.generateCustomID(8)
        while CraftingTables[id] do
            id = it.generateCustomID(8)
        end
        
        MySQL.insert('INSERT INTO `it_crafting_tables` (id, coords, type, rotation, owner) VALUES (:id, :coords, :type, :rotation, :owner)', {
            ['id'] = id,
            ['coords'] = json.encode(coords),
            ['type'] = type,
            ['rotation'] = rotation,
            ['owner'] = it.getCitizenId(src)
        }, function()
            local currentTable = CraftingTable:new(id, {
                entity = nil,
                coords = coords,
                rotation = rotation,
                owner = it.getCitizenId(src),
                tableType = type
            })


            local recipes = Config.CraftingTables[type].recipes
            for recipeId, recipeData in pairs(recipes) do
                if currentTable:getRecipeData(recipeId) then
                    if Config.Debug then lib.print.info('[setupTables] - Table with ID:', currentTable.id, 'already has recipe with ID:', recipeId) end
                else
                    local recipe = Recipe:new(recipeId, recipeData)
                    currentTable:addRecipe(recipeId, recipe)
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


RegisterNetEvent('it-crafting:server:syncparticlefx', function(status, tableId, netId, particlefx)
    TriggerClientEvent('it-crafting:client:syncparticlefx',-1, status, tableId, netId, particlefx)
end)

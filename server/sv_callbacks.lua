--- Get all recipes from a crafting table or point.
---@param _ number : The player ID of the player who triggered the event.
---@param type string : The type of crafting entity ('table' or 'point').
---@param id string : The ID of the crafting entity.
---@return nil | table : Returns nil if the entity is not found, or a table of recipes if found.
lib.callback.register('it-crafting:callback:getRecipes', function(_, type, id)
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

--- Get a recipe by its ID from a crafting table or point.
---@param _ number : The player ID of the player who triggered the event.
---@param type string: The type of crafting entity ('table' or 'point').
---@param craftId string: The ID of the crafting entity.
---@param recipeId string: The ID of the recipe to retrieve.
---@return nil | table : Returns nil if the entity or recipe is not found, or the recipe data if found.
lib.callback.register('it-crafting:callback:getRecipeById', function(_, type, craftId, recipeId)

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

--- Get all data from a crafting table or point by its ID.
---@param _ number : The player ID of the player who triggered the event.
---@param type string : The type of crafting entity ('table' or 'point').
---@param id string : The ID of the crafting entity.
---@return nil | table : Returns nil if the entity is not found, or the data of the entity if found.
lib.callback.register('it-crafting:callback:getDataById', function(_, type, id)
    
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

--- Get a crafting table by its owner.
--- @param source number : The player ID of the player who triggered the event.
--- @return nil | table : Returns nil if the table is not found, or the data of the table if found.
lib.callback.register('it-crafting:callback:getTableByOwner', function(source)

    local src = source
    local citId = exports.it_bridge:GetCitizenId(src)
    if Config.Debug then lib.print.info('[getTableByOwner] - Try to get Table with Owner:', citId) end

    local temp = {}

    for k, v in pairs(CraftingTables) do
        if v.owner == citId then
            temp[k] = v:getData()
        end
    end

    if not next(temp) then
        if Config.Debug then lib.print.error('[getTableByOwner] - Table with Owner:', source, 'not found') end
        return nil
    end

    if Config.Debug then lib.print.info('[getTableByOwner] - Table with Owner:', source, 'found') end
    return temp
end)

lib.callback.register('it-crafting:callback:inUse', function(source, type, id)
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

lib.callback.register('it-crafting:callback:updateUse', function(source, type, id, inUse)
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

lib.callback.register('it-crafting:callback:getTables', function(source)
    local temp = {}

    for k, v in pairs(CraftingTables) do
        temp[k] = v:getData()
    end

    return temp
end)

lib.callback.register('it-crafting:callback:getPoints', function(source)
    local temp = {}

    for k, v in pairs(CraftingPoints) do
        temp[k] = v:getData()
    end

    return temp
end)

lib.callback.register('it-crafting:callback:craftItem', function(source, type, data)
    local currentTable = {}
    if type == 'table' then
        currentTable = CraftingTables
    elseif type == 'point' then
        currentTable = CraftingPoints
    else
        lib.print.error('[Crafting] - Invalid type:', type)
        return false
    end

    if not currentTable[data.tableId] then return end
    local craftingAction = currentTable[data.tableId]
    local recipe = craftingAction:getRecipeData(data.recipeId)
    if #(GetEntityCoords(GetPlayerPed(source)) - craftingAction.coords) > 10 then return end

    local player = exports.it_bridge:GetPlayer(source)
    --local tableInfos = Config.ProcessingTables[processingTables[entity].type]

    if not player then return end
    local givenItems = {}

    local failChance = math.random(1, 100)
    if failChance <= recipe.failChance then
        ShowNotification(source, _U('NOTIFICATION__CRAFT__FAIL'), 'error')
        for k,v in pairs(recipe.ingrediants) do
            if v.remove then
                exports.it_bridge:RemoveItem(source, k, v.amount)
            end
        end
        return true
    end

    for k, v in pairs(recipe.ingrediants) do
        if v.remove then
            if not exports.it_bridge:RemoveItem(source, k, v.amount) then
                ShowNotification(source, _U('NOTIFICATION__MISSING__INGIDIANT'), 'error')
                if #givenItems > 0 then
                    for _, x in pairs(givenItems) do
                        exports.it_bridge:GiveItem(source, x.name, x.amount)
                    end
                end
                return false
            else
                table.insert(givenItems, {name = k, amount = v.amount})
            end
        end
    end

    for k, v in pairs(recipe.outputs) do
        exports.it_bridge:GiveItem(source, k, v)
    end

    local messageData = craftingAction:getData()
    messageData.recipe = recipe

    SendToWebhook(source, type, 'craft', messageData)
    return true
end)
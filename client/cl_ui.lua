local currentRecipes = {}
local currentTableId, currentTableType = nil, nil

local itemLabelCache = {}
local itemIconCache = {}

local function transformRecipeData(recipeData)
    local transformedData = {}
    
    -- Funktion zum Abrufen von Daten mit Caching
    local function getItemLabel(itemName)
        if not itemLabelCache[itemName] then
            itemLabelCache[itemName] = exports.it_bridge:GetItemLabel(itemName)
        end
        return itemLabelCache[itemName]
    end
    
    local function getItemIcon(itemName)
        if not itemIconCache[itemName] then
            itemIconCache[itemName] = exports.it_bridge:GetInventoryImage(itemName)
        end
        return itemIconCache[itemName]
    end
    
    local function getItemCount(itemName)
        return exports.it_bridge:GetItemCount(itemName)
    end
    
    -- Der Fehler tritt hier auf - wir ändern zur einfacheren Form
    -- transformedData = table.create(#recipeData)
    transformedData = {}
    
    for recipeId, recipe in pairs(recipeData) do
        -- Outputs initialisieren
        local transformedOutputs = {}
        
        -- Transformiere Outputs
        for itemName, amount in pairs(recipe.outputs) do
            table.insert(transformedOutputs, {
                name = getItemLabel(itemName),
                quantity = amount,
                icon = getItemIcon(itemName)
            })
        end
        
        -- Ingredients initialisieren
        local transformedIngredients = {}
        local canCraft = true
        
        -- Transformiere Ingredients
        for itemName, itemData in pairs(recipe.ingrediants) do
            local itemCount = getItemCount(itemName)
            local required = itemData.amount
            
            -- Direkter Vergleich
            if itemCount < required then
                canCraft = false
            end
            
            -- Status-Berechnung
            local status
            if itemCount >= required then
                status = 'complete'
            elseif itemCount > 0 then
                status = 'partial'
            else
                status = 'missing'
            end
            
            table.insert(transformedIngredients, {
                name = itemName,
                label = getItemLabel(itemName),
                required = required,
                current = itemCount,
                icon = getItemIcon(itemName),
                status = status,
                hidden = itemData.show,
                remove = itemData.remove
            })
        end
        
        -- Füge transformiertes Rezept hinzu
        table.insert(transformedData, {
            id = recipeId,
            name = recipe.label,
            craftTime = recipe.processTime,
            outputs = transformedOutputs,
            ingredients = transformedIngredients,
            canCraft = canCraft,
            skillCheck = recipe.skillCheck,
        })
    end
    
    return transformedData
end

RegisterNetEvent('it-crafting:client:showCraftingUI', function(type, data)

    lib.print.info('Show crafting UI', type, data)

    currentTableId = data.tableId
    currentTableType = type
    currentRecipes = lib.callback.await('it-crafting:callback:getRecipes', false, currentTableType, currentTableId)

    if not currentRecipes then
        ShowNotification(nil, _U('NOTIFICATION__NO__RECIPES'), 'error')
        return
    end

    lib.print.info('Current recipes', currentRecipes)

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "showCraftingUi"
    })
    TriggerEvent('it-crafting:client:syncRestLoop', true)
end)

RegisterNUICallback('uiReady', function(_, cb)
    cb({})
    -- Starte die Datentransformation im nächsten Frame
    CreateThread(function()
        -- Transformiere die Daten
        local transformedData = transformRecipeData(currentRecipes)
        -- Sende die transformierten Daten zurück an die UI
        SendNUIMessage({
            action = "showCraftingUi",
            recipes = transformedData
        })
    end)
end)

RegisterNUICallback('craftItem', function(data, cb)
    local recipeId = data.recipeId

    local recipe = lib.callback.await('it-crafting:callback:getRecipeById', false, data.craftingType, data.craftId, data.recipeId)

    if Config.UseWeightSystem then
        if not exports.it_bridge:CanCarryItems(recipe.outputs) then
            ShowNotification(nil, _U('NOTIFICATION__CANT__CARRY'), 'error')
            cb({false})
            return
        end
    end

    local success = lib.callback.await('it-crafting:callback:craftItem', false, currentTableType, {tableId = currentTableId, recipeId = recipeId})
    cb({success})
end)


RegisterNuiCallback('closeMenu', function(_, cb)
    SetNuiFocus(false, false)
    TriggerEvent('it-crafting:client:syncRestLoop', false)
    lib.callback.await('it-crafting:callback:updateUse', false, currentTableType, currentTableId, false)
    currentTableType, currentTableId = nil, nil
    currentRecipes = {}
    cb({})
end)

RegisterNuiCallback('fetchItemCount', function(data, cb)
    local itemCount = exports.it_bridge:GetItemCount(data.name)
    cb({itemCount})
end)
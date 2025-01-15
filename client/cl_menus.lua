-- Processing Menu
RegisterNetEvent('it-crafting:client:showRecipesMenu', function(type, data)

    local tableId = data.tableId
    local recipes = lib.callback.await('it-crafting:server:getRecipes', false, type, tableId)

    if not recipes then
        ShowNotification(nil, _U('NOTIFICATION__NO__RECIPES'), 'error')
        return
    end

    local options = {}

    for recipeId, recipeData in pairs(recipes) do
        table.insert(options, {
            title = recipeData.label,
            description = _U('MENU__RECIPE__DESC'),
            icon = "gear",
            arrow = true,
            onSelect = function(_)
                TriggerEvent('it-crafting:client:showCraftingMenu', type, {craftId = tableId, recipeId = recipeId})
            end,
        })
    end

    lib.registerContext({
        id = "it-crafting-recipes-menu",
        title = _U('MENU__PROCESSING'),
        onExit = function()
            TriggerEvent('it-crafting:client:syncRestLoop', false)
        end,
        options = options
    })

    TriggerEvent('it-crafting:client:syncRestLoop', true)
    lib.showContext("it-crafting-recipes-menu")

end)

RegisterNetEvent("it-crafting:client:showCraftingMenu", function(type, data)

    local recipe = lib.callback.await('it-crafting:server:getRecipeById', false, type, data.craftId, data.recipeId)

    local options = {}
    if not recipe.showIngrediants then
        for _, v in pairs(recipe.ingrediants) do
            -- Menu only shows the amount not the name of the item
            table.insert(options, {
                title = _U('MENU__UNKNOWN__INGREDIANT'),
                description = _U('MENU__INGREDIANT__DESC'):format(v.amount),
                icon = "flask",
            })
        end
    else
        for k, v in pairs(recipe.ingrediants) do
            table.insert(options, {
                title = it.getItemLabel(k),
                description = _U('MENU__INGREDIANT__DESC'):format(v.amount), --:replace("{amount}", v),
                icon = "flask",
            })
        end
    end

    table.insert(options, {
        title = _U('MENU__TABLE__PROCESS'),
        icon = "play",
        description = _U('MENU__TABLE__PROCESS__DESC'),
        arrow = true,
        onSelect = function(_)
            TriggerEvent('it-crafting:client:craftItem', type, {craftId = data.craftId, recipeId = data.recipeId})
        end,
        event = "it-crafting:client:craftItem",
    })

    lib.registerContext({
        id = "it-crafting-processing-menu",
        title = recipe.label,
        options = options,
        menu = 'it-crafting-recipes-menu',
        onBack = function()
            TriggerEvent('it-crafting:client:showRecipesMenu', type, {tableId = data.craftId})
        end,
        onExit = function()
            TriggerEvent('it-crafting:client:syncRestLoop', false)
        end,
    })
    TriggerEvent('it-crafting:client:syncRestLoop', true)
    lib.showContext("it-crafting-processing-menu")
end)
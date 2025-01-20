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

    if not Config.Target and type == 'table' then
        table.insert(options, {
            title = _U('TARGET__TABLE__REMOVE'),
            icon = 'fa-trash',
            onSelect = function(_)
                lib.callback("it-crafting:server:getDataById", false, function(tableData)
                    if not tableData then
                        lib.print.error('[it-crafting] Unable to get table data by network id')
                    else
                        local extendedCraftingData = nil
                        extendedCraftingData = Config.CraftingTables[tableData.tableType]
                        if extendedCraftingData.restricCrafting['onlyOwnerRemove'] then
                            if tableData.owner ~= it.getCitizenId() then
                                ShowNotification(nil, _U('NOTIFICATION__NOT__ALLOWED'), 'error')
                                return
                            end
                            TriggerEvent('it-crafting:client:removeTable', {tableId = tableId})
                        end
                    end
                end, 'table', tableId)
            end,
        })
    end

    lib.registerContext({
        id = "it-crafting-recipes-menu",
        title = _U('MENU__CRAFTING__TITLE'),
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
        title = _U('MENU__TABLE__CRAFT__TITLE'),
        icon = "play",
        description = _U('MENU__TABLE__CRAFT__DESC'),
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

-- ┌──────────────────────────────────────────────────────────┐
-- │    _       _           _         __  __                  │
-- │   / \   __| |_ __ ___ (_)_ __   |  \/  | ___ _ __  _   _ │
-- │  / _ \ / _` | '_ ` _ \| | '_ \  | |\/| |/ _ \ '_ \| | | |│
-- │ / ___ \ (_| | | | | | | | | | | | |  | |  __/ | | | |_| |│
-- │/_/   \_\__,_|_| |_| |_|_|_| |_| |_|  |_|\___|_| |_|\__,_|│
-- └──────────────────────────────────────────────────────────┘

local function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

RegisterNetEvent('it-crafting:client:showMainAdminMenu', function()

    local allTables = lib.callback.await('it-crafting:server:getTables', false)
    local tableCount = tablelength(allTables)

    lib.registerContext({
        id = "it-crafting-admin-main-menu-tables",
        title = _U('MENU__ADMIN__TABLE__MAIN'),
        onExit = function()
            TriggerEvent('it-crafting:client:syncRestLoop', false)
        end,
        options = {
            {
                title = _U('MENU__TABLE__COUNT__TITLE'),
                description = _U('MENU__TABLE__COUNT__DESC'):format(tableCount),
                icon = "flask-vial",
            },
            {
                title = _U('MENU__LIST__TABLES__TITLE'),
                description = _U('MENU__LIST__TABLES__DESC'),
                icon = "list",
                arrow = true,
                onSelect = function()
                    TriggerEvent('it-crafting:client:generateTableListMenu')
                end,
            },
            {
                title = _U('MENU__ADD__BLIPS__TITLE'),
                description = _U('MENU__ADD_TABLE__BLIPS__DESC'),
                icon = "map-location-dot",
                arrow = true,
                onSelect = function()
                    TriggerEvent('it-crafting:client:addAllAdminBlips')
                end,
            },
            {
                title = _U('MENU__REMOVE__BLIPS__TITLE'),
                description = _U('MENU__REMOVE__TABLE__BLIPS__DESC'),
                icon = "eraser",
                arrow = true,
                onSelect = function()
                    TriggerEvent('it-crafting:client:removeAllAdminBlips')
                end,
            },
        }
    })
    TriggerEvent('it-crafting:client:syncRestLoop', true)
    lib.showContext("it-crafting-admin-main-menu-tables")
end)

RegisterNetEvent('it-crafting:client:showTableListMenu', function(data)
    
    local tableList = data.tableList

    local options = {}
    for _, v in ipairs(tableList) do
        table.insert(options, {
            title = v.label,
            description = _U('MENU__DIST'):format(it.round(v.distance, 2)),
            icon = "flask-vial",
            arrow = true,
            onSelect = function()
                TriggerEvent('it-crafting:client:showTableAdminMenu', {tableData = v})
            end,
        })
    end

    lib.registerContext({
        id = "it-crafting-table-list-menu",
        title = _U('MENU__LIST__TABLES__TITLE'),
        menu = 'it-crafting-placeholder',
        onBack = function()
            TriggerEvent('it-crafting:client:showMainAdminMenu', {menuType = 'tables'})
        end,
        onExit = function()
            TriggerEvent('it-crafting:client:syncRestLoop', false)
        end,
        options = options
    })
    TriggerEvent('it-crafting:client:syncRestLoop', true)
    lib.showContext("it-crafting-table-list-menu")
end)

RegisterNetEvent('it-crafting:client:showTableAdminMenu', function(data)
    local tableData = data.tableData
    local streetNameHash, _ = GetStreetNameAtCoord(tableData.coords.x, tableData.coords.y, tableData.coords.z)
    local streetName = GetStreetNameFromHashKey(streetNameHash)

    lib.registerContext({
        id = "it-crafting-table-admin-menu",
        title = _U('MENU__TABLE__ID'):format(tableData.id),
        menu = 'it-crafting-placeholder',
        onBack = function()
            TriggerEvent('it-crafting:client:generateTableListMenu')
        end,
        onExit = function()
            TriggerEvent('it-crafting:client:syncRestLoop', false)
        end,
        options = {
            {
                title = _U('MENU__OWNER'),
                description = tableData.owner,
                --description = it.getPlayerNameByCitizenId(tableData.owner),
                metadata = {
                    _U('MENU__OWNER__META')
                },
                onSelect = function()
                    lib.setClipboard(tableData.owner)
                    ShowNotification(nil, _U('NOTIFICATION__COPY__CLIPBOARD'):format(tableData.owner), 'success')
                end
            },
            {
                title = _U('MENU__TABLE__LOCATION'),
                description = _U('MENU__LOCATION__DESC'):format(streetName, tableData.coords.x, tableData.coords.y, tableData.coords.z),
                metadata = {
                    _U('MENU__LOCATION__META')
                },
                icon = "map-marker",
                onSelect = function()
                    lib.setClipboard('('..tableData.coords.x..", "..tableData.coords.y..", "..tableData.coords.z..')')
                    ShowNotification(nil, _U('NOTIFICATION__COPY__CLIPBOARD'):format('('..tableData.coords.x..", "..tableData.coords.y..", "..tableData.coords.z..')'), 'success')
                end
            },
            {
                title = _U('MENU__TABLE__TELEPORT'),
                description = _U('MENU__TABLE__TELEPORT__DESC'),
                icon = "route",
                arrow = true,
                onSelect = function()
                    SetEntityCoords(PlayerPedId(), tableData.coords.x, tableData.coords.y, tableData.coords.z)
                    ShowNotification(nil, _U('NOTIFICATION__TELEPORTED'), 'success')
                end
            },
            {
                title = _U('MENU__ADD__BLIP'),
                description = _U('MENU__ADD__TABLE__BLIP__DESC'),
                icon = "map-location-dot",
                arrow = true,
                onSelect = function()
                    TriggerEvent('it-crafting:client:addAdminBlip', tableData.id)
                    ShowNotification(nil, _U('NOTIFICATION__BLIP__ADDED'), 'success')
                end,
            },
            {
                title = _U('MENU__TABLE__DESTROY'),
                description = _U('MENU__TABLE__DESTROY__DESC'),
                icon = "trash",
                arrow = true,
                onSelect = function()
                    TriggerServerEvent('it-crafting:server:removeTable', {tableId = tableData.id, extra='admin'})
                    ShowNotification(nil, _U('NOTIFICATION__TABLE__DESTROYED'), 'success')
                end,
            }
        }
    })
    TriggerEvent('it-crafting:client:syncRestLoop', true)
    lib.showContext("it-crafting-table-admin-menu")
end)
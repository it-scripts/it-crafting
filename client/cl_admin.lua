RegisterNetEvent('it-crafting:client:showAdminAlertBox', function(args)
    local userLicense = args.userLicense
    local username = args.username

    local alert = lib.alertDialog({
        header = _U('ALERT__ADMIN__HEADER'),
        content = _U('ALERT__ADMIN__CONTENT'):format(userLicense, username),
        centered = true,
        size = 'xl',
        cancel = true,
        labels = {
            cancel = _U('ALTER__ADMIN__CANCEL'),
            confirm = _U('ALTER__ADMIN__COPY')
        }
    })

    if alert == 'confirm' then
        -- copy content to clipboard
        lib.setClipboard('add_ace identifier.'..userLicense..' it-crafting allow #'..username..' License')
        ShowNotification(nil, _U('NOTIFICATION__COPY__CLIPBOARD'):format('User License'), "success")
    end
end)

RegisterNetEvent('it-crafting:client:generateTableListMenu', function()
    local currentCoords = GetEntityCoords(PlayerPedId())
    local allTables = lib.callback.await('it-crafting:server:getTables', false)

    -- check if there are any tables
    if not allTables then return end

    local tableList = {}

    -- Sort tables by distance To player
    for _, data in pairs(allTables) do
        local distance = #(currentCoords - data.coords)
        local temp = {
            id = data.id,
            owner = data.owner,
            coords = data.coords,
            type = data.tableType,
            label = Config.CraftingTables[data.tableType].label..' ('..data.id..')',
            distance = distance,
            netId = data.netId
        }
        table.insert(tableList, temp)
    end

    table.sort(tableList, function(a, b) return a.distance < b.distance end)
    TriggerEvent('it-crafting:client:showTableListMenu', {tableList = tableList})
end)
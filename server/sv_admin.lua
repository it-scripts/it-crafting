lib.addCommand(_U('COMMAND__ADMINMENU'), {
    help = _U('COMMAND__ADMINMENU__USAGE'),
}, function(source, args, raw)
    local src = source
    if IsPlayerAceAllowed(src, 'it-crafting') then
        TriggerClientEvent('it-crafting:client:showMainAdminMenu', src)
    else
        -- get user license
        local userLicense = GetPlayerIdentifiers(src)[1]
        local username = GetPlayerName(src)

        TriggerClientEvent('it-crafting:client:showAdminAlertBox', src, {userLicense = userLicense, username = username})
    end
end)
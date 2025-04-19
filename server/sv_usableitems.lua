local serverInventory = exports.it_bridge:GetServerInventory()
local serverFramework = exports.it_bridge:GetServerFramework()

local getMetadata = function(itemData)
    if not itemData then return nil end
    if serverFramework == 'ox' then
        return itemData.metadata or nil
    elseif serverFramework == "qb-core" then
        return itemData.info or nil
    elseif serverFramework == "esx" then
        return itemData.metadata or nil
    end

    return nil
end

if serverInventory == 'ox_inventory' then
    exports('placeCraftingTable', function(event, item, inventory, slot, data)
        if Config.Debug then lib.print.info('[placeCraftingTable]', event, item) end
        local prTable = item.name
        if event == 'usingItem' then
            if Config.Debug then lib.print.info('Using item', item) end
            local src = inventory.id
            local metadata = getMetadata(item)
            if Config.Debug then lib.print.info('Table metadata', metadata) end
            TriggerClientEvent('it-crafting:client:placeCraftingTable', src, prTable, metadata)
        end
    end)
else
    for crTable, _ in pairs(Config.CraftingTables) do
        exports.it_bridge:CreateUsableItem(crTable, function(source, data)
            local src = source
            if exports.it_bridge:HasItem(src, crTable, 1) then
                local metadata = getMetadata(data)
                if Config.Debug then lib.print.info('Table metadata', metadata) end
                TriggerClientEvent('it-crafting:client:placeCraftingTable', src, crTable, metadata)
            end
        end)
    end
end

local getMetadata = function(itemData)
    if not itemData then return nil end
    local encodedData = json.encode(itemData)
    if it.inventory == 'ox' then
        return itemData.metadata or nil
    elseif it.core == "qb-core" then
        return itemData.info or nil
    elseif it.core == "esx" then
        return itemData.metadata or nil
    end
end


if it.inventory == 'ox' then
    exports('placeCraftingTable', function(event, item, inventory, slot, data)
        
        if Config.Debug then lib.print.info('[placeCraftingTable]', event, item) end
        local prTable = item.name
        --[[ if not it.hasItem(inventory.id, prTable, 1) then 
            if Config.Debug then lib.print.error('Player does not have the item', prTable) end
            return    
        end ]]

        if event == 'usingItem' then
            if Config.Debug then lib.print.info('Using item', item) end
            local src = inventory.id
            local metadata = getMetadata(item)
            if Config.Debug then lib.print.info('Table metadata', metadata) end
            TriggerClientEvent('it-crafting:client:placeCraftingTable', src, prTable, metadata)
        end
    end)
else
    for crTable, _ in pairs(Config.CraftingTable) do
        it.createUsableItem(crTable, function(source, data)
            local src = source
            if it.hasItem(src, crTable, 1) then
                local metadata = getMetadata(data)
                if Config.Debug then lib.print.info('Table metadata', metadata) end
                TriggerClientEvent('it-crafting:client:placeCraftingTable', src, crTable, metadata)
            end
        end)
    end
end

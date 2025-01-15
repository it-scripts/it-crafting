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
        if Config.Debug then lib.print.info('[placeCraftingTable]', item) end

        local prTable = item.name
        if event == 'usingItem' then
            local src = inventory.id
            if it.hasItem(src, prTable, 1) then
                local metadata = getMetadata(prTable)
                if Config.Debug then lib.print.info('Table metadata', metadata) end
                TriggerClientEvent('it-crafting:client:placeCraftingTable', src, prTable, metadata)
            end
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

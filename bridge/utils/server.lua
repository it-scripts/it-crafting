function it.notify(source, message, type, length)
    TriggerClientEvent('it-crafting:client:Notify', source, message, type, length)
end
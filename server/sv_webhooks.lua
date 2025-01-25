--[[
    Here you set up the discord webhook, you can find more information about
    this in the server/webhook.lua file.
    If you dont know what a webhook is, you can read more about it here:
    https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks
]]
local webhookSettings = {
    ['active'] = false, -- Set to true to enable the webhook
    ['name'] = 'it-crafting', -- Name for the webhook
    ['avatar'] = 'https://i.imgur.com/mbM87BJ.png', -- Avatar for the webhook
    ['urls'] = {
        ['crafting'] = nil, --'', -- Webhook URL for plant actions
        ['message'] = nil, -- Webhook URL for messages
    }
}

local errors = {
    [200] = "Everything is fine the webhook message was sent successfully!",
    [204] = "Everything is fine the webhook message was sent successfully but without any content! (You don't need to worry about this)",

    [400] = "Your webhook URL is invalid!",
    [401] = "Your webhook URL is invalid!",
    [404] = "Your webhook URL is invalide!",
    [405] = "Your webhook URL is invalide!",
    [429] = "You are being rate limited by Discord!",
    [500] = "Discord is having internal server issues!",
    [502] = "Discord is having internal server issues!",
    [503] = "Discord is having internal server issues!",
    [504] = "Discord is having internal server issues!",
}

local messagesToSend = {
    ['crafting'] = {},
}

local function buildPlaceHolderEmbed(type, messageData)
    local embed = {
        ["color"] = 4374938,
        ["author"] = {
            ["name"] = webhookSettings['name'],
            ["icon_url"] = webhookSettings['avatar'],
            ["url"] = webhookSettings['avatar'],
        }
    }
    if type == 'table' then
        embed["title"] = "Table: "..messageData.netId
        embed["description"] = "### Table History:\n"
        embed["fields"] = {
            {
                ["name"] = "Table Data:",
                ["value"] = "**ID:** `"..messageData.id.."`\n"..
                            "**Owner:** `"..messageData.owner.."`\n"..
                            "**Type:** `"..messageData.tableType.."`\n"..
                            "**Coords:** `"..messageData.coords.."`\n",
                ["inline"] = false,
            },
        }
        embed["footer"] = {
            ["text"] = os.date("%c"),
            ["icon_url"] = webhookSettings['avatar'],
        }
    elseif type == 'point' then
        embed["title"] = "Point: "..messageData.id
        embed["description"] = "### Point History:\n"
        embed["fields"] = {
            {
                ["name"] = "Point Data:",
                ["value"] = "**ID:** `"..messageData.id.."`\n"..
                            "**Coords:** `"..messageData.coords.."`\n",
                ["inline"] = false,
            },
        }
        embed["footer"] = {
            ["text"] = os.date("%c"),
            ["icon_url"] = webhookSettings['avatar'],
        }
    elseif type == 'message' then
        embed["title"] = "Script Message"
        embed["description"] = messageData.description
        embed["footer"] = {
            ["text"] = os.date("%c"),
            ["icon_url"] = webhookSettings['avatar'],
        }
    end
    return embed
end

local function getPlayerDiscordId(source)
    local src = source
    local discordID = 'NA'
    for k,v in pairs(GetPlayerIdentifiers(source)) do 
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordID = string.gsub(v, "discord:", "")
        end
    end
    return discordID
end

local function sendWehookDiscord(messageId)
    if not webhookSettings['active'] then return end
    if not messageId then
        if messagesToSend == nil then return end
        for webhookType, messageList in pairs(messagesToSend) do
            for messageId, messages in pairs(messageList) do
                local webhookUrl = webhookSettings['urls'][webhookType]

                if webhookUrl then
                    PerformHttpRequest(webhookUrl, function(err, text, headers)
                        if err == 200 or err == 204 then
                            messagesToSend[webhookType][messageId] = nil
                        else
                            lib.print.info('[WEBHOOK ERROR] ' .. errors[err] .. ' (' .. err .. ')')
                            webhookSettings['urls'][webhookType] = nil
                        end
                    end, 'POST', json.encode({username = webhookSettings['name'], avatar_url = webhookSettings['avatar'], embeds = {messages}}), { ['Content-Type'] = 'application/json' })
                end
            end
        end
        return
    end

    -- Send the message with the given id
    for webhookType, messageList in pairs(messagesToSend) do
        for messageId, messages in pairs(messageList) do
            if messageId == messageId then
                local webhookUrl = webhookSettings['urls'][webhookType]

                if webhookUrl then
                    PerformHttpRequest(webhookUrl, function(err, text, headers)
                        if err == 200 or err == 204 then
                            messagesToSend[webhookType][messageId] = nil
                        else
                            lib.print.info('[WEBHOOK ERROR] ' .. errors[err] .. ' (' .. err .. ')')
                            webhookSettings['urls'][webhookType] = nil
                        end
                    end, 'POST', json.encode({username = webhookSettings['name'], avatar_url = webhookSettings['avatar'], embeds = {messages}}), { ['Content-Type'] = 'application/json' })
                end
            end
        end
    end
end

function SendToWebhook(source, type, action, messageData)
    if not webhookSettings['active'] then return end
    local id = messageData.id
    local embedMessage = nil
    if type == 'message' then
        if webhookSettings['urls']['message'] == nil then return end

        embedMessage = buildPlaceHolderEmbed(type, messageData)
        PerformHttpRequest(webhookSettings['urls']['message'], function(err, text, headers) 
            if err == 200 or err == 204 then
            else
                lib.print.info('[WEBHOOK ERROR] ' .. errors[err] .. ' (' .. err .. ')')
                webhookSettings['urls']['message'] = nil
            end
        end, 'POST', json.encode({username = webhookSettings['name'], avatar_url = webhookSettings['avatar'], embeds = {embedMessage}}), { ['Content-Type'] = 'application/json' })
        return
    end

    if messagesToSend['crafting'][id] == nil then
        messagesToSend['crafting'][id] = buildPlaceHolderEmbed(type, messageData)
    end

    -- Check if message description is too long

    local time = os.time()

    local discordID = getPlayerDiscordId(source)
    local newMessageLine = nil
    if action == 'place' then
        newMessageLine = messagesToSend['crafting'][id]["description"].."> [<t:"..time..":d><t:"..time..":T>]: <@"..discordID..">: Placed Table\n"
    elseif action == 'remove' then
        newMessageLine = messagesToSend['crafting'][id]["description"].."> [<t:"..time..":d><t:"..time..":T>]: <@"..discordID..">: Removed Table\n"
    elseif action == 'craft' then
        local itemString = ''
        for name, amount in pairs(messageData.recipe.outputs) do
            itemString = itemString.."`"..name.." x"..amount.."` \n"	
        end
        newMessageLine = messagesToSend['crafting'][id]["description"].."> [<t:"..time..":d><t:"..time..":T>]: <@"..discordID..">: Craft "..itemString.."\n"
    end

    if newMessageLine then
        if string.len(newMessageLine) > 2048 then
            -- Send the message and reset the description
            sendWehookDiscord(id)
            if action == 'place' then
                messagesToSend['crafting'][id]["description"] = "> [<t:"..time..":d><t:"..time..":T>]: <@"..discordID..">: Placed Table\n"
            elseif action == 'remove' then
                messagesToSend['crafting'][id]["description"] = "> [<t:"..time..":d><t:"..time..":T>]: <@"..discordID..">: Removed Table\n"
            elseif action == 'craft' then
                local itemString = ''
                for name, amount in pairs(messageData.recipe.outputs) do
                    itemString = itemString.."`"..name.." x"..amount.."` \n"
                end
                messagesToSend['crafting'][id]["description"] = "> [<t:"..time..":d><t:"..time..":T>]: <@"..discordID..">: Craft "..itemString.."\n"
            end
        else
            messagesToSend['crafting'][id]["description"] = newMessageLine
        end
    end
end

CreateThread(function()
    if not webhookSettings['active'] then return end
    while true do
        Wait(1000 * 60) -- Wait 1 minute
        sendWehookDiscord()
    end
end)
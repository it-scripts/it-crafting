--== VERSION CHECK ==--

-- pars the jason code to a table
local function parseJson(data)
    local decodedData = json.decode(data)
    return decodedData
end

local resourceName = GetCurrentResourceName()

-- Get the current version from the fxmanifest.lua
local currentVersion = GetResourceMetadata(resourceName, 'version', 0)
-- Get identifier from the fxmanifest.lua
local scriptIdentifier = GetResourceMetadata(resourceName, 'identifier', 0)

local remoteVersionFile = nil
local verioncheckURL = "https://api.it-scripts.com/v1/scripts/"..scriptIdentifier.."/update.json"

local function checkResourceVersion(err, responseText, headers)
    remoteVersionFile = parseJson(responseText)
    if responseText == nil or remoteVersionFile == nil then
        print("^5======================================^7")
        print(' ')
        print('^8ERROR: ^0Failed to check for update.')
        print(' ')
        print("^5======================================^7")
        return
    end
    
    if currentVersion >= remoteVersionFile.version then
        print("^5======================================^7")
        print(' ')
        print("^2["..resourceName.."] - The Script is up to date!")
        print("^7Current Version: ^4" .. remoteVersionFile.version .. "^7.")
        print(' ')
        print("^5======================================^7")
        return
    end

    print("^5======================================^7")
    print(' ')
    print('^8['..resourceName..'] - New update available now!')
    print('^7Current Version: ^4'..currentVersion..'^7.')
    print('^7New Version: ^4'..remoteVersionFile.version..'^7.')
    print('^7Notes: ^4' ..remoteVersionFile.message.. '^7.')
    print(' ')
    print('^4Download it now on https://keymaster.fivem.net')
    print(' ')
    print("^5======================================^7")
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() and Config.EnableVersionCheck then
        Wait(3000)
        PerformHttpRequest(verioncheckURL, checkResourceVersion, "GET")
    end
end)
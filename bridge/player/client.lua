function it.getPlayerData()

    if it.core == 'qb-core' then
        return CoreObject.Functions.GetPlayerData()
    end

    if it.core == 'esx' then
        return CoreObject.GetPlayerData()
    end

    if it.core == 'ND_Core' then
        return CoreObject.getPlayer()
    end
end

function it.getCitizenId()
    local citizenId = lib.callback.await('it-crafting:getCitizenId', false)
    return citizenId
end

function it.getPlayerJob()
    return lib.callback.await('it-crafting:getPlayerJob', false)
end

function it.getPlayerGang()
    local gang = {}
    local playerData = it.getPlayerData()

    if it.core == 'qb-core' then
        gang = {
            name = playerData.gang.name,
            label = playerData.gang.label,
            grade_name = playerData.gang.grade.level,
            grade_label = playerData.gang.grade.name,
            isboss = playerData.gang.isboss,
        }
    elseif it.core == 'esx' then
        gang = {
            name = playerData.job.name,
            label = playerData.job.label,
            grade_name = playerData.job.grade_name,
            grade_label = playerData.job.grade_label,
            isboss = playerData.job.grade_name == 'boss' or false,
        }
    end
    return gang
end

function it.getPlayerMoney(type)
    local playerData = it.getPlayerData()
    if it.core == 'qb-core' then
        local types = { ['cash'] = 'cash', ['bank'] = 'bank', ['black'] = false }

        if types[type] then
            return playerData.money[types[type]]
        end
        return 0
    elseif it.core == 'esx' then
        local types = { ['cash'] = 'money', ['bank'] = 'bank', ['black'] = 'black_money' }

        if types[type] then
            for _, data in pairs(playerData.accounts) do
                if data.name == types[type] then
                    return data.money
                end
            end
        end
        return 0
    end
end

function it.getPlayerName()
    local playerData = it.getPlayerData()
    if it.core == 'qb-core' then
        return playerData.charinfo.firstname .. ' ' .. playerData.charinfo.lastname
    elseif it.core == 'esx' then
        return lib.callback.await('it-crafting:getPlayerName', false)
    end
end

function it.getPlayerNameByCitizenId(citizenId)
    local playerName = lib.callback.await('it-crafting:getPlayerNameByCitizenId', false, citizenId)
    return playerName
end

function it.getLicences()
    local licences = lib.callback.await('it-crafting:getLicences', false)
    return licences
end

function it.getLicence(licenseType)
    local licence = lib.callback.await('it-crafting:getLicence', false, licenseType)
    return licence
end
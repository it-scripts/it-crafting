-- Setup the Database from the it_drugs.sql file
DatabaseSetuped = false

local craftingStatement = 'CREATE TABLE IF NOT EXISTS it_crafting_tables ('..
    'id VARCHAR(11) NOT NULL, PRIMARY KEY(id),'..
    'coords LONGTEXT NOT NULL,'..
    'rotation DOUBLE NOT NULL,'..
    'dimension INT NOT NULL,'..
    'owner LONGTEXT NOT NULL,'..
    'type VARCHAR(100) NOT NULL'..
    ');'

local updateStaement = 'ALTER TABLE it_crafting_tables ADD COLUMN IF NOT EXISTS dimension INT NOT NULL DEFAULT 0;'

local function setupDatabase()
    MySQL.rawExecute(craftingStatement, {}, function(response)
        if not response then
            lib.print.error('[setupDatabase] Faild to create processing database')
        else
            if Config.Debug then
                lib.print.info('[setupDatabase] Plant database created:', response)
            end
        end
    end)

    MySQL.rawExecute(updateStaement, {}, function(response)
        if not response then
            lib.print.error('[setupDatabase] Faild to update processing database')
        else
            if Config.Debug then
                lib.print.info('[setupDatabase] Plant database updated:', response)
            end
        end
    end)
  
    return true
end

CreateThread(function()

    if not Config.ManualDatabaseSetup then
        while not setupDatabase() do
            Wait(100)
        end
    end

    DatabaseSetuped = true
end)
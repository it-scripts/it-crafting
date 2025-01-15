CraftingTables = {}

---@class CraftingTable : OxClass
---@field id string
CraftingTable = lib.class('CraftingTable')

function CraftingTable:constructor(id, tableData)

    if Config.Debug then lib.print.info('[ProcessingTable:constructor] - Start constructing ProcessingTable with ID:', id) end

    ---@type string: The ID of the processing table
    self.id = id
    ---@type number: The entity of the processing table
    self.entity = nil
    ---@type string: The netId of the processing table
    self.netId = nil
    ---@type vector3: The coords of the processing table
    self.coords = tableData.coords
    ---@type number: The rotation of the processing table
    self.rotation = tableData.rotation
    ---@type string: The owner of the processing table
    self.owner = tableData.owner
    ---@type string: The type of the processing table
    self.tableType = tableData.tableType

    ---@type table: The recipe of the processing table
    self.recipes = {}

    self.inUse = false

    CraftingTables[self.id] = self

    if Config.Debug then lib.print.info('[ProcessingTable:constructor] - Finished constructing ProcessingTable with ID:', id) end
end

function CraftingTable:delete()
    self:destroyProp()
    CraftingTables[self.id] = nil
end

function CraftingTable:spawn()

    if Config.Debug then lib.print.info('[ProcessingTable:spawn] - Spawning ProcessingTable with ID:', self.id) end
    local modelHash = Config.CraftingTables[self.tableType].model

    local tableEntity = CreateObjectNoOffset(modelHash, self.coords.x, self.coords.y, self.coords.z, true, true, false)
    Wait(20)
    SetEntityHeading(tableEntity, self.rotation)
    FreezeEntityPosition(tableEntity, true)

    self.entity = tableEntity
    self.netId = NetworkGetNetworkIdFromEntity(tableEntity)

    CraftingTables[self.id] = self

    TriggerClientEvent('it-crafting:client:addTableBlip', -1, self.tableType, self.id)
    TriggerClientEvent('it-crafting:client:addTableZone', -1, self.tableType, self.id)

    if Config.Debug then lib.print.info('[ProcessingTable:spawn] - Finished spawning ProcessingTable with ID:', self.id) end
end

function CraftingTable:destroyProp()

    if Config.Debug then lib.print.info('[ProcessingTable:destroyProp] - Destroying ProcessingTable with ID:', self.id) end
    if not DoesEntityExist(self.entity) then return end
    DeleteEntity(self.entity)

    self.entity = nil
    self.netId = nil

    CraftingTables[self.id] = self

    TriggerClientEvent('it-crafting:client:removeTableBlip', -1, self.id)
    TriggerClientEvent('it-crafting:client:removeTableZone', -1, self.id)
end

function CraftingTable:useTable(bool)
    self.inUse = bool
end

function CraftingTable:getData()
    return {
        id = self.id,
        entity = self.entity,
        netId = self.netId,
        coords = self.coords,
        rotation = self.rotation,
        owner = self.owner,
        tableType = self.tableType,
        recipes = self.recipes,
        inUse = self.inUse
    }
end

--- Method to add a recipe to the processing table
---@param recipeid string: The ID of the recipe
---@param recipe Recipe: The recipe object
function CraftingTable:addRecipe(recipeid, recipe)
    self.recipes[recipeid] = recipe
    CraftingTables[self.id] = self
end

--- Method to remove a recipe from the processing table
--- @param recipeid string: The ID of the recipe
function CraftingTable:removeRecipe(recipeid)
    self.recipes[recipeid] = nil
    CraftingTables[self.id] = self
end

--- Method to get the recipe data from the processing table
--- @param recipeid string: The ID of the recipe
function CraftingTable:getRecipeData(recipeid)
    local recipe = self.recipes[recipeid]
    if not recipe then return nil end
    return recipe:getData()
end

function CraftingTable:getRecipes()
    local temp = {}

    for k, v in pairs(self.recipes) do
        temp[k] = v:getData()
    end

    return temp
end
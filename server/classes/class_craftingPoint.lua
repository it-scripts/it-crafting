CraftingPoints = {}

---@class CraftingPoint : OxClass
---@field id string
CraftingPoint = lib.class('CraftingPoint')

function CraftingPoint:constructor(id, pointData)

    if Config.Debug then lib.print.info('[CraftingPoint:constructor] - Start constructing CraftingPoint with ID:', id) end

    ---@type string: The ID of the crafting point
    self.id = id
    self.entity = nil
    ---@type string: The netId of the crafting point
    self.netId = nil
    ---@type vector3: The coords of the crafting point
    self.coords = pointData.coords
    ---@type number: The rotation of the crafting point
    self.rotation = pointData.rotation
    ---@type string: The type of the crafting point
    self.tableType = pointData.craftingType

    ---@type table: The recipes of the crafting point
    self.recipes = {}

    self.inUse = false

    CraftingPoints[self.id] = self

    if Config.Debug then lib.print.info('[CraftingPoint:constructor] - Finished constructing CraftingPoint with ID:', id) end
end

function CraftingPoint:delete()
    self:destroyProp()
    CraftingPoints[self.id] = nil
end

function CraftingPoint:spawn()

    if Config.CraftingPoints[self.id].model ~= nil then
        if Config.Debug then lib.print.info('[CraftingPoint:spawn] - Spawning CraftingPoint with ID:', self.id) end
        local modelHash = Config.CraftingPoints[self.id].model

        if modelHash == nil then
            if Config.Debug then lib.print.error('[CraftingPoint:spawn] - Model hash is nil for CraftingPoint with ID:', self.id) end
            return
        end

        local tableEntity = CreateObjectNoOffset(modelHash, self.coords.x, self.coords.y, self.coords.z, true, true, false)
        Wait(20)
        SetEntityHeading(tableEntity, self.rotation)
        FreezeEntityPosition(tableEntity, true)

        self.entity = tableEntity
        self.netId = NetworkGetNetworkIdFromEntity(tableEntity)

        CraftingPoints[self.id] = self

        if Config.Debug then lib.print.info('[CraftingPoint:spawn] - Finished spawning CraftingPoint with ID:', self.id) end
    end
end

function CraftingPoint:destroyProp()
    if Config.Debug then lib.print.info('[CraftingPoint:destroyProp] - Destroying CraftingPoint with ID:', self.id) end
    
    if not self.entity then return end
    
    if not DoesEntityExist(self.entity) then return end
    DeleteEntity(self.entity)

    self.entity = nil
    self.netId = nil

    CraftingPoints[self.id] = self
end

function CraftingPoint:useTable(bool)
    self.inUse = bool
end

function CraftingPoint:getData()
    return {
        id = self.id,
        entity = self.entity,
        netId = self.netId,
        coords = self.coords,
        rotation = self.rotation,
        tableType = self.tableType,
        recipes = self.recipes,
        inUse = self.inUse
    }
end

--- Method to add a recipe to the processing table
---@param recipeid string: The ID of the recipe
---@param recipe Recipe: The recipe object
function CraftingPoint:addRecipe(recipeid, recipe)
    self.recipes[recipeid] = recipe
    CraftingPoints[self.id] = self
end

--- Method to remove a recipe from the processing table
--- @param recipeid string: The ID of the recipe
function CraftingPoint:removeRecipe(recipeid)
    self.recipes[recipeid] = nil
    CraftingPoints[self.id] = self
end

--- Method to get the recipe data from the processing table
--- @param recipeid string: The ID of the recipe
function CraftingPoint:getRecipeData(recipeid)
    local recipe = self.recipes[recipeid]
    if not recipe then return nil end
    return recipe:getData()
end

function CraftingPoint:getRecipes()
    local temp = {}

    for k, v in pairs(self.recipes) do
        temp[k] = v:getData()
    end

    return temp
end
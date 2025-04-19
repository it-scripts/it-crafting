CraftingProps = {}

---@class CraftingPoint : OxClass
---@field id string
CraftingProp = lib.class('CraftingProp')

function CraftingProp:constructor(id, pointData)

    if Config.Debug then lib.print.info('[CraftingProp:constructor] - Start constructing CraftingProp with ID:', id) end

    ---@type string: The ID of the crafting point
    self.id = id
    self.model = pointData.model

    ---@type table: The recipes of the crafting point
    self.recipes = {}

    self.inUse = false

    CraftingProps[self.id] = self

    if Config.Debug then lib.print.info('[CraftingProp:constructor] - Finished constructing CraftingProp with ID:', id) end
end

function CraftingProp:useTable(bool)
    self.inUse = bool
end

function CraftingProp:getData()
    return {
        id = self.id,
        model = self.model,
        recipes = self.recipes,
        inUse = self.inUse
    }
end

--- Method to add a recipe to the processing table
---@param recipeid string: The ID of the recipe
---@param recipe Recipe: The recipe object
function CraftingProp:addRecipe(recipeid, recipe)
    self.recipes[recipeid] = recipe
    CraftingPoints[self.id] = self
end

--- Method to remove a recipe from the processing table
--- @param recipeid string: The ID of the recipe
function CraftingProp:removeRecipe(recipeid)
    self.recipes[recipeid] = nil
    CraftingPoints[self.id] = self
end

--- Method to get the recipe data from the processing table
--- @param recipeid string: The ID of the recipe
function CraftingProp:getRecipeData(recipeid)
    local recipe = self.recipes[recipeid]
    if not recipe then return nil end
    return recipe:getData()
end

function CraftingProp:getRecipes()
    local temp = {}

    for k, v in pairs(self.recipes) do
        temp[k] = v:getData()
    end

    return temp
end
---@class Recipe : OxClass
---@field id string
Recipe = lib.class('Recipe')

function Recipe:constructor(id, recipeData)
    self.id = id
    self.label = recipeData.label
    self.ingrediants = recipeData.ingrediants
    self.outputs = recipeData.outputs
    self.failChance = recipeData.failChance
    self.processTime = recipeData.processTime
    self.showIngrediants = recipeData.showIngrediants
    self.animation = recipeData.animation or {dict = 'anim@amb@drug_processors@coke@female_a@idles', name = 'idle_a',}
    self.particlefx = recipeData.particlefx or nil
    self.skillCheck = recipeData.skillCheck or nil
end

function Recipe:getData()
    return {
        id = self.id,
        label = self.label,
        ingrediants = self.ingrediants,
        outputs = self.outputs,
        failChance = self.failChance,
        processTime = self.processTime,
        showIngrediants = self.showIngrediants,
        animation = self.animation,
        particlefx = self.particlefx,
        skillCheck = self.skillCheck
    }
end
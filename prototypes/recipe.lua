
local def = require("defines")

data:extend({
    {
        type = "recipe",
        name = "stratagem-beacon-recipe",
        enable = true,
        results = {
            {type="item", name="stratagem-beacon-item", amount = 1}
        },
        ingredients = {
            {type = "item", name = "iron-plate", amount = 2}
        },
        recipe_category = "basic-crafting"
    }
})



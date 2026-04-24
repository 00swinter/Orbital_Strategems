local def = require("defines")

data:extend({
    {
        type = "recipe",
        name = "stratagem-beacon-recipe",
        enable = true,
        results = {
            { type = "item", name = "stratagem-beacon-item", amount = 1 }
        },
        ingredients = {
            { type = "item", name = "iron-plate", amount = 2 }
        },
        recipe_category = "basic-crafting"
    },
    {
        type = "recipe",
        name = "stratagem-hub-ui-recipe",
        enabled = true,
        results = {
            { type = "item", name = "iron-plate", amount = 1 }
        },
        ingredients = {
            { type = "item", name = "copper-ore", amount = 1},
            { type = "item", name = "copper-plate", amount = 1},
            { type = "item", name = "copper-cable", amount = 1},
            { type = "item", name = "iron-ore", amount = 1},
            { type = "item", name = "iron-plate", amount = 1},
            { type = "item", name = "iron-stick", amount = 1},
            { type = "item", name = "stone", amount = 1},
            { type = "item", name = "coal", amount = 1},
            { type = "item", name = "uranium-ore", amount = 1},
        },
        recipe_category = "basic-crafting",
    }
})

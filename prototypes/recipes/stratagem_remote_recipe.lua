local hd = require("lib.defines")

data:extend({
  {
    type = "recipe",
    name = hd.id.recipe.stratagem_remote,
    enabled = true,
    results = {
      {type = "item", name = hd.id.item.stratagem_remote, amount = 1}
    },
    category = "crafting"
  },
  {
    type = "recipe",
    name = hd.id.recipe.stratagem,
    enabled = true,
    results = {
      {type = "item", name = hd.id.item.stratagem, amount = 1}
    },
    ingredients = {
      {type = "item", name = "iron-plate", amount = 2}
    },
    category = "crafting"
  },
  {
    type = "recipe",
    name = hd.id.recipe.hellpod,
    enabled = true,
    results = {
      {type = "item", name = hd.id.item.hellpod, amount = 1}
    },
    ingredients = {
      {type = "item", name = "iron-plate", amount = 50}
    },
    category = "crafting"
  }
})

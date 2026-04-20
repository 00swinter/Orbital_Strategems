local hd = require("lib.defines")
local defs = require("prototypes.stratagem_defs")

local recipes = {
  {
    type = "recipe",
    name = hd.id.recipe.stratagem_beacon,
    enabled = true,
    results = {
      {type = "item", name = defs.beacon_item_name, amount = 1}
    },
    ingredients = {
      {type = "item", name = "iron-plate", amount = 1}
    },
    category = "crafting"
  }
}

for _, stratagem in ipairs(defs.entries) do
  recipes[#recipes + 1] = {
    type = "recipe",
    name = "recipe-hdm-remote-" .. stratagem.id,
    enabled = true,
    ingredients = {
      {type = "item", name = "electronic-circuit", amount = 2},
      {type = "item", name = "iron-gear-wheel", amount = 1}
    },
    results = {
      {type = "item", name = stratagem.remote_item_name, amount = 1}
    },
    category = "crafting"
  }

  recipes[#recipes + 1] = {
    type = "recipe",
    name = "recipe-hdm-hellpod-" .. stratagem.id,
    enabled = true,
    ingredients = {
      {type = "item", name = "steel-plate", amount = 10},
      {type = "item", name = "iron-gear-wheel", amount = 4}
    },
    results = {
      {type = "item", name = stratagem.hellpod_item_name, amount = 1}
    },
    category = "crafting"
  }
end

data:extend(recipes)

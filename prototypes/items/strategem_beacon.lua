local defs = require("prototypes.stratagem_defs")

data:extend({
  {
    type = "item",
    name = defs.beacon_item_name,
    icon = "__base__/graphics/icons/cluster-grenade.png",
    icon_size = 64,
    subgroup = "tool",
    order = "a[items]-b[stratagem-beacon]",
    stack_size = 200
  }
})

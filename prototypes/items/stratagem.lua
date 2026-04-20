local hd = require("lib.defines")

data:extend({
  {
    type = "item",
    name = hd.id.item.stratagem,
    icon = hd.mod_path .. "/graphics/icons/stratagem-item.png",
    icon_size = 64,
    subgroup = "tool",
    order = "a[items]-b[stratagem-item]",
    stack_size = 150,
    place_result = hd.id.entity.stratagem_marker
  }
})

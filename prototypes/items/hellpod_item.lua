local hd = require("lib.defines")

data:extend({
  {
    type = "item",
    name = hd.id.item.hellpod,
    icon = hd.mod_path .. "/graphics/icons/hellpod-icon.png",
    icon_size = 64,
    subgroup = "tool",
    order = "a[items]-b[hellpod-item]",
    stack_size = 100
  }
})

local hd = require("lib.defines")

data:extend({
  {
    type = "item",
    name = hd.id.item.space_building,
    icon = hd.mod_path .. "/graphics/icons/building-icon.png",
    icon_size = 64,
    subgroup = "tool",
    order = "a[items]-b[space-building-item]",
    stack_size = 5,
    place_result = hd.id.container.orbital_launcher
  }
})

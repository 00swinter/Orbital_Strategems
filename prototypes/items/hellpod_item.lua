local hd = require("lib.defines")
local defs = require("prototypes.stratagem_defs")

local pods = {
  {
    type = "item",
    name = hd.id.item.hellpod,
    icon = "__base__/graphics/icons/cargo-wagon.png",
    icon_size = 64,
    subgroup = "tool",
    order = "a[items]-b[hellpod-item]-legacy",
    stack_size = 100
  }
}

for _, stratagem in ipairs(defs.entries) do
  pods[#pods + 1] = {
    type = "item",
    name = stratagem.hellpod_item_name,
    icon = stratagem.hellpod_icon or "__base__/graphics/icons/cargo-wagon.png",
    icon_size = 64,
    subgroup = "tool",
    order = "a[items]-b[hellpod-item]-" .. stratagem.id,
    stack_size = 100,
    localised_name = {"", stratagem.display_name, " Hellpod"}
  }
end

data:extend(pods)

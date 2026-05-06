local def = require("defines")

data:extend({
    {
        type = "item",
        name = "space-hub",
        icon = def.path_generated.sprite("space_hub_sprite"),
        icon_size = 64,
        place_result = "space-hub",
        stack_size = 64
    },
    {
        type = "item",
        name = "stratagem-beacon-item",
        icon = "__Helldivers__/graphics/icons/stratagem_beacon_icon.png",
        icon_size = 64,
        subgroup = "stratagem-item-subgroup",
        order = "a[items]-b[stratagem-item]",
        stack_size = 150,
        place_result = "stratagem-beacon-entity"
    },
    {
        type = "item",
        name = def.prototype_names.crafting.empty_hellpod,
        icon = "__Helldivers__/graphics/icons/empty_hellpod_icon.png",
        icon_size = 64,
        subgroup = "stratagem-item-subgroup",
        order = "a[items]-b[stratagem-item]",
        stack_size = 150,
        place_result = "stratagem-beacon-entity"
    },
})

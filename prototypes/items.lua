local def = require("defines")

data:extend({
    {
        type = "item-group",
        name = "helldivers-mod-item-group",
        icon = "__Helldivers__/graphics/icons/stratagem-remote-item.png",
        icon_size = 64
    },
    {
        type = "item-subgroup",
        name = "stratagem-item-subgroup",
        group = "helldivers-mod-item-group"
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
    }
})

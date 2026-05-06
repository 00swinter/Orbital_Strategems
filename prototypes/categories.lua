local def = require("defines")

data:extend({
    {
        type = "item-group",
        name = "helldivers-mod-item-group",
        icon = "__Helldivers__/graphics/icons/stratagem_beacon_icon.png",
        icon_size = 64
    },
    {
        type = "item-subgroup",
        name = "stratagem-item-subgroup",
        group = "helldivers-mod-item-group"
    },
    {
        type = "item-subgroup",
        name = "hellpod-item-subgroup",
        group = "helldivers-mod-item-group"
    },
    {
        type = "item-subgroup",
        name = "ingredients-item-subgroup",
        group = "helldivers-mod-item-group"
    },


    {
        type = "ammo-category",
        name = "stratagem-ammo-category"
    },
    {
        type = "ammo-category",
        name = "autocannon-ammo-category"
    },

})


local def = require("defines")





local autocannon_ammo = table.deepcopy(data.raw["ammo"]["cannon-shell"])

autocannon_ammo.name = def.prototype_names.sentry.autocannon.ammo
autocannon_ammo.icon = def.MOD_PATH_NAME .. "/graphics/icons/autocannon_ammo_icon.png"
autocannon_ammo.icon_size = 64
autocannon_ammo.magazine_size = 3
autocannon_ammo.reload_time = 120
autocannon_ammo.ammo_category = "autocannon-ammo-category"




data:extend({
    autocannon_ammo
})
local def = require("defines")

local dynamic_base_path_autocannon = def.MOD_PATH_NAME ..
    "/graphics/dynamic/" .. def.prototype_names.hellpod_entities_short.sentry_autocannon .. "/"


function hd_autocannon_sheet(inputs)
    return {
        layers = {
            {
                filename = dynamic_base_path_autocannon .. "rotation_animation.png",
                priority = "medium",
                width = 720,
                height = 720,
                direction_count = 64,
                frame_count = 1,
                axially_symmetrical = false,
                line_length = 8,
                run_mode = inputs.run_mode or "forward",
                scale = 0.8,
                shift = { 0, 0 },
            }
        }
    }
end

local autocannon = table.deepcopy(data.raw["ammo-turret"]["gun-turret"])

autocannon.name = def.prototype_names_generated.hellpod_entity(def.prototype_names.hellpod_entities_short.sentry_autocannon)

autocannon.folded_animation = hd_autocannon_sheet {}
autocannon.folding_animation = hd_autocannon_sheet { run_mode = "backward" }
autocannon.prepared_animation = hd_autocannon_sheet {}
autocannon.preparing_animation = hd_autocannon_sheet {}
autocannon.attacking_animation = hd_autocannon_sheet {}

autocannon.attacking_speed = 1.015
autocannon.rotation_speed = 0.003
autocannon.preparing_speed = 1
autocannon.folding_speed = 1

autocannon_shoot_sound = table.deepcopy(data.raw["gun"]["tank-cannon"].attack_parameters.sound)
autocannon.flags = {
    "placeable-player", 
    "player-creation",
    "placeable-off-grid"
}
autocannon.attack_parameters = {
    type = "projectile",
    ammo_category = "autocannon-ammo-category",
    cooldown = 60,
    rotate_penalty = 1,
    projectile_creation_distance = 4,
    projectile_center = { 0, -0.7 }, -- same as gun_turret_attack shift
    shell_particle =
    {
        name = "artillery-shell-particle",
        direction = 0.45,
        direction_deviation = 0.02,
        speed = 0.05,
        speed_deviation = 0.02,
        center = { 0, 0 },
        creation_distance = -4.5,
        starting_frame_speed = 1,
        starting_frame_speed_deviation = 0.1,
        vertical_speed = 0.15,
        vertical_speed_deviation = 0.03
    },
    sound = autocannon_shoot_sound,
    range = 50,
    min_range = 6,
}




data:extend({
    autocannon,
    { -- temp only
        type = "item",
        name = def.prototype_names.sentry.autocannon.turret,
        icon = "__Helldivers__/graphics/icons/stratagem_beacon_icon.png",
        icon_size = 64,
        subgroup = "stratagem-item-subgroup",
        order = "a[items]-b[stratagem-item]",
        stack_size = 150,
        place_result = def.prototype_names_generated.hellpod_entity(def.prototype_names.hellpod_entities_short.sentry_autocannon)
    }
})

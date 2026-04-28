local def = require("defines")
local stratagem_def = require("prototypes.dynamic_stratagem_def")


local prototypes = {}

for _, stratagem in ipairs(stratagem_def) do
    local color_map = {
        white = { 0.1, 0.1, 0.1, 0.1 },
        red = { 0.1, 0.0, 0.0, 0.1 },
        green = { 0.0, 0.1, 0.0, 0.1 },
        blue = { 0.0, 0.0, 0.1, 0.1 },
    }

    -- the remotes to throw the beacons
    table.insert(prototypes, {
        type = "capsule",
        name = stratagem.name .. "-capsule",
        icon = stratagem.icon,
        icon_size = 32,
        stack_size = 1,
        flags = { "spawnable", "only-in-cursor", "not-stackable" },
        subgroup = "stratagem-item-subgroup",
        order = "a[" .. stratagem.color .. "]-a[" .. stratagem.name .. "]",

        capsule_action = {
            type = "throw",
            attack_parameters = {
                type = "projectile",
                range = stratagem.range,
                cooldown = stratagem.cooldown,
                ammo_category = "capsule",
                ammo_type = {
                    target_type = "position",
                    action = {
                        type = "direct",
                        action_delivery = {
                            type = "stream",
                            stream = stratagem.name .. "-stream"
                        }
                    }
                }
            },
            uses_stack = false
        },
        radius_color = color_map[stratagem.color]
    })

    -- the stream so the remote flys in arc
    table.insert(prototypes, {
        type = "stream",
        name = stratagem.name .. "-stream",
        flags = { "not-on-map" },
        hidden = true,
        oriented_particle = true,
        particle = {
            filename = "__base__/graphics/entity/grenade/grenade.png",
            width = 48,
            height = 54,
            animation_speed = 0.25,
            frame_count = 16,
            line_length = 8,
            shift = { 0.015625, 0.015625 },
            scale = 0.5
        },
        shadow = {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/grenade/grenade-shadow.png",
            width = 50,
            height = 40,
            animation_speed = 0.25,
            frame_count = 16,
            line_length = 8,
            shift = { 0.0625, 0.1875 },
            scale = 0.5
        },
        particle_buffer_size = 1,
        particle_end_alpha = 1,
        particle_fade_out_threshold = 1,
        particle_loop_exit_threshold = 1,
        particle_loop_frame_count = 1,
        particle_start_alpha = 1,
        particle_start_scale = 1,
        particle_spawn_interval = 0,
        particle_spawn_timeout = 1,

        particle_horizontal_speed = 0.7,
        particle_horizontal_speed_deviation = 0.05,
        particle_vertical_acceleration = 0.025,

        action = {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    {
                        type = "script",
                        effect_id = stratagem.name .. "#" .. def.script_trigger.hellpod_beacon_landed_ending
                    }
                }
            }
        },
        stream_light = {
            color = { r = 1, g = 1, b = 1 },
            intensity = 0.5,
            size = 2
        },
    })

    -- the recipes to craft the remotes
    table.insert(prototypes, {
        type = "recipe",
        name = stratagem.name .. "-recipe",
        enable = true,
        results = {
            { type = "item", name = stratagem.name .. "-capsule", amount = 1 }
        },
        recipe_category = "basic-crafting",
        icon = stratagem.icon,
        icon_size = 32
    })


    if stratagem.type == "hellpod" then
        -- the hellpod projectiles
        table.insert(prototypes, {

            type = "projectile",
            name = stratagem.name .. "-hellpod-projectile",
            acceleration = -0.005,
            light = { intensity = 3, size = 40 },
            action = {
                {
                    type = "area",
                    radius = 1.1,
                    action_delivery =
                    {
                        type = "instant",
                        target_effects =
                        {
                            {
                                type = "damage",
                                damage = { amount = 500, type = "explosion" }
                            },
                            {
                                type = "invoke-tile-trigger",
                                repeat_count = 3
                            },
                            {
                                type = "create-entity",
                                entity_name = "big-scorchmark-tintable",
                                check_buildability = true
                            },
                        }
                    }
                },
                {
                    type = "direct",
                    action_delivery = {
                        type = "instant",
                        target_effects =
                        {
                            {
                                type = "script",
                                effect_id = def.script_trigger.hellpod_smash
                            }
                        }
                    }
                },
                {
                    type = "direct",
                    action_delivery = {
                        type = "delayed",
                        delayed_trigger = def.MOD_PREFIX .. "hellpod-pop-animation-delayed-trigger"
                    }
                },
                {
                    type = "direct",
                    action_delivery = {
                        type = "delayed",
                        delayed_trigger = def.MOD_PREFIX .. "hellpod-spawn-container-delayed-trigger"
                    }
                }
            }
        })
    end






    -- table.insert(prototypes, {
    --     type = "capsule",
    --     name = props.name,
    --     icon = props.icon,
    --     icon_size = 32,
    --     subgroup = "stratagem-item-subgroup",
    --     order = "a[" .. props.color .. "]-a[" .. props.name .. "]",
    --     stack_size = 1,
    --     capsule_action = {
    --         type = "throw",
    --         uses_stack = false,
    --         attack_parameters = {
    --             type = "projectile",
    --             cooldown = props.cooldown,
    --             range = props.range,
    --             ammo_category = "capsule",
    --             ammo_type = {
    --                 action = {
    --                     type = "direct",
    --                     action_delivery = {
    --                         type = "projectile",
    --                         projectile = "stratagem-projectile",
    --                         starting_speed = 0.5,
    --                     }
    --                 }
    --             }
    --         }
    --     }
    -- })
end

data:extend(prototypes)

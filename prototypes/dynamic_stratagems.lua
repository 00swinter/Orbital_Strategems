local def = require("defines")
local stratagem_def = require("prototypes.dynamic_stratagem_def")


local prototypes = {}

local dynamic_base_path = def.MOD_PATH_NAME .. "/graphics/dynamic/"

for _, stratagem in ipairs(stratagem_def) do
    local color_map = {
        white = { 0.1, 0.1, 0.1, 0.1 },
        red = { 0.1, 0.0, 0.0, 0.1 },
        green = { 0.0, 0.1, 0.0, 0.1 },
        blue = { 0.0, 0.0, 0.1, 0.1 },
    }

    local spawn_delay = 0

    if stratagem.action.subtype == "mines" then
        spawn_delay = 128
    end

    -- the capsule     (remote) to throw the beacons
    table.insert(prototypes, {
        type = "capsule",
        name = def.prototype_names_generated.stratagem_capsule(stratagem.name),
        icon = dynamic_base_path .. stratagem.name .. "/remote_icon.png",
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
                            stream = def.prototype_names_generated.stratagem_stream(stratagem.name)
                        }
                    }
                }
            },
            uses_stack = false
        },
        radius_color = color_map[stratagem.color]
    })

    -- the stream       so the remote flys in arc
    table.insert(prototypes, {
        type = "stream",
        name = def.prototype_names_generated.stratagem_stream(stratagem.name),
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
                        effect_id = def.script_trigger_effect_generated(stratagem.name,
                            def.script_trigger_dynamic_type.stratagem_beacon_landed)
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

    -- the recipes       to craft the remotes
    table.insert(prototypes, {
        type = "recipe",
        name = def.prototype_names_generated.stratagem_recipe(stratagem.name),
        enable = true,
        results = {
            { type = "item", name = def.prototype_names_generated.stratagem_capsule(stratagem.name), amount = 1 }
        },
        recipe_category = "basic-crafting",
        icon = dynamic_base_path .. stratagem.name .. "/remote_icon.png",
        icon_size = 32
    })


    if stratagem.type == "hellpod" then
        -- the hellpod projectiles
        local hellpod_projectile = {
            type = "projectile",
            name = def.prototype_names_generated.hellpod_projectile(stratagem.name),
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
                        delayed_trigger = def.prototype_names_generated.delayed_trigger_rise_animation(stratagem.name)
                    }
                },
                {
                    type = "direct",
                    action_delivery = {
                        type = "delayed",
                        delayed_trigger = def.prototype_names_generated.delayed_trigger_spawn(stratagem.name)
                    }
                }
            }
        }

        if stratagem.action.subtype == "mines" then
            table.insert(hellpod_projectile.action, {
                type = "direct",
                action_delivery = {
                    type = "delayed",
                    delayed_trigger = def.prototype_names_generated.delayed_trigger_mines_deploy_animation(stratagem
                        .name)
                }
            })

            --delay trigger spawn mine projectiles distance 5
            table.insert(hellpod_projectile.action, {
                type = "direct",
                action_delivery = {
                    type = "delayed",
                    delayed_trigger = def.prototype_names_generated.delayed_mines_deploy_mines_projectiles(
                        stratagem.name, "5")
                }
            })

            --delay trigger spawn mine projectiles distance 10
            table.insert(hellpod_projectile.action, {
                type = "direct",
                action_delivery = {
                    type = "delayed",
                    delayed_trigger = def.prototype_names_generated.delayed_mines_deploy_mines_projectiles(
                        stratagem.name, "10")
                }
            })
        end

        table.insert(prototypes, hellpod_projectile)

        -- lid-corpse
        table.insert(prototypes, {
            type = "corpse",
            name = def.prototype_names_generated.hellpod_lid_corpse(stratagem.name),
            flags = {
                "placeable-neutral",
                "placeable-off-grid",
                "not-on-map"
            },
            icon = "__base__/graphics/icons/gun-turret.png",
            selectable_in_game = false,
            animation = {
                {
                    filename = "__Helldivers__/graphics/sprites/hellpod_container_lid_corpse_sprite.png",
                    width = 720,
                    height = 720,
                    scale = 0.8
                }
            },
            time_before_removed = 60 * 26,
            time_before_shading_off = 60 * 24,
        })

        -- delayed rise animation trigger
        table.insert(prototypes, {
            type = "delayed-active-trigger",
            name = def.prototype_names_generated.delayed_trigger_rise_animation(stratagem.name),
            delay = 60,
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
                                damage = { amount = 5000, type = "explosion" }
                            }
                        }
                    }
                },
                {
                    type = "direct",
                    action_delivery = {
                        type = "instant",
                        target_effects = {
                            {
                                type = "script",
                                effect_id = def.script_trigger_effect_generated(stratagem.name,
                                    def.script_trigger_dynamic_type.hellpod_rise_animation)
                            }
                        }
                    }
                }
            }
        })

        -- delayed spawn trigger
        table.insert(prototypes, {
            type = "delayed-active-trigger",
            name = def.prototype_names_generated.delayed_trigger_spawn(stratagem.name),
            delay = 130 + spawn_delay,
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
                                damage = { amount = 5000, type = "explosion" }
                            }
                        }
                    }
                },
                {
                    type = "direct",
                    action_delivery = {
                        type = "instant",
                        target_effects = {
                            {
                                type = "script",
                                effect_id = def.script_trigger_effect_generated(stratagem.name,
                                    def.script_trigger_dynamic_type.hellpod_spawn_result)
                            }
                        }
                    }
                }
            }
        })


        local projectile_spawn_delays = { -- duration 128 ticks  -> 8 launches each 16 ticks apart
            ["5"] = 130 + 16 * 1,
            ["10"] = 130 + 16 * 2,
        }



        -- delayed spawn projectiles trigger   DISTANCE 5
        table.insert(prototypes, {
            type = "delayed-active-trigger",
            name = def.prototype_names_generated.delayed_mines_deploy_mines_projectiles(stratagem.name, "5"),
            delay = projectile_spawn_delays["5"],
            action = {
                {
                    type = "direct",
                    action_delivery = {
                        type = "instant",
                        target_effects = {
                            {
                                type = "script",
                                effect_id = def.script_trigger_effect_generated(stratagem.name,
                                    def.script_trigger_dynamic_type.mines_spawn_projectiles, "5")
                            }
                        }
                    }
                }
            }
        })

        -- delayed spawn projectiles trigger   DISTANCE 5
        table.insert(prototypes, {
            type = "delayed-active-trigger",
            name = def.prototype_names_generated.delayed_mines_deploy_mines_projectiles(stratagem.name, "10"),
            delay = projectile_spawn_delays["10"],
            action = {
                {
                    type = "direct",
                    action_delivery = {
                        type = "instant",
                        target_effects = {
                            {
                                type = "script",
                                effect_id = def.script_trigger_effect_generated(stratagem.name,
                                    def.script_trigger_dynamic_type.mines_spawn_projectiles, "10")
                            }
                        }
                    }
                }
            }
        })


        --rise animation
        table.insert(prototypes, {
            type = "animation",
            name = def.prototype_names_generated.hellpod_rise_animation(stratagem.name),
            filename = dynamic_base_path .. stratagem.name .. "/rise_animation.png",
            width = 720,
            height = 720,
            scale = 0.8,
            frame_count = 36,
            line_length = 6
        })

        if stratagem.action.subtype == "mines" then
            -- delayed deploy animation trigger
            table.insert(prototypes, {
                type = "delayed-active-trigger",
                name = def.prototype_names_generated.delayed_trigger_mines_deploy_animation(stratagem.name),
                delay = 130,
                action = {
                    {
                        type = "direct",
                        action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "script",
                                    effect_id = def.script_trigger_effect_generated(stratagem.name,
                                        def.script_trigger_dynamic_type.mines_deploy_animation)
                                }
                            }
                        }
                    }
                }
            })

            --mine deploy animation
            table.insert(prototypes, {
                type = "animation",
                name = def.prototype_names_generated.hellpod_mines_deploy_animation(stratagem.name),
                filename = dynamic_base_path .. stratagem.name .. "/deploy_animation.png",
                width = 720,  --576,
                height = 720, --576,
                scale = 0.8,
                frame_count = 64,
                line_length = 8
            })

            --mines entity (the tower not the mines themselves)
            table.insert(prototypes, {
                type = "simple-entity",
                name = def.prototype_names_generated.hellpod_entity(stratagem.name),
                icon = dynamic_base_path .. stratagem.name .. "/remote_icon.png",
                icon_size = 32,
                flags = {
                    "placeable-neutral",
                    "placeable-player",
                    "placeable-off-grid",
                    "no-copy-paste"
                },
                selection_box = { { -1, -1 }, { 1, 1 } },
                collision_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
                tile_width = 1,
                tile_height = 1,
                picture = {
                    filename = dynamic_base_path .. stratagem.name .. "/sprite.png",
                    width = 720,
                    height = 720,
                    shift = { 0, 0 },
                    scale = 0.8
                },
                max_health = 100,
                minable = {
                    mining_time = 0.5,
                    result = "iron-plate"
                },
                created_smoke = {
                    type = "create-trivial-smoke",
                    smoke_name = "smoke-building",
                    offset_deviation = { { -0.2, -0.2 }, { 0.2, 0.2 } },
                    repeat_count = 80,
                    repeat_count_deviation = 0.1,
                    speed_from_center = 0.01,
                    speed_from_center_deviation = 0.1,
                    max_radius = 100
                },
                corpse = def.prototype_names.corpse.hellpod
            })

            -- the mine stream / projectile        so the mine flys in an arc
            table.insert(prototypes, {
                type = "stream",
                name = def.prototype_names_generated.mine_stream(stratagem.name),
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

                particle_horizontal_speed = 0.1,
                particle_horizontal_speed_deviation = 0.05,
                particle_vertical_acceleration = 0.003,

                action = {
                    type = "direct",
                    action_delivery = {
                        type = "instant",
                        target_effects = {
                            {
                                type = "create-entity",
                                entity_name = stratagem.action.mine_name,
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
        end
    end
end

data:extend(prototypes)

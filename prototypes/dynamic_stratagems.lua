local def = require("defines")
local stratagem_def = require("prototypes.dynamic_stratagem_def")


local prototypes = {}

local dynamic_base_path = def.MOD_PATH_NAME .. "/graphics/dynamic/"

local space_hub_fixed_recipe_ingredients = {}

for _, stratagem in ipairs(stratagem_def) do
    local color_map = {
        white = { 0.1, 0.1, 0.1, 0.1 },
        red = { 0.1, 0.0, 0.0, 0.1 },
        green = { 0.0, 0.1, 0.0, 0.1 },
        blue = { 0.0, 0.0, 0.1, 0.1 },
    }



    -- the capsule     (remote) to throw the beacons
    table.insert(prototypes, {
        type = "capsule",
        name = def.prototype_names_generated.stratagem_capsule(stratagem.name),
        icon = def.get_image(stratagem.name, def.image_type.remote_icon),
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


    -- the space-hub item that is used on stratagem use
    table.insert(prototypes, {
        type = "item",
        name = def.prototype_names_generated.space_hub_item(stratagem.name),
        icon = def.get_image(stratagem.name, def.image_type.space_hub_item_icon),
        icon_size = 32,
        stack_size = 100
    })

    --collect all space-hub-items in the fixed recipe
    table.insert(space_hub_fixed_recipe_ingredients, {
        type = "item",
        name = def.prototype_names_generated.space_hub_item(stratagem.name),
        amount = 50
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
        icon = def.get_image(stratagem.name, def.image_type.remote_icon),
        icon_size = 32
    })


    if stratagem.action.type == "hellpod" then
        
        
        local spawn_delay = 0

        if stratagem.action.subtype == "mines" then
            spawn_delay = 127
        elseif stratagem.action.subtype == "sentry" then
            spawn_delay = 64
        end


        -- the hellpod projectiles
        local hellpod_projectile = {
            type = "projectile",
            name = def.prototype_names_generated.hellpod_projectile(stratagem.name),
            acceleration = -0.005,
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



            local mines_deploy_progression = {
                start_tick = 170,
                end_tick = 220,
                repeat_count = 8,
                min_distance = 10,
                max_distance = 35,
            }

            -- register all the trigger for projectile spawn
            for i = 1, mines_deploy_progression.repeat_count do
                local fraction = (i - 1) / (mines_deploy_progression.repeat_count - 1)

                local current_dist = math.floor(mines_deploy_progression.min_distance +
                    fraction * (mines_deploy_progression.max_distance - mines_deploy_progression.min_distance) + 0.5)
                local current_delay = math.floor(mines_deploy_progression.start_tick +
                    fraction * (mines_deploy_progression.end_tick - mines_deploy_progression.start_tick) + 0.5)

                local dist_str = tostring(current_dist)

                table.insert(hellpod_projectile.action, {
                    type = "direct",
                    action_delivery = {
                        type = "delayed",
                        delayed_trigger = def.prototype_names_generated.delayed_trigger_mines_deploy_projectiles(
                            stratagem.name, dist_str)
                    }
                })

                table.insert(prototypes, {
                    type = "delayed-active-trigger",
                    name = def.prototype_names_generated.delayed_trigger_mines_deploy_projectiles(stratagem.name,
                        dist_str),
                    delay = current_delay,
                    action = {
                        {
                            type = "direct",
                            action_delivery = {
                                type = "instant",
                                target_effects = {
                                    {
                                        type = "script",
                                        effect_id = def.script_trigger_effect_generated(stratagem.name,
                                            def.script_trigger_dynamic_type.mines_spawn_projectiles, dist_str)
                                    }
                                }
                            }
                        }
                    }
                })
            end

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
                filename = def.get_image(stratagem.name, def.image_type.deploy_animation),
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
                icon = def.get_image(stratagem.name, def.image_type.remote_icon),
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
                    filename = def.get_image(stratagem.name, def.image_type.normal_sprite),
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
                    filename = def.get_image(stratagem.name, def.image_type.fly_animation),
                    width = 720,
                    height = 720,
                    animation_speed = 2,
                    frame_count = 16,
                    line_length = 4,
                    shift = { 0, 0 },
                    scale = 0.08
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
                particle_loop_exit_threshold = 16,
                particle_loop_frame_count = 16,
                particle_start_alpha = 1,
                particle_start_scale = 1,
                particle_spawn_interval = 0,
                particle_spawn_timeout = 1,

                particle_horizontal_speed = 0.2,
                particle_horizontal_speed_deviation = 0,
                particle_vertical_acceleration = 0.003,

                action = {
                    type = "direct",
                    action_delivery = {
                        type = "instant",
                        target_effects = {
                            {
                                type = "create-entity",
                                entity_name = stratagem.action.mine_name,
                                check_buildability = true
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

        if stratagem.action.subtype == "sentry" then

            --add trigger for sentry unfold 
            table.insert(hellpod_projectile.action, {
                type = "direct",
                action_delivery = {
                    type = "delayed",
                    delayed_trigger = def.prototype_names_generated.delayed_trigger_sentry_unfold_animation(stratagem.name)
                }
            })

            -- delayed unfold  animation trigger
            table.insert(prototypes, {
                type = "delayed-active-trigger",
                name = def.prototype_names_generated.delayed_trigger_sentry_unfold_animation(stratagem.name),
                delay = 130,
                action = {
                    {
                        type = "direct",
                        action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "script",
                                    effect_id = def.script_trigger_effect_generated(stratagem.name, def.script_trigger_dynamic_type.sentry_unfold_animation)
                                }
                            }
                        }
                    }
                }
            })

            --sentry unfold animation
            table.insert(prototypes, {
                type = "animation",
                name = def.prototype_names_generated.hellpod_sentry_unfold_animation(stratagem.name),
                filename = def.get_image(stratagem.name, def.image_type.unfold_animation),
                width = 720,
                height = 720,
                scale = 0.8,
                frame_count = 36,
                line_length = 6
            })
        end

        table.insert(prototypes, hellpod_projectile)


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
                            },
                            {
                                type = "create-particle",
                                particle_name = "hellpod-lid-particle",
                                initial_height = 0,
                                initial_vertical_speed = 0.17,
                                initial_vertical_speed_deviation = 0.05,
                                speed_from_center = 0.08,
                                speed_from_center_deviation = 0.02,
                                frame_speed = 0.4,
                                frame_speed_deviation = 0.2,
                                offset_deviation = { { -0.1, -0.1 }, { 0.1, 0.1 } },
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

        --rise animation
        table.insert(prototypes, {
            type = "animation",
            name = def.prototype_names_generated.hellpod_rise_animation(stratagem.name),
            filename = def.get_image(stratagem.name, def.image_type.rise_animation),
            width = 720,
            height = 720,
            scale = 0.8,
            frame_count = 36,
            line_length = 6
        })
    end
end



-- the space-hub-fixed recipe
table.insert(prototypes, {
    type = "recipe",
    name = "space-hub-fixed-recipe",
    enable = true,
    results = {
        { type = "item", name = "stratagem-beacon-item", amount = 1 }
    },
    ingredients = space_hub_fixed_recipe_ingredients,
    recipe_category = "basic-crafting"
})




data:extend(prototypes)

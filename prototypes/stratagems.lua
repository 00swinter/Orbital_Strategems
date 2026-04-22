local def = require("defines")
local stratagem_def = require("prototypes.stratagem_def")


local prototypes = {}

for _, stratagem in ipairs(stratagem_def) do

    local color_map = {
        white = {1, 1, 1, 1},
        red = {1, 0, 0, 1},
        green = {0, 1, 0, 1},
        blue = {0, 0, 1, 1}
    }

    table.insert(prototypes, {
        type = "capsule",
        name = stratagem.name .. "-capsule",
        icon = stratagem.icon,
        icon_size = 32,
        stack_size = 1,
        flags = {"spawnable", "only-in-cursor", "not-stackable"},
        subgroup = "stratagem-item-subgroup",
        order = "a[" .. stratagem.color .. "]-a[" .. stratagem.name .. "]",

        capsule_action = {
            type = "throw",
            attack_parameters = {
                type = "stream",
                range = stratagem.range,
                cooldown = stratagem.cooldown,
                ammo_category = "capsule",
                ammo_type = {
                    type = "direct",
                    action_delivery = {
                        type = "stream",
                        stream = stratagem.name .. "-stream"
                    }
                }
            },
            uses_stack = false
        },
        radius_color = color_map[stratagem.color]
    })


    table.insert(prototypes, {
        type = "stream",
        name = stratagem.name .. "-stream",
        particle_spawn_interval = 0,
        particle_spawn_timeout = 1,
        particle_horizontal_speed = 0.5,
        particle_horizontal_speed_deviation = 0.05,
        particle_vertical_acceleration = 0.01,
        action = {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    {
                        type = "create-entity",
                        entity_name = "stratagem-beacon-entity",
                    }
                }
            }
        },
    })

    table.insert(prototypes, {
        type = "recipe",
        name = stratagem.name .. "-recipe",
        enable = true,
        results = {
            {type="item", name=stratagem.name .. "-capsule", amount = 1}
        },
        recipe_category = "basic-crafting",
        icon = stratagem.icon,
        icon_size = 32
    })



    
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
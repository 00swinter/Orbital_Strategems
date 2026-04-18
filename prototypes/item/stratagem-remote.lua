data:extend({
    {
        type = "capsule",
        name = "stratagem-remote",
        icon = "__Orbital_Strategems__/graphics/icons/stratagem-remote-item.png",
        icon_size = 64,
        subgroup = "capsule",
        order = "a[grenade]-a[stratagem-remote]",
        stack_size = 1,
        capsule_action = {
            type = "throw",
            uses_stack = false,
            attack_parameters = {
                type = "projectile",
                cooldown = 10,
                range = 500,
                ammo_category = "capsule",
                ammo_type = {
                    action = {
                        type="direct",
                        action_delivery = {
                            type = "projectile",
                            projectile = "stratagem-projectile",
                            starting_speed = 0.5,
                        }
                    }
                }
                }
            }
    }
})

data:extend({
    {
        type = "delayed-active-trigger",
        name = "spawn-sentry-trigger",
        delay = 600,
        action = {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    {
                        type = "create-entity",
                        entity_name = "gun-turret",
                        find_non_colliding_position = true
                    }
                }
            }
        }
    }
})
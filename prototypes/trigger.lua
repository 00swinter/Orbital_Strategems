local def = require("defines")

data:extend({
    {
        type = "delayed-active-trigger",
        name = def.MOD_PREFIX .. "hellpod-pop-animation-delayed-trigger",
        delay = 60,
        action = {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    {
                        type = "script",
                        effect_id = def.script_trigger.hellpod_pop
                    }
                }
            }
        }
    },
})

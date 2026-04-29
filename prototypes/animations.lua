local def = require("defines")


data:extend({
    {
        type = "animation",
        name = "hellpod_falling_animation",
        filename = "__Helldivers__/graphics/animation/hellpod/hellpod_landing.png",
        width = 512,
        height = 512,
        scale = 0.6,
        frame_count = 15,
        line_length = 4,
        shift = { 0, -7 }
    },
    {
        type = "animation",
        name = "hellpod_smash_animation",
        filename = "__Helldivers__/graphics/animation/hellpod/hellpod_smash.png",
        width = 720,
        height = 720,
        scale = 0.8,
        frame_count = 36,
        line_length = 6,
        shift = { 0, 0 }
    },
    {
        type = "animation",
        name = "hellpod_pop_animation",
        filename = "__Helldivers__/graphics/animation/hellpod/hellpod_pop.png",
        width = 720,
        height = 720,
        scale = 0.8,
        frame_count = 36,
        line_length = 6,
        shift = { 0, 0 }
    },
    {
        type = "animation",
        name = def.prototype_names_generated.hellpod_rise_animation(def.prototype_names.hellpod_entities_short.container),
        filename = "__Helldivers__/graphics/animation/hellpod/hellpod_rise_container.png",
        width = 720,
        height = 720,
        scale = 0.8,
        frame_count = 36,
        line_length = 6,
        shift = { 0, 0 }
    },
    {
        type = "animation",
        name = def.prototype_names_generated.hellpod_rise_animation(def.prototype_names.hellpod_entities_short.gatling_gun),
        filename = "__Helldivers__/graphics/animation/hellpod/hellpod_rise_container.png",
        width = 720,
        height = 720,
        scale = 0.8,
        frame_count = 36,
        line_length = 6,
        shift = { 0, 0 }
    },
})

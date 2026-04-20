local hd = require("lib.defines")

data:extend({
  {
    type = "animation",
    name = hd.id.animation.hellpod_landing,
    filename = hd.mod_path .. "/graphics/animation/hellpod/hellpod_landing.png",
    width = 512,
    height = 512,
    scale = 0.6,
    frame_count = 15,
    line_length = 4,
    shift = {0, -7}
  }
})

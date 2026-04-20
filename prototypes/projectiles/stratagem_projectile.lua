local hd = require("lib.defines")

data:extend({
  {
    type = "projectile",
    name = hd.id.projectile.stratagem,
    flags = {"not-on-map"},
    acceleration = 0,
    action = {
      type = "direct",
      action_delivery = {
        type = "instant",
        target_effects = {
          {
            type = "script",
            effect_id = hd.id.effect.trigger_pod_drop
          },
          {
            type = "create-entity",
            entity_name = hd.id.entity.stratagem_marker
          }
        }
      }
    },
    animation = {
      filename = hd.mod_path .. "/graphics/sprites/stratagem-sprite.png",
      frame_count = 1,
      width = 64,
      height = 64,
      scale = 0.2,
      priority = "high"
    },
    shadow = {
      filename = hd.mod_path .. "/graphics/sprites/shadow.png",
      width = 64,
      height = 64,
      scale = 0.5,
      frame_count = 1,
      direction_count = 1
    }
  }
})

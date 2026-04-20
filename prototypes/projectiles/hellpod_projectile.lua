local hd = require("lib.defines")

data:extend({
  {
    type = "projectile",
    name = hd.id.projectile.hellpod,
    acceleration = -0.005,
    light = {intensity = 3, size = 40},
    action = {
      {
        type = "area",
        radius = 1.1,
        action_delivery = {
          type = "instant",
          target_effects = {
            {
              type = "damage",
              damage = {amount = 3500, type = "explosion"}
            },
            {
              type = "invoke-tile-trigger",
              repeat_count = 3
            },
            {
              type = "create-entity",
              entity_name = "big-scorchmark-tintable",
              check_buildability = true
            }
          }
        }
      }
    },
    final_action = {
      {
        type = "direct",
        action_delivery = {
          type = "instant",
          target_effects = {
            {
              type = "script",
              effect_id = hd.id.effect.trigger_hellpod_smash
            }
          }
        }
      }
    }
  }
})

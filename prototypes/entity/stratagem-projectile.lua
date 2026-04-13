data:extend({
  {
    type = "projectile",
    name = "stratagem-projectile",
    flags = {"not-on-map"},
    acceleration = 0.005,
    action = {
      type = "direct",
      action_delivery = {
        type = "instant",
        target_effects = {
          {
            type = "script",
            effect_id = "trigger_pod_drop"
          },
          {
            type = "create-entity",
            entity_name = "stratagem-entity",
          }
        }
      }
    },
    animation = {
      filename = "__Orbital_Strategems__/graphics/sprites/stratagem-sprite.png",
      frame_count = 1,
      width = 64,
      height = 64,
      scale= 0.2,
      priority = "high"
    },
    shadow = {
      filename = "__Orbital_Strategems__/graphics/sprites/shadow.png",
      width = 64,
      height = 64,
      scale = 0.5,
      frame_count = 1,
      direction_count = 1
    }
  }
  })
  
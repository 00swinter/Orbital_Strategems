data:extend({
  {
    type = "projectile",
    name = "sentry-pod",
    acceleration = -0.002,
    animation = {
      filename = "__base__/graphics/entity/grenade/grenade.png",
      draw_as_glow = true,
      frame_count = 15,
      line_length = 8,
      animation_speed = 0.250,
      width = 48,
      height = 54,
      shift = util.by_pixel(0.5, 0.5),
      priority = "high",
      scale = 0.5
    },
    smoke = {
      {
        name = "smoke",
        deviation = {0.5, 0.5},
        frequency = 2,
        position = {0, 0},
        starting_frame = 0,
        starting_frame_deviation = 5,
        starting_vertical_speed = -0.1,
      }
    },
    final_action = {
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
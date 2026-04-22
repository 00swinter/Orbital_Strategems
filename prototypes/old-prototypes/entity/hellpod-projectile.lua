data:extend({
  {
    type = "projectile",
    name = "hellpod-projectile",
    acceleration = -0.005,
    light = {intensity = 3, size = 40},
    action =
    {
      {
        type = "area",
        radius = 1.1,
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
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
            },
          }
        }
      },
      
    },
    final_action = {
      {
        type = "direct",
        action_delivery = {
          type = "delayed",
          delayed_trigger = "spawn-sentry-trigger"
        }
      },
      {
        type = "direct",
        action_delivery = {
          type = "instant",
          target_effects =
          {
            {
              type = "script",
              effect_id = "trigger_hellpod_smash"
            }
          }
        }
      }
    }
  }
})
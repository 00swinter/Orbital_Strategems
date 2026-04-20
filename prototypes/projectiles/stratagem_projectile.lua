local hd = require("lib.defines")
local defs = require("prototypes.stratagem_defs")

local projectiles = {
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
      filename = hd.mod_path .. "/graphics/icons/stratagem-remote-item.png",
      frame_count = 1,
      width = 64,
      height = 64,
      scale = 0.2,
      priority = "high"
    },
    shadow = {
      filename = hd.mod_path .. "/graphics/icons/stratagem-remote-item.png",
      width = 64,
      height = 64,
      scale = 0.2,
      frame_count = 1,
      direction_count = 1
    }
  }
}

for _, stratagem in ipairs(defs.entries) do
  projectiles[#projectiles + 1] = {
    type = "projectile",
    name = stratagem.capsule_name,
    flags = {"not-on-map"},
    acceleration = 0,
    action = {
      type = "direct",
      action_delivery = {
        type = "instant",
        target_effects = {
          {
            type = "script",
            effect_id = stratagem.drop_effect_id
          },
          {
            type = "create-entity",
            entity_name = hd.id.entity.stratagem_marker
          }
        }
      }
    },
    animation = {
      filename = hd.mod_path .. "/graphics/icons/stratagem-remote-item.png",
      frame_count = 1,
      width = 64,
      height = 64,
      scale = 0.2,
      priority = "high"
    },
    shadow = {
      filename = hd.mod_path .. "/graphics/icons/stratagem-remote-item.png",
      width = 64,
      height = 64,
      scale = 0.2,
      frame_count = 1,
      direction_count = 1
    }
  }
end

data:extend(projectiles)

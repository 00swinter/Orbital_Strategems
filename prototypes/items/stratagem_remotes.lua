local defs = require("prototypes.stratagem_defs")

local remotes = {}

for _, stratagem in ipairs(defs.entries) do
  remotes[#remotes + 1] = {
    type = "capsule",
    name = stratagem.remote_item_name,
    icon = stratagem.icon,
    icon_size = 64,
    subgroup = "capsule",
    order = "a[grenade]-b[stratagem-remote]-" .. stratagem.id,
    stack_size = 1,
    localised_name = {"", stratagem.display_name, " Remote"},
    capsule_action = {
      type = "throw",
      uses_stack = false,
      attack_parameters = {
        type = "projectile",
        cooldown = 10,
        range = 500,
        ammo_category = "capsule",
        ammo_type = {
          action = {
            type = "direct",
            action_delivery = {
              type = "projectile",
              projectile = stratagem.capsule_name,
              starting_speed = 0.5
            }
          }
        }
      }
    }
  }
end

data:extend(remotes)

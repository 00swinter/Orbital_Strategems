local hd = require("lib.defines")

local defs = {}

defs.prefix = "hdv"
defs.default_beacon_cost = 1
defs.beacon_item_name = hd.id.item.stratagem_beacon

defs.entries = {
  {
    id = "machine-gun-sentry",
    display_name = "Machine Gun Sentry",
    icon = "__base__/graphics/icons/gun-turret.png",
    hellpod_icon = "__base__/graphics/icons/cargo-wagon.png",
    beacon_cost = 1,
    cooldown_ticks = 0,
    action_type = "deploy_entity",
    action_params = {
      entity_name = "gun-turret"
    }
  },
  {
    id = "incendiary-minefield",
    display_name = "Incendiary Minefield",
    icon = "__base__/graphics/icons/land-mine.png",
    hellpod_icon = "__base__/graphics/icons/cargo-wagon.png",
    beacon_cost = 1,
    cooldown_ticks = 0,
    action_type = "deploy_minefield",
    action_params = {}
  }
}

local function build_names(entry)
  entry.remote_item_name = "item-hdm-remote-" .. entry.id
  entry.capsule_name = "projectile-hdm-stratagem-" .. entry.id
  entry.hellpod_item_name = "item-hdm-hellpod-" .. entry.id
  entry.drop_effect_id = "effect-hdm-stratagem-drop-" .. entry.id
  return entry
end

for _, entry in ipairs(defs.entries) do
  build_names(entry)
end

function defs.by_drop_effect_id()
  local result = {}
  for _, entry in ipairs(defs.entries) do
    result[entry.drop_effect_id] = entry
  end
  return result
end

function defs.by_id()
  local result = {}
  for _, entry in ipairs(defs.entries) do
    result[entry.id] = entry
  end
  return result
end

return defs

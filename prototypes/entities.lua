local def = require("defines")


local newContainer = table.deepcopy(data.raw["container"]["steel-chest"])

newContainer.inventory_type = "with_filters_and_bar"
newContainer.name = "test-container"

data:extend({
  newContainer,
})




data:extend({
  {
    type = "simple-entity",
    name = "stratagem-beacon-entity",
    icon = "__Helldivers__/graphics/icons/stratagem_beacon_icon.png",
    icon_size = 64,
    flags = {
      "placeable-neutral",
      "placeable-player",
      "placeable-off-grid",
      "no-copy-paste"
    },
    selection_box = { { -0.3, -0.3 }, { 0.3, 0.3 } },
    collision_box = { { 0, 0 }, { 0, 0 } },
    tile_width = 1,
    tile_height = 1,
    picture = {
      filename = "__Helldivers__/graphics/sprites/stratagem_beacon_sprite.png",
      width = 720,
      height = 720,
      shift = { 0, 0 },
      scale = 0.04
    },
    max_health = 100,
    minable = {
      mining_time = 0.5,
      result = "iron-plate"
    },
    created_smoke = {
      type = "create-trivial-smoke",
      smoke_name = "smoke-building",
      offset_deviation = { { -0.2, -0.2 }, { 0.2, 0.2 } },
      repeat_count = 80,
      repeat_count_deviation = 0.1,
      speed_from_center = 0.01,
      speed_from_center_deviation = 0.1,
      max_radius = 100
    }
  },
  {
    type = "simple-entity",
    name = def.prototype_names_generated.hellpod_entity(def.prototype_names.hellpod_entities_short.container),
    icon = "__Helldivers__/graphics/icons/stratagem-item.png",
    icon_size = 64,
    flags = {
      "placeable-neutral",
      "placeable-player",
      "placeable-off-grid",
      "no-copy-paste"
    },
    selection_box = { { -1, -1 }, { 1, 1 } },
    collision_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    tile_width = 1,
    tile_height = 1,
    picture = {
      filename = "__Helldivers__/graphics/sprites/hellpod_container_sprite.png",
      width = 720,
      height = 720,
      shift = { 0, 0 },
      scale = 0.8
    },
    max_health = 100,
    minable = {
      mining_time = 0.5,
      result = "iron-plate"
    },
    created_smoke = {
      type = "create-trivial-smoke",
      smoke_name = "smoke-building",
      offset_deviation = { { -0.2, -0.2 }, { 0.2, 0.2 } },
      repeat_count = 80,
      repeat_count_deviation = 0.1,
      speed_from_center = 0.01,
      speed_from_center_deviation = 0.1,
      max_radius = 100
    },
    corpse = def.prototype_names.corpse.hellpod
  },
  {
    type = "simple-entity",
    name = def.prototype_names_generated.hellpod_entity(def.prototype_names.hellpod_entities_short.gatling_gun),
    icon = "__Helldivers__/graphics/icons/stratagem-item.png",
    icon_size = 64,
    flags = {
      "placeable-neutral",
      "placeable-player",
      "placeable-off-grid",
      "no-copy-paste"
    },
    selection_box = { { -1, -1 }, { 1, 1 } },
    collision_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    tile_width = 1,
    tile_height = 1,
    picture = {
      filename = "__Helldivers__/graphics/sprites/hellpod_container_sprite.png",
      width = 720,
      height = 720,
      shift = { 0, 0 },
      scale = 0.8
    },
    max_health = 100,
    minable = {
      mining_time = 0.5,
      result = "iron-plate"
    },
    created_smoke = {
      type = "create-trivial-smoke",
      smoke_name = "smoke-building",
      offset_deviation = { { -0.2, -0.2 }, { 0.2, 0.2 } },
      repeat_count = 80,
      repeat_count_deviation = 0.1,
      speed_from_center = 0.01,
      speed_from_center_deviation = 0.1,
      max_radius = 100
    },
    corpse = def.prototype_names.corpse.hellpod,
    dying_explosion = "gun-turret-explosion",
  },
  {
    type = "corpse",
    name = def.prototype_names.corpse.hellpod,
    flags = {"placeable-neutral", "not-on-map"},
    icon = "__base__/graphics/icons/gun-turret.png",
    selectable_in_game = false,
    animation = {
      {
        filename = "__Helldivers__/graphics/sprites/hellpod_corpse_sprite.png",
        width = 720,
        height = 720,
        scale = 0.8
      }
    },
    time_before_removed = 60*60,
    time_before_shading_off = 60*57,
  }
})

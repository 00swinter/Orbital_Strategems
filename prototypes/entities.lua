data:extend({
  {
    type = "simple-entity",
    name = "stratagem-beacon-entity",
    icon = "__Helldivers__/graphics/icons/stratagem-item.png",
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
      filename = "__Helldivers__/graphics/sprites/stratagem-sprite.png",
      width = 64,
      height = 64,
      shift = { 0, 0 },
      scale = 0.3
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
  }
})

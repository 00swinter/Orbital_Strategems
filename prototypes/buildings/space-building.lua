data:extend({
  {
    type = "container",
    name = "orbital_launcher_building",
    icon = "__Orbital_Strategems__/graphics/icons/building-icon.png",
    icon_size = 64,
    flags = {"placeable-player", "player-creation"},
    max_health = 300,
    inventory_size = 5,
    picture = {
      filename = "__Orbital_Strategems__/graphics/sprites/building-sprite.png",
      width = 64,
      height = 64,
      scale = 1.3
    },
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
  }
})
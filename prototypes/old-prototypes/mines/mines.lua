data:extend({
  {
    type = "item",
    name = "orbital-incendiary-land-mine",
    icon = "__base__/graphics/icons/land-mine.png",
    icon_size = 64,
    subgroup = "defensive-structure",
    order = "f[land-mine]-d[incendiary]",
    place_result = "orbital-incendiary-land-mine",
    stack_size = 100
  },

  {
    type = "recipe",
    name = "orbital-incendiary-land-mine",
    category = "chemistry",
    enabled = false,
    energy_required = 20,
    ingredients = {
      {type = "item", name = "steel-plate", amount = 1},
      {type = "item", name = "explosives", amount = 2},
      {type = "fluid", name = "light-oil", amount = 80},
      {type = "fluid", name = "heavy-oil", amount = 80}
    },
    results = {
      {type = "item", name = "orbital-incendiary-land-mine", amount = 4}
    }
  },

  {
    type = "technology",
    name = "orbital-incendiary-land-mine",
    icon = "__base__/graphics/technology/land-mine.png",
    icon_size = 256,
    effects = {
      {type = "unlock-recipe", recipe = "orbital-incendiary-land-mine"}
    },
    prerequisites = {"land-mine", "flamethrower"},
    unit = {
      count = 100,
      ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"military-science-pack", 1}
      },
      time = 30
    },
    order = "e-e"
  },

  {
    type = "projectile",
    name = "orbital-incendiary-fire-projectile",
    flags = {"not-on-map"},
    hidden = true,
    acceleration = 0.001,
    action = {
      type = "direct",
      action_delivery = {
        type = "instant",
        target_effects = {
          {
            type = "create-fire",
            entity_name = "fire-flame",
            initial_ground_flame_count = 5
          }
        }
      }
    },
    animation = {
      filename = "__base__/graphics/entity/grenade/grenade-shadow.png",
      frame_count = 1,
      width = 24,
      height = 24,
      priority = "high"
    }
  },

  {
    type = "land-mine",
    name = "orbital-incendiary-land-mine",
    icon = "__base__/graphics/icons/land-mine.png",
    icon_size = 64,
    flags = {
      "placeable-player",
      "placeable-enemy",
      "player-creation",
      "placeable-off-grid",
      "not-on-map",
      "no-copy-paste",
      "not-selectable-in-game",
      "not-upgradable",
      "not-in-kill-statistics",
      "not-repairable",
      "not-blueprintable"
    },
    minable = {mining_time = 0.5, result = "orbital-incendiary-land-mine"},
    create_ghost_on_death = false,
    alert_when_damaged = false,
    max_health = 15,
    resistances = {{type = "fire", percent = 100}},
    corpse = "land-mine-remnants",
    dying_trigger_effect = {
      {
        type = "create-entity",
        entity_name = "small-scorchmark",
        check_buildability = true
      },
      {
        type = "nested-result",
        action = {
          type = "cluster",
          cluster_count = 150,
          distance = 2,
          distance_deviation = 2,
          action_delivery = {
            type = "projectile",
            projectile = "orbital-incendiary-fire-projectile",
            direction_deviation = 0.7,
            starting_speed = 0.15,
            starting_speed_deviation = 0.2
          }
        }
      },
      {
        type = "show-explosion-on-chart",
        scale = 0.25
      }
    },

    collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    trigger_radius = 2.5,
    ammo_category = "landmine",

    picture_safe = {
      filename = "__base__/graphics/entity/land-mine/land-mine.png",
      priority = "medium",
      width = 64,
      height = 64,
      scale = 0.5
    },
    picture_set = {
      filename = "__base__/graphics/entity/land-mine/land-mine-set.png",
      priority = "medium",
      width = 64,
      height = 64,
      scale = 0.5
    },
    picture_set_enemy = {
      filename = "__base__/graphics/entity/land-mine/land-mine-set-enemy.png",
      priority = "medium",
      width = 32,
      height = 32,
      scale = 1
    },

    action = {
      type = "direct",
      action_delivery = {
        type = "instant",
        source_effects = {
          {
            type = "create-entity",
            entity_name = "small-scorchmark",
            check_buildability = true
          },

          -- Fire carpet: creates flames even on empty ground.
          {
            type = "nested-result",
            action = {
              type = "cluster",
              cluster_count = 150,
              distance = 2,
              distance_deviation = 2,
              action_delivery = {
                type = "projectile",
                projectile = "orbital-incendiary-fire-projectile",
                direction_deviation = 0.7,
                starting_speed = 0.15,
                starting_speed_deviation = 0.2
              }
            }
          },

          {type = "show-explosion-on-chart", scale = 0.25}
        }
      }
    }
  }
})

data:extend({
  {
    type = "item",
    name = "orbital-minefield-deployer",
    icon = "__base__/graphics/icons/land-mine.png",
    icon_size = 64,
    subgroup = "defensive-structure",
    order = "f[land-mine]-z[minefield-deployer]",
    place_result = "orbital-minefield-deployer",
    stack_size = 20
  },
  {
    type = "recipe",
    name = "orbital-minefield-deployer",
    enabled = false,
    energy_required = 2,
    ingredients = {
      {type = "item", name = "orbital-incendiary-land-mine", amount = 16},
      {type = "item", name = "electronic-circuit", amount = 4}
    },
    results = {
      {type = "item", name = "orbital-minefield-deployer", amount = 1}
    }
  },
  {
    type = "simple-entity",
    name = "orbital-minefield-deployer",
    icon = "__base__/graphics/icons/land-mine.png",
    icon_size = 64,
    flags = {
      "placeable-player",
      "player-creation",
      "placeable-off-grid",
      "not-on-map"
    },
    selectable_in_game = false,
    collision_box = {{0, 0}, {0, 0}},
    selection_box = {{-0.1, -0.1}, {0.1, 0.1}},
    max_health = 1,
    render_layer = "object",
    picture = {
      filename = "__core__/graphics/empty.png",
      width = 1,
      height = 1
    }
  },
  {
    type = "projectile",
    name = "orbital-minefield-mine-projectile",
    flags = {"not-on-map"},
    hidden = true,
    acceleration = 0.005,
    action = {
      type = "direct",
      action_delivery = {
        type = "instant",
        target_effects = {
          {
            type = "create-entity",
            show_in_tooltip = true,
            entity_name = "orbital-incendiary-land-mine"
          }
        }
      }
    },
    animation = {
      filename = "__base__/graphics/entity/grenade/grenade-shadow.png",
      frame_count = 1,
      width = 24,
      height = 24,
      priority = "high"
    }
  }
})

if data.raw.technology["orbital-incendiary-land-mine"] then
  table.insert(
    data.raw.technology["orbital-incendiary-land-mine"].effects,
    {type = "unlock-recipe", recipe = "orbital-minefield-deployer"}
  )
else
  data.raw.recipe["orbital-minefield-deployer"].enabled = true
end
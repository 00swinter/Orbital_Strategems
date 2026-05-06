local def = require("defines")

local dynamic_base_path_incendary = def.MOD_PATH_NAME .. "/graphics/dynamic/" .. def.prototype_names.hellpod_entities_short.mines_incendary .. "/"
local dynamic_base_path_gas = def.MOD_PATH_NAME .. "/graphics/dynamic/" .. def.prototype_names.hellpod_entities_short.mines_gas .. "/"


local firemine = table.deepcopy(data.raw["land-mine"]["land-mine"])

firemine.name = "fire-mine"
firemine.picture_safe = {
    filename = dynamic_base_path_incendary .. "mine_safe_sprite.png",
    priority = "medium",
    width = 720,
    height = 720,
    scale = 0.08
}
firemine.picture_set = {
    filename = dynamic_base_path_incendary .. "mine_set_sprite.png",
    priority = "medium",
    width = 720,
    height = 720,
    scale = 0.08
}
firemine.picture_set_enemy = {
    filename = dynamic_base_path_incendary .. "mine_set_enemy_sprite.png",
    priority = "medium",
    width = 720,
    height = 720,
    scale = 0.08
}

firemine.dying_trigger_effect = {
    {
        type = "create-entity",
        entity_name = "small-scorchmark",
        check_buildability = true
    },
    {
        type = "nested-result",
        action = {
            type = "cluster",
            cluster_count = 50,
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
}
firemine.light = { intensity = 3, size = 40 }

firemine.action = {
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
                    cluster_count = 50,
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

            { type = "show-explosion-on-chart", scale = 0.25 }
        }
    }
}

-- GAS MINES

-- local gasmine = table.deepcopy(data.raw["land-mine"]["land-mine"])

-- gasmine.name = "gas-mine"
-- gasmine.picture_safe = {
--     filename = dynamic_base_path_gas .. "mine_safe_sprite.png",
--     priority = "medium",
--     width = 720,
--     height = 720,
--     scale = 0.08
-- }
-- gasmine.picture_set = {
--     filename = dynamic_base_path_gas .. "mine_set_sprite.png",
--     priority = "medium",
--     width = 720,
--     height = 720,
--     scale = 0.08
-- }
-- gasmine.picture_set_enemy = {
--     filename = dynamic_base_path_gas .. "mine_set_enemy_sprite.png",
--     priority = "medium",
--     width = 720,
--     height = 720,
--     scale = 0.08
-- }

-- gasmine.dying_trigger_effect = {
--     {
--         type = "create-entity",
--         entity_name = "small-scorchmark",
--         check_buildability = true
--     },
--     {
--         type = "nested-result",
--         action = {
--             type = "cluster",
--             cluster_count = 150,
--             distance = 2,
--             distance_deviation = 2,
--             action_delivery = {
--                 type = "projectile",
--                 projectile = "orbital-incendiary-fire-projectile",
--                 direction_deviation = 0.7,
--                 starting_speed = 0.15,
--                 starting_speed_deviation = 0.2
--             }
--         }
--     },
--     {
--         type = "show-explosion-on-chart",
--         scale = 0.25
--     }
-- }
-- gasmine.light = { intensity = 3, size = 40 }

-- gasmine.action = {
--     type = "direct",
--     action_delivery = {
--         type = "instant",
--         source_effects = {
--             {
--                 type = "create-entity",
--                 entity_name = "small-scorchmark",
--                 check_buildability = true
--             },

--             -- Fire carpet: creates flames even on empty ground.
--             {
--                 type = "nested-result",
--                 action = {
--                     type = "cluster",
--                     cluster_count = 150,
--                     distance = 2,
--                     distance_deviation = 2,
--                     action_delivery = {
--                         type = "projectile",
--                         projectile = "orbital-incendiary-fire-projectile",
--                         direction_deviation = 0.7,
--                         starting_speed = 0.15,
--                         starting_speed_deviation = 0.2
--                     }
--                 }
--             },

--             { type = "show-explosion-on-chart", scale = 0.25 }
--         }
--     }
-- }


data:extend({
    firemine,
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
})







-- local old = {
--     type = "land-mine",
--     name = "fire-mine",
--     icon = "__base__/graphics/icons/land-mine.png",
--     flags =
--     {
--       "placeable-player",
--       "placeable-enemy",
--       "player-creation",
--       "placeable-off-grid",
--       "not-on-map"
--     },
--     minable = {mining_time = 0.5, result = "land-mine"},
--     fast_replaceable_group = "land-mine",
--     mined_sound = sounds.deconstruct_small(1.0),
--     max_health = 15,
--     corpse = "land-mine-remnants",
--     dying_explosion = "land-mine-explosion",
--     collision_box = {{-0.4,-0.4}, {0.4, 0.4}},
--     selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
--     damaged_trigger_effect = hit_effects.entity(),
--     open_sound = sounds.machine_open,
--     close_sound = sounds.machine_close,

--     trigger_radius = 2.5,
--     ammo_category = "landmine",
--     action =
--     {
--       type = "direct",
--       action_delivery =
--       {
--         type = "instant",
--         source_effects =
--         {
--           {
--             type = "nested-result",
--             affects_target = true,
--             action =
--             {
--               type = "area",
--               radius = 6,
--               force = "enemy",
--               action_delivery =
--               {
--                 type = "instant",
--                 target_effects =
--                 {
--                   {
--                     type = "damage",
--                     damage = { amount = 250, type = "explosion"}
--                   },
--                   {
--                     type = "create-sticker",
--                     sticker = "stun-sticker"
--                   }
--                 }
--               }
--             }
--           },
--           {
--             type = "create-entity",
--             entity_name = "explosion"
--           },
--           {
--             type = "damage",
--             damage = { amount = 1000, type = "explosion"}
--           }
--         }
--       }
--     }
--   }

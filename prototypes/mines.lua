local def = require("defines")
local dynamic_base_path = def.MOD_PATH_NAME .. "/graphics/dynamic/"


local firemine = table.deepcopy(data.raw["land-mine"]["land-mine"])

firemine.name = "fire-mine"
firemine.picture_safe = {
    filename = dynamic_base_path .. "mines_incendary/mine_safe_sprite.png",
    priority = "medium",
    width = 720,
    height = 720,
    scale = 0.08
}
firemine.picture_set = {
    filename = dynamic_base_path .. "mines_incendary/mine_set_sprite.png",
    priority = "medium",
    width = 720,
    height = 720,
    scale = 0.08
}
firemine.picture_set_enemy = {
    filename = dynamic_base_path .. "mines_incendary/mine_set_enemy_sprite.png",
    priority = "medium",
    width = 720,
    height = 720,
    scale = 0.08
}

data:extend({
    firemine
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


local def = require("defines")

local default = {
    range = 50,
    cooldown = 60, -- 1 sec
    color = "white",
    icon = def.MOD_PATH_NAME .. "/graphics/icons/stratagems/remote_01.png"
}

local stratagem_definitions = {
    {
        name = "stratagem-remote",
        icon = def.MOD_PATH_NAME .. "/graphics/icons/stratagems/remote_01.png"
    },
    {
        name = def.MOD_PREFIX .. "container",
        icon = def.MOD_PATH_NAME .. "/graphics/icons/stratagems/remote_02.png"
    }
}



local function merge_defaults(definition)
    local merged = {}
    for k, v in pairs(default) do
        merged[k] = v
    end
    for k, v in pairs(definition) do
        merged[k] = v
    end
    return merged
end

local prototypes = {
    {
        type = "item-group",
        name = "helldivers-mod-item-group",
        icon = "__Helldivers__/graphics/icons/stratagem-remote-item.png",
        icon_size = 64
    },
    {
        type = "item-subgroup",
        name = "stratagem-item-subgroup",
        group = "helldivers-mod-item-group"
    },
    {
        type = "custom-input",
        name = "helldivers_cancel",
        key_sequence = "CONTROL + E",
        consuming = "game-only"
    },
    {
        type = "custom-input",
        name = "helldivers_arrow_up",
        key_sequence = "CONTROL + W",
        consuming = "game-only"
    },
    {
        type = "custom-input",
        name = "helldivers_arrow_down",
        key_sequence = "CONTROL + S",
        consuming = "game-only"
    },
    {
        type = "custom-input",
        name = "helldivers_arrow_right",
        key_sequence = "CONTROL + D",
        consuming = "game-only"
    },
    {
        type = "custom-input",
        name = "helldivers_arrow_left",
        key_sequence = "CONTROL + A",
        consuming = "game-only"
    }
}

for _, strat in ipairs(stratagem_definitions) do
    local props = merge_defaults(strat)

    table.insert(prototypes, {
        type = "item",
        name = props.name,
        icon = props.icon,
        icon_size = 32,
        stack_size = 1,
        flags = {"spawnable", "only-in-cursor", "not-stackable"},
        subgroup = "stratagem-item-subgroup",
        order = "a[" .. props.color .. "]-a[" .. props.name .. "]"
    })
    
    -- table.insert(prototypes, {
    --     type = "capsule",
    --     name = props.name,
    --     icon = props.icon,
    --     icon_size = 32,
    --     subgroup = "stratagem-item-subgroup",
    --     order = "a[" .. props.color .. "]-a[" .. props.name .. "]",
    --     stack_size = 1,
    --     capsule_action = {
    --         type = "throw",
    --         uses_stack = false,
    --         attack_parameters = {
    --             type = "projectile",
    --             cooldown = props.cooldown,
    --             range = props.range,
    --             ammo_category = "capsule",
    --             ammo_type = {
    --                 action = {
    --                     type = "direct",
    --                     action_delivery = {
    --                         type = "projectile",
    --                         projectile = "stratagem-projectile",
    --                         starting_speed = 0.5,
    --                     }
    --                 }
    --             }
    --         }
    --     }
    -- })
end

data:extend(prototypes)




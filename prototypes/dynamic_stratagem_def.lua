local def = require("defines")


local default = {
    --type = "hellpod", --  "hellpod" | "eagle" | "orbital",
    --name = def.MOD_PREFIX .. "unnamed-stratagem",
    range = 50,
    cooldown = 15,
    color = "white",  --  "white" | "red" | "green" | "blue"
    --icon = def.MOD_PATH_NAME .. "/graphics/icons/stratagems/remote_01.png",
    --arrows = {"Up", "RIGHT", "DOWN", "LEFT"}
}



local stratagems = {
    {
        type = "hellpod",
        name = def.prototype_names.hellpod_entities_short.gatling_gun,
        icon = def.MOD_PATH_NAME .. "/graphics/icons/stratagems/remote_01.png",
        arrows = {"Up", "RIGHT", "DOWN", "DOWN", "DOWN"},
        color = "red",
        action = {
            type = "hellpod",
            subtype = "sentry",
            ammo = "normal ammo",
        }
    },
    {
        type = "hellpod",
        name = def.prototype_names.hellpod_entities_short.resupply,
        icon = def.MOD_PATH_NAME .. "/graphics/icons/stratagems/remote_02.png",
        arrows = {"DOWN", "DOWN", "UP", "RIGHT"},
        color = "blue",
        action = {
            type = "hellpod",
            subtype = "container",
            items = {
                {name = "iron-plate", count = 100},
                {name = "copper-plate", count = 100},
                {name = "coal", count = 100},
                {name = "stone", count = 100}
            }
        }
    },
    {
        type = "hellpod",
        name = def.prototype_names.hellpod_entities_short.mines_incendary,
        icon = def.MOD_PATH_NAME .. "/graphics/icons/stratagems/remote_02.png",
        arrows = {"DOWN", "LEFT", "LEFT", "DOWN"},
        color = "red",
        action = {
            type = "hellpod",
            subtype = "mines",
            mine_name = "fire-mine";
        }
    },
    {
        type = "hellpod",
        name = def.prototype_names.hellpod_entities_short.sentry_autocannon,
        arrows = {"DOWN", "DOWN", "DOWN", "DOWN"},
        color = "red",
        action = {
            type = "hellpod",
            subtype = "sentry",
            ammo = { type = "item", name = "name", amount = 5 }
        }
    }
}

-- Merge defaults into each entry
for _, stratagem in ipairs(stratagems) do
    for key, value in pairs(default) do
        if stratagem[key] == nil then
            stratagem[key] = value
        end
    end
end

return stratagems

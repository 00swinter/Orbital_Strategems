local def = require("defines")


local default = {
    type = "hellpod", --  "hellpod" | "eagle" | "orbital",
    name = def.MOD_PREFIX .. "unnamed-stratagem",
    range = 50,
    cooldown = 10, -- 1 sec
    color = "white",  --  "white" | "red" | "green" | "blue"
    icon = def.MOD_PATH_NAME .. "/graphics/icons/stratagems/remote_01.png",
    arrows = {"Up", "RIGHT", "DOWN", "LEFT"}
}

local stratagems = {
    {
        type = "hellpod",
        name = "gatling-gun",
        icon = def.MOD_PATH_NAME .. "/graphics/icons/stratagems/remote_01.png",
        arrows = {"Up", "RIGHT", "DOWN", "DOWN", "DOWN"},
        color = "red"
    },
    {
        type = "hellpod",
        name = "container",
        icon = def.MOD_PATH_NAME .. "/graphics/icons/stratagems/remote_02.png",
        arrows = {"DOWN", "UP", "RIGHT", "LEFT"},
        color = "blue"
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

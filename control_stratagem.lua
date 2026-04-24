local def = require("defines")
local stratagem_def = require("prototypes.dynamic_stratagem_def")


local LANDED_TRIGGER_TAG = "-stratagem-beacon-landed-trigger"

local function splitByHash(text)
    local parts = {}
    for part in string.gmatch(text, "([^#]+)") do
        table.insert(parts, part)
    end
    return parts
end

local function renderAnimation(target, surface, animation_name, frames_num, speed, render_layer, time_to_live)
    local offset = -(game.tick * speed) % frames_num

    rendering.draw_animation {
        target = target,
        surface = surface,
        animation = animation_name,
        animation_offset = offset,
        animation_speed = speed,
        render_layer = render_layer,
        time_to_live = time_to_live
    }
end

local function spawnHellpod(event, stratagem_data)
    local current_surface = game.surfaces[event.surface_index]
    local destination = event.target_position

    if current_surface and destination then
        local elevated_position = {
            x = destination.x,
            y = destination.y - 200
        }

        local hellpod_projectile = current_surface.create_entity {
            name = stratagem_data.name .. "-hellpod-projectile",
            position = elevated_position,
            target = destination,
            speed = 1.9
        }

        renderAnimation(
            hellpod_projectile,
            current_surface,
            "hellpod_falling_animation",
            15,
            0.25,
            "air-object",
            500
        )
    end
end


local function handleLandedTrigger(event)
    local effect_name = event.effect_id
    if type(effect_name) ~= "string" then return end

    local parts = splitByHash(effect_name)
    if #parts < 2 then return end

    if parts[#parts] ~= def.script_trigger.hellpod_beacon_landed_ending then return end

    local stratagem_name = parts[1]
    if stratagem_name == "" then return end


    local surface = game.surfaces[1]       -- or get the surface from event if available
    local position = event.target_position -- The position where the effect triggered


    --check if available
    local stratagem_data
    for _, stratagem in ipairs(stratagem_def) do
        if stratagem.name == stratagem_name then
            stratagem_data = stratagem
        else
            break
        end
    end

    --spawn result
    if stratagem_data.type == "hellpod" then
        spawnHellpod(event, stratagem_data)
    end



    -- local chest = surface.create_entity({
    --     name = "steel-chest",
    --     position = position,
    --     player = event.source_entity.player,
    --     force = "player"
    -- })

    --chest.operable = false;






    --game.print("Stratagem beacon landed for: " .. stratagem_data.name)
end






script.on_event(defines.events.on_script_trigger_effect, function(event)
    --game.print(event.effect_id)
    handleLandedTrigger(event)

    local current_surface = game.surfaces[event.surface_index]
    local destination = event.target_position

    if event.effect_id == def.script_trigger.hellpod_smash then
        renderAnimation(
            destination,
            current_surface,
            "hellpod_smash_animation",
            36,
            0.5,
            "lower-object-above-shadow",
            70
        )
    end

    if event.effect_id == def.script_trigger.hellpod_pop then
        renderAnimation(
            destination,
            current_surface,
            "hellpod_pop_animation",
            36,
            0.5,
            "lower-object-above-shadow",
            70
        )
    end
end)







-- script.on_event(defines.events.on_script_trigger_effect, function(event)
--     if event.effect_id == "trigger_pod_drop" then

--         local current_surface = game.surfaces[event.surface_index]
--         local destination = event.target_position

--         if current_surface and destination then

--             local elevated_position = {
--                 x = destination.x,
--                 y = destination.y - 200
--             }

--             local sentry_pod = current_surface.create_entity{
--                 name = "hellpod-projectile",
--                 position = elevated_position,
--                 target = destination,
--                 speed = 1.9
--             }

--             local frames = 15
--             local speed = 0.25
--             local offset = -(game.tick * speed) % frames

--             rendering.draw_animation{
--                 target = sentry_pod,
--                 surface = current_surface,
--                 animation = "hellpod_landing_animation",
--                 animation_offset = offset,
--                 animation_speed = speed,
--                 render_layer = "air-object",
--             }
--         end
--     end

--     if event.effect_id == "trigger_hellpod_smash" then

--         local current_surface = game.surfaces[event.surface_index]
--         local destination = event.target_position

--         if current_surface and destination then
--             local frames = 36
--             local speed = 0.5
--             local offset = -(game.tick * speed) % frames


--             rendering.draw_animation{
--                 target = destination,
--                 surface = current_surface,
--                 animation = "hellpod_smash_animation",
--                 time_to_live = 70,
--                 animation_offset = offset,
--                 animation_speed = speed,
--                 render_layer = "lower-object-above-shadow",
--             }
--         end
--     end
-- end)

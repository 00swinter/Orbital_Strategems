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


local function handle_beacon_landed(event, name)
    local surface = game.surfaces[event.surface_index]
    local position = event.target_position

    --check if available

    --spawn entity

    local elevated_position = {
        x = position.x,
        y = position.y - 200
    }

    local hellpod_projectile = surface.create_entity {
        name = def.prototype_names_generated.hellpod_projectile(name),
        position = elevated_position,
        target = position,
        speed = 1.9
    }

    renderAnimation(
        hellpod_projectile,
        surface,
        "hellpod_falling_animation",
        15,
        0.25,
        "air-object",
        500
    )


    --spawn beacon
    surface.create_entity({
        name = "stratagem-beacon-entity",
        position = position,
        player = event.source_entity.player,
        force = "player"
    })
end

local function handle_hellpod_spawn_entity(event, name)
    local surface = game.surfaces[event.surface_index]
    local position = event.target_position

    surface.create_entity({
        name = def.prototype_names_generated.hellpod_entity(name),
        position = position,
    })

    surface.create_entity({
        name = def.prototype_names_generated.hellpod_lid_corpse(name),
        position = position,
    })
end

local function handle_hellpod_rise_animation(event, name)
    local surface = game.surfaces[event.surface_index]
    local position = event.target_position

    renderAnimation(
        position,
        surface,
        def.prototype_names_generated.hellpod_rise_animation(name),
        36,
        0.5,
        "lower-object-above-shadow",
        70
    )
end

local function handle_mines_deploy_animation(event, name)
    local surface = game.surfaces[event.surface_index]
    local position = event.target_position

    renderAnimation(
        position,
        surface,
        def.prototype_names_generated.hellpod_mines_deploy_animation(name),
        64,
        0.5,
        "lower-object-above-shadow",
        128
    )
end

local function handle_mines_spawn_projectiles(event, name, extra)
    local surface = game.surfaces[event.surface_index]
    local position = event.target_position


    for i = 1, 6 do

        local target_position = {
            x = position.x + math.cos((i-1) * math.pi/3) * extra * 1,
            y = position.y + math.sin((i-1) * math.pi/3) * extra * 1
        }

        local mine_projectile = surface.create_entity {
            name = def.prototype_names_generated.mine_stream(name),
            position = position,
            source_position = position,
            target_position = target_position,
        }
    end
end

local function handleDynamicTrigger(event) -- Prefix # name # type # script_trigger
    local effect_id = event.effect_id
    if type(effect_id) ~= "string" then return end

    local parts = splitByHash(effect_id)

    if #parts ~= 5 then return end

    local trigger_name = parts[2]
    local trigger_type = parts[3]
    local trigger_extra = parts[4]

    if trigger_name == "" or trigger_type == "" then return end


    if trigger_type == def.script_trigger_dynamic_type.stratagem_beacon_landed then
        handle_beacon_landed(event, trigger_name)
    elseif trigger_type == def.script_trigger_dynamic_type.hellpod_spawn_result then
        handle_hellpod_spawn_entity(event, trigger_name)
    elseif trigger_type == def.script_trigger_dynamic_type.hellpod_rise_animation then
        handle_hellpod_rise_animation(event, trigger_name)
    elseif trigger_type == def.script_trigger_dynamic_type.mines_deploy_animation then
        handle_mines_deploy_animation(event, trigger_name)
    elseif trigger_type == def.script_trigger_dynamic_type.mines_spawn_projectiles then
        handle_mines_spawn_projectiles(event, trigger_name, trigger_extra)
    end
end





script.on_event(defines.events.on_script_trigger_effect, function(event)
    handleDynamicTrigger(event)

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

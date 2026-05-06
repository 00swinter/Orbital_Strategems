local def = require("defines")
local stratagem_def = require("prototypes.dynamic_stratagem_def")
local vector2 = require("vector2")

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


local function check_stratagem_availability(event, name)
    local surface = event.surface_index and game.surfaces[event.surface_index]
    local item_name = def.prototype_names_generated.space_hub_item(name)

    local player = event.source_entity and event.source_entity.player
    local playerForce = player and player.force

    local forcePlatforms = playerForce and playerForce.platforms

    local platforms_in_orbit = {}


    for _, platform in pairs(forcePlatforms) do
        local location = platform.space_location

        if location.name == surface.planet.name then
            table.insert(platforms_in_orbit, platform)
        end
    end

    if platforms_in_orbit == {} then
        return {
            status = false,
            reason = "you need a space platform with a space-hub to use stratagems"
        }
    end

    local space_hubs_tried_for_removal = 0


    for _, platforms_in_orbit in pairs(platforms_in_orbit) do
        if storage.space_hubs and storage.space_hubs[platforms_in_orbit.index] then
            -- found a spacehub in orbit, now check if it has the required item

            local hub = storage.space_hubs[platforms_in_orbit.index]
            local inventory = hub.get_inventory(defines.inventory.crafter_input)

            local removed_item_count = inventory.remove({ name = item_name, count = 1 })

            if removed_item_count > 0 then
                return {
                    status = true,
                    reason = "..."
                }
            else
                space_hubs_tried_for_removal = space_hubs_tried_for_removal + 1
            end
        else
            -- no spacehub found on this platform in orbit

        end
    end

    if space_hubs_tried_for_removal > 0 then
        return {
            status = false,
            reason = "none of the space-hubs in orbit has the required hellpod for you request"
        }
    else
        return {
            status = false,
            reason = "you dont have any space-hubs in the orbit of this planet, you need at least one to use stratagems"
        }
    end
        
end

local function handle_beacon_landed(event, name)
    local surface = game.surfaces[event.surface_index]
    local position = event.target_position


    --check if available
    local availability_result = check_stratagem_availability(event, name)

    --spawn entity

    if availability_result.status == false then
        game.print(availability_result.reason)
        return
    end

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
        127
    )
end

local function handle_mines_spawn_projectiles(event, name, extra)
    local surface = game.surfaces[event.surface_index]
    local position = event.target_position

    local distance = tonumber(extra) or 1
    local golden_angle = math.pi * (3 - math.sqrt(5))

    for i = 1, 6 do
        local unique_seed = distance * 10 + i

        local angle = unique_seed * golden_angle
        local radius = distance * 0.8

        local target_position = {
            x = position.x + math.cos(angle) * radius,
            y = position.y + math.sin(angle) * radius
        }
        local direction = vector2.normalize(vector2.sub(target_position, position))

        local min_spawn_distance = 0.5
        local max_spawn_distance = 1.5

        local min_spawn_height = -1.3
        local max_spawn_height = -0.3

        local distance_factor = (distance - 10) / 25

        local spawn_distance = distance_factor * (max_spawn_distance - min_spawn_distance) + min_spawn_distance

        local spawn_height = distance_factor * (max_spawn_height - min_spawn_height) + min_spawn_height

        local spawn_position = vector2.add(position, vector2.scale(direction, spawn_distance))

        spawn_position = vector2.add(spawn_position, { x = 0, y = spawn_height })

        local mine_projectile = surface.create_entity {
            name = def.prototype_names_generated.mine_stream(name),
            position = spawn_position,
            source_position = spawn_position,
            target_position = target_position,
            force = "player",
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



local function enforce_single_space_hub(event)
    local entity = event.entity or event.created_entity or event.destination
    if not (entity and entity.valid) then return end

    game.print("sdasd")

    if entity.name == "space-hub" then
        local surface = entity.surface

        storage.space_hubs = storage.space_hubs or {}
        local existing_hub = storage.space_hubs[surface.index]

        if existing_hub and existing_hub.valid then
            local item_to_return = "space-hub"

            if event.player_index then
                local player = game.get_player(event.player_index)
                player.insert({ name = item_to_return, count = 1 })
                player.create_local_flying_text {
                    text = "Only one Helldivers_space_hub allowed per surface",
                    position = entity.position
                }
            else
                surface.spill_item_stack {
                    position = entity.position,
                    stack = { name = item_to_return, count = 1 }
                }
            end

            entity.destroy()
        else
            storage.space_hubs[surface.index] = entity
        end

        --game.print(serpent.block(storage.space_hubs))
        --game.print(serpent.block(entity.get_main_inventory()))

        --local hub = storage.space_hubs[surface.index]

        --local inventory = hub.get_inventory(defines.inventory.crafter_input)

        --game.print(serpent.block(inventory.get_contents()))
    end
end


local build_events = {
    defines.events.on_built_entity,
    defines.events.on_robot_built_entity,
    defines.events.on_space_platform_built_entity,
    defines.events.on_entity_cloned,
    defines.events.script_raised_built,
    defines.events.script_raised_revive
}

script.on_event(build_events, enforce_single_space_hub)






local function handle_building_removal(event)
    local entity = event.entity
    if not (entity and entity.valid) then return end

    if entity.name == "space-hub" then
        storage.space_hubs[entity.surface.index] = nil
    end
end

local remove_events = {
    defines.events.on_player_mined_entity,
    defines.events.on_robot_mined_entity,
    defines.events.on_entity_died,
    defines.events.script_raised_destroy
}

script.on_event(remove_events, handle_building_removal)

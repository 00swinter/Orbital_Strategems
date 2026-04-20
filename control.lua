local hd = require("lib.defines")

local minefield_deployer_name = hd.id.entity.minefield_deployer
local minefield_projectile_name = hd.id.projectile.minefield_mine
local minefield_count = 24
local minefield_radius = 10

local hellpod_projectile_name = hd.id.projectile.hellpod
local hellpod_smash_effect_id = hd.id.effect.trigger_hellpod_smash
local hellpod_drop_effect_id = hd.id.effect.trigger_pod_drop
local hellpod_smash_ttl = 70
local hellpod_pop_ttl = 70

local stratagem_order = {
    hd.id.item.stratagem
}

local stratagem_defs = {
    [hd.id.item.stratagem] = {
        pop_animation = hd.id.animation.hellpod_pop,
        deploy = function(surface, destination, force_name)
            surface.create_entity{
                name = "gun-turret",
                position = destination,
                force = force_name,
                find_non_colliding_position = true
            }
        end
    }
}

local function ensure_globals()
    storage.pending_stratagem_by_player = storage.pending_stratagem_by_player or {}
    storage.hellpod_payload_by_projectile = storage.hellpod_payload_by_projectile or {}
    storage.queued_pop_events = storage.queued_pop_events or {}
end

script.on_init(ensure_globals)
script.on_configuration_changed(ensure_globals)

local function consume_stratagem_item(player)
    local inventory = player.get_inventory(defines.inventory.character_main)
    if not inventory then return nil end

    for _, item_name in ipairs(stratagem_order) do
        if inventory.get_item_count(item_name) > 0 then
            player.remove_item({name = item_name, count = 1})
            return item_name
        end
    end
    return nil
end

local function queue_pop_event(surface_index, destination, force_name, stratagem_name)
    storage.queued_pop_events[#storage.queued_pop_events + 1] = {
        due_tick = game.tick + hellpod_smash_ttl,
        surface_index = surface_index,
        destination = {x = destination.x, y = destination.y},
        force_name = force_name,
        stratagem_name = stratagem_name
    }
end

local function deploy_hellpod(current_surface, destination, force_name, stratagem_name)
    local elevated_position = {
        x = destination.x,
        y = destination.y - 200
    }

    local pod = current_surface.create_entity{
        name = hellpod_projectile_name,
        position = elevated_position,
        target = destination,
        speed = 1.9,
        force = force_name
    }

    if pod and pod.valid and pod.unit_number then
        storage.hellpod_payload_by_projectile[pod.unit_number] = {
            stratagem_name = stratagem_name,
            force_name = force_name
        }
    end

    local frames = 15
    local speed = 0.25
    local offset = -(game.tick * speed) % frames

    rendering.draw_animation{
        target = pod,
        surface = current_surface,
        animation = hd.id.animation.hellpod_landing,
        animation_offset = offset,
        animation_speed = speed,
        render_layer = "air-object"
    }
end

local function handle_pod_drop_trigger(event)
    local current_surface = game.surfaces[event.surface_index]
    local destination = event.target_position
    if not (current_surface and destination) then return end

    local player_index = event.source_player_index
    local pending_name = player_index and storage.pending_stratagem_by_player[player_index] or nil
    local stratagem_name = pending_name or hd.id.item.stratagem

    if player_index then
        storage.pending_stratagem_by_player[player_index] = nil
    end

    local force_name = "player"
    local source_entity = event.source_entity
    if source_entity and source_entity.valid and source_entity.force then
        force_name = source_entity.force.name
    elseif player_index and game.players[player_index] and game.players[player_index].valid then
        force_name = game.players[player_index].force.name
    end

    deploy_hellpod(current_surface, destination, force_name, stratagem_name)
end

local function handle_pod_smash_trigger(event)
    local current_surface = game.surfaces[event.surface_index]
    local destination = event.target_position
    if not (current_surface and destination) then return end

    local frames = 36
    local speed = 0.5
    local offset = -(game.tick * speed) % frames

    rendering.draw_animation{
        target = destination,
        surface = current_surface,
        animation = hd.id.animation.hellpod_smash,
        time_to_live = hellpod_smash_ttl,
        animation_offset = offset,
        animation_speed = speed,
        render_layer = "lower-object-above-shadow"
    }

    local force_name = "player"
    local stratagem_name = hd.id.item.stratagem
    local source_entity = event.source_entity

    if source_entity and source_entity.valid and source_entity.force then
        force_name = source_entity.force.name
        if source_entity.unit_number then
            local payload = storage.hellpod_payload_by_projectile[source_entity.unit_number]
            if payload then
                stratagem_name = payload.stratagem_name or stratagem_name
                force_name = payload.force_name or force_name
                storage.hellpod_payload_by_projectile[source_entity.unit_number] = nil
            end
        end
    end

    queue_pop_event(event.surface_index, destination, force_name, stratagem_name)
end

local function deploy_minefield(entity)
    if not (entity and entity.valid) then return end
    if entity.name ~= minefield_deployer_name then return end

    local surface = entity.surface
    local origin = entity.position

    for i = 1, minefield_count do
        local angle = (2 * math.pi) * (i - 1) / minefield_count
        local target = {
            x = origin.x + math.cos(angle) * minefield_radius,
            y = origin.y + math.sin(angle) * minefield_radius
        }

        surface.create_entity{
            name = minefield_projectile_name,
            position = origin,
            target = target,
            speed = 0.3,
            force = entity.force
        }
    end

    surface.create_entity{
        name = "big-explosion",
        position = origin
    }

    entity.destroy()
end

script.on_event(defines.events.on_player_used_capsule, function(event)
    ensure_globals()

    local player = game.players[event.player_index]
    local capsule = event.item
    if not (player and capsule and capsule.name == hd.id.item.stratagem_remote) then return end

    local stratagem_name = consume_stratagem_item(player)
    if stratagem_name then
        storage.pending_stratagem_by_player[event.player_index] = stratagem_name
        return
    end

    local projectiles = player.surface.find_entities_filtered({
        name = hd.id.projectile.stratagem,
        radius = 2,
        position = player.position
    })
    for _, entity in pairs(projectiles) do
        entity.destroy()
    end
end)

script.on_event(defines.events.on_script_trigger_effect, function(event)
    ensure_globals()

    if event.effect_id == hellpod_drop_effect_id then
        handle_pod_drop_trigger(event)
        return
    end

    if event.effect_id == hellpod_smash_effect_id then
        handle_pod_smash_trigger(event)
    end
end)

script.on_event(defines.events.on_tick, function()
    ensure_globals()

    local queue = storage.queued_pop_events
    if #queue == 0 then return end

    local keep = {}
    for _, queued in ipairs(queue) do
        if queued.due_tick > game.tick then
            keep[#keep + 1] = queued
        else
            local surface = game.surfaces[queued.surface_index]
            local def = stratagem_defs[queued.stratagem_name] or stratagem_defs[hd.id.item.stratagem]

            if surface then
                local pop_speed = 0.5
                local pop_frames = 36
                local pop_offset = -(game.tick * pop_speed) % pop_frames

                rendering.draw_animation{
                    target = queued.destination,
                    surface = surface,
                    animation = def.pop_animation or hd.id.animation.hellpod_pop,
                    time_to_live = hellpod_pop_ttl,
                    animation_offset = pop_offset,
                    animation_speed = pop_speed,
                    render_layer = "object"
                }

                if def.deploy then
                    def.deploy(surface, queued.destination, queued.force_name)
                end
            end
        end
    end

    storage.queued_pop_events = keep
end)

local function on_entity_built(event)
    local entity = event.entity or event.created_entity or event.destination
    deploy_minefield(entity)
end

script.on_event(defines.events.on_built_entity, on_entity_built)
script.on_event(defines.events.on_robot_built_entity, on_entity_built)
script.on_event(defines.events.script_raised_built, on_entity_built)
script.on_event(defines.events.script_raised_revive, on_entity_built)
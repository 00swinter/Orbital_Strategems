local hd = require("lib.defines")
local stratagem_defs = require("prototypes.stratagem_defs")
local orbit_inventory = require("scripts.orbit_inventory")

local runtime = {}

local minefield_deployer_name = hd.id.entity.minefield_deployer
local minefield_projectile_name = hd.id.projectile.minefield_mine
local minefield_count = 24
local minefield_radius = 10

local hellpod_projectile_name = hd.id.projectile.hellpod
local hellpod_smash_effect_id = hd.id.effect.trigger_hellpod_smash
local hellpod_smash_ttl = 70
local hellpod_pop_ttl = 70

local stratagem_by_effect_id = stratagem_defs.by_drop_effect_id()
local stratagem_by_id = stratagem_defs.by_id()

local function ensure_globals()
  storage.hellpod_payload_by_projectile = storage.hellpod_payload_by_projectile or {}
  storage.queued_pop_events = storage.queued_pop_events or {}
end

local function notify_player(player, message_key, details)
  if not (player and player.valid) then return end
  if details then
    player.print({"", "[Helldivers] ", {"", message_key, ": ", details}})
    return
  end
  player.print({"", "[Helldivers] ", message_key})
end

local function has_beacon(player, count)
  count = count or 1
  local inventory = player and player.get_inventory(defines.inventory.character_main)
  if not inventory then
    return false
  end

  return inventory.get_item_count(stratagem_defs.beacon_item_name) >= count
end

local function consume_beacon(player, count)
  count = count or 1
  local inventory = player and player.get_inventory(defines.inventory.character_main)
  if not inventory then
    return false
  end

  local removed = inventory.remove({name = stratagem_defs.beacon_item_name, count = count})
  return removed >= count
end

local function queue_pop_event(surface_index, destination, force_name, stratagem_id)
  storage.queued_pop_events[#storage.queued_pop_events + 1] = {
    due_tick = game.tick + hellpod_smash_ttl,
    surface_index = surface_index,
    destination = {x = destination.x, y = destination.y},
    force_name = force_name,
    stratagem_id = stratagem_id
  }
end

local function deploy_hellpod(current_surface, destination, force_name, stratagem_id)
  local elevated_position = {
    x = destination.x,
    y = destination.y - 200
  }

  local pod = current_surface.create_entity({
    name = hellpod_projectile_name,
    position = elevated_position,
    target = destination,
    speed = 1.9,
    force = force_name
  })

  if pod and pod.valid and pod.unit_number then
    storage.hellpod_payload_by_projectile[pod.unit_number] = {
      stratagem_id = stratagem_id,
      force_name = force_name
    }
  end

  local frames = 15
  local speed = 0.25
  local offset = -(game.tick * speed) % frames

  rendering.draw_animation({
    target = pod,
    surface = current_surface,
    animation = hd.id.animation.hellpod_landing,
    animation_offset = offset,
    animation_speed = speed,
    render_layer = "air-object"
  })
end

local function spawn_minefield(surface, origin, force_name)
  for i = 1, minefield_count do
    local angle = (2 * math.pi) * (i - 1) / minefield_count
    local target = {
      x = origin.x + math.cos(angle) * minefield_radius,
      y = origin.y + math.sin(angle) * minefield_radius
    }

    surface.create_entity({
      name = minefield_projectile_name,
      position = origin,
      target = target,
      speed = 0.3,
      force = force_name
    })
  end

  surface.create_entity({
    name = "big-explosion",
    position = origin
  })
end

local function execute_stratagem(surface, destination, force_name, stratagem)
  if stratagem.action_type == "deploy_entity" then
    surface.create_entity({
      name = stratagem.action_params.entity_name,
      position = destination,
      force = force_name,
      find_non_colliding_position = true
    })
    return
  end

  if stratagem.action_type == "deploy_minefield" then
    spawn_minefield(surface, destination, force_name)
    return
  end
end

local function handle_stratagem_drop_trigger(event, stratagem)
  local current_surface = game.surfaces[event.surface_index]
  local destination = event.target_position
  if not (current_surface and destination and stratagem) then return end

  local source_player_index = event.source_player_index
  local player = source_player_index and game.players[source_player_index] or nil
  local force = (player and player.valid and player.force) or (event.source_entity and event.source_entity.force) or game.forces.player

  local beacon_cost = stratagem.beacon_cost or stratagem_defs.default_beacon_cost
  if not has_beacon(player, beacon_cost) then
    notify_player(player, "missing_beacon")
    return
  end

  if not orbit_inventory.has_any_launcher(force.name) then
    notify_player(player, "no_deploy_structure")
    return
  end

  local consumed, reason = orbit_inventory.consume_hellpod(force.name, stratagem.hellpod_item_name, 1)
  if not consumed then
    notify_player(player, reason or "orbit_out_of_stock")
    return
  end

  if not consume_beacon(player, beacon_cost) then
    notify_player(player, "missing_beacon")
    return
  end

  deploy_hellpod(current_surface, destination, force.name, stratagem.id)
end

local function handle_pod_smash_trigger(event)
  local current_surface = game.surfaces[event.surface_index]
  local destination = event.target_position
  if not (current_surface and destination) then return end

  local frames = 36
  local speed = 0.5
  local offset = -(game.tick * speed) % frames

  rendering.draw_animation({
    target = destination,
    surface = current_surface,
    animation = hd.id.animation.hellpod_smash,
    time_to_live = hellpod_smash_ttl,
    animation_offset = offset,
    animation_speed = speed,
    render_layer = "lower-object-above-shadow"
  })

  local force_name = "player"
  local stratagem_id = stratagem_defs.entries[1] and stratagem_defs.entries[1].id
  local source_entity = event.source_entity

  if source_entity and source_entity.valid and source_entity.force then
    force_name = source_entity.force.name
    if source_entity.unit_number then
      local payload = storage.hellpod_payload_by_projectile[source_entity.unit_number]
      if payload then
        stratagem_id = payload.stratagem_id or stratagem_id
        force_name = payload.force_name or force_name
        storage.hellpod_payload_by_projectile[source_entity.unit_number] = nil
      end
    end
  end

  if stratagem_id then
    queue_pop_event(event.surface_index, destination, force_name, stratagem_id)
  end
end

local function deploy_minefield_entity(entity)
  if not (entity and entity.valid) then return end
  if entity.name ~= minefield_deployer_name then return end

  spawn_minefield(entity.surface, entity.position, entity.force.name)
  entity.destroy()
end

function runtime.on_init()
  ensure_globals()
end

function runtime.on_configuration_changed()
  ensure_globals()
end

function runtime.on_script_trigger_effect(event)
  ensure_globals()

  if event.effect_id == hellpod_smash_effect_id then
    handle_pod_smash_trigger(event)
    return
  end

  local stratagem = stratagem_by_effect_id[event.effect_id]
  if stratagem then
    handle_stratagem_drop_trigger(event, stratagem)
  end
end

function runtime.on_tick()
  ensure_globals()

  local queue = storage.queued_pop_events
  if #queue == 0 then return end

  local keep = {}
  for _, queued in ipairs(queue) do
    if queued.due_tick > game.tick then
      keep[#keep + 1] = queued
    else
      local surface = game.surfaces[queued.surface_index]
      local def = stratagem_by_id[queued.stratagem_id]

      if surface and def then
        local pop_speed = 0.5
        local pop_frames = 36
        local pop_offset = -(game.tick * pop_speed) % pop_frames

        rendering.draw_animation({
          target = queued.destination,
          surface = surface,
          animation = hd.id.animation.hellpod_pop,
          time_to_live = hellpod_pop_ttl,
          animation_offset = pop_offset,
          animation_speed = pop_speed,
          render_layer = "object"
        })

        execute_stratagem(surface, queued.destination, queued.force_name, def)
      end
    end
  end

  storage.queued_pop_events = keep
end

function runtime.on_entity_built(event)
  local entity = event.entity or event.created_entity or event.destination
  deploy_minefield_entity(entity)
end

return runtime

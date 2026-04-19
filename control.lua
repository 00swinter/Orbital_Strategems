script.on_event(defines.events.on_player_used_capsule, function(event)
    
    
    local player = game.players[event.player_index]
    local capsule = event.item 
    local stratagemItem = "stratagem-item"
    local item_count = player.get_inventory(defines.inventory.character_main).get_item_count(stratagemItem) 
    

    if capsule.name == "stratagem-remote" then

        if item_count > 0 then
            player.remove_item({name=stratagemItem, count = 1})
        else
            local projectiles = player.surface.find_entities_filtered({
                name = "stratagem-projectile",  -- Filter for turrets
                radius = 2,
                position = player.position
            })
            for _, entity in pairs(projectiles) do
                entity.destroy()  -- Deletes the entity from the game
            end
        end
    end
end)


script.on_event(defines.events.on_script_trigger_effect, function(event)
    if event.effect_id == "trigger_pod_drop" then
        
        local current_surface = game.surfaces[event.surface_index]
        local destination = event.target_position
        
        if current_surface and destination then
            
            local elevated_position = {
                x = destination.x,
                y = destination.y - 200
            }
            
            local sentry_pod = current_surface.create_entity{
                name = "hellpod-projectile",
                position = elevated_position,
                target = destination,
                speed = 1.9
            }

            local frames = 15
            local speed = 0.25
            local offset = -(game.tick * speed) % frames

            rendering.draw_animation{
                target = sentry_pod,
                surface = current_surface,
                animation = "hellpod_landing_animation",
                animation_offset = offset,
                animation_speed = speed,
                render_layer = "air-object",
            }
        end
    end

    if event.effect_id == "trigger_hellpod_smash" then
        
        local current_surface = game.surfaces[event.surface_index]
        local destination = event.target_position
        
        if current_surface and destination then
            local frames = 36
            local speed = 0.5
            local offset = -(game.tick * speed) % frames
            

            rendering.draw_animation{
                target = destination,
                surface = current_surface,
                animation = "hellpod_smash_animation",
                time_to_live = 70,
                animation_offset = offset,
                animation_speed = speed,
                render_layer = "lower-object-above-shadow",
            }
        end
    end
end)



-- function tick()

-- end

-- script.on_event(defines.events.on_tick, tick());

local minefield_deployer_name = "orbital-minefield-deployer"
local minefield_projectile_name = "orbital-minefield-mine-projectile"
local minefield_count = 24
local minefield_radius = 10

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

local function on_entity_built(event)
    local entity = event.entity or event.created_entity or event.destination
    deploy_minefield(entity)
end

script.on_event(defines.events.on_built_entity, on_entity_built)
script.on_event(defines.events.on_robot_built_entity, on_entity_built)
script.on_event(defines.events.script_raised_built, on_entity_built)
script.on_event(defines.events.script_raised_revive, on_entity_built)
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

            rendering.draw_animation{
                target = sentry_pod,
                surface = current_surface,
                animation = "hellpod_landing_animation",
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
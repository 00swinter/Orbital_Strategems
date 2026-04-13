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
                y = destination.y - 60
            }
            
            current_surface.create_entity{
                name = "sentry-pod",
                position = elevated_position,
                target = destination,
                speed = 0.5
            }
        end
    end
end)
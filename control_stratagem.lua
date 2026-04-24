


local LANDED_TRIGGER_TAG = "-stratagem-beacon-landed-trigger"

local function splitByHash(text)
    local parts = {}
    for part in string.gmatch(text, "([^#]+)") do
        table.insert(parts, part)
    end
    return parts
end




local function handleLandedTrigger(event)
    local effect_name = event.effect_id
    if type(effect_name) ~= "string" then return end

    local parts = splitByHash(effect_name)
    if #parts < 2 then return end

    if parts[#parts] ~= LANDED_TRIGGER_TAG then return end

    local stratagem_name = parts[1]
    if stratagem_name == "" then return end


    local surface = game.surfaces[1]  -- or get the surface from event if available
    local position = event.target_position  -- The position where the effect triggered
    
    local chest = surface.create_entity({
        name = "steel-chest",
        position = position,
        player = event.source_entity.player,
        force = "player"
    })  

    --chest.operable = false;






    game.print("Stratagem beacon landed for: " .. stratagem_name)
end






script.on_event(defines.events.on_script_trigger_effect, function(event)
    game.print(event.effect_id)
    handleLandedTrigger(event)

end)

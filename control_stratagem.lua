


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

    game.print("Stratagem beacon landed for: " .. stratagem_name)
end






script.on_event(defines.events.on_script_trigger_effect, function(event)
    game.print(event.effect_id)
    handleLandedTrigger(event)

end)

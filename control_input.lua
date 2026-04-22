
local def = require("defines")

local stratagem_def = require("prototypes.stratagem_def")


local function ensurePlayerDefaults(player_data)
    player_data.arrowSequence = player_data.arrowSequence or {}
    player_data.renderIds = player_data.renderIds or {}
    return player_data
end

local function getOrCreatePlayerData(player_index)
    storage.players = storage.players or {}
    local player_data = storage.players[player_index]
    if not player_data then
        player_data = {}
        storage.players[player_index] = player_data
    end

    return ensurePlayerDefaults(player_data)
end

local function clearSequenceVisuals(player_index)
    local player = getOrCreatePlayerData(player_index)
    for _, render_id in ipairs(player.renderIds) do
        pcall(function() rendering.destroy(render_id) end)
    end
    player.renderIds = {}
end

local function drawArrowSequence(player_index)
    local player_obj = game.players[player_index]
    if not player_obj or not player_obj.character then return end
    
    local player = getOrCreatePlayerData(player_index)
    clearSequenceVisuals(player_index)
    
    local arrow_map = {
        UP = "hd_arrow_up",
        DOWN = "hd_arrow_down",
        LEFT = "hd_arrow_left",
        RIGHT = "hd_arrow_right"
    }
    

    local arrowWidth = 1
    local spacing = 1
    local totalArrows = #player.arrowSequence
    local yOffset = -3

    for i, direction in ipairs(player.arrowSequence) do
        
        local centerShift = (totalArrows - 1) / 2
        local currentPosition = i - 1
        
        local xOffset = (currentPosition - centerShift) * (arrowWidth + spacing)
        
        
        local render_id = rendering.draw_sprite{
            sprite = arrow_map[direction],
            target = {
                entity = player_obj.character,
                offset = {xOffset, yOffset}
            },
            surface = player_obj.surface,
            time_to_live = 5
        }
        table.insert(player.renderIds, render_id)

        -- Replace this comment with your game engine drawing function
        -- Example: love.graphics.draw(arrowImage, drawX, drawY)
        
    end

    -- Draw sequence above player
    local text = ""

    for i, direction in ipairs(player.arrowSequence) do
        text = text .. arrow_map[direction] .. " " .. i
    end
    --game.print(text)
    
end

local function cancelInput(e)
    local player = getOrCreatePlayerData(e.player_index)
    player.arrowSequence = {}
    clearSequenceVisuals(e.player_index)
    player.clearTick = nil
    game.print("clear")
end

local INPUT_CLEAR_TICKS = 60
local COMPLETE_SHOW_TICKS = 60

local function normalizeDirection(direction)
    if type(direction) ~= "string" then return nil end
    return string.upper(direction)
end

local function checkArrows(playerindex)
    local player_data = getOrCreatePlayerData(playerindex)
    local player_sequence = player_data.arrowSequence

    local has_partial_match = false

    for _, stratagem in ipairs(stratagem_def) do
        local arrows = stratagem.arrows or {}
        local is_prefix_match = true

        if #player_sequence > #arrows then
            is_prefix_match = false
        else
            for i = 1, #player_sequence do
                if normalizeDirection(player_sequence[i]) ~= normalizeDirection(arrows[i]) then
                    is_prefix_match = false
                    break
                end
            end
        end

        if is_prefix_match then
            if #player_sequence == #arrows then
                return "complete", stratagem.name
            end
            has_partial_match = true
        end
    end

    if has_partial_match then
        return "partial", nil
    end

    return "failed", nil
end

local function arrowInput(e)
    local direction
    if e.input_name == "helldivers_arrow_up" then
        direction = "UP"
    elseif e.input_name == "helldivers_arrow_down" then
        direction = "DOWN"
    elseif e.input_name == "helldivers_arrow_right" then
        direction = "RIGHT"
    elseif e.input_name == "helldivers_arrow_left" then
        direction = "LEFT"
    end
    
    if direction then
        local player = getOrCreatePlayerData(e.player_index)
        table.insert(player.arrowSequence, direction)
        player.clearTick = game.tick + INPUT_CLEAR_TICKS

        local match_state, matched_stratagem_name = checkArrows(e.player_index)
        if match_state == "complete" then
            local player_obj = game.players[e.player_index]
            if player_obj and player_obj.valid and player_obj.character and matched_stratagem_name then
                player_obj.cursor_stack.set_stack({name = def.MOD_PREFIX .. matched_stratagem_name .. "-capsule"})
            end

            game.print("Arrow combo matched: " .. (matched_stratagem_name or "unknown"))
            -- Keep the full combo visible briefly before automatic cleanup.
            player.clearTick = game.tick + COMPLETE_SHOW_TICKS
        elseif match_state == "failed" then
            player.arrowSequence = {}
            clearSequenceVisuals(e.player_index)
            player.clearTick = nil
        end

        --drawArrowSequence(e.player_index)
        --game.print("Sequence: " .. table.concat(player.arrowSequence, ", "))
    end
end

local function data_validation()
    storage.players = storage.players or {}
    for _, player_data in pairs(storage.players) do
        ensurePlayerDefaults(player_data)
    end
end








local function onTick()

    if game.tick % 5 ~= 0 then return end

    for _, player in ipairs(game.connected_players) do
        local player_data = getOrCreatePlayerData(player.index)
        if player_data.clearTick and game.tick >= player_data.clearTick then
            player_data.arrowSequence = {}
            clearSequenceVisuals(player.index)
            player_data.clearTick = nil
        elseif #player_data.arrowSequence > 0 then
            drawArrowSequence(player.index)
        end
    end

    --game.print("update" .. game.tick)

end


script.on_event("helldivers_cancel", cancelInput)
script.on_event("helldivers_arrow_up", arrowInput)
script.on_event("helldivers_arrow_down", arrowInput)
script.on_event("helldivers_arrow_right", arrowInput)
script.on_event("helldivers_arrow_left", arrowInput)

script.on_init(data_validation)

script.on_event(defines.events.on_tick, onTick)

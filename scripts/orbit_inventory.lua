local hd = require("lib.defines")

local orbit_inventory = {}

local function get_inventory(entity)
  if not (entity and entity.valid) then return nil end
  return entity.get_inventory(defines.inventory.chest)
end

function orbit_inventory.find_launcher_with_stock(force_name, item_name, required_count)
  required_count = required_count or 1

  for _, surface in pairs(game.surfaces) do
    local launchers = surface.find_entities_filtered({
      name = hd.id.container.orbital_launcher,
      force = force_name
    })

    for _, launcher in pairs(launchers) do
      local inventory = get_inventory(launcher)
      if inventory and inventory.valid and inventory.get_item_count(item_name) >= required_count then
        return launcher, inventory
      end
    end
  end

  return nil, nil
end

function orbit_inventory.has_hellpod(force_name, item_name, required_count)
  local launcher = orbit_inventory.find_launcher_with_stock(force_name, item_name, required_count)
  return launcher ~= nil
end

function orbit_inventory.consume_hellpod(force_name, item_name, count)
  count = count or 1
  local launcher, inventory = orbit_inventory.find_launcher_with_stock(force_name, item_name, count)
  if not (launcher and inventory) then
    return false, "orbit_out_of_stock"
  end

  local removed = inventory.remove({name = item_name, count = count})
  if removed < count then
    return false, "orbit_out_of_stock"
  end

  return true, nil
end

function orbit_inventory.has_any_launcher(force_name)
  for _, surface in pairs(game.surfaces) do
    local launchers = surface.find_entities_filtered({
      name = hd.id.container.orbital_launcher,
      force = force_name,
      limit = 1
    })
    if #launchers > 0 then
      return true
    end
  end
  return false
end

return orbit_inventory

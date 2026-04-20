local runtime = require("scripts.stratagem_runtime")

script.on_init(runtime.on_init)
script.on_configuration_changed(runtime.on_configuration_changed)

script.on_event(defines.events.on_script_trigger_effect, runtime.on_script_trigger_effect)
script.on_event(defines.events.on_tick, runtime.on_tick)

script.on_event(defines.events.on_built_entity, runtime.on_entity_built)
script.on_event(defines.events.on_robot_built_entity, runtime.on_entity_built)
script.on_event(defines.events.script_raised_built, runtime.on_entity_built)
script.on_event(defines.events.script_raised_revive, runtime.on_entity_built)

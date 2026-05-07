local _MOD_PREFIX = "HD-"

return {
   MOD_PATH_NAME = "__Helldivers__",
   MOD_PREFIX = _MOD_PREFIX,
   setting_a = _MOD_PREFIX .. "setting-name",

   path_generated = {
      icon = function(base_name)
         return "__Helldivers__/graphics/icons/" .. base_name .. ".png"
      end,
      sprite = function(base_name)
         return "__Helldivers__/graphics/sprites/" .. base_name .. ".png"
      end
   },

   image_type = {
      deploy_animation = "deploy_animation",
      unfold_animation = "unfold_animation",
      fly_animation = "fly_animation",
      remote_icon = "remote_icon",
      rise_animation = "rise_animation",
      space_hub_item_icon = "space_hub_item_icon",
      normal_sprite = "sprite"
   },

   get_image = function(name, type)
      return "__Helldivers__/graphics/dynamic/" .. name .. "/" .. type .. ".png"
   end,

   script_trigger = {
      hellpod_fall = _MOD_PREFIX .. "hellpod-fall-animation-script-trigger",
      hellpod_smash = _MOD_PREFIX .. "hellpod-smash-animation-script-trigger",
      hellpod_pop = _MOD_PREFIX .. "hellpod-pop-animation-script-trigger",
      hellpod_spawn_ending = "-hellpod-spawn-script-trigger",
      hellpod_beacon_landed_ending = "-stratagem-beacon-landed-script-trigger",
      hellpod_spawn_entity_ending = "-hellpod_spawn_entity_script_trigger",
      hellpod_rise_animation_ending = "-hellpod_rise_animation_script_trigger",
      hellpod_spawn_container = "hellpod-spawn-container-script-trigger"
   },
   script_trigger_dynamic_type = {
      stratagem_beacon_landed = "stratagem_beacon_landed",
      hellpod_spawn_result = "hellpod_spawn_entity",
      hellpod_rise_animation = "hellpod_rise_animation",
      mines_deploy_animation = "mines_deploy_animation",
      mines_spawn_projectiles = "mines_spawn_projectiles",
      sentry_unfold_animation = "sentry_unfold_animation",
   },

   script_trigger_effect_generated = function(base_name, type, extra)
      extra = extra or "none"
      return _MOD_PREFIX .. "#" .. base_name .. "#" .. type .. "#" .. extra .. "#" .. "-script_trigger_effect"
   end,

   prototype_names = {
      hellpod_entities_short = {
         resupply = "resupply",
         gatling_gun = "gatling_gun",
         sentry_autocannon = "sentry_autocannon",
         mines_incendary = "mines_incendary",
         mines_gas = "mines_gas",
      },
      spaceHub = _MOD_PREFIX .. "space-hub",
      corpse = {
         hellpod = _MOD_PREFIX .. "hellpod-corpse"
      },
      sentry = {
         autocannon = {
            turret = _MOD_PREFIX .. "autocannon-turret",
            ammo = _MOD_PREFIX .. "autocannon-ammo",
            particle = _MOD_PREFIX .. "autocannon-shell-particle"
         }
      },
      mines = {
         incendary = {
            mine = _MOD_PREFIX .. "incendary-mine",
         }
      },
      crafting = {
         empty_hellpod = _MOD_PREFIX .. "empty-hellpod",
         charged_battery = _MOD_PREFIX .. "charged-battery",
         computer = _MOD_PREFIX .. "steering-computer",

      }
   },
   prototype_names_generated = {
      stratagem_capsule = function(base_name)
         return _MOD_PREFIX .. base_name .. "-stratagem_capsule"
      end,

      stratagem_stream = function(base_name)
         return _MOD_PREFIX .. base_name .. "-stratagem_stream"
      end,

      stratagem_recipe = function(base_name)
         return _MOD_PREFIX .. base_name .. "-stratagem_recipe"
      end,

      hellpod_entity = function(base_name)
         return _MOD_PREFIX .. base_name .. "-hellpod_entity"
      end,

      space_hub_item = function(base_name)
         return _MOD_PREFIX .. base_name .. "-space_hub_item"
      end,

      hellpod_projectile = function(base_name)
         return _MOD_PREFIX .. base_name .. "-hellpod_projectile"
      end,

      hellpod_rise_animation = function(base_name)
         return _MOD_PREFIX .. base_name .. "-hellpod_rise_animation"
      end,

      hellpod_lid_corpse = function(base_name)
         return _MOD_PREFIX .. base_name .. "-hellpod_lid_corpse"
      end,

      hellpod_mines_deploy_animation = function(base_name)
         return _MOD_PREFIX .. base_name .. "-hellpod_mines_deploy_animation"
      end,

      hellpod_sentry_unfold_animation = function(base_name)
         return _MOD_PREFIX .. base_name .. "-hellpod_sentry_unfold_animation"
      end,

      mine_stream = function(base_name)
         return _MOD_PREFIX .. base_name .. "-mine_stream"
      end,

      delayed_trigger_mines_deploy_projectiles = function(base_name, distance)
         return _MOD_PREFIX .. base_name .. "-distance_" .. distance .. "-hellpod_mines_deploy_animation"
      end,

      delayed_trigger_mines_deploy_animation = function(base_name)
         return _MOD_PREFIX .. base_name .. "-deploy_animation_delayed_trigger"
      end,

      delayed_trigger_sentry_unfold_animation = function(base_name)
         return _MOD_PREFIX .. base_name .. "-unfold_animation_delayed_trigger"
      end,

      delayed_trigger_spawn = function(base_name)
         return _MOD_PREFIX .. base_name .. "-spawn_delayed_trigger"
      end,

      delayed_trigger_rise_animation = function(base_name)
         return _MOD_PREFIX .. base_name .. "-rise_animation_delayed_trigger"
      end,


   }
}

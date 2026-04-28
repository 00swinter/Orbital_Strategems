local _MOD_PREFIX = "HD-"

return {
   MOD_PATH_NAME = "__Helldivers__",
   MOD_PREFIX = _MOD_PREFIX,
   setting_a = _MOD_PREFIX .. "setting-name",


   script_trigger = {
      hellpod_fall = _MOD_PREFIX .. "hellpod-fall-animation-script-trigger",
      hellpod_smash = _MOD_PREFIX .. "hellpod-smash-animation-script-trigger",
      hellpod_pop = _MOD_PREFIX .. "hellpod-pop-animation-script-trigger",
      hellpod_spawn_ending = "-hellpod-spawn-script-trigger",
      hellpod_beacon_landed_ending = "-stratagem-beacon-landed-script-trigger",
      hellpod_spawn_container = "hellpod-spawn-container-script-trigger"
   }
}

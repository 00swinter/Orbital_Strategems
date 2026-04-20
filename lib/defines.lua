local d = {}

d.short = "hdm"
d.mod_name = "Helldivers"
d.mod_path = "__Helldivers__"

local function id(kind, suffix)
  return kind .. "-" .. d.short .. "-" .. suffix
end

d.id = {
  animation = {
    hellpod_landing = id("animation", "hellpod-landing"),
    hellpod_smash = id("animation", "hellpod-smash"),
    hellpod_pop = id("animation", "hellpod-pop")
  },
  effect = {
    trigger_pod_drop = id("effect", "trigger-pod-drop"),
    trigger_hellpod_smash = id("effect", "trigger-hellpod-smash")
  },
  projectile = {
    hellpod = id("projectile", "hellpod"),
    stratagem = id("projectile", "stratagem"),
    incendiary_fire = id("projectile", "incendiary-fire"),
    minefield_mine = id("projectile", "minefield-mine")
  },
  item = {
    stratagem = id("item", "stratagem"),
    stratagem_remote = id("item", "stratagem-remote"),
    hellpod = id("item", "hellpod"),
    space_building = id("item", "space-building"),
    incendiary_land_mine = id("item", "orbital-incendiary-land-mine"),
    minefield_deployer = id("item", "minefield-deployer")
  },
  recipe = {
    stratagem_remote = id("recipe", "stratagem-remote"),
    stratagem = id("recipe", "stratagem"),
    hellpod = id("recipe", "hellpod"),
    incendiary_land_mine = id("recipe", "orbital-incendiary-land-mine"),
    minefield_deployer = id("recipe", "minefield-deployer")
  },
  entity = {
    stratagem_marker = id("entity", "stratagem-marker"),
    minefield_deployer = id("entity", "minefield-deployer")
  },
  land_mine = {
    incendiary = id("land-mine", "orbital-incendiary")
  },
  technology = {
    incendiary_land_mine = id("technology", "orbital-incendiary-land-mine")
  },
  container = {
    orbital_launcher = id("container", "orbital-launcher-building")
  },
  corpse = {
    hellpod = id("corpse", "hellpod")
  }
}

return d

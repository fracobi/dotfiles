_G.HYPR_VARS = {
  mainMod = "SUPER",

  terminal = "kitty",
  fileManager = "thunar",
  browser = "brave-browser",
}

HYPR_VARS.menu = "bash -lc '/home/cobi/.config/rofi/launchers/type-2/launcher.sh'"
HYPR_VARS.webapp = HYPR_VARS.browser .. " --app"

_G.HYPR_VARS = {
  mainMod = "SUPER",

  defaultLayout = "scrolling",

  terminal = "kitty",
  fileManager = "thunar",
  browser = "brave-browser",
}

HYPR_VARS.menu = "qs -c noctalia-shell ipc call launcher toggle"
HYPR_VARS.webapp = HYPR_VARS.browser .. " --app"

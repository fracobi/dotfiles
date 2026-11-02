-- New machines use preferred modes. Select the original profile in local.lua.
if DOTFILES_MONITOR_PROFILE == "current" then
hl.monitor({
  output = "eDP-1",
  mode = "1920x1080@60",
  position = "0x0",
  scale = 1.2,
})

hl.monitor({
  output = "HDMI-A-1",
  mode = "1920x1080@60",
  position = "1600x0",
  scale = 1,
})

else
  hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
end

hl.config({
  xwayland = {
    force_zero_scaling = true,
  },
})


local home = os.getenv("HOME")

hl.on("hyprland.start", function()
  -- hl.exec_cmd("waybar")

  hl.exec_cmd(home .. "/Scripts/notification-sound.sh")

  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")

  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")

  -- hl.exec_cmd("hyprpm reload")

  hl.exec_cmd(home .. "/clipryx/publish/clipryx --daemon")

  hl.exec_cmd("hypridle")

  hl.exec_cmd("qs -c overview")
  hl.exec_cmd("qs -c noctalia-shell")

  -- hl.exec_cmd("numlockx on")
end)

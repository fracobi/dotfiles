local home = os.getenv("HOME")

hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")

hl.on("hyprland.start", function()

  hl.exec_cmd("systemctl --user restart quickshell-overview.service")
  hl.exec_cmd("sh -c 'sleep 5; hyprpm reload -n'")

  hl.exec_cmd(home .. "/Scripts/notification-sound.sh")

  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")

  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")

  hl.exec_cmd(home .. "/clipryx/publish/clipryx --daemon")

  --hl.exec_cmd("hypridle")

  hl.exec_cmd("qs -c noctalia-shell")

-- WhatsApp Web PWA in background
  hl.exec_cmd("sh -c 'sleep 10 && gtk-launch brave-hnpfjngllnobngcgfapefoaidbinmjnm-Default'")

  -- hl.exec_cmd("numlockx on")
end)

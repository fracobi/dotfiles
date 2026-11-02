local home = os.getenv("HOME")

hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
-- Session lifecycle and portals are managed by UWSM.

local function sync_monitor_workspaces(delay)
  hl.exec_cmd("sh -c 'sleep " .. delay .. "; ~/.config/hypr/scripts/sync-monitor-workspaces.sh'")
end

hl.on("hyprland.start", function()

  hl.exec_cmd("systemctl --user start quickshell-overview.service")
  hl.exec_cmd("~/.config/hypr/scripts/reload-plugins.sh")

  hl.exec_cmd(home .. "/Scripts/notification-sound.sh")

  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")

  hl.exec_cmd("systemctl --user start hyprpolkitagent")


  --hl.exec_cmd("hypridle")

  hl.exec_cmd("qs -c noctalia-shell")

  sync_monitor_workspaces("1")

-- WhatsApp Web PWA in background
  hl.exec_cmd("~/.config/hypr/scripts/start-personal-apps.sh")

  -- hl.exec_cmd("numlockx on")
end)

hl.on("monitor.added", function()
  sync_monitor_workspaces("1")
end)

hl.on("monitor.removed", function()
  sync_monitor_workspaces("1")
end)

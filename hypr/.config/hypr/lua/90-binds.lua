local vars = _G.HYPR_VARS or {}

local mainMod = vars.mainMod or "SUPER"
local terminal = vars.terminal or "kitty"
local fileManager = vars.fileManager or "thunar"
local browser = vars.browser or "brave-browser"

-- Helpers
local function bind(keys, dispatcher, flags)
  hl.bind(keys, dispatcher, flags)
end

local function exec(cmd)
  return hl.dsp.exec_cmd(cmd)
end

local function focus_workspace(workspace)
  return hl.dsp.focus({ workspace = tostring(workspace) })
end

local function move_to_workspace(workspace)
  return hl.dsp.window.move({ workspace = tostring(workspace) })
end

-- Lock
bind(mainMod .. " + SHIFT + M", exec("hyprlock"))

-- Main
bind(mainMod .. " + B", exec(browser))
bind(mainMod .. " + RETURN", exec(terminal))
bind(mainMod .. " + E", exec(fileManager))
bind(mainMod .. " + Y", exec("kitty --title spf -e spf"))

-- Window manipulation
bind(mainMod .. " + mouse:274", hl.dsp.window.close())
bind(mainMod .. " + A", hl.dsp.window.close())

-- fullscreen, 1 = maximized
bind(mainMod .. " + M", hl.dsp.window.fullscreen({
  mode = "maximized",
  action = "toggle",
}))

-- fullscreen, 0 = real fullscreen
bind(mainMod .. " + F", hl.dsp.window.fullscreen({
  mode = "fullscreen",
  action = "toggle",
}))

bind(mainMod .. " + V", hl.dsp.window.float({
  action = "toggle",
}))

bind(mainMod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "l" }))
bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "r" }))
bind(mainMod .. " + SHIFT + up", hl.dsp.window.swap({ direction = "u" }))
bind(mainMod .. " + SHIFT + down", hl.dsp.window.swap({ direction = "d" }))

-- Vecchi bind commentati:
-- bind(mainMod .. " + SPACE", exec(vars.menu))
-- bind(mainMod .. " + C", exec("~/clipryx/publish/clipryx"))
-- bind(mainMod .. " + SHIFT + C", exec("~/.config/hypr/scripts/clipboard.sh"))

-- Dashboard
bind(mainMod .. " + D", exec("~/.config/eww/toggle-dashboard.sh"))
bind(mainMod .. " + escape", exec("~/.config/eww/close-dashboard.sh"))

-- Workspace navigation
bind(mainMod .. " + CTRL + right", focus_workspace("e+1"))
bind(mainMod .. " + CTRL + left", focus_workspace("e-1"))

bind(mainMod .. " + P", hl.dsp.window.pseudo({
  action = "toggle",
}))

bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
bind(mainMod .. " + TAB", exec("qs ipc -c overview call overview toggle"))

-- Noctalia
bind(mainMod .. " + SPACE", exec("qs -c noctalia-shell ipc call launcher toggle"))

bind(
  mainMod .. " + C",
  exec("qs -c noctalia-shell ipc call plugin:clipboard toggle"),
  { release = true }
)

bind(
  mainMod .. " + SHIFT + C",
  exec("qs -c noctalia-shell ipc call plugin:clipboard wipe"),
  { release = true }
)

bind(mainMod .. " + N", exec("qs -c noctalia-shell ipc call controlCenter toggle"))
bind(mainMod .. " + SHIFT + N", exec("qs -c noctalia-shell ipc call settings toggle"))
bind(mainMod .. " + I", exec("qs -c noctalia-shell ipc call wallpaper toggle"))
bind(mainMod .. " + Delete", exec("qs -c noctalia-shell ipc call sessionMenu toggle"))

-- Grouping
bind(mainMod .. " + G", hl.dsp.group.toggle())
bind("ALT + TAB", hl.dsp.group.next())
bind("ALT + SHIFT + TAB", hl.dsp.group.prev())
bind(mainMod .. " + SHIFT + G", hl.dsp.group.toggle())

-- Web pages
bind(mainMod .. " + L", exec('~/.config/hypr/scripts/open-url-smart.sh "https://chatgpt.com"'))
bind(mainMod .. " + T", exec('~/.config/hypr/scripts/open-url-smart.sh "https://www.youtube.com"'))

-- Focus
bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Workspace con numpad
bind(mainMod .. " + code:87", focus_workspace(1))
bind(mainMod .. " + code:88", focus_workspace(2))
bind(mainMod .. " + code:89", focus_workspace(3))
bind(mainMod .. " + code:83", focus_workspace(4))
bind(mainMod .. " + code:84", focus_workspace(5))
bind(mainMod .. " + code:85", focus_workspace(6))
bind(mainMod .. " + code:79", focus_workspace(7))
bind(mainMod .. " + code:80", focus_workspace(8))
bind(mainMod .. " + code:81", focus_workspace(9))
bind(mainMod .. " + code:90", focus_workspace(10))

-- Normal number key
bind(mainMod .. " + 1", focus_workspace(1))
bind(mainMod .. " + 2", focus_workspace(2))
bind(mainMod .. " + 3", focus_workspace(3))
bind(mainMod .. " + 4", focus_workspace(4))
bind(mainMod .. " + 5", focus_workspace(5))
bind(mainMod .. " + 6", focus_workspace(6))
bind(mainMod .. " + 7", focus_workspace(7))
bind(mainMod .. " + 8", focus_workspace(8))
bind(mainMod .. " + 9", focus_workspace(9))
bind(mainMod .. " + 0", focus_workspace(10))

-- Workspace monitor virtuale WINSCREEN
bind("SUPER + CTRL + 1", focus_workspace(11))
bind("SUPER + CTRL + 2", focus_workspace(12))
bind("SUPER + CTRL + 3", focus_workspace(13))
bind("SUPER + CTRL + 4", focus_workspace(14))
bind("SUPER + CTRL + 5", focus_workspace(15))

bind("SUPER + CTRL + code:87", focus_workspace(11))
bind("SUPER + CTRL + code:88", focus_workspace(12))
bind("SUPER + CTRL + code:89", focus_workspace(13))
bind("SUPER + CTRL + code:83", focus_workspace(14))
bind("SUPER + CTRL + code:84", focus_workspace(15))

-- Sposta finestra su workspace con numpad
bind(mainMod .. " + SHIFT + code:87", move_to_workspace(1))
bind(mainMod .. " + SHIFT + code:88", move_to_workspace(2))
bind(mainMod .. " + SHIFT + code:89", move_to_workspace(3))
bind(mainMod .. " + SHIFT + code:83", move_to_workspace(4))
bind(mainMod .. " + SHIFT + code:84", move_to_workspace(5))
bind(mainMod .. " + SHIFT + code:85", move_to_workspace(6))
bind(mainMod .. " + SHIFT + code:79", move_to_workspace(7))
bind(mainMod .. " + SHIFT + code:80", move_to_workspace(8))
bind(mainMod .. " + SHIFT + code:81", move_to_workspace(9))
bind(mainMod .. " + SHIFT + code:90", move_to_workspace(10))

-- Sposta finestra su workspace con numeri normali
bind(mainMod .. " + SHIFT + 1", move_to_workspace(1))
bind(mainMod .. " + SHIFT + 2", move_to_workspace(2))
bind(mainMod .. " + SHIFT + 3", move_to_workspace(3))
bind(mainMod .. " + SHIFT + 4", move_to_workspace(4))
bind(mainMod .. " + SHIFT + 5", move_to_workspace(5))
bind(mainMod .. " + SHIFT + 6", move_to_workspace(6))
bind(mainMod .. " + SHIFT + 7", move_to_workspace(7))
bind(mainMod .. " + SHIFT + 8", move_to_workspace(8))
bind(mainMod .. " + SHIFT + 9", move_to_workspace(9))
bind(mainMod .. " + SHIFT + 0", move_to_workspace(10))

-- Spostare finestra attiva sui workspace virtuali
bind("SUPER + CTRL + ALT + 1", move_to_workspace(11))
bind("SUPER + CTRL + ALT + 2", move_to_workspace(12))
bind("SUPER + CTRL + ALT + 3", move_to_workspace(13))
bind("SUPER + CTRL + ALT + 4", move_to_workspace(14))
bind("SUPER + CTRL + ALT + 5", move_to_workspace(15))

bind("SUPER + CTRL + ALT + code:87", move_to_workspace(11))
bind("SUPER + CTRL + ALT + code:88", move_to_workspace(12))
bind("SUPER + CTRL + ALT + code:89", move_to_workspace(13))
bind("SUPER + CTRL + ALT + code:83", move_to_workspace(14))
bind("SUPER + CTRL + ALT + code:84", move_to_workspace(15))

-- Mouse wheel workspace navigation
bind(mainMod .. " + mouse_down", focus_workspace("e+1"))
bind(mainMod .. " + mouse_up", focus_workspace("e-1"))

-- Mouse move/resize
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Audio / brightness
bind(
  "XF86AudioRaiseVolume",
  exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { repeating = true, locked = true }
)

bind(
  "XF86AudioLowerVolume",
  exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { repeating = true, locked = true }
)

bind(
  "XF86AudioMute",
  exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { repeating = true, locked = true }
)

bind(
  "XF86AudioMicMute",
  exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { repeating = true, locked = true }
)

bind(
  "XF86MonBrightnessUp",
  exec("brightnessctl -e4 -n2 set 5%+"),
  { repeating = true, locked = true }
)

bind(
  "XF86MonBrightnessDown",
  exec("brightnessctl -e4 -n2 set 5%-"),
  { repeating = true, locked = true }
)

-- Media keys
bind("XF86AudioNext", exec("playerctl next"), { locked = true })
bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true })
bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })

-- Screenshot
bind(mainMod .. " + S", exec("/home/cobi/.local/bin/hyprshot -m region --clipboard-only"))
bind(mainMod .. " + SHIFT + S", exec("/home/cobi/.local/bin/hyprshot -m region -o /home/cobi/Immagini/Schermate"))
bind(mainMod .. " + SHIFT + W", exec("/home/cobi/.local/bin/hyprshot -m window"))
bind("Print", exec("/home/cobi/.local/bin/hyprshot -m output -o /home/cobi/Immagini/Schermate"))

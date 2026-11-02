local vars = _G.HYPR_VARS or {}

local mainMod = vars.mainMod or "SUPER"
local terminal = vars.terminal or "kitty"
local fileManager = vars.fileManager or "thunar"
local browser = vars.browser or "brave-browser"

local currentLayout = vars.defaultLayout or "scrolling"

-- ============================================================
-- Helpers
-- ============================================================

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

local function set_layout(layout)
  currentLayout = layout

  hl.config({
    general = {
      layout = layout,
    },
  })
end

local function resize_window(x, y)
  hl.dispatch(hl.dsp.window.resize({
    x = x,
    y = y,
    relative = true,
  }))
end

-- In scrolling layout il focus orizzontale deve usare il layout message,
-- altrimenti Hyprland può saltare verso finestre su altri monitor.
local function smart_horizontal_focus(direction)
  if currentLayout == "scrolling" then
    if direction == "r" then
      hl.dispatch(exec("~/.config/hypr/scripts/smart-scroll-focus.sh right"))
    else
      hl.dispatch(exec("~/.config/hypr/scripts/smart-scroll-focus.sh left"))
    end
  else
    hl.dispatch(hl.dsp.focus({ direction = direction }))
  end
end

local function smart_horizontal_focus_local(direction)
  if currentLayout == "scrolling" then
    if direction == "r" then
      hl.dispatch(exec("hyprctl eval 'hl.dispatch(hl.dsp.layout(\"focus r\"))'"))
    else
      hl.dispatch(exec("hyprctl eval 'hl.dispatch(hl.dsp.layout(\"focus l\"))'"))
    end
  else
    hl.dispatch(hl.dsp.focus({ direction = direction }))
  end
end

-- In scrolling layout UP/DOWN diventano cambio workspace.
-- In master/dwindle restano focus verticale tra finestre.
local function smart_vertical_focus(direction)
  if currentLayout == "scrolling" then
    if direction == "u" then
      hl.dispatch(exec("~/.config/hypr/scripts/workspace-monitor-step.sh prev"))
    else
      hl.dispatch(exec("~/.config/hypr/scripts/workspace-monitor-step.sh next"))
    end
  else
    hl.dispatch(hl.dsp.focus({ direction = direction }))
  end
end

-- ============================================================
-- Main apps / session
-- ============================================================

bind(mainMod .. " + RETURN", exec(terminal))
bind(mainMod .. " + B", exec(browser))
bind(mainMod .. " + E", exec(fileManager))
bind(mainMod .. " + Y", exec("kitty --title spf -e ~/.local/bin/dotfiles-tool spf"))
bind(mainMod .. " + K", exec("~/.local/bin/tastiera-virtuale"))

bind(mainMod .. " + SHIFT + M", exec("hyprlock"))
bind(mainMod .. " + Delete", exec("qs -c noctalia-shell ipc call sessionMenu toggle"))

-- Workspace dedicato WhatsApp
bind(mainMod .. " + W", focus_workspace("99"))

-- ============================================================
-- Window actions
-- ============================================================

bind(mainMod .. " + A", hl.dsp.window.close())
bind(mainMod .. " + mouse:274", hl.dsp.window.close())

-- Maximized
bind(mainMod .. " + M", hl.dsp.window.fullscreen({
  mode = "maximized",
  action = "toggle",
}))

-- Real fullscreen
bind(mainMod .. " + F", hl.dsp.window.fullscreen({
  mode = "fullscreen",
  action = "toggle",
}))

-- Floating smart:
-- se la finestra è unica nel workspace: float + resize + center
-- se ci sono più finestre: solo toggle float
bind(mainMod .. " + V", exec("~/.config/hypr/scripts/toggle-float-smart.sh"))

-- Swap finestre
bind(mainMod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "l" }))
bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "r" }))
bind(mainMod .. " + SHIFT + up", hl.dsp.window.swap({ direction = "u" }))
bind(mainMod .. " + SHIFT + down", hl.dsp.window.swap({ direction = "d" }))

-- Pseudo / split
bind(mainMod .. " + P", hl.dsp.window.pseudo({ action = "toggle" }))
bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- ============================================================
-- Smart navigation
-- ============================================================
-- SUPER + LEFT/RIGHT:
--   scrolling      -> focus l/r nel tape scrolling
--   master/dwindle -> focus normale finestra
--
-- SUPER + UP/DOWN:
--   scrolling      -> workspace precedente/successivo
--   master/dwindle -> focus normale finestra

bind(mainMod .. " + left", function()
  smart_horizontal_focus("l")
end)
--, { repeating = true })

bind(mainMod .. " + right", function()
  smart_horizontal_focus("r")
end)
--, { repeating = true })

bind(mainMod .. " + up", function()
  smart_vertical_focus("u")
end, { repeating = true })

bind(mainMod .. " + down", function()
  smart_vertical_focus("d")
end, { repeating = true })

-- Focus verticale tra finestre; nello scrolling naviga nella colonna.
bind(mainMod .. " + CTRL + up", hl.dsp.focus({ direction = "u" }))
bind(mainMod .. " + CTRL + down", hl.dsp.focus({ direction = "d" }))

-- Mouse wheel workspace navigation
bind(mainMod .. " + mouse_up", exec("~/.config/hypr/scripts/workspace-monitor-step.sh prev"))
bind(mainMod .. " + mouse_down", exec("~/.config/hypr/scripts/workspace-monitor-step.sh next"))
bind(mainMod .. " + ALT + mouse_up", function()
  smart_horizontal_focus_local("r")
end)
bind(mainMod .. " + ALT + mouse_down", function()
  smart_horizontal_focus_local("l")
end)

-- ============================================================
-- Layout switching
-- ============================================================

bind(mainMod .. " + ALT + S", function()
  set_layout("scrolling")
end)

bind(mainMod .. " + ALT + M", function()
  set_layout("master")
end)

bind(mainMod .. " + ALT + D", function()
  set_layout("dwindle")
end)

-- Larghezza colonna nello scrolling layout
bind(mainMod .. " + CTRL + right", hl.dsp.layout("colresize +conf"))
bind(mainMod .. " + CTRL + left", hl.dsp.layout("colresize -conf"))

-- Scrolling: inserisci nella colonna precedente / estrai in una propria.
bind(mainMod .. " + I", function()
  if currentLayout == "scrolling" then
    hl.dispatch(hl.dsp.layout("consume"))
  end
end)

bind(mainMod .. " + O", function()
  if currentLayout == "scrolling" then
    hl.dispatch(hl.dsp.layout("expel"))
  end
end)

-- ============================================================
-- Resize
-- ============================================================
-- SUPER + ALT + frecce fa SEMPRE resize finestra.
-- Non è più contestuale: così il comportamento rimane prevedibile.

bind(mainMod .. " + ALT + right", function()
  resize_window(40, 0)
end, { repeating = true })

bind(mainMod .. " + ALT + left", function()
  resize_window(-40, 0)
end, { repeating = true })

bind(mainMod .. " + ALT + down", function()
  resize_window(0, 40)
end, { repeating = true })

bind(mainMod .. " + ALT + up", function()
  resize_window(0, -40)
end, { repeating = true })

-- Mouse move/resize
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
bind(mainMod .. " + ALT + mouse:272", hl.dsp.window.resize(), { mouse = true })

-- ============================================================
-- Overview / launchers / Noctalia
-- ============================================================

-- Quickshell overview
bind(mainMod .. " + TAB", exec("qs ipc -c overview call overview toggle"))

-- ScrollOverview plugin
bind(mainMod .. " + Q", function()
  if hl.plugin and hl.plugin.scrolloverview then
    hl.plugin.scrolloverview.overview("toggle all")
  end
end)

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
bind(mainMod .. " + SHIFT + I", exec("qs -c noctalia-shell ipc call wallpaper toggle"))
bind(mainMod .. " + CTRL + C", exec("qs -c noctalia-shell ipc call plugin openPanel noctalia-calculator"))

-- ============================================================
-- Groups
-- ============================================================

bind(mainMod .. " + G", hl.dsp.group.toggle())
bind(mainMod .. " + SHIFT + G", hl.dsp.group.toggle())
bind("ALT + TAB", hl.dsp.group.next())
bind("ALT + SHIFT + TAB", hl.dsp.group.prev())

-- ============================================================
-- Web shortcuts
-- ============================================================

bind(mainMod .. " + L", exec('~/.config/hypr/scripts/open-url-smart.sh "https://chatgpt.com"'))
bind(mainMod .. " + T", exec('~/.config/hypr/scripts/open-url-smart.sh "https://www.youtube.com"'))

-- ============================================================
-- Workspace direct access
-- ============================================================

-- Numpad
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

-- Number row
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

-- Workspace virtual monitor WINSCREEN
bind(mainMod .. " + CTRL + 1", focus_workspace(11))
bind(mainMod .. " + CTRL + 2", focus_workspace(12))
bind(mainMod .. " + CTRL + 3", focus_workspace(13))
bind(mainMod .. " + CTRL + 4", focus_workspace(14))
bind(mainMod .. " + CTRL + 5", focus_workspace(15))

bind(mainMod .. " + CTRL + code:87", focus_workspace(11))
bind(mainMod .. " + CTRL + code:88", focus_workspace(12))
bind(mainMod .. " + CTRL + code:89", focus_workspace(13))
bind(mainMod .. " + CTRL + code:83", focus_workspace(14))
bind(mainMod .. " + CTRL + code:84", focus_workspace(15))

-- ============================================================
-- Move active window to workspace
-- ============================================================

-- Numpad
bind(mainMod .. " + ALT + code:87", move_to_workspace(1))
bind(mainMod .. " + ALT + code:88", move_to_workspace(2))
bind(mainMod .. " + ALT + code:89", move_to_workspace(3))
bind(mainMod .. " + ALT + code:83", move_to_workspace(4))
bind(mainMod .. " + ALT + code:84", move_to_workspace(5))
bind(mainMod .. " + ALT + code:85", move_to_workspace(6))
bind(mainMod .. " + ALT + code:79", move_to_workspace(7))
bind(mainMod .. " + ALT + code:80", move_to_workspace(8))
bind(mainMod .. " + ALT + code:81", move_to_workspace(9))
bind(mainMod .. " + ALT + code:90", move_to_workspace(10))

-- Number row
bind(mainMod .. " + ALT + 1", move_to_workspace(1))
bind(mainMod .. " + ALT + 2", move_to_workspace(2))
bind(mainMod .. " + ALT + 3", move_to_workspace(3))
bind(mainMod .. " + ALT + 4", move_to_workspace(4))
bind(mainMod .. " + ALT + 5", move_to_workspace(5))
bind(mainMod .. " + ALT + 6", move_to_workspace(6))
bind(mainMod .. " + ALT + 7", move_to_workspace(7))
bind(mainMod .. " + ALT + 8", move_to_workspace(8))
bind(mainMod .. " + ALT + 9", move_to_workspace(9))
bind(mainMod .. " + ALT + 0", move_to_workspace(10))

-- Virtual monitor workspaces
bind(mainMod .. " + CTRL + ALT + 1", move_to_workspace(11))
bind(mainMod .. " + CTRL + ALT + 2", move_to_workspace(12))
bind(mainMod .. " + CTRL + ALT + 3", move_to_workspace(13))
bind(mainMod .. " + CTRL + ALT + 4", move_to_workspace(14))
bind(mainMod .. " + CTRL + ALT + 5", move_to_workspace(15))

bind(mainMod .. " + CTRL + ALT + code:87", move_to_workspace(11))
bind(mainMod .. " + CTRL + ALT + code:88", move_to_workspace(12))
bind(mainMod .. " + CTRL + ALT + code:89", move_to_workspace(13))
bind(mainMod .. " + CTRL + ALT + code:83", move_to_workspace(14))
bind(mainMod .. " + CTRL + ALT + code:84", move_to_workspace(15))

-- ============================================================
-- Audio / brightness
-- ============================================================

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

-- ============================================================
-- Media keys
-- ============================================================

bind("XF86AudioNext", exec("playerctl next"), { locked = true })
bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true })
bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })

-- ============================================================
-- Screenshots
-- ============================================================

bind(mainMod .. " + S", exec("/usr/bin/bash ~/.config/hypr/lua/screenshot-region.sh clipboard"))
bind(mainMod .. " + SHIFT + S", exec("/usr/bin/bash ~/.config/hypr/lua/screenshot-region.sh save"))
bind(mainMod .. " + SHIFT + W", exec("~/.config/hypr/scripts/screenshot-active-window.sh"))
bind("CTRL + SHIFT + W", exec("hyprshot -m window"))
bind("Print", exec("hyprshot -m output -o ~/Pictures/Screenshots"))

-- BEGIN dettatura locale (waystt)
-- SUPER ALT D resta assegnato al layout dwindle.
bind(mainMod .. " + D", exec("~/.local/bin/dettatura toggle"))
bind(mainMod .. " + Escape", exec("~/.local/bin/dettatura cancel"))
-- END dettatura locale (waystt)

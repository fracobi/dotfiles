-- ~/.config/hypr/lua/80-workspaces.lua

local function monitor_present(name)
  local handle = io.popen("hyprctl -j monitors 2>/dev/null")
  if not handle then
    return false
  end

  local output = handle:read("*a") or ""
  handle:close()

  return output:find('"' .. name .. '"', 1, true) ~= nil
end

local primary_monitor = monitor_present("HDMI-A-1") and "HDMI-A-1" or "eDP-1"
local secondary_monitor = primary_monitor == "HDMI-A-1" and "eDP-1" or nil

for i = 1, 5 do
  hl.workspace_rule({
    workspace = tostring(i),
    monitor = primary_monitor,
  })
end

if secondary_monitor then
  for i = 6, 10 do
    hl.workspace_rule({
      workspace = tostring(i),
      monitor = secondary_monitor,
    })
  end
end

for i = 11, 15 do
  hl.workspace_rule({
    workspace = tostring(i),
    monitor = "WINSCREEN",
    default = i == 11,
  })
end

-- ~/.config/hypr/lua/80-workspaces.lua

for i = 1, 5 do
  hl.workspace_rule({
    workspace = tostring(i),
    monitor = "HDMI-A-1",
  })
end

for i = 6, 10 do
  hl.workspace_rule({
    workspace = tostring(i),
    monitor = "eDP-1",
  })
end

for i = 11, 15 do
  hl.workspace_rule({
    workspace = tostring(i),
    monitor = "WINSCREEN",
    default = i == 11,
  })
end

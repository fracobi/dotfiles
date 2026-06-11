-- ~/.config/hypr/lua/95-plugins.lua

if hl.plugin and hl.plugin.scrolloverview then
    hl.plugin.scrolloverview.configure({
        gesture_distance = 300, -- how far is the "max" for the gesture
        scale = 0.8, -- preferred overview scale
        workspace_gap = 0,
        wallpaper = 0, -- 0: global only, 1: per-workspace only, 2: both
        blur = false, -- blur only the main overview wallpaper

        shadow = {
            enabled = false,
            range = 50,
            render_power = 3,
            color = 0xee1a1a1a,
        },
    })
end


-- Vecchia configurazione plugin hyprexpo, per ora lasciata disattivata.

--[[
hl.config({
  plugin = {
    hyprexpo = {
      columns = 3,
      gap_size = 12,
      bg_col = "rgba(000000aa)",
      workspace_method = "workspace 1",
      hyprexpo_gesture = "3, up, expo",
      skip_empty = false,
    },
  },
})
]]

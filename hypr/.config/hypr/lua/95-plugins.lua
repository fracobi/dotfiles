-- ~/.config/hypr/lua/95-plugins.lua

if hl.plugin and hl.plugin.scrolloverview then
    hl.plugin.scrolloverview.configure({
        gesture_distance = 300,
        scale = 0.4,
        workspace_gap = 0,
        wallpaper = 0,
        blur = false,

        input = {
	    touchpad_scroll_factor = 6,
	    scroll_event_delay = 350,
        },

        shadow = {
            enabled = false,
            range = 10,
            render_power = 1,
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

-- ~/.config/hypr/lua/95-plugins.lua

-- Vecchia configurazione plugin hyprexpo, per ora lasciata disattivata.
-- La riattiviamo solo dopo aver verificato compatibilità plugin + Lua config.

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

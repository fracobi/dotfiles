
hl.config({
  input = {
    kb_layout = "it",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",

    follow_mouse = 1,
    sensitivity = 0,

    numlock_by_default = true,

    touchpad = {
      natural_scroll = true,
      scroll_factor = 0.3
    },
  },
})

hl.gesture({
  fingers = 3,
  direction = "vertical",
  action = "workspace",
  scale = 1.5,
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "scroll_move",
    scale = 1.5,
})

hl.gesture({
    fingers = 4,
    direction = "vertical",
    action = function()
        if hl.plugin and hl.plugin.scrolloverview then
            hl.plugin.scrolloverview.overview("toggle")
        end
    end,
    scale = 1.5,
})

hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})

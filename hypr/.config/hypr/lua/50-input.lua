
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
  direction = "horizontal",
  action = "workspace",
})

hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})

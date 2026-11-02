
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

-- Scorrimento continuo delle finestre: sensibilità doppia rispetto a 1.5.
-- Il layout assegna il focus alla finestra di arrivo al rilascio del gesto.
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "scroll_move",
    scale = 3.0,
})

-- Gesture nativa ScrollOverview: l'animazione segue il movimento delle dita.
-- Alterna apertura/chiusura sul monitor attivo; corsa ridotta da scale e
-- plugin.scrolloverview.gesture_distance (in 95-plugins.lua).
if hl.plugin and hl.plugin.scrolloverview then
    hl.plugin.scrolloverview.gesture({
        fingers = 4,
        direction = "vertical",
        scale = 1.8,
    })
end

hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})

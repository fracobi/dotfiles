
-- btop dentro kitty: floating, dimensione fissa, centrato
--hl.window_rule({
--  match = {
--    class = "^(kitty)$",
--    title = "^(btop)$",
--  },
-- float = true,
--  size = { 900, 600 },
--  center = true,
--})

-- Popup nmtui-go
hl.window_rule({
  match = {
    class = "^(nmtui-go)$",
  },
  float = true,
  size = { 650, 450 },
  move = { "(monitor_w-650-10)", 45 },
})

-- Popup bluetui
hl.window_rule({
  match = {
    class = "^(bluetui)$",
  },
  float = true,
  size = { 650, 450 },
  move = { "(monitor_w-650-10)", 45 },
})

-- Popup calendario
hl.window_rule({
  match = {
    class = "^(calendar-popup)$",
  },
  float = true,
  size = { 650, 450 },
  move = { "(monitor_w-650-10)", 45 },
})

-- Sopprime eventi maximize
hl.window_rule({
  name = "suppress-maximize-events",
  match = {
    class = ".*",
  },
  suppress_event = "maximize",
})

-- Fix drag XWayland
hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

-- Posizione floating di hyprland-run
hl.window_rule({
  name = "move-hyprland-run",
  match = {
    class = "hyprland-run",
  },
  move = { 20, "monitor_h-120" },
  float = true,
})

-- WhatsApp Web PWA: workspace tecnico per notifiche
hl.window_rule({
  name = "whatsapp-web-background",
  match = {
    class = "^(brave-hnpfjngllnobngcgfapefoaidbinmjnm-Default)$",
  },
  workspace = "99 silent",
})

-- Chrome: mostra la finestra del profilo selezionato anche su altri workspace.
hl.window_rule({
  name = "chrome-profile-activation",
  match = {
    class = "^(google-chrome)$",
  },
  focus_on_activate = true,
})

-- Faster touchpad scrolling for PdfCraft only (global factor: 0.3).
hl.window_rule({
  name = "pdfcraft-touchpad-scroll",
  match = { class = "^(ai\\.storyteller\\.pdfcraft)$" },
  scroll_touchpad = 1.2,
})

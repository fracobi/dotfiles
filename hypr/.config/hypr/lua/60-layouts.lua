-- Vecchia parte commentata:
-- dwindle {
--     pseudotile = true
--     preserve_split = true
-- }

hl.config({
    general = {
        layout = "scrolling",
    },

    scrolling = {
        column_width = 0.7,
        fullscreen_on_one_column = true,
        focus_fit_method = 1,
        follow_focus = true,
        follow_min_visible = 0.4,
        direction = "right",
	wrap_focus = true,
	explicit_column_widths = "0.333, 0.5, 0.6, 0.667, 1.0",
    },

    master = {
        new_status = "master",
    },
})

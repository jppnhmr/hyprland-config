hl.config({
    general = {
        gaps_in     = 0,
        gaps_out    = 0,
        border_size = 0,
        col = {
            -- Black means those pixels are off, so tiled windows can't wear lines
            -- into the panel. dim_inactive below shows which window has focus.
            active_border   = "rgba(000000ff)",--"rgba(9900ffff)",--"rgba(fdff00ff)",
            inactive_border = "rgba(000000ff)",
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 1,
        dim_inactive   = true,
        dim_strength   = 0.25,
        shadow = { enabled = true, range = 4, render_power = 3, color = "rgba(1a1a1aee)" },
        blur   = { enabled = true, size = 3, passes = 1, vibrancy = 0.1696 },
    },

    animations = { enabled = true },

    dwindle = {
        preserve_split = false,
        force_split    = 2,
        smart_split    = false,
        smart_resizing = false,
    },

    master = { new_status = "master" },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        -- Wake the screen after hypridle or SUPER+SHIFT+F2 turns it off
        key_press_enables_dpms  = true,
        mouse_move_enables_dpms = true,
    },
})

-- CURVES --
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1} } })

-- ANIMATIONS --
hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

-- Smart gaps (still commented, new syntax)
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({ name = "no-gaps-wtv1", match = { float = false, workspace = "w[tv1]" }, border_size = 0, rounding = 0 })
-- hl.window_rule({ name = "no-gaps-f1",   match = { float = false, workspace = "f[1]" },   border_size = 0, rounding = 0 })

-- ROFI --
hl.layer_rule({
    name = "rofi-glass",
    match = { namespace = "^rofi$" },
    blur = true,
    ignore_alpha = 0.2,
})

hl.layer_rule({
    name = "waybar-glass",
    match = { namespace = "^waybar$" },
    blur = true,
    ignore_alpha = 0.2,
})

hl.layer_rule({
    name = "overlay",
    match = { namespace = "^overlay$" },
    blur = true,
    ignore_alpha = 0.2,
})

-- HYPREXPO --
if hl.get_config("plugin.hyprexpo.gaps_in") ~= nil then
    hl.config({
        plugin = {
            hyprexpo = {
                bg_col = "rgb(0e1016)",
                gaps_in = 16,
                gaps_out = 16,
                tile_rounding = 14,
                tile_rounding_current = 14,
                tile_rounding_focus = 14,
                tile_rounding_hover = 14,
                border_width = 1,
                border_color = "rgba(ffffff1f)",
                border_color_current = "rgba(ffffff66)",
                border_color_focus = "rgba(ffffff66)",
                border_color_hover = "rgba(ffffff40)",
            },
        },
    })
end

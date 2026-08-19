local home = os.getenv("HOME")
local conf = home .. "/.config/hypr/my_conf"
local waybar_config = home .. "/.config/waybar/waybar-config/config"
local waybar_style  = home .. "/.config/waybar/waybar-config/style.css"

-- ENVIRONMENT --
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "23")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("QT_QPA_PLATFORMTHEME", "hyprqt6engine")   -- moved here from windowrules

hl.config({
    cursor = { no_hardware_cursors = true },
})

-- MONITORS --
-- Ultrawide setup:
-- hl.monitor({ output = "DP-1", mode = "3440x1440@60", position = "0x0",    scale = 1 })
-- hl.monitor({ output = "DP-2", mode = "1920x1080@60", position = "3440x0", scale = 1, transform = 3 })

hl.monitor({ output = "DP-1", mode = "1920x1080@144", position = "0x0",    scale = 1 })
hl.monitor({ output = "DP-2", mode = "1920x1080@60",  position = "1920x0", scale = 1, transform = 3 })

hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-2", default = true })

-- INPUT --
hl.config({
    input = {
        kb_layout    = "us",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "",
        kb_rules     = "",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad     = { natural_scroll = false },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- AUTOSTART --
hl.on("hyprland.start", function()
    hl.exec_cmd("awww-daemon --no-cache")
    hl.exec_cmd(conf .. "/set-wallpaper.sh")
    hl.exec_cmd("waybar --config " .. waybar_config .. " --style " .. waybar_style)
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("hyprpm reload -n")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("nemo --daemon")

    hl.dispatch(hl.dsp.focus({ monitor = "DP-1" }))
end)

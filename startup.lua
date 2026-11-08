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
--hl.env("QT_QPA_PLATFORMTHEME", "hyprqt6engine")   -- moved here from windowrules
hl.env("QT_QPA_PLATFORMTHEME", "hyprqt6engine")

hl.config({
    cursor = {
        no_hardware_cursors = true,
        inactive_timeout    = 5, -- hide a parked cursor after 5 seconds
    },
    -- Without this, XWayland games render at 3072x1728 and get upscaled.
    -- X11 app UIs (Steam's client, for one) will look smaller as a result.
    xwayland = { force_zero_scaling = true },
})

hl.device({
    name = "cherry",
    kb_options = "altwin:swap_lalt_lwin",
})

-- GENERGAL CONFIG --
hl.config({ render = { cm_auto_hdr = 1 } })
-- MONITORS --
hl.monitor({ output = "", mode = "3840x2160@165", position = "auto", scale = 1.25 })

-- INPUT --
hl.config({
    input = {
        kb_layout    = "us",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "altwin:swap_lalt_lwin",
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
    hl.exec_cmd(conf .. "/boot-wallpaper.sh")
    hl.exec_cmd("waybar --config " .. waybar_config .. " --style " .. waybar_style)
    hl.exec_cmd("hypridle")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("hyprpm reload -n")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("nemo --daemon")
    --hl.exec_cmd("hyprpaper") -- would draw over awww's wallpaper
	hl.exec_cmd("swayosd-server")
	--hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/setup-sunshine-remote-output")
end)

-- REMOTE DESKTOP --
hl.device({
    name = "libvirtualhid-mouse",
    accel_profile = "flat",
    sensitivity = -0.75,
})

-- WALLPAPER --
-- set immediately on startup
hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/my_conf/boot-wallpaper.sh")
-- cycle the wallpaper every 30 mins
hl.timer(function()
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/my_conf/boot-wallpaper.sh")
end, { timeout = 30 * 60 * 1000, type = "repeat" })

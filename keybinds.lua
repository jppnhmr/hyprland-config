local home = os.getenv("HOME")
local conf = home .. "/.config/hypr/my_conf"
local bar  = require("autohide")

local mod      = "SUPER"
local terminal = "kitty"
local menu     = "rofi"

-- WINDOW MANAGEMENT --
hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mod .. " + F",         hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + Space",     hl.dsp.window.float({ action = "toggle" }))

-- APPS --
hl.bind(mod .. " + RETURN",    hl.dsp.exec_cmd(terminal .. " --directory=" .. home))
--hl.bind(mod .. " + E",         hl.dsp.exec_cmd(terminal .. " --directory -e yazi"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("QT_STYLE_OVERRIDE=kvantum dolphin --new-window ~"))
hl.bind(mod .. " + SHIFT + F", hl.dsp.exec_cmd("firefox"))
hl.bind(mod .. " + D",         hl.dsp.exec_cmd(menu .. " -show drun"))
hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd(home .. "/.local/bin/vpn-launch"))
hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd("ncmpcpp"))
hl.bind(mod .. " + SHIFT + N", hl.dsp.exec_cmd("rnote"))
hl.bind(mod .. " + SHIFT + T", hl.dsp.exec_cmd(home .. "/.local/bin/tools"))

-- FOCUS / MOVE / RESIZE --
local dirs = {
    { key = "j",         dir = "left",  x = -20, y = 0   },
    { key = "semicolon", dir = "right", x =  20, y = 0   },
    { key = "k",         dir = "up",    x =   0, y = -20 },
    { key = "l",         dir = "down",  x =   0, y =  20 },
}

for _, d in ipairs(dirs) do
    hl.bind(mod .. " + " .. d.key,           hl.dsp.focus({ direction = d.dir }))
    hl.bind(mod .. " + SHIFT + " .. d.key,   hl.dsp.window.move({ direction = d.dir }))
    hl.bind(mod .. " + CTRL + " .. d.key, hl.dsp.window.resize({ x = d.x, y = d.y, relative = true }))
end

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- WORKSPACES --
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i, follow = false }))
end

local numpad = { "KP_End", "KP_Down", "KP_Next", "KP_Left", "KP_Begin",
                 "KP_Right", "KP_Home", "KP_Up", "KP_Prior", "KP_Insert" }

for i, key in ipairs(numpad) do
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mod .. " + SHIFT + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + SHIFT + left",  hl.dsp.focus({ workspace = "e-1" }))

hl.bind("SUPER + a", function()
    hl.plugin.hyprexpo.expo("toggle")
end)

-- MISC --
hl.bind(mod .. " + N", bar.reveal)

hl.bind(mod .. " + SHIFT + R",       hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mod .. " + CTRL + SHIFT + W",hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/my_conf/boot-wallpaper.sh")) -- New Wallpaper
hl.bind(mod .. " + CTRL + SHIFT + I",hl.dsp.exec_cmd(conf .. "/weather-today.sh"))
hl.bind(mod .. " + SHIFT + F12",     hl.dsp.exec_cmd("poweroff"))
hl.bind(mod .. " + SHIFT + F11",     hl.dsp.exec_cmd("reboot"))
hl.bind(mod .. " + SHIFT + U",       hl.dsp.exec_cmd(
    "kitty --hold -e sh -c 'sudo pacman -Syu --noconfirm; yay -Syu; flatpak update'"))
    
-- Brightness
hl.on("hyprland.start", function()
	hl.exec_cmd("rm -f $XDG_RUNTIME_DIR/wob.sock && mkfifo $XDG_RUNTIME_DIR/wob.sock && tail -f $XDG_RUNTIME_DIR/wob.sock | wob")
end)
local bright = os.getenv("HOME") .. "/.local/bin/brightness"
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(bright .. " up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(bright .. " down"), {locked = true, repeating = true})

-- Change Monitor Source
hl.bind("SUPER + F1", -- desktop
	hl.dsp.exec_cmd("ddcutil --bus 2 --noverify setvcp 60 0x0f"), 
	{ description = "Switch monitor to DP input "}
) 
hl.bind("SUPER + F2", -- laptop
	hl.dsp.exec_cmd("ddcutil --bus 2 --noverify setvcp 60 0x11"),
	{ description = "Switch monitor to HDMI input" }
) 

-- Turn the screen off now, for when you step away. Any key or mouse movement wakes it.
hl.bind(mod .. " + SHIFT + F2", function()
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = "off" }))
    end, { timeout = 500, type = "oneshot" })
end)

-- SCREENSHOTS --
hl.bind(mod .. " + P",        hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))
hl.bind(mod .. " + CTRL + P", hl.dsp.exec_cmd(
    [[grim -g "$(slurp)" - | tee ]] .. home ..
    [[/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png | wl-copy]]))

-- GAMMA --
local gamma = "gammastep -l geoclue2 -t "
hl.bind(mod .. " + CTRL + SHIFT + Z", hl.dsp.exec_cmd(gamma .. "6500:1500"))
hl.bind(mod .. " + CTRL + SHIFT + X", hl.dsp.exec_cmd(gamma .. "10500:2500"))
hl.bind(mod .. " + CTRL + SHIFT + C", hl.dsp.exec_cmd(gamma .. "1500:8500"))


-- ASSIGN EJECT -> DEL --
hl.bind(
    "code:169",
    hl.dsp.send_shortcut({
        mods = "",
        key = "Delete",
        window = "activewindow",
    }),
    {
        repeating = true,
        devices = {
            inclusive = true,
            list = { "apple-inc.-magic-keyboard" },
        },
    }
)

local home = os.getenv("HOME")
local conf = home .. "/.config/hypr/my_conf"
local waybar_config = home .. "/.config/waybar/waybar-config/config"
local waybar_style  = home .. "/.config/waybar/waybar-config/style.css"

local mod      = "SUPER"
local terminal = "kitty"
local menu     = "rofi"

-- WINDOW MANAGEMENT --
hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mod .. " + F",         hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + Space",     hl.dsp.window.float({ action = "toggle" }))

-- APPS --
hl.bind(mod .. " + RETURN",    hl.dsp.exec_cmd(terminal .. " --directory=" .. home))
hl.bind(mod .. " + E",         hl.dsp.exec_cmd(terminal .. " --directory -e yazi"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("nemo"))
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
    hl.bind(mod .. " + CTRL + " .. d.key,    hl.dsp.window.resize({ x = d.x, y = d.y }))
end

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- WORKSPACES --
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
end

local numpad = { "KP_End", "KP_Down", "KP_Next", "KP_Left", "KP_Begin",
                 "KP_Right", "KP_Home", "KP_Up", "KP_Prior", "KP_Insert" }

for i, key in ipairs(numpad) do
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mod .. " + SHIFT + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + SHIFT + left",  hl.dsp.focus({ workspace = "e-1" }))

-- MISC --
hl.bind(mod .. " + N", hl.dsp.exec_cmd(
    "pgrep waybar > /dev/null && killall waybar || waybar --config "
    .. waybar_config .. " --style " .. waybar_style))

hl.bind(mod .. " + SHIFT + R",       hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mod .. " + SHIFT + W",       hl.dsp.exec_cmd(conf .. "/random-wallpaper.sh"))
hl.bind(mod .. " + CTRL + SHIFT + W",hl.dsp.exec_cmd(conf .. "/set-wallpaper.sh"))
hl.bind(mod .. " + CTRL + SHIFT + I",hl.dsp.exec_cmd(conf .. "/weather-today.sh"))
hl.bind(mod .. " + SHIFT + End",     hl.dsp.exec_cmd("poweroff"))
hl.bind(mod .. " + SHIFT + Home",    hl.dsp.exec_cmd("reboot"))
hl.bind(mod .. " + SHIFT + U",       hl.dsp.exec_cmd(
    "kitty --hold -e sh -c 'sudo pacman -Syu --noconfirm; yay -Syu; flatpak update'"))

-- Toggle second monitor
hl.bind(mod .. " + SHIFT + F9", function()
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = "toggle", monitor = "DP-2" }))
    end, { timeout = 500, type = "oneshot" })
end)

-- SCREENSHOTS --
hl.bind(mod .. " + P",        hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))
hl.bind(mod .. " + CTRL + P", hl.dsp.exec_cmd(
    [[grim -g "$(slurp)" - | tee ]] .. home ..
    [[/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png | wl-copy]]))

-- GAMMA --
local gamma = "gammastep -l 51.45:-2.59 -t "
hl.bind(mod .. " + CTRL + SHIFT + Z", hl.dsp.exec_cmd(gamma .. "6500:1500"))
hl.bind(mod .. " + CTRL + SHIFT + X", hl.dsp.exec_cmd(gamma .. "10500:2500"))
hl.bind(mod .. " + CTRL + SHIFT + C", hl.dsp.exec_cmd(gamma .. "1500:8500"))

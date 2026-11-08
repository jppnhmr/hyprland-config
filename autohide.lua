-- Keeps Waybar hidden so its pixels aren't lit all day on the OLED.
-- It shows when you press the keybind or rest the cursor on the top edge of the
-- screen, stays up while the cursor is on it (or just below), and hides as soon
-- as the cursor moves away. The edge is ignored while a game or fullscreen window
-- is up. The keybind always works, on the assumption a keypress is deliberate.
--
-- Waybar side: start_hidden, on-sigusr1 = show, on-sigusr2 = hide (see its config).

local M = {}

local home   = os.getenv("HOME")
local config = home .. "/.config/waybar/waybar-config/config"
local style  = home .. "/.config/waybar/waybar-config/style.css"

local REVEAL_MS = 2000 -- how long a keybind reveal stays up if the cursor
                       -- never goes onto the bar
local POLL_MS   = 100  -- how often the cursor is checked
local DWELL_MS  = 100  -- how long the cursor must rest on the edge, so flicking
                       -- up to a browser tab doesn't trigger it
local EDGE_PX   = 1    -- height of the top-edge trigger
local BAR_PX    = 46   -- height of the bar
local MARGIN_PX = 20   -- extra room below the bar before it hides
local HOLD_PX   = BAR_PX + MARGIN_PX -- the bar stays up while the cursor is above this

-- Windows that count as games even when they aren't fullscreen. These match the
-- window rules that float Steam and Wine windows.
local GAME_CLASSES = { "^steam_app_", "%.exe$" }

local visible   = false
local hovered   = false -- the cursor has been on the bar since it was shown
local remaining = 0
local dwell     = 0
local armed     = true -- false until the cursor leaves the edge again, so the
                       -- bar doesn't pop straight back up after hiding

function M.reveal()
    remaining = REVEAL_MS
    hovered = false
    visible = true
    -- Starts Waybar if it isn't running. It starts hidden, so press again to see it.
    hl.exec_cmd("pkill -USR1 -x waybar || waybar --config " .. config .. " --style " .. style)
end

function M.hide()
    visible = false
    hovered = false
    hl.exec_cmd("pkill -USR2 -x waybar")
end

local function game_or_fullscreen(mon)
    local ws = mon.active_workspace
    if ws and ws.has_fullscreen then return true end

    local win = hl.get_active_window()
    if not win then return false end

    for _, pattern in ipairs(GAME_CLASSES) do
        if win.class:match(pattern) then return true end
    end

    -- Borderless games: a floating window as big as the screen.
    -- Window sizes are in scaled pixels, monitor sizes in real ones.
    return win.floating
        and win.size.x >= mon.width / mon.scale
        and win.size.y >= mon.height / mon.scale
end

local function tick()
    local pos = hl.get_cursor_pos()
    local mon = hl.get_monitor_at_cursor()
    if not pos or not mon then return end

    local y = pos.y - mon.y

    if visible then
        if y < HOLD_PX then
            -- On the bar (or just under it): keep it up for as long as it's here.
            hovered = true
        elseif hovered then
            -- Was on the bar and has now left: hide straight away.
            M.hide()
        else
            -- Shown by the keybind and the cursor never came up: time out.
            remaining = remaining - POLL_MS
            if remaining <= 0 then M.hide() end
        end
    end

    if y > EDGE_PX then
        armed, dwell = true, 0
    elseif armed then
        dwell = dwell + POLL_MS
        if dwell >= DWELL_MS then
            armed = false
            if not visible and not game_or_fullscreen(mon) then M.reveal() end
        end
    end
end

-- There's no cursor-moved event in the Lua API, so this polls. It only reads the
-- cursor position and doesn't trigger a redraw.
hl.timer(tick, { timeout = POLL_MS, type = "repeat" })

-- A config reload resets the state above, so make Waybar match it.
hl.on("config.reloaded", M.hide)

return M

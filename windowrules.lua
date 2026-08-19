hl.window_rule({ name = "kitty-opacity",  match = { class = "kitty" },  opacity = "0.9"  })
hl.window_rule({ name = "thunar-opacity", match = { class = "thunar" }, opacity = "0.98" })

hl.window_rule({ name = "float-wine", match = { class = ".*\\.exe$" }, float = true })

hl.window_rule({
    name  = "float-steam-games",
    match = { class = "^steam_app_.*$" },
    float = true,
    fullscreen = false,
})

-- Startup dashboard windows
hl.window_rule({
    name  = "startup-clock",
    match = { title = "startup-clock" },
    float = true, monitor = "0", size = "50% 50%", move = "0 0",
})

hl.window_rule({
    name  = "startup-upgrade",
    match = { title = "startup-upgrade" },
    float = true, monitor = "0", size = "50% 50%", move = "50% 0",
})

hl.window_rule({
    name  = "startup-fire",
    match = { title = "startup-fire" },
    float = true, monitor = "0", size = "100% 50%", move = "0 50%",
})

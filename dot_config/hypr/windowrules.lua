hl.window_rule({
    -- Ignore maximize requests from all apps
    name           = "suppress-maximize-events",
    match          = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- General floating windows
local float_classes = {
    { class = "yad" },
    { class = "nm-connection-editor" },
    { class = "pavucontrol-qt" },
    { class = "xfce-polkit" },
    { class = "hyprpolkitagent" },
    { class = "kvantummanager" },
    { class = "qt5ct" },
    { class = "feh" },
    { class = "Viewnior" },
    { class = "viewnior" },
    { class = "Gpicview" },
    { class = "Gimp" },
    { class = "MPlayer" },
    { class = "qemu" },
    { class = "Qemu-system-x86_64" },
    { class = "mpv" },
    { class = "zenity" },
    { class = "file_progress" },
    { class = "confirm" },
    { class = "dialog" },
    { class = "download" },
    { class = "notification" },
    { class = "error" },
    { class = "splash" },
    { class = "confirmreset" },
    { class = "Lxappearance" },
    { class = "blueman-manager" },
    { class = "file-roller" },
    { title = "^(New Text Note — Okular)$" },
    { title = "^(branchdialog)$" },
    { title = "^(Media viewer)$" },
    { title = "^(Volume Control)$" },
    { title = "^(Picture-in-Picture)$" },
}
for _, rule in ipairs(float_classes) do
    hl.window_rule({ match = rule, float = true, center = true })
end
hl.window_rule({ match = { title = "^(Open File|Save File|xdg-desktop-portal-gtk)$" }, float = true, size = "75% 75%", center = true })

-- Hacking software
-- AVD
hl.window_rule({ match = { title = "^(Emulator)$" }, float = true, center = true, move = "100 100" })

-- Ghidra
hl.window_rule({ match = { title = "^(Java)$" }, center = true })
hl.window_rule({ match = { class = "ghidra-Ghidra", title = "^(Ghidra.*)$" }, tile = true })
hl.window_rule({ match = { class = "ghidra-Ghidra", title = "^(CodeBrowser.*)$" }, tile = true })

-- Force tile
hl.window_rule({ match = { class = "qemu-system-x86_64" }, tile = true })
hl.window_rule({ match = { class = "Spotify" }, tile = true })

-- Flameshot
hl.window_rule({ match = { class = "flameshot", title = "^(flameshot)$" }, float = true, size = "30% 30%", pin = true, fullscreen_state = 2 })

-- Launchers
hl.layer_rule({ match = { namespace = "walker" }, no_anim = true })

-- Clipboard manager (clipse)
hl.window_rule({ match = { class = "clipse-gui" }, float = true, stay_focused = true })

-- jetbrains
hl.window_rule({ match = { class = ".*jetbrains.*", title = "^(Confirm Exit|Open Project|win*|splash)$" }, center = true })
hl.window_rule({ match = { class = ".*jetbrains.*", title = "^(splash)$" }, size = "640 400" })
hl.window_rule({ match = { class = ".*jetbrains.*", title = "^(win.*)$" }, no_initial_focus = true, no_focus = true })

-- Screen sharing
hl.window_rule({ match = { title = "^(Firefox — Sharing Indicator)$" }, float = true })
hl.window_rule({ match = { title = "^(Chromium — Sharing Indicator)$" }, move = "100% 20%" })
hl.window_rule({ match = { title = "^(.*is sharing (your screen|a window)\\.)$" }, float = true, move = "100% 20%" })
-- -- xwaylandvideobridge
hl.window_rule({ match = { class = "xwaylandvideobridge" }, no_anim = true, no_initial_focus = true, max_size = "1 1", no_blur = true })

-- Dont idleinhibit fullscreen
hl.window_rule({ match = { fullscreen = true }, idle_inhibit = "fullscreen" })

-- Communication
-- -- Zoom
hl.window_rule({ match = { class = "zoom", title = "^(Meeting Chat)$" }, float = true })
hl.window_rule({ match = { class = "zoom" }, idle_inhibit = "focus" })
hl.window_rule({ match = { title = "^(.*Zoom.*|Meet –.*)$" }, idle_inhibit = "focus" })

-- Python libraries
hl.window_rule({ match = { class = "Matplotlib" }, float = true })

-- Polkit force focus
hl.window_rule({ match = { class = "hyprpolkitagent" }, stay_focused = true })

-- Floating regex rules
local rules = {
    {
        width = 30,
        height = 54,
        patterns = {
            "%(Bitwarden.*Password Manager%) %- Bitwarden",
            "^Bitwarden$",
        }
    },
    {
        width = 25,
        height = 54,
        patterns = {
            "^Sign In %- Google Accounts %— ",
        }
    },
}

local function matches(title, rule)
    for _, pattern in ipairs(rule.patterns) do
        if title:match(pattern) then return true end
    end
    return false
end

hl.on("window.title", function(window)
    local title = window.title or ""
    for _, rule in ipairs(rules) do
        if matches(title, rule) then
            local monitor = hl.get_active_monitor()
            if not monitor then return end

            hl.dispatch(hl.dsp.window.float({ window = window, action = "on" }))
            hl.dispatch(hl.dsp.window.center({ window = window, action = "on" }))
            hl.dispatch(hl.dsp.window.resize({
                window = window,
                x = math.floor(monitor.width * rule.width / 100),
                y = math.floor(monitor.height * rule.height / 100),
            }))
            return
        end
    end
end)

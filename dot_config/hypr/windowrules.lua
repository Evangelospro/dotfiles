-- General floating windows
local float_classes = { "yad", "nm-connection-editor", "pavucontrol-qt", "xfce-polkit", "hyprpolkitagent",
    "kvantummanager", "qt5ct", "feh", "Viewnior", "Gpicview", "Gimp", "MPlayer", "qemu", "Qemu-system-x86_64", "mpv" }
for _, class in ipairs(float_classes) do
    hl.window_rule({ match = { class = class }, float = true, center = true })
end

-- Floating windows
hl.window_rule({ match = { class = "zenity" }, float = true })
hl.window_rule({ match = { title = "^(New Text Note — Okular)$" }, float = true })
hl.window_rule({ match = { class = "file_progress" }, float = true })
hl.window_rule({ match = { class = "confirm" }, float = true })
hl.window_rule({ match = { class = "dialog" }, float = true })
hl.window_rule({ match = { class = "download" }, float = true })
hl.window_rule({ match = { class = "notification" }, float = true })
hl.window_rule({ match = { class = "error" }, float = true })
hl.window_rule({ match = { class = "splash" }, float = true })
hl.window_rule({ match = { class = "confirmreset" }, float = true })
hl.window_rule({ match = { title = "^(Open File|Save File|xdg-desktop-portal-gtk)$" }, float = true, size = "75% 75%", center = true })
hl.window_rule({ match = { title = "^(branchdialog)$" }, float = true })
hl.window_rule({ match = { class = "Lxappearance" }, float = true })
hl.window_rule({ match = { class = "viewnior" }, float = true })
hl.window_rule({ match = { class = "feh" }, float = true })
hl.window_rule({ match = { class = "blueman-manager" }, float = true })
hl.window_rule({ match = { class = "nm-connection-editor" }, float = true })
hl.window_rule({ match = { class = "file-roller" }, float = true })
hl.window_rule({ match = { title = "^(Media viewer)$" }, float = true })
hl.window_rule({ match = { title = "^(Volume Control)$" }, float = true })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, float = true })

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

-- czkawka
hl.window_rule({ match = { class = "czkawka_gui", title = "^(Scanning)$" }, center = true, size = "30% 30%" })

-- FlameShot
hl.window_rule({
    match = { class = "flameshot", title = "^(flameshot)$" },
    float = true,
    monitor = 0,
    move = "0 0",
    size =
    "3280 1080"
})

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

-- OnlyOffice
hl.window_rule({ match = { class = "ONLYOFFICE Desktop Editors" }, tile = true })

-- Dont idleinhibit fullscreen
hl.window_rule({ match = { fullscreen = true }, idle_inhibit = "fullscreen" })

-- Communication
-- Viber
hl.window_rule({ match = { class = "com.viber.Viber", title = "^(ViberPC)$" }, float = true, move = "1610 55" })

-- Zoom
hl.window_rule({ match = { class = "zoom", title = "^(Meeting Chat)$" }, float = true })
hl.window_rule({ match = { class = "zoom" }, idle_inhibit = "focus" })
hl.window_rule({ match = { title = "^(.*Zoom.*|Meet –.*)$" }, idle_inhibit = "focus" })

-- xwaylandvideobridge
hl.window_rule({ match = { class = "xwaylandvideobridge" }, no_anim = true, no_initial_focus = true, max_size = "1 1", no_blur = true })

-- Python libraries
hl.window_rule({ match = { class = "Matplotlib" }, float = true })

-- Background apps
-- hl.window_rule({ match = { initial_title = "^(ROG Control)(.*)$" }, workspace = "special:rog-control-center", pin = true })
-- hl.window_rule({ match = { class = "valent" }, workspace = "special:valent", pin = true })

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
    {
        width = 25,
        height = 54,
        patterns = {
            "^Extension: %(MetaMask%) %- MetaMask %— Firefox",
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

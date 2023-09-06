local wezterm = require('wezterm')
local module = {}

local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

module.hide_tab_bar_if_only_one_tab = false
module.window_close_confirmation = 'NeverPrompt'
module.tab_bar_at_bottom = true
module.window_decorations = "RESIZE"
module.scrollback_lines = 10000

module.bidi_enabled = true
module.enable_scroll_bar = false
module.native_macos_fullscreen_mode = true
module.enable_tab_bar = true
module.use_fancy_tab_bar = false
module.enable_kitty_graphics = true

module.color_scheme = 'Dracula (Official)'

module.tiling_desktop_environments = {
    'X11 LG3D',
    'X11 bspwm',
    'X11 i3',
    'X11 dwm',
    'Wayland'
}

module.enable_wayland = true

return module

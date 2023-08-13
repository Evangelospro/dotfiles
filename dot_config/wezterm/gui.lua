local wezterm = require('wezterm')
local module = {}

local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

module.color_scheme = 'Dracula (base16)'
module.colors = wezterm.color.get_builtin_schemes()[module.color_scheme]

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

module.colors = {

    background = "#282936",

    tab_bar = {
        background = "#282a36",
        inactive_tab = {
            bg_color = "#282a36",
            fg_color = "#6272a4"
        },
        active_tab = {
            bg_color = "#282a36",
            fg_color = "#f8f8f2"
        },
        new_tab = {
            bg_color = "#282a36",
            fg_color = "#f8f8f2"
        },
        new_tab_hover = {
            bg_color = "#282a36",
            fg_color = "#f8f8f2"
        }
    },

    ansi = {
        "#282936",
        "#ea51b2",
        "#00f769",
        "#ebff87",
        "#62d6e8",
        "#b45bcf",
        "#a1efe4",
        "#e9e9f4"
    },

    brights = {
        "#4d4f68",
        "#ea51b2",
        "#00f769",
        "#ebff87",
        "#62d6e8",
        "#b45bcf",
        "#a1efe4",
        "#f7f7fb"
    },
}
--- powerline start
wezterm.on('update-right-status', function(window, pane)
    -- Each element holds the text for a cell in a "powerline" style << fade
    local cells = {};

    -- Figure out the cwd and host of the current pane.
    -- This will pick up the hostname for the remote host if your
    -- shell is using OSC 7 on the remote host.
    local cwd_uri = pane:get_current_working_dir()
    if cwd_uri then
        cwd_uri = cwd_uri:sub(8);
        local slash = cwd_uri:find("/")
        local hostname = ""
        if slash then
            hostname = cwd_uri:sub(1, slash - 1)
            -- Remove the domain name portion of the hostname
            local dot = hostname:find("[.]")
            if dot then
                hostname = hostname:sub(1, dot - 1)
            end

            table.insert(cells, hostname);
        end
    end

    -- An entry for each battery (typically 0 or 1 battery)
    for _, b in ipairs(wezterm.battery_info()) do
        table.insert(cells, string.format("%.0f%%", b.state_of_charge * 100))
    end

    -- I like my date/time in this style: "2022-02-15 07:05"
    local date = wezterm.strftime("%Y-%m-%-d %H:%M");
    table.insert(cells, date);

    -- Color palette for the backgrounds of each cell
    local pink = wezterm.color.parse(module.colors.brights[6])
    local colors = {pink:darken(0.1), pink:darken(0.2), pink:darken(0.3), pink:darken(0.4), pink:darken(0.5)};

    -- Foreground color for the text across the fade
    local text_fg = module.colors.background

    -- The elements to be formatted
    local elements = {{
        Foreground = {
            Color = colors[1]
        }
    }, {
        Text = SOLID_LEFT_ARROW
    }};

    -- How many cells have been formatted
    local num_cells = 0;

    -- Translate a cell into elements
    local function push(text, is_last)
        local cell_no = num_cells + 1
        table.insert(elements, {
            Foreground = {
                Color = text_fg
            }
        })
        table.insert(elements, {
            Background = {
                Color = colors[cell_no]
            }
        })
        table.insert(elements, {
            Text = " " .. text .. " "
        })
        if not is_last then
            table.insert(elements, {
                Foreground = {
                    Color = colors[cell_no + 1]
                }
            })
            table.insert(elements, {
                Text = SOLID_LEFT_ARROW
            })
        end
        num_cells = num_cells + 1
    end

    while #cells > 0 do
        local cell = table.remove(cells, 1)
        push(cell, #cells == 0)
    end

    window:set_right_status(wezterm.format(elements));
end);

module.tab_bar_style = {
    new_tab = wezterm.format {
    { Background = {Color = module.colors.tab_bar.new_tab.bg_color} },
    { Foreground = {Color = module.colors.tab_bar.background} },
    { Text = SOLID_RIGHT_ARROW },
    { Background = { Color = module.colors.tab_bar.new_tab.bg_color } },
    { Foreground = { Color = module.colors.tab_bar.new_tab.fg_color } },
    { Text = " + " },
    { Background = { Color = module.colors.tab_bar.background } },
    { Foreground = { Color = module.colors.tab_bar.new_tab.bg_color } },
    { Text = SOLID_RIGHT_ARROW }
    },

    new_tab_hover = wezterm.format {
    { Attribute = { Italic = false } },
    { Attribute = { Intensity = "Bold" } },
    { Background = { Color = module.colors.tab_bar.inactive_tab.bg_color } },
    { Foreground = { Color = module.colors.tab_bar.background } },
    { Text = SOLID_RIGHT_ARROW },
    { Background = { Color = module.colors.tab_bar.inactive_tab.bg_color } },
    { Foreground = { Color = module.colors.tab_bar.inactive_tab.fg_color } },
    { Text = " + " },
    { Background = { Color = module.colors.tab_bar.background } },
    { Foreground = { Color = module.colors.tab_bar.inactive_tab.bg_color } },
    { Text = SOLID_RIGHT_ARROW }
    }
}

module.color_schemes = {
    ['Dracula custom'] = module.colors
}

module.color_scheme = 'Dracula custom'

module.tiling_desktop_environments = {
    'X11 LG3D',
    'X11 bspwm',
    'X11 i3',
    'X11 dwm',
    'Wayland'
}

return module

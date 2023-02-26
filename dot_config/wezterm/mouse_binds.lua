local wezterm = require('wezterm')
local module = {}
local paste_right_click = {
  event = {
    Up = {
      streak = 1,
      button = "Right"
    }
  },
  mods = "NONE",
  action = wezterm.action{
    PasteFrom = "PrimarySelection"
  }
}

module.mouse_bindings = { paste_right_click }

return module


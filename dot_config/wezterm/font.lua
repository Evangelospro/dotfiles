local wezterm = require('wezterm')
local module = {}

module.font = wezterm.font_with_fallback({
  'FiraCode Nerd Font',
  'JetBrains Mono'
})
module.font_size = 16

return module

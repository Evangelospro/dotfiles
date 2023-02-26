local wezterm = require('wezterm')
local action = wezterm.action

local keys = {
  {
    key = "c",
    mods = "CTRL|SHIFT",
    action = action{CopyTo = "Clipboard"},
  },
  {
    key = "v",
    mods = "CTRL|SHIFT",
    action = action{PasteFrom = "Clipboard"},
  },
  {
    key = "LeftArrow",
    mods = "CTRL|SHIFT",
    action = action{ActivateTabRelative = -1},
  },
  {
    key = "RightArrow",
    mods = "CTRL|SHIFT",
    action = action{ActivateTabRelative = 1},
  },
  {
    key = "Enter",
    mods = "CTRL|SHIFT",
    action = action{SpawnTab = "CurrentPaneDomain"},
  },
  {
    key = "r",
    mods = "CTRL|SHIFT",
    action = action.ReloadConfiguration,
  },
  {
    key = "w",
    mods = "CTRL|SHIFT",
    action = action.QuitApplication,
  },
  {
    key = "t",
    mods = "CTRL|SHIFT",
    action = action{SpawnTab = "CurrentPaneDomain"},
  },
  -- {
  --   key = "n",
  --   mods = "CTRL",
  --   action = action(SpawnCommand = "navi"),
  -- },
  {
    key = "n",
    mods = "CTRL|SHIFT",
    action = action.SpawnWindow,
  },
  {
    key = "q",
    mods = "CTRL|SHIFT",
    action = action{CloseCurrentTab = {confirm=true}},
  },
  {
    key = "1",
    mods = "CTRL",
    action = action{ActivateTab = 0},
  },
  {
    key = "2",
    mods = "CTRL",
    action = action{ActivateTab = 1},
  },
  {
    key = "3",
    mods = "CTRL",
    action = action{ActivateTab = 2},
  },
  {
    key = "4",
    mods = "CTRL",
    action = action{ActivateTab = 3},
  },
  {
    key = "5",
    mods = "CTRL",
    action = action{ActivateTab = 4},
  },
  {
    key = "6",
    mods = "CTRL",
    action = action{ActivateTab = 5},
  },
  {
    key = "7",
    mods = "CTRL",
    action = action{ActivateTab = 6},
  },
  {
    key = "8",
    mods = "CTRL",
    action = action{ActivateTab = 7},
  },
  {
    key = "9",
    mods = "CTRL",
    action = action{ActivateTab = 8},
  },
  {
    key = "0",
    mods = "CTRL",
    action = action{ActivateTab = 9},
  },
  {
    key = "Enter",
    mods = "CTRL",
    action = action{SplitHorizontal = {domain="CurrentPaneDomain"}},
  },
  {
    key = "Enter",
    mods = "CTRL|SHIFT",
    action = action{SplitVertical = {domain="CurrentPaneDomain"}},
  }
}

return {keys = keys}
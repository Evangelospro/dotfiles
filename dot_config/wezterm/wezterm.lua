local merge = require('utils').merge
local cursor = require('cursor')
local font = require('font')
local gui = require('gui')
local mouse_binds = require('mouse_binds')
local shell = require('shell')
local keybinds = require('keybinds')


return merge(cursor, font, gui, mouse_binds, shell, keybinds)

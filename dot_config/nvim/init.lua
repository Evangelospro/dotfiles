require "options"
require "keymaps"
require "lazy-config"

vim.opt.number = true
vim.opt.relativenumber = true

if vim.g.vscode then
    vim.notify = vscode.notify
    vim.cmd[[source $HOME/.config/nvim/vscode/settings.vim]]
else
    -- ordinary Neovim
end

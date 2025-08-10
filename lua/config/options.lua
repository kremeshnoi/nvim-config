vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.fillchars:append { vert = " " }
vim.opt.cursorline = false
vim.opt.cursorcolumn = false
vim.opt.showmode = false

local opt = vim.opt

opt.number = true
opt.cursorline = true
opt.fillchars:append { eob = " " }

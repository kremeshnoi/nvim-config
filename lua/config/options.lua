vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.number = true
opt.fillchars:append { vert = " " }
opt.cursorline = false
opt.cursorcolumn = false
opt.showmode = false
opt.colorcolumn = "120"
opt.foldenable = false
opt.foldmethod = "manual"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.fillchars:append { eob = " " }
vim.opt.splitright = true

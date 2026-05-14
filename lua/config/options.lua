vim.cmd("source " .. vim.fn.stdpath "config" .. "/.vimrc")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- opt.fillchars:append { vert = " " }
opt.cursorline = false
opt.cursorcolumn = false
opt.showmode = false
opt.laststatus = 3
opt.ruler = false
opt.foldenable = false
opt.foldmethod = "manual"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.fillchars:append { eob = " " }
opt.splitright = true
opt.colorcolumn = "+1"

opt.clipboard = "unnamedplus"
if vim.fn.has "wsl" == 1 or (vim.uv or vim.loop).os_uname().release:lower():find "microsoft" then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -NoLogo -NoProfile -Command [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -NoLogo -NoProfile -Command [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end
